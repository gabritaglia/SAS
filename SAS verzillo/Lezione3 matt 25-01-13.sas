/*Fissiamo un percorso fisico dove mettere le varie cose*/
libname corso "F:\SAS verzillo";
run;

/*******************
 ISTRUZIONE RETAIN
*******************/

/*è un'istruzione non eseguibile inserita in un qualsiasi passo di data.
Svolge due funzioni:
1 trattenere i valori nel precedente passo di data, nonostante non venga scritto nell'explorer, in sostanza tiene la memoria
2 assegna dei valori alle variabili, le inizializza*/

data dati;
input punteggi; /*setto il nome delle variabili*/
datalines; /*inserisco i valori*/
10
3
7
5
;
proc print; 
Run;

data dati;
retain totale 0;  /*=tieni in memoria totale ad ogni riga, inizializzalo a 0*/
input punteggi; /*setto il nome delle variabili*/
totale = totale + punteggi;
datalines; /*inserisco i valori*/
10
3
7
5
;
proc print; 
Run;

data dati;
retain conto totale 0;  /*=tieni in memoria totale ad ogni riga, inizializzalo a 0*/
input punteggi; /*setto il nome delle variabili*/
totale = totale + punteggi;
conto =conto+3;
datalines; /*inserisco i valori*/
10
3
7
.

6
4
; /*attenzione a cosa succede sulla variabile totale a causa del missing, non può sommare da lì in avanti*/
proc print; 
Run;

/*se volessi dare valore alle osservazioni 4 5 e 6 faccio così */
data dati;
retain conto totale 0;  /*=tieni in memoria totale ad ogni riga, inizializzalo a 0*/
input punteggi; /*setto il nome delle variabili*/
totale = sum(totale,punteggi); /*facendo coì quando incontra un missing riscrive il totale, la riga dopo somma riga per riga*/
conto =conto+3;
datalines; /*inserisco i valori*/
10
3
7
.

6
4
;
proc print; 
Run; /*nota, se togli retain sas non ha un punto di partenza per conto e totale 
e quindi in conto mette tutti missing, in totale mette semplicemente punteggi*/


/*******************
 TRANSPOSE/RESHAPE
*******************/

/*PROC TRANSPOSE*/
/*serve per trasporre un data set da righe a colonne e da colonne a righe
in sostanza se tipo voglio rendere in un'unica riga valori riferiti alla stessa persona*/

/*from long to wide*/

data long1;
input famid	year faminc; /*faminc= family income*/
datalines;
1 96 40000
1 97 40600
1 98 41000
2 96 45000
2 97 45400
2 98 45800
3 96 70000
3 97 71600
3 98 72000
;
proc print;
run;

proc transpose data=long1 out=wide1 prefix=faminc;
/*prefix è l'opzione con cui setto il nome delle nuove variabili trasposte*/
by famid; /*dice qual'è l'indentificativo delle righe*/
id year;/*setta il riferimento delle colonne*/
var faminc ;/*questo è la variabile del dataset wide, quella che viene trasposta*/
proc print;
run;


/*adesso trasponiamo due o più variabili*/
/*prima facciamo un data set trasposto con la spesa per anno
poi faccio la merge dei trasposti*/
data long2;
input famid	year faminc famexp; /*faminc= family income   famexp= familiy expenses  */
datalines;
1 96 40000 38000
1 97 40600 39000
1 98 41000 40000
2 96 45000 43000
2 97 45400 44000
2 98 45800 42000
3 96 70000 67000
3 97 71600 70500
3 98 72000 70000
;
proc print;
run;

proc transpose data=long2 out=wide2 prefix=famiexp;
by famid; /*dice qual'è l'indentificativo delle righe*/
id year;/*setta il riferimento delle colonne*/
var famexp ;/*questo è la variabile del dataset wide, quella che viene trasposta*/
proc print;
run;

/*prima di fare la merge bisogna ordinare secondo la variabile comune*/
proc sort data=wide1;
by famid;
run;
proc sort data=wide2;
by famid;
run;

data famaccounting;
merge wide1(drop= _NAME_) wide2(drop= _NAME_); /*qua gli diciamo anche di eliminare la variabile inutile _NAME_*/
by famid;
proc print;
run;

/*usiamo dal file dataset_sas.sas per costruire il dataset long3*/
/*lo usiamo per definire una trasposta con chiavi multiple*/
data long3;    
INPUT famid birth measure ht;  /*birth è numero del figlio, ht è la variabile di interesse*/
cards;  
1 1 1 2.8  
1 1 2 3.4  
1 2 1 2.9  
1 2 2 3.8  
1 3 1 2.2  
1 3 2 2.9  
2 1 1 2.0  
2 1 2 3.2  
2 2 1 1.8  
2 2 2 2.8  
2 3 1 1.9  
2 3 2 2.4  
3 1 1 2.2  
3 1 2 3.3  
3 2 1 2.3  
3 2 2 3.4  
3 3 1 2.1  
3 3 2 2.9
;  
proc print;
run;  


proc transpose data=long3 out=wide3 prefix=ht; /*prefix è la variabile da trasporre*/
by famid birth; /*scriviamo le osservazioni secondo l'accoppiata famid e birth, è l'identificativo individuale*/
id measure; /*lui crea tante colonne quante sono le modalità della variabile age*/
var ht ;
proc print;
run;

/*from wide to long*/
/*comando inverso dalla tabella "larga" alla tabella "lunga" */

data wide1; 
  input famid faminc96 faminc97 faminc98 ; 
/*cards è analogo a datalines*/
cards; 
1 40000 40500 41000 
2 45000 45400 45800 
3 75000 76000 77000 
; 
proc print;
run;

proc transpose data=wide1 out=long1;
by famid;
proc print;
run;

data long1 (drop=_NAME_); /*questa è l'ultima operazione che sas fa del comando*/
set long1 (rename =(COL1=income)); /*rinomina col1 con income*/
year=input(substr(_NAME_,7),5.) ;
/*crea la nuova variabile year riempiendola con quello che leggi dalla _name_ dalla posizione 7 in poi, convertendola
in formato numerico (.) con al massimo 5 valori*/
proc print;
run;

/*****************
   ARRAY
******************/

/*struttura logica utilizzabile solo nel passo di data. Si utilizzano quando dobbiamo fare le stesse operazioni su un gran
numero di variabili.
Evita la ripetizioni di istruzioni ripetitive*/

proc import datafile="F:\SAS verzillo\SAS_dati\sanita.xls" 
out=sanita 
dbms=excel;
run;

proc print;
run;
/*abbiamo il reddito per 20 anni per categorie di lavoratori*/

/*scopo è cambiare il reddito in dollari in nuove variabili chiamate usd_income*/
/*il tasso di cambio al 15 gennaio era 1 euro =1.33 usd*/

data corso.sanita;
set sanita;
usd_income_1990=income_1990*1.33;
usd_income_1991=income_1991*1.33;
usd_income_1992=income_1992*1.33;
usd_income_1993=income_1993*1.33;

proc print;
run;

/*dato che scrivere per ogni variabile la stessa cosa è una noia mortale si può usare l'array*/
/*l'array di fatto stocca le variabili in una specie di vettore che automatizza le operazioni, 
da uno stock di variabili fa le cose e poi le mette in un altro stock di variabili nuove*/

data corso.sanita_usd;
set sanita;
array euros(22) income_1990-income_2011; /*abbiamo indicizzato le variabili in euro*/
array dollars(22) usd_income_1990-usd_income_2011; /*abbiamo indicizzato le variabili in euro*/
do i=1 to 22; 
dollars(i)=euros(i)*1.33;
end; /*chiudi il ciclo do*/
drop i;
proc print;
run;

/*scopo ora è modificare il formato di una variabile*/

data dates;
length date1 date2 date3 $10;
input date1 $ date2 $ date3;
datalines;
11jun08 11jun2008 06/11/2008
10jul08 10jul2008 07/10/2008
;
proc print;
run;

/*converto formato data*/
data convertite (drop=i);
set dates;
array c_dates(3) $10 date1-date3;
array n_dates(3) $10 n_date1-n_date3;
do i=1 to 3;
/*qui scrivo l'operazione per modificare il formato orario*/
n_dates(i)=input(c_dates(i), anydtdte10.); 
end; 
/*in pratica sas modifica la data a partire da un giorno zero impostato, tutte le date sono viste da sas come
prima o dopo questo giorno zero, un po' come fosse a.C. e d.C.*/
proc print;
run;

/*nuovo esempio abbiamo per gennaio la temperatura media, minima e massima
dobbiamo
1) trasformare le tre temperature da gradi centigradi a farenheit far=cent*(180/100)+32
2) stimare la temperatura alle ore 12 sapendo che temph12=media( temp min max)
3) vogliamo scrivere temph12 in gradi centigradi e farenheit*/

data mi_jan_2013; 
input day $ temp min max;
cards; 
jan1 1 -4 4 
jan2 2 2 5
jan3 4 -1 9
jan4 4 0 10
jan5 8 2 16
jan6 6 0 14
jan7 4 0 6
jan8 5 4 6
jan9 5 4 7
jan10 5 3 7
jan11 3 -1 5
jan12 4 -1 5
jan13 4 3 5
jan14 4 3 5
jan15 2 3 5
jan16 1 0 2
jan17 1 0 1
;
proc print;
run;

/*   punto 1 2  e 3  */
data mi_jan_2013_NEW (drop=i);
set mi_jan_2013;
temp_h12= mean(of temp min max);
	array cent(4) temp -- temp_h12;
	array far(4) temp_f -- temp_h12_f;
		do i=1 to 4;
		far(i)=cent(i)*(180/100)+32;
		end; 
proc print;
run;

proc means data=mi_jan_2013; /*la funzione proc means restituisce le descrittive delle variabili*/
run;
/*proc means è diverso da mean*/
