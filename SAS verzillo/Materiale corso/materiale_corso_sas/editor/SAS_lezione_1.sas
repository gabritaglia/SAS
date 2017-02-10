/*******************************************************************************************************************************
*******************************************************************************************************************************
*******************************************************************************************************************************
*******************************************************************************************************************************/


/****************************
	CREARE UNA LIBRARY
****************************/

libname lib "\\vmware-host\Shared Folders\Desktop\SAS_lezioni_master\Lezione_1\dataset_lez1";
run;

/*in alternativa, come detto, SAS crea in automatico una Library Temporanea chiamata "WORK" che però si svuota quando SAS termina*/

/*
HELP
- barra superiore ?
- http://support.sas.com
- www.ats.ucla.edu/stat/sas.htm
*/

/**************************************
  CARICARE UN FILE DATI IN UN DATASET
***************************************/

/* L'accesso ai dati può avvenire in forme differenti:
A -	dati su supporto cartaceo da inserire nel program editor digitandoli ex-novo
B -	dati memorizzati in un file esterno (.xls, .csv, .txt, etc...)
C -	dati ricavabili da un dataset già presente nel sistema SAS */

/*A - dati su supporto cartaceo da inserire ex-novo*/

/*******************************************************************************************************************************
*******************************************************************************************************************************
*******************************************************************************************************************************
*******************************************************************************************************************************/

/****************************
	IL PASSO DI DATA-1
****************************/

data uno;
input nome $ sesso $ eta altezza peso diabete;
datalines /* inizio dati dopo il ;*/;
Andrea M 25 185 90 1
Roberto M 71 167 65 0
Cristina F 24 163 55 1
Lucia F 14 173 52 0
Gianbattista M 88 198 89 1
/*fine dati con il ;*/;
run;
/*attenzione di default la lunghezza dei campi è 8 caratteri*/
data uno;
length nome $ 12;/*allungo a 12 la lunghezza della variabile nome*/
input nome $ sesso $ eta altezza peso diabete;
datalines /* inizio dati dopo il ;*/;
Andrea M 25 185 90 1
Roberto M 71 167 65 0
Cristina F 24 163 55 1
Lucia F 14 173 52 0
Gianbattista M 88 198 89 1
/*fine dati con il ;*/;
run;


/*B - dati memorizzati in un database esterno*/
/*B.1 - importazione tramite SAS Import Wizard*/ 
/*
-File
-Importa dati
-Define the data format
-Browse to select the data file
-Import
-dati vengono memorizzati o in work o in una library
*/
/* B.2 - importazione tramite DATA STEP*/


/*il comando FILENAME viene usato per collegare al programma SAS un file esterno,
assegnandogli un nome di riferimento utilizzabile, quando necessario, nei vari STEPS
Va utilizzato sempre prima di un DATA STEP*/

filename due "\\vmware-host\Shared Folders\Desktop\SAS_lezioni_master\Lezione_1\dataset_lez1\due.csv"; /*chiamiamolo due*/
data due;
length nome $ 12;
infile due delimiter=',' firstobs=2 obs=6; 
input nome $ sesso $ eta altezza peso diabete;
run;

/* B.3 - importazione tramite PROC*/
proc import datafile="\\vmware-host\Shared Folders\Desktop\SAS_lezioni_master\dataset_lez1\due.csv"
     out=due
     dbms=csv /*excel or dlm*/
     replace;
     getnames=yes;
run;

proc print;
run;

/*C - dati provenienti da un dataset già presente nel sistema*/
data tre; 
set uno;
if eta < 18 then cl_eta = 'giovane';
if eta > 18 & eta < 65 then cl_eta = 'adulto';
else cl_eta='anziano';
run;

/*SALVARE IL DATASET CREATO/IMPORTATO IN UNA LIBRERIA PERMANENTE*/
data lib.due;
set due;
run;
/*l'estensione del file costruito e` .SD2 ed è stato salvato nella directory windows "C:Desktop\library_SAS"*/

/*se volessi accedere ad un dataset memorizzato, opearandoci sopra*/
data lib.nuovo;
set lib.vecchio;
/*istruzioni*/
run;

/*ALCUNE PRIME PROCEDURE BASE utili a comprendere i passi di data (es print)*/
/*PROC PRINT*/
proc print data=uno;
var nome sesso altezza peso eta diabete;
run;
proc print data=tre; 
var eta cl_eta; 
run;
/*omettendo var stampa tutto il dataset con tutte le variabili in output*/
proc print data=tre;
run;

/*PROC SORT*/
/*
La procedura SORT serve a cambiare l’ordine dei record in un dataset; 
il criterio di ordinamento viene deciso e settato tramite il comando BY 
- se volessimo ordinare il nostro dataset in base alla variabile età per esempio scriveremmo:
*/
proc sort data=uno; 
by sesso; 
run;
proc print;
run;
/*per ordinare secondo criteri multipli, prima per eta e poi per sesso*/
proc sort data=uno; 
by sesso peso; 
proc print;
run;
/*OPZIONI - BY: l’ordinamento di partenza e` sempre dal piu` piccolo al piu` grande o dalla A alla Z (ascendente) 
  l'opzione DESCENDING prima della variabile lo inverte */
/*attenzione al tempo di elaborazione! big data tricks, e.g. merge (-->PROC SQL)*/
proc sort data=uno; 
by eta; 
proc print;
run;

proc sort data=uno; 
by descending eta; 
proc print;
run;

/*ESEMPIO SCLERODERMIA*/
/*
Nel file "sclero" sono riportati i dati di uno studio svolto su alcuni pazienti, 
provenienti da differenti cliniche, affetti da sclerodermia (una malattia della pelle caratterizzata 
da un ispessimento e da una elevata tensione dell’epidermide), con possibile coinvolgimento dei vasi sanguigni 
e degli organi interni. Parte di questi pazienti e` stata trattata con un nuovo farmaco, parte con un placebo 
(farmaco: 1=nuovo 2=placebo). 
Prima e dopo il trattamento si sono misurati i seguenti parametri per ogni paziente: 
- spessore della pelle (spess1 / spess2; maggiore il valore, peggiore la situazione);
- mobilita` della pelle (mobi1 / mobi2; maggiore il valore, migliore la situazione); 
- gravita` delle condizioni generali del paziente (condiz1 / condiz2; maggiore il valore, peggiore la situazione);

Consegna:
Vogliamo vedere, per i pazienti dalla clinica 45 fino alla 50, 
in quali pazienti si sono riscontrati alcuni miglioramenti nella variabile condizione generale, 
raggruppando i soggetti secondo il farmaco assunto e quantificando il miglioramento. 
I dati , in formato Excel, sono nel file ‘sclero.xls’*/

data sclero;
input Clinica	Paziente	Farmaco	Spess1	Spess2	Mobi1	Mobi2	Condiz1	Condiz2;
datalines;
42	1	1	6	6	436	441	5	4
42	2	1	5	5	438	442	4	3
43	3	1	18	20	380	193	7	5
42	4	2	13	16	314	374	9	5
44	5	2	10	20	380	396	5	3
41	6	1	26	26	189	. 9	8
40	7	2	40	43	356	378	5	2
42	8	2	19	8	445	564	6	4
43	9	1	24	28	209	209	9	7
44	10	2	19	20	380	374	3	2
37	11	2	16	19	191	192	3	1
41	12	1	13	14	323	367	9	8
43	13	1	18	7	444	563	4	3
37	14	2	26	30	211	310	7	5
42	15	1	18	18	378	373	9	5
43	16	2	6	7	675	636	5	3
44	17	2	18	18	378	373	6	4
39	18	2	23 . 424 543 6 4
37	19	1	18	18	338	363	9	7
41	20	2	30	30	193 . 3	2
41	21	2	44	47	360	382	7	6
38	22	1	23	12	449	568	2	1
38	23	2	28	32	213	213	5	2
38	24	2	23	24	384	378	4	3
43	25	1	20	23	195	196	7	5
39	26	1	17	18	327	371	9	5
44	27	2	17	19	211	310	9	8
40	28	2	12	11	378	373	5	2
40	29	2	9	7	675	636	6	4
40	30	2	28	31	440	444	9	7
39	31	1	26	28	307	351	3	2
37	32	1	18	21	211	310	3	1
44	33	1	7	5	378	373	2	1
45	34	2	38	43	184	195	7	6
45	35	2	24	27	472	537	2	1
45	36	1	26	29	255	211	5	2
43	37	2	6	6	675	636	9	8
39	38	1	23	27	440	444	5	2
39	39	2	27	23	164	175	6	4
46	40	2	9	9	347	309	9	7
44	41	2	12	15	432	398	3	2
47	42	1	5	5	435	440	5	4
46	43	1	7	7	440	444	4	3
46	44	1	17	18	191	192	7	5
46	45	2	12	15	313	373	9	5
46	46	2	9	11	359	395	5	3
47	47	1	28	28	191 . 9	8
47	48	2	7	7	383 . 5	2
48	49	2	18	17	444	563	6	4
48	50	1	26	30	211	310	9	7
49	51	2	18	18	378	373	3	2
49	52	2	7	7	675	636	3	1
49	53	1	6	6	531	521	2	1
50	54	1	19	9	432	398	5	1
50	55	2	17	9	510	448	3	1
;
proc print;
run;

data sclero_uno; 
set sclero;
migliora = condiz1 - condiz2; 
if migliora > 0;
if 45 <= clinica <= 50; 
run;
/*oppure*/
data sclero_uno; 
set sclero;
migliora = condiz1 - condiz2; 
if (migliora > 0) & (45 <= clinica <= 50); 
run;

proc sort; by farmaco; run;
proc print; by farmaco; run;
run;

/*PROC CONTENTS*/
proc contents;
run;

/*PROC EXPORT*/
proc export data=sclero_uno 
dbms=csv 
outfile="\\vmware-host\Shared Folders\Desktop\SAS_lezioni_master\Lezione_1\dataset_lez1\sclero.csv"
replace;
run;

/*ALCUNE OSSERVAZIONI SU COME SCRIVERE UN CODICE SAS*/
/*
A) 	X1-Xn 			si considerano tutte le variabili da X1 a Xn ( X1 X2 X3 ... Xn)
b) 	X--A 			si considerano tutte le variabili da X a A
	X-NUMERIC-A 	si considerano tutte le variabili numeriche da X a A
	X-CHARACTER-A 	si considerano tutte le variabili carattere da X a A
c) 	_NUMERIC_ 		si considerano tutte le variabili numeriche 
	_CHARACTER_ 	si considerano tutte le variabili carattere
	_ALL_ 			si considerano tutte le variabili
*/       

/*ESEMPIO*/
data quattro;
input x1 x2 y x3 x5;
datalines;
1 2 3 4 5
6 7 8 9 0
;
run;
proc print; 
var x1--x3; 
run;
proc print; 
var x1-x3; 
run;
proc print; 
var x1--x5; 
run;
proc print; 
var x1-x5; 
run;
/*attenzione all'errore nel log!*/


/*******************************************************************************************************************************
*******************************************************************************************************************************
*******************************************************************************************************************************
*******************************************************************************************************************************/


/****************************
MANIPOLAZIONE DI UN DATASET
****************************/

/*SELEZIONARE SOTTO-GRUPPI DI OSSERVAZIONI*/
/*L'identificazione e la selezione di sotto-gruppi di osservazioni contenute in un DataSet SAS 
è effettuabile in diversi modi. Vediamone alcuni*/

/*TRAMITE L'OPERATORE IF COME SELEZIONATORE*/
/*I comandi IF...THEN...ELSE vengono usati per creare nuove variabili, 
nel caso in cui il valore di queste dipende dal valore di una variabile gia` esistente. 
IF e THEN vanno considerati insieme come un unico comando, 
mentre ELSE viene usato di seguito, in un’altra ‘frase’, per migliorare l’efficienza del programma.
SAS controlla, per ogni record, se la condizione IF e` verificata.  

/*per affermazione*/
data uomini;
set tre;
if sesso='M';/*specifichiamo il criterio di selezione*/
run; 
/*per negazione*/
data donne;
set tre;
if sesso^='M';/*operatore diverso*/
run; 
/*per doppia negazione*/
data donne;
set tre;
if sesso='M' then delete;
run; 
proc print; 
run;
/*In generale: if then else*/
data uno;
set uno;
if eta <= 18 then cl_eta = 'giovane';
if eta > 18 & eta <= 65 then cl_eta = 'adulto';
else cl_eta='anziano'; /*attenzione ai missing*/
minorenne=0;
if eta ne 18 & eta<= 17 then minorenne=1; 
proc print;
run;
/*lista operatori:
	<= 					- minore uguale
	< 					- minore
	= 					- uguale
	> 					- maggiore
	>= 					- maggiore uguale
	^= oppure "ne" 		- diverso
	& oppure and		- &  (contemporaneamente)
	or					- or (oppure)
e.g if (eta > 18) &/and (eta <= 65) then cl_eta = 'adulto';
*/
/*se ho molte condizioni consecutive l'else aumenta l'efficienza (tempo di elaborazione) saltando le altre istruzioni
quando incontra quella corretta*/
/*esempio reddito*/
data income;
length nome $12. ruolo $15.; 
input nome $ sesso $ eta ruolo $ income ;
datalines /* inizio dati dopo il ;*/;
Andrea M 25 impiegato 27500
Roberto M 71 pensionato 18000
Cristina F 24 praticante 15000
Lucia F 14 studente 1500
Gianbattista M 88 pensionato 24600
/*fine dati con il ;*/;
run;
data income;
set income;
if income<= 1000 then scaglione=1;
else if (income>1000) and (income<= 5000) then scaglione=2;
else if (income>5000) and (income<= 10000) then scaglione=3;
else if (income>10000) and (income<= 15000) then scaglione=4;
else if (income>15000) and (income<= 20000) then scaglione=5;
else if (income>20000) and (income<= 25000) then scaglione=6;
else if (income>25000) and (income<= 30000) then scaglione=7;
else if (income>30000) and (income<= 35000) then scaglione=8;
else if income>35000 then scaglione=9;
run;
proc print;
run;


/*SELEZIONE DI OSSERVAZIONI CONSECUTIVE*/
data prime3; 
set tre(obs=3);
run;
proc print;
run;

data dalla3; 
set tre(firstobs=3);
run;
proc print;
run;

data centrali; 
set tre(firstobs=2 obs=3);
proc print; 
run;

/*SELEZIONE DI VARIABILI*/
/*Si effettua selezione delle variabili con l'utilizzo delle istruzioni di comando DROP e KEEP
Queste istruzioni sono complementari e servono per specificare: 
-	le variabili di un DataSet che non si vogliono mantenere nel nuovo (istruzione DROP); 
-	le variabili di un DataSet che si vogliono mantenere nel nuovo (istruzione KEEP);
*/

data etasesso; 
set tre;
drop altezza peso cl_eta diabete; /*keep nome eta sesso*/;
run;
proc print;
run;
/*Le istruzioni DROP e KEEP sono "non-eseguibili"! Possono pertanto comparire in qualunque punto di un passo di Data.*/
data sei; 
set tre (drop = cl_eta sesso); /*inserisco nel set il drop delle variabili*/
rapporto=altezza/peso /*aggiungo poi altre istruzioni*/;
run;

/*CAMBIO DI NOME ALLE VARIABILI*/
/*E` sufficiente usare l'istruzione RENAME nel passo di data*/
data nuovo(rename=(sesso=mf)); 
set tre;
rapporto=altezza/peso/* altre istruzioni */; 
run;

/*COSTRUZIONE DI PIU DATASET CONTEMPORANEAMENTE IN UN UNICO PASSO DI DATA*/
data maschi femmine; 
set tre; 
if sesso='M' then output maschi; 
else if sesso='F' then output femmine; 
else put 'osservazioni sbagliate' _all_;
run;
proc print data=maschi; 
run;
proc print data=femmine; 
run;
/*in alternativa possiamo utilizzare l'operatore SELECT-WHEN-(OTHERWISE)*/
data maschi femmine; 
set tre; 
select(sesso);
when('M') output maschi; 
when('F') output femmine; 
otherwise put 'osservazioni sbagliate' _all_;
end; 
run;
proc print data=maschi; 
run;
proc print data=femmine; 
run;

/*se ci fosse stato un valore errato avremmo ottenuto il seguente errore nel LOG SAS
	"osservazioni sbagliate nome= sesso= _ERROR_=0 _N_=1"
*/
data maschi femmine; 
set tre; 
select(sesso);
when('M') output maschi; 
when('f') output femmine; 
otherwise put 'osservazioni sbagliate' _all_;
end; 
run;

/*CONCATENAZIONE DI PIU' DATASETS*/
/*Si usa l'istruzione SET, come nel seguente esempio in cui i DS hanno le stesse variabili*/
data tutti; 
set maschi femmine;
run;
proc print; 
run;
/*Uutilizzando due volte consecutive l'istruzione SET il sistema in caso di stesse variabili sovrascrive e otteniamo 
un ds con il minimo delle osservazioni*/
data tutti2; 
set maschi; 
set femmine; 
proc print; 
run;
/*Le due istruzioni set si possono usare quando i DS hanno variabili diverse (ma rilevate sulla stessa popolazione). 
In questo caso i due DS risultano "affiancati"*/
data maschi1; 
set maschi; 
keep nome sesso eta;
data maschi2; 
set maschi; 
keep nome altezza peso;
data maschi3; 
set maschi1; 
set maschi2;
proc print; 
run;
/*Se i due Data Set hanno un ^= numero di osservazioni per ciascuna variabile, 
viene costruito un nuovo Data Set contenente tutte le variabili dei Data Set precedenti, 
mettendo a missing le osservazioni mancanti*/

/*Si ottiene lo stesso risultato con la più nota e utilizzata istruzione MERGE*/
proc sort data=maschi1; 
by nome;
run;
proc sort data=maschi2; 
by nome;
run;
data maschi3s; 
merge maschi1 maschi2;
by nome; 
run;
proc print; 
run;

/*VEDIAMO UN ALTRO ESEMPIO*/
data uno;
input n $ x y;
datalines;
a 12 13
b 14 15
d 16 17
;
run;
data due;
input n $ x z;
datalines;
a 22 23
b 24 25
c 26 27
;
run;

/*CONCATENO*/
data tre;
set uno;
set due;
run;
proc print; 
run;
/*MERGIO*/
data quattro;
merge uno due;
by n;
/*solitamente bisogna sempre ordinare tramite SORT i dataset da mergiare, in questo caso sono già ordinati di default*/
run; 
proc print; 
run;


/*LETTURA DI DATASETS DI TIPO "DIVERSO"*/
proc means data=uno; 
var altezza peso; 
output out=sommario mean=m_alt m_peso; /*crea un dataset con le medie e chiamale m_alt m_peso*/
run;

proc print data=sommario; 
run;

/*Vogliamo ora costruire un DataSet con gli scarti dalle medie. Operariamo nel seguente modo*/
data scarti;
if _n_=1 then set sommario; /*senza l'"if-then" si otterrebbe un DSS con tutte le var e un # di osservazioni = a quelle in sommario (primo Ds a cui si fa il set)*/
set uno; 
alt_c=altezza-m_alt; 
peso_c=peso-m_peso; 
drop _type_ _freq_; 
run;
/*Creiamo così un DataSet con le variabili di UNO piu` le due medie (m_alt e m_peso) e 
le due nuove variabili che sono gli scarti alt_c e peso_c*/
proc print; 
run;


/*******************************************************************************************************************************
*******************************************************************************************************************************
*******************************************************************************************************************************
*******************************************************************************************************************************/


/****************************
	IL PASSO DI DATA-2 
****************************/
/*LE FUNZIONI SAS*/
/*Le funzioni SAS sono dei programmi gia` scritti che si invocano con una parola chiave e 
restituiscono un valore calcolato sugli argomenti che vengono impostati per la funzione*/

/*
Le funzioni producono statistiche per ogni osservazione (riga) del DSS 
e producono risultati pari al numero di osservazioni
Le procedure invece producono statistiche per le variabili (colonne) nel DSS*/

/*es. funzione MEAN*/
data temperature; 
input citta $ t6 t12 t18;
media_temp=mean(t6, t12, t18);
datalines; 
Bari 25 27 26
Chiavari 20 25 23
Cremona 13 15 14
Genova 19 24 22 
Milano 15 18 18 
Napoli 26 30 29 
Palermo 28 31 27 
; 
run;

/*alternativamente possiamo scrivere*/
/*media_temp=mean(of t6--t18);*/
/*media_temp=mean(of t6 t12 t18);*/

proc print;
run;

/*es. procedura means*/
proc means;
run;

/*MISSING DATA*/
/*
Il valore di una variabile solitamente viene messo a missing se il campo di input e` blank oppure e` un punto "."
I valori mancanti si propagano nelle espressioni aritmetiche; 
nelle funzioni, invece, il discorso cambia.	I valori mancanti nei confronti vengono messi a "meno infinito".
Esempio.*/

data esempio; 
input dato1 dato2; 
somma=dato1+dato2; 
totale=sum(dato1,dato2); 
media1=(dato1+dato2)/2; /*scrivo l'espressione direttamente*/
media2=mean(dato1,dato2); /*invoco l'espressione mean già esistente*/
datalines; 
1 3
6 4
. 78 
8 1
12 14 
; 
run;

proc print;
run;

/*In generale le funzioni "ignorano" i valori missing; 
- SUM i missing sono considerati 0, 
- MEAN viene fatta la somma dei valori non missing e il risultato viene diviso per il numero dei valori non missing
*/

/*LA FUNZIONE LAG*/
/*
SAS tratta i dati un record alla volta, tuttavia potrebbe essere utile usare un valore preso dall’osservazione precedente! 
La funzione LAG assegna all’osservazione corrente una nuova variabile il cui valore e` quello di una determinata variabile
del record precedente. 

La forma della funzione e`:
nuova variabile = lag(variabile); 
*/

/*Supponiamo di avere un dataset con le temperature medie giorno per giorno: vogliamo calcolare
la relativa differenza giornaliera*/
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
/*Per poter saper la differenza dal primo al due di gennaio, e` necessario che entrambe le informazioni siano disponibili
sullo stesso record: la seguente istruzione aggiunge un nuova variabile PRE_TEMP alle variabili DAY e TEMP*/
data mi_jan_2013;
set mi_jan_2013;
pre_temp=lag(temp);
proc print;
run;
/* Ora per calcolare la differenza tra le temp del day i e del day i-1*/
data mi_jan_2013;
set mi_jan_2013;
diff = temp - pre_temp;
proc print;
run;

/*L'ISTRUZIONE RETAIN*/
/*E' una istruzione non eseguibile e quindi puo` essere messa in qualunque punto del passo di DATA
svolge le due seguenti funzioni: 
- trattiene i valori delle variabili dalla precedente esecuzione del passo di Data 
- assegna dei valori iniziali alle variabili
*/

data ADD; 
RETAIN TOTALE 0;
input PUNTEGGI; 
TOTALE=TOTALE+PUNTEGGI; 
DATALINES;
10 
3 
7 
5 
; 
run;
proc print;
run;
data ADD2; 
set ADD;
RETAIN CONTO 0; /*equivalente alle istruzioni seguenti che utilizzano la funzione SUM: Retain CONTO 0; CONTO=sum(CONTO, 3);*/
CONTO=CONTO+3;
run; 

proc print;
run;

/*RETAIN e valori MISSING*/
DATA ADD; 
RETAIN CONTO TOTALE 0;
INPUT PUNTEGGI; 
TOTALE=TOTALE+PUNTEGGI;
CONTO=CONTO+3; 
DATALINES;
10 
3 
7 
. (missing value) 
6
4 
; 
proc print;
run;

/*Se si volesse avere TOTALE con valore anche per le osservazioni 4, 5 e 6 si dovrebbe fare*/

DATA ADD; 
RETAIN CONTO TOTALE 0;
INPUT PUNTEGGI; 
TOTALE=SUM(TOTALE, PUNTEGGI);
CONTO=CONTO+3; 
DATALINES;
10 
3 
7 
. (missing value) 
6
4 
; 
proc print;
run;

/*Se si omettesse l'istruzione RETAIN le variabili TOTALE e PUNTEGGI avrebbero solo valori missing*/

DATA ADD; 
INPUT PUNTEGGI; 
TOTALE=TOTALE+PUNTEGGI;
CONTO=CONTO+3; 
DATALINES;
10 
3 
7 
. (missing value) 
6
4 
; 
proc print;
run;

/*LE FUNZIONI NUMERICHE*/
/*
abs(argomento) 				- valore assoluto
exp(argomento) 				- esponenziale
int(argomento) 				- valore intero
log(argomento)				- logaritmo
round(argomento, decimale) 	- arrotonda i decimali
sqrt(argomento)				- radice quadrata
*/

data funzioni;
input number;
cards; 
10.229 
-22.333 
12.559 
0.12 
9.41
5.67
-19.43
-4.67
9.89
9.99
; 
proc print;
run;

/*calcolo le funzioni numeriche di questi numbers*/


/*FUNZIONI di TESTO*/
/*
esempio con la funzione substring
Estrae in y una sottostringa dell’argomento x, che inizia dal carattere nella posizione specificata e di lunghezza n
y=substr(x, posizione, n);
*/
/*esempio codice clinica*/
data citta; 
input clinica $; 
cards; 
01mi 
02mi 
03mi 
04pv 
05pv 
06pd 
07pd 
; 
run;
data citta;
set citta;
city=substr(clinica,3,2); 
proc print;
run;


/*FUNZIONI di PROBABILITA'*/
/*
probbnml(p,n,x) per esempio fornisce P(X <= m), 
dove X e` una variabile casuale distribuita come una binomiale, 
0 <= p <= 1, e n e` il numero di prove
*/
data bino;
input m; 
n=5;
p=0.4; 
cards; 
0 
1 
2
3 
4 
5 
;
proc print;
run;
data bino;
set bino;
cdf=probbnml(p,n,m);
proc print; 
var m cdf;
run;




/****************************
		  GLI ARRAY
****************************/
/*
Gli array sono una struttura logica che non viene conservata nel DataSet ma che e` utilizzabile solo nel passo di Data 
nel quale l’array e` costruito.
Si usano quando bisogna fare le stesse operazioni su un gran numero di variabili.
*/

/*
"As a matter of fact, most of the time someone spends doing SAS programming is spent manipulating data. 
In an earlier career, I found myself spending upwards of 80% of my time just getting data in the ‘right shape’" 
(Ben Cochran)
*/

/*
Definition: A SAS array is a set of variables that are grouped together and referred to by a single name; 
- These variables are known as elements of the array.
- Each element is referred to by an index value which represents its position in the array;

You can do many things with SAS arrays. You can: 
-	perform repetitive calculations;
-	create many variables with like attributes; 
-	read data; 
-	make the same comparison for several variables; 
-	perform table lookup;
*/

/*ESEMPIO-1*/
/*
Abbiamo dati (stimati) delle retribuzioni annue di alcune categorie di lavoratori del comparto sanitario in euro.
Vogliamo trasformare tali dati in Dollari per una notiziario sulla sanità in Italia destinato ad un pubblico americano. 
dati=sanita.xls
*/
/*senza conoscere come scrivere un arrey avremmo scritto un codice di questo tipo*/
data sanita_dollari;
set lib.sanita;
/*cambio 1euro=1.33 dollari*/
d_income_1990=income_1990*1.33;
d_income_1991=income_1991*1.33;
d_income_1992=income_1992*1.33;
d_income_1993=income_1993*1.33;
d_income_1994=income_1994*1.33;
d_income_1995=income_1995*1.33;
d_income_1996=income_1996*1.33;
d_income_1997=income_1997*1.33;
d_income_1998=income_1998*1.33;
d_income_1999=income_1999*1.33;
d_income_2000=income_2000*1.33;
d_income_2001=income_2001*1.33;
d_income_2002=income_2002*1.33;
d_income_2003=income_2003*1.33;
d_income_2004=income_2004*1.33;
d_income_2005=income_2005*1.33;
d_income_2006=income_2006*1.33;
d_income_2007=income_2007*1.33;
d_income_2008=income_2008*1.33;
d_income_2009=income_2009*1.33;
d_income_2010=income_2010*1.33;
d_income_2011=income_2011*1.33;
proc print;
run;
/*invece possiamo scrivere*/
data sanita_d;
set lib.sanita;
array euros(22) income_1990-income_2011;
array dollars(22) income_d_1990-income_d_2011;
do i=1 to 22;
dollars{i}=(euros{i}*1.33);
end;
run;
proc print;
run;

/*ESEMPIO-2*/
/*
A certain dataset has all its date values in character variables (not true SAS dates). 
Write a DATA step to convert a series of character variables to numeric values.
*/

data dates; 
length date1 date2 date3 $10; 
input date1 $ date2 $ date3; 
datalines;
11jun08 11jun2008 06/11/2008 
10jul08 10jul2008 07/10/2008 
;
proc print;
run;

data convert (drop = i); 
set dates;
array c_dates (3) $ 10 date1-date3; 
array n_dates (3) n_date1-n_date3; 
do i = 1 to 3;
n_dates(i) = input(c_dates{i}, anydtdte10.);
end;
run; 
proc print data=convert; 
run;
/*Notice all the n_date variables have been converted to SAS dates and stored as numbers*/

/*ESEMPIO-3*/
/*
It is characterized by a series of cholesterol readings generated on a series of dates. 
Some patients have more readings than others.	
The head physician at the clinic wants to know the difference in readings for each patient from one month to the next
Write an appropriate SAS arrey code
*/
data cholesterol;
input patient_id 1-4 @5 date_1 date.9 @16 reading_1 @21 date_2 date.9 @32 reading_2 @37 date_3 date.9 @48 reading_3 @53 date_4 date.9 @64 reading_4;
datalines;
1009 03JAN2002 216.9 06FEB2002 212.3 09MAR2002 209.6 08APR2002 207.8
1017 02JAN2002 190.2 04FEB2002 189.5 05MAR2002 192.8 01APR2002 190.6
1023 04JAN2002 256.3 05FEB2002 249.5 06MAR2002 243.5 03APR2002 241.2
1234 05JAN2002 196.2 06FEB2002 199.9 07MAR2002 197.5 03APR2002 198.5
1333 06JAN2002 192.5 07FEB2002 196.5 08MAR2002 195.3 06APR2002 194.7
1354 07JAN2002 222.6 03FEB2002 226.2 04MAR2002 229.8 05APR2002 226.3
1378 03JAN2002 212.5 02FEB2002 210.8 05MAR2002 207.9 07APR2002 206.5
1444 04JAN2002 206.2 01FEB2002 202.3 02MAR2002 200.2 09APR2002 199.9
1545 05JAN2002 188.8 02FEB2002 189.0 03MAR2002 190.4 02APR2002 189.7
1812 06JAN2002 199.2 03FEB2002 198.2 04MAR2002 196.8 04APR2002 195.2
;
run;
proc print;
format date_1-date_4 date9.;
run;

data difference (drop=i); 
set cholesterol (drop=date_2-date_4);
array chol(4) reading_1-reading_4; 
array diff(3) diff1-diff3; 
do i = 1 to 3; 
diff(i)=chol(i+1)-chol(i);
end; 
rename date_1=Starting_Date;
run;
proc print data=difference(obs=9) width=min label;/*alcune opzioni, 9 obs nn tutte, aggiungo etichette alle variabili con label*/
var patient_id Starting_Date diff1-diff3;/*seleziono solo alcune variabili di interesse dell'head of the dept.*/
format Starting_Date mmddyy10.;/*formato che desidero /date9.*/
title "Changes in Cholesterol readings";/*aggiungo titolo*/
label diff1='Change from diff1 to diff2'/*aggiungo labels*/
label diff2='Change from diff2 to diff3' 
label diff3='Change from diff3 to diff4';
run;
/*Now use again an array processing to calculate the percent difference in readings from month to month*/
data p_difference (drop = i); 
set cholesterol (drop=date_2-date_4);
array chol(4) reading_1-reading_4; 
array diff(3)diff1-diff3; 
array percent(3); 
do i = 1 to 3; 
diff(i)=chol(i+1)-chol(i); 
percent(i)=diff(i)/chol(i);
end; 
rename date_1 = Starting_Date;
run;

proc print data=p_difference(obs=10) width=min label;/*aggiungo etichette alle variabili con label*/
var patient_id Starting_Date percent1-percent3;/*seleziono solo alcune variabili di interesse per l'head of the dept.*/
format Starting_Date mmddyy10. percent1-percent3 percent8.1;/*formato che desidero /date9.*/
title "Percent differences in Cholesterol readings";/*aggiungo titolo*/
label diff1='% Change from diff1 to diff2'/*aggiungo labels*/
label diff2='% Change from diff2 to diff3' 
label diff3='% Change from diff3 to diff4';
run;

/*ESERCIZI DA FARE IN AULA (10 min x uno): 
Nel dataset precedente avevamo le temperature medie, min e max registrate a Milano negli scorsi giorni di Gennaio 2013.
Trasformiamole tutte da gradi centigradi a gradi Farhenait
ricordando che un tra i gradi Farhenait e i gradi Centigradi vige la seguente relazione:
far=(cent*180/100)+32
supponendo che la temperatura alle ore 12:00 prevista a posteriori per ciascun giorno 
sia la media della minima, la massima e la avg, 
creo due variabili nuove con le temperature previste alle 12 di ciascun giorno 
in entrambe le unità di misura.

Idem con quelle del giorno precedente!

*/
proc print;
run;

data mi_jan_2013;
set mi_jan_2013;
array cent{3} temp--max;
	array far{3} temp_f min_f max_f;
	do i=1 to 3;
	far{i}=(cent{i}*180/100)+32;
	end;
drop i;
est_temp=mean(of cent{*});
est_temp_f=mean(of far{*});
proc print;
run;

/*utilizzare il dataset seguente*/
data sales;
input store year qtr amount;
datalines;
050 2005 1 23508.99 
050 2005 2 26172.41
050 2005 3 25676.63
050 2005 4 27431.05
050 2006 1 45968.31
050 2006 2 51178.09
050 2006 3 53602.54
050 2006 4 53728.53
050 2007 1 50389.34
050 2007 2 56524.56
050 2007 3 59063.14
050 2007 4 62038.21
050 2008 1 55953.56
050 2008 2 63808.45
050 2008 3 66917.95
050 2008 4 66967.36
;
proc print;
run;

/*
The VP of Sales predicts quarterly sales growth next year (2009) will be 1.1%, 2.2%, 0.1%, and 3.3%. 
Write a program that shows what the sales will be if this estimate is correct*/
proc transpose data=sales out=transpose_sales prefix=y2008q;
by year;
id qtr;
var amount;
proc print;
run;

data _4cast(drop=i);
set transpose_sales;
array qtrs(4) y2008q1 y2008q2 y2008q3 y2008q4;
array _4cast(4) y2009q1 y2009q2 y2009q3 y2009q4;
array pc_inc(4) _temporary_ (1.011 1.022 1.001 1.033);
do i=1 to dim(qtrs);
_4cast(i)=qtrs(i)*pc_inc(i);
end;
proc print;
run;



/*******************************************************************************************************************************
*******************************************************************************************************************************
*******************************************************************************************************************************
*******************************************************************************************************************************/


/****************************
	IL PASSO DI PROC
****************************/
/*PROC DATASET*/

proc dataset;


/*PROC TRANSPOSE*/

/*1. LONG TO WIDE*/
data long1 ;    
input famid year faminc ;
cards ;  
1 96 40000  
1 97 40500  
1 98 41000  
2 96 45000  
2 97 45400  
2 98 45800  
3 96 75000  
3 97 76000  
3 98 77000  
;  
run;  

proc transpose data=long1 out=wide1 prefix=faminc; /*prefix is an option specify the prefix used in constructing names for transposed variables*/     
by famid ;     
id year;     
var faminc; 
run;  
proc print data = wide1; 
run;  

/*SAS automaticly generates a variable called "_NAME_" which contains the name of the variable being transposed*/

/*Transposing two variables*/
/*
With only a few modifications, the above example can be used to reshape two (or more) variables. 
The approach here is to use proc transpose multiple times as needed. 
The multiple transposed data files then are merged back into one DSS only.
*/
data long2;    
input famid year faminc spend;  
cards;  
1 96 40000 38000  
1 97 40500 39000  
1 98 41000 40000  
2 96 45000 42000  
2 97 45400 43000  
2 98 45800 44000  
3 96 75000 70000  
3 97 76000 71000  
3 98 77000 72000
;  
run;  
/*traspongo il reddito famigliare*/
proc transpose data=long2 out=widef prefix=faminc;    
by famid;    
id year;    
var faminc; 
run;  
/*traspongo la spesa*/
proc transpose data=long2 out=wides prefix=spend;    
by famid;    
id year;    
var spend; 
run;  
/*mergio in un unico dataset --> "wide2" */
data wide2;     
merge  widef(drop=_name_) wides(drop=_name_);     
by famid; 
run;  
proc print data=wide2; 
run;  


/*Reshaping data with two variables that identify the wide record*/

/*
There is no variable that uniquely identifies each observation.  
Rather, two or more variables are necessary to uniquely identify each observation.  
So we need to use two or more var in the by statement!
*/

data long3;    
INPUT famid birth age ht;  
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
run;  

proc transpose data=long3 out=wide3 prefix=ht;    
by famid birth;    
id age;    
var ht; 
run;  

proc print data=wide3; 
run;  


/*And finally a more realistic example*/

/*
The following example is a realistic example that uses a data file having 
300 records in long format (50 wide records and six time points)
*/

data long4;    
input id year income;  
cards;   
1 90 66483   
1 91 69146   
1 92 74643   
1 93 79783   
1 94 81710   
1 95 86143   
2 90 17510   
2 91 17947   
2 92 19484   
2 93 20979   
2 94 21268   
2 95 22998   
3 90 57947   
3 91 62964   
3 92 68717   
3 93 70957   
3 94 75198   
3 95 75722   
4 90 64831   
4 91 71060   
4 92 71918   
4 93 72514   
4 94 73100   
4 95 74379   
5 90 18904   
5 91 19949   
5 92 21335   
5 93 22237   
5 94 23829   
5 95 23913   
6 90 32057   
6 91 34770   
6 92 35834   
6 93 37387   
6 94 40899   
6 95 42372   
7 90 60551   
7 91 64869   
7 92 67983   
7 93 70498   
7 94 71253   
7 95 75177   
8 90 16553   
8 91 18189   
8 92 18349   
8 93 19815   
8 94 21739   
8 95 22980   
9 90 32611   
9 91 33465   
9 92 35961   
9 93 36416   
9 94 37183   
9 95 40627  
10 90 61379  
10 91 66002  
10 92 67936  
10 93 70513  
10 94 74405  
10 95 76009  
11 90 24065  
11 91 24229  
11 92 25709  
11 93 26121  
11 94 26617  
11 95 28142  
12 90 32975  
12 91 36185  
12 92 37601  
12 93 41336  
12 94 43399  
12 95 43670  
13 90 69548  
13 91 71341  
13 92 72455  
13 93 76552  
13 94 80538  
13 95 85330  
14 90 50274  
14 91 53349  
14 92 55900  
14 93 59375  
14 94 61216  
14 95 63911  
15 90 72011  
15 91 73334  
15 92 76248  
15 93 77724  
15 94 78638  
15 95 80582  
16 90 18911  
16 91 20046  
16 92 21343  
16 93 21630  
16 94 22330  
16 95 23081  
17 90 68841  
17 91 75410  
17 92 80806  
17 93 81327  
17 94 81571  
17 95 86499  
18 90 28099  
18 91 30716  
18 92 32986  
18 93 36097  
18 94 39124  
18 95 39866  
19 90 17302  
19 91 18778  
19 92 18872  
19 93 19884  
19 94 20665  
19 95 21855  
20 90 16291  
20 91 16674  
20 92 16770  
20 93 17182  
20 94 17979  
20 95 18917  
21 90 43244  
21 91 46545  
21 92 47633  
21 93 50744  
21 94 54734  
21 95 59075  
22 90 56393  
22 91 59120  
22 92 60801  
22 93 61404  
22 94 63111  
22 95 69278  
23 90 47347  
23 91 49571  
23 92 50101  
23 93 51345  
23 94 56463  
23 95 56927  
24 90 16076  
24 91 17217  
24 92 17296  
24 93 17900  
24 94 18171  
24 95 18366  
25 90 65906  
25 91 69679  
25 92 76131  
25 93 77676  
25 94 81980  
25 95 85426  
26 90 58586  
26 91 61188  
26 92 66542  
26 93 69267  
26 94 71063  
26 95 74549  
27 90 61674  
27 91 66584  
27 92 69185  
27 93 75193  
27 94 78647  
27 95 81898  
28 90 31673  
28 91 31883  
28 92 32774  
28 93 34485  
28 94 36929  
28 95 39751  
29 90 63412  
29 91 67593  
29 92 69911  
29 93 73092  
29 94 80105  
29 95 81840  
30 90 27684  
30 91 28439  
30 92 30861  
30 93 31406  
30 94 32960  
30 95 35530  
31 90 71873  
31 91 76449  
31 92 80848  
31 93 88691  
31 94 94149  
31 95 97431  
32 90 62177  
32 91 63812  
32 92 64235  
32 93 65703  
32 94 69985  
32 95 71136  
33 90 37684  
33 91 38258  
33 92 39208  
33 93 39489  
33 94 39745  
33 95 41236  
34 90 64013  
34 91 66398  
34 92 71877  
34 93 75610  
34 94 76395  
34 95 79644  
35 90 16011  
35 91 16847  
35 92 17746  
35 93 19123  
35 94 19183  
35 95 19996  
36 90 49215  
36 91 52195  
36 92 52343  
36 93 56365  
36 94 58752  
36 95 59354  
37 90 15774  
37 91 16643  
37 92 17605  
37 93 18781  
37 94 18996  
37 95 19685  
38 90 29106  
38 91 31693  
38 92 31852  
38 93 34505  
38 94 35806  
38 95 36179  
39 90 25147  
39 91 26923  
39 92 28785  
39 93 30987  
39 94 34036  
39 95 34106  
40 90 71978  
40 91 79144  
40 92 80453  
40 93 86580  
40 94 95164  
40 95 96155  
41 90 46166  
41 91 47579  
41 92 49455  
41 93 53849  
41 94 56630  
41 95 57473  
42 90 55810  
42 91 59443  
42 92 65291  
42 93 66065  
42 94 69009  
42 95 74365  
43 90 49642  
43 91 50603  
43 92 53917  
43 93 54858  
43 94 58470  
43 95 59767  
44 90 21348  
44 91 22361  
44 92 23412  
44 93 24038  
44 94 24774  
44 95 25828  
45 90 44361  
45 91 48720  
45 92 51356  
45 93 54927  
45 94 56670  
45 95 58800  
46 90 56509  
46 91 60517  
46 92 61532  
46 93 65077  
46 94 69594  
46 95 73089  
47 90 39097  
47 91 40293  
47 92 43237  
47 93 44809  
47 94 48782  
47 95 53091  
48 90 18685  
48 91 19405  
48 92 20165  
48 93 20316  
48 94 22197  
48 95 23557  
49 90 73103  
49 91 76243  
49 92 76778  
49 93 82734  
49 94 86279  
49 95 86784  
50 90 48129  
50 91 49267  
50 92 53799  
50 93 58768  
50 94 63011  
50 95 66461  
;  
run;   
proc transpose data=long4 out=wide4 prefix=income;   
by id;   
id year;   
var income; 
run;  
proc print data=wide4 (obs=10); 
run;  

/*2. WIDE TO LONG*/

data wide1; 
  input famid faminc96 faminc97 faminc98 ; 
cards; 
1 40000 40500 41000 
2 45000 45400 45800 
3 75000 76000 77000 
; 
proc print;
run; 

proc transpose data=wide1 out=long1;
   by famid;
proc print data=long1;
run;

data long1 (drop=_NAME_);
set long1 (rename=(COL1=income));
year=input(substr(_name_, 7), 5.);
proc print;
run;

/*TRANSPOSING TWO GROUPS OF VARIABLES*/
/*
In the following data set we have two groups of variables that need to be transposed. 
The first group is family income across years and the second group is the spending across year. 
A simple approach here is to transpose one group of variables at a time and then merge them back together. 
In the data step where we merge the transposed data sets, 
we also create a numeric variable year based on the SAS automatic variable _NAME_ from the second transposed data set. 
*/ 


data wide2 ; 
      input famid faminc96 faminc97 faminc98 spend96 spend97 spend98 ; 
    cards ; 
    1 40000 40500 41000 38000 39000 40000 
    2 45000 45400 45800 42000 43000 44000 
    3 75000 76000 77000 70000 71000 72000 
; 
proc print;
run ;

proc transpose data=wide2 out=longf prefix=faminc ;
       by famid;
    var faminc96-faminc98;
run;

proc transpose data=wide2 out=longs prefix=spend ;
       by famid;
    var spend96-spend98;
run;

data long2;
       merge longf (rename=(faminc1=faminc) drop=_name_) longs (rename=(spend1=spend));
       by famid;
       year=input(substr(_name_, 6), 5.);
       drop _name_;
run;
proc print data=long2;
run;

/*RESHAPE width to long with a CHARACTER variable*/
/*
In the following data set we have three groups of variables that needs to be transposed. 
One of the groups is the indicator of debt across years. 
The approach is the same with either numeric variables or character variables. 
Since there are three groups of variables, we need to use proc transpose three times, one for each group. 
Then we merge them back together. 
In the data step where we merge the transposed data files together, 
we also create a numeric variable for year and rename each of the variables properly. 
The variable year is created based on the SAS automatic variable _NAME_ from the last transposed data set. 
*/

    data wide4; 
      input famid faminc96 faminc97 faminc98 spend96 spend97 
      spend98 debt96 $ debt97 $ debt98 $ ; 
    cards; 
    1 40000 40500 41000 38000 39000 40000 yes yes no 
    2 45000 45400 45800 42000 43000 44000 yes no  no 
    3 75000 76000 77000 70000 71000 72000 no  no  no 
    ; 
	proc print;
    run ;

    proc transpose data=wide4 out=longf prefix=faminc;
    by famid;
    var faminc96-faminc98; 
    run;

    proc transpose data=wide4 out=longs prefix=spend;
    by famid;
    var spend96-spend98;
    run;

    proc transpose data=wide4 out=longd prefix=debt;
    by famid;
    var debt96-debt98;
	proc print;
    run;

    data long4;
    	merge longf (rename=(faminc1=faminc) drop=_name_) 
    	      longs (rename=(spend1=spend) drop=_name_) 
    	      longd (rename=(debt1=debt));
    	by famid;
    	year=input(substr(_name_, 5), 5.);
       drop _name_;
	   proc print; run;


/*******************************************************************************************************************************
*******************************************************************************************************************************
*******************************************************************************************************************************
*******************************************************************************************************************************/


/****************************
   STATISTICHE DESCRITTIVE
****************************/
/*
Per descrivere dei dati e` necessario calcolare medie, deviazioni standard e percentili, 
disegnare grafici e organizzare i dati in tabelle. 
In SAS esistono diverse procedure pensate a questo scopo:
vedremo due procedure tra le più utilizzate che si utilizzano in questo contesto
- PROC UNIVARIATE; 
- PROC MEANS; 
*/

/*PROC MEANS*/
/*
La PROC MEANS e` la piu` semplice e immediata procedura per calcolare statistiche descrittive univariate di base
Per default la procedura genera la dimensione campionaria, la media, la deviazione standard, i valori massimi e minimi
Forma generale di una PROC MEANS:
proc means data = dataset <opzioni> ; 
by <variabili>;
var <variabili>;
output out= dataset_out stat(s)=nome_var(s);
run;
*/

/*I comandi LABEL e TITLE*/
/*
Opzioni preliminari all'uso delle proc:
alcune volte un output potrebbe risultare difficile da leggere causa il fatto che i nomi assegnati alle variabili 
possono avere al massimo una lunghezza di otto caratteri. 
Per ovviare a tale inconveniente --> l’utilizzo di etichette e titoli.
*/
/*
Il comando LABEL assegna un’etichetta ad una variabile, 
che apparira` nell‘output accanto al nome originale. 
La lunghezza massima e` di 40 caratteri; 
il comando e` valido sia nel DATA STEP che nel PROC STEP. 
*/
data facolta_medicina; 
length docente $14.;
      input stud_id tempo voto docente $ esito $; 
cards; 
055201 55 30 Velonesi yes 
055021 50 28 Lanpetta yes 
054675 49 25 Velonesi yes 
053891 59 24 Kustermas yes 
051982 60 15 Velonesi no 
052457 48 21 Kustermas yes 
059999 51 22 Velonesi yes 
050001 53 30 Kustermas yes 
058972 56 17 Lanpetta no 
055512 28 16 Velonesi no 
057978 55 29 Kustermas yes 
051012 58 28 Fassio yes 
050112 59 23 Lanpetta yes 
055101 57 24 Lanpetta yes 
047819 60 27 Fassio yes 
056721 46 19 Lanpetta yes 
044879 56 18 Fassio yes 
065721 52 12 Kustermas no 
056783 51 30 Fassio yes 
; 
proc print;
run ;



proc means;
label 
tempo = "tempo necessario a finire l'esame" /*calcola statistiche descrittive sulle variabili numeriche del Data Set SAS. 
E' simile alla PROC MEANS.	Di default non produce output. bISOGNA DARGLI OPZIONE PRINT
OPPURE OUTPUT OUT*/
PROC SUMMARY DATA=FACOLTA_MEDICINA PRINT;
VAR STUD_ID TEMPO VOTO;
RUN;
docente= "nome del docente"
voto  = ‘punteggio ottenuto all’’esame’; 
var tempo voto; 
run;
/*
Il comando TITLE assegna un titolo in testa ad ogni pagina di output; 
si possono creare piu` titoli in una stessa pagina numerandoli (TITLE1, TITLE2, ...), 
o cambiarli all’interno del programma.
*/
proc means;
label 
tempo = "tempo necessario a finire l'esame" 
;
title 
"Tempo medio esami Medicina Interna 2013";
;
var tempo;
run;

/*ESERCIZIO - 
data --> kids in three families with serious deseases
1 step --> collapse across kids to form 'family records' from the 'kids records' with means of age and wt

*/

/*SOLUZIONE*/
DATA kids;
      LENGTH kidname $ 4 sex $ 1;
      INPUT famid kidname birth age wt sex ;
    CARDS;
    1 Beth 1  9  60  f
    1 Bob  2  6  40  m
    1 Barb 3  3  20  f
    2 Andy 1  8  80  m
    2 Al   2  6  50  m
    2 Ann  3  2  20  f
    3 Pete 1  6  60  m
    3 Pam  2  4  40  f
    3 Phil 3  2  20  m
    ;
RUN;

PROC PRINT DATA=kids;
RUN;
/*first step*/
PROC MEANS DATA=kids ;
      class famid;
      VAR age;
      OUTPUT OUT=fam2 MEAN= ;
RUN;
PROC PRINT DATA=fam2;
RUN;
/*elimino la media overall (_freq_=9) con l'opzione nway*/
PROC MEANS DATA=kids NWAY ;
      CLASS famid;
      VAR age;
      OUTPUT OUT=fam3 MEAN=avg_age;
RUN;
PROC PRINT DATA=fam3;
RUN;
/*+ statistiche contemporaneamente*/
PROC MEANS DATA=kids NWAY ;
      CLASS famid;
      VAR age;
      OUTPUT OUT=fam4 MEAN=avg_age STD=std_age;
RUN;
PROC PRINT DATA=fam4;
RUN;
/*+ variabili e + statistiche contemporaneamente*/
PROC MEANS DATA=kids NWAY  noprint; /*option noprint suppresses the output in case of big data*/
      CLASS famid;
      VAR age wt;
      OUTPUT OUT=fam5 MEAN=avg_age avg_wt STD=std_age std_wt N=n_age n_wt;
RUN;
PROC PRINT DATA=fam5;
RUN;

/*vogliamo contare ora quanti figli maaschi e quante figlie femmine ci sono in ogni famiglia*/
DATA kids2 ;
  SET kids;
If sex = "m" THEN boy = 1; ELSE boy = 0 ;
If sex = "f" THEN girl= 1; ELSE girl= 0 ;
RUN;
proc print;
var famid sex boy girl;
run;
/*sommo per famiglia le variabili boy and girl*/
PROC MEANS DATA=kids2 NWAY NOPRINT ;
  CLASS famid;
  VAR boy girl ;
  OUTPUT OUT=fam6 SUM=boys girls ;
RUN;
proc print;
run;

/*PROC UNIVARIATE*/
/*
Proseguendo l’esempio precedente sui dati di uno studio sulla sclerodermia, 
generiamo alcune statistiche descrittive. 
In particolare vogliamo: 
-	assegnare al nome di alcune variabili una descrizione piu` lunga; 
-	descrivere le diverse statistiche riguardanti il miglioramento delle condizioni generali nel
gruppo che ha assunto il nuovo farmaco e in quello che ha assunto il placebo
*/

data sclero_one; 
set sclero; 
migliora = condiz1 - condiz2;
label
farmaco = ‘farmaco (1) o placebo (2)’ 
migliora = ‘miglioramento delle condizioni’; 
run;

proc univariate; 
var migliora; 
id paziente;
title ‘Studio sulla Sclerodermia’; 
run;

/*by farmaco=1 o placebo=2*/
/*
Se volessimo generare statistiche separate per variabile (nel nostro caso 'farmaco') 
usiamo il comando BY, dopo esserci assicurati che il dataset sia stato ordinato (SORT) per quella variabile.
*/
proc sort; 
by farmaco;
run;
proc univariate; 
by farmaco;
var migliora; 
id paziente;
title ‘Studio sulla Sclerodermia’; 
run;
proc print;
run;
/*
L’Output mostra il risultato relativo alla variabile ‘miglioramento delle condizioni’ 
nel gruppo che ha assunto il farmaco. 
Nella prima parte dell’output troviamo il numero di osservazioni (N)=55, 
la media campionaria (Mean), la deviazione standard campionaria (Std Dev), 
la somma aritmetica dei valori delle osservazioni (Sum), e la varianza campionaria (Variance); 
quindi i quantili, la mediana (Med), il range e la moda (Mode).
Vengono poi presentati i valori piu` bassi e quelli piu` alti del dataset: 
*/


/****************************
 		  FREQUENZE
****************************/
/*Il modo piu` semplice e immediato per descrivere dei dati e` organizzarli in tabelle. 
In questa parte analizzeremo la procedura che genera tabelle (PROC FREQ).
La PROC FREQ fornisce, per il dataset in esame, le frequenze relative al valore di una variabile o 
alla combinazione dei valori relativi a due o piu` variabili.
Se la variabile in esame e` continua o ha molti valori ad essa assegnati, 
le tabelle che otterremo riferite a quella variabile saranno poco informative. 
Spesso i dati, prima di essere analizzati e presentati, devono essere organizzati in categorie.
Nella sua forma piu` semplice, la procedura, quando riferita ad una variabile, 
genera una tabella ad un’entrata riassuntiva, con informazioni sulla frequenza di ogni valore, 
la sua percentuale sul totale e quella cumulativa. 
Per due variabili si ottiene una tabella a doppia entrata contenente le frequenze di ogni cella, 
la loro percentuale sul totale generale, sul totale di riga e sul totale di colonna.
Nella PROC FREQ, per specificare per quali variabili costruire le tabelle, si usa il comando TABLES.

Forma generale di una PROC FREQ:
proc freq data = dataset ; 
by variabili; 
tables var1*var2 / < opzioni >;
run;
*/
DATA auto ;
length MAKE $15.;
  input MAKE $ PRICE MPG REP78 FOREIGN ;
DATALINES;
AUDI    14099 22 3 0
AUDI    14749 17 3 0
AUDI    13799 22 3 0
FIAT   9690 17 5 1
FIAT   6295 23 3 1
BMW    19735 25 4 0
Volkswagen  4816 20 3 0
Volkswagen  7827 15 4 0
Volkswagen  5788 18 3 0
Volkswagen  4453 26 3 0
Volkswagen  5189 20 3 0
Volkswagen 10372 16 3 0
Volkswagen  4082 19 3 0
Lancia  11385 14 3 1
Lancia  14500 14 2 1
Lancia  15906 21 3 1
Chevrolet  3299 29 3 1
Chevrolet  5705 16 4 1
Chevrolet  4504 22 3 1
Chevrolet  5104 22 2 1
Chevrolet  3667 24 2 1
Chevrolet  3955 19 3 1
Toyota 6229 23 4 1
Toyota 4589 35 5 1
Toyota 5079 24 4 1
Toyota 8129 21 4 1
;
RUN;
proc print;
run;

PROC PRINT DATA=auto(obs=10);
RUN; 

/*we use proc freq to produce frequencies tables for rep78 (repair history of the car) foreign (or domestic) make (name)*/
PROC FREQ DATA=auto;
  TABLES make ;
RUN;

PROC FREQ DATA=auto;
  TABLES rep78 ;
RUN;

PROC FREQ DATA=auto;
  TABLES foreign ;
RUN; 
/*se le volessi le 3 tabelle da un unico comando*/
PROC FREQ DATA=auto;
  TABLES make rep78 foreign ;
RUN; 
/*voglio una tabella a doppia entrata con la storia delle riparazioni per le auto nazionali e quelle straniere*/
PROC FREQ DATA=auto;
  TABLES rep78*foreign ;/*l'asterisco definisce la cross-tabulazione*/
RUN; 
PROC FREQ DATA=auto;
  TABLES rep78*foreign / NOROW NOCOL NOFREQ;/*rende più snella la tabella togliendo le percentuali di riga colonna etc*/
 RUN; 



/*******************************************************************************************************************************
*******************************************************************************************************************************
*******************************************************************************************************************************
*******************************************************************************************************************************/


/****************************
 			CICLO DO
****************************
SINTASSI GENERALE:

DO (variabile indice) = (val. iniziale) TO (val. finale) BY (incremento) 
WHILE (espressione ) [UNTIL(espressione ) ;
istruzioni ; 
END; 

dove: 
- la variabile indice puo` anche essere di tipo carattere;
- val.iniziale e val.finale possono essere sostituiti da una serie di valori separati da ","
attenzione: nel Data Set viene scritto solo il valore che le variabili (create o modificate nelle istruzioni che 
compaiono "dentro il DO") hanno alla fine dell'esecuzione dell'istruzione DO; 
se si vuole conservare il valore delle variabili a ogni passo del DO 
e` necessario scrivere "dentro il DO" l'istruzione OUTPUT;
*/

/*ESEMPI DI UTILIZZO DEL CICLO DO*/

data Do;
input x y a$;
datalines;
5 7 n
3 2 a
4 7 a
2 1 n
5 5 n
;
RUN;
/*voglio moltiplicare la variabile x per i=5*/
data Do_uno;
set Do;
do i=5;
z=x*i;
end;
proc print;
run;

/*moltiplico x per 5 e per 7*/
data Do_due;
set Do;
do i=5,7;
z=x*i;
output;/*essenziale se no sovrascrive 7 su 5*/
end;
proc print;run;

/*moltiplico per la variabile y*/
data Do_tre;
set Do;
do i=y;
z=x*i;
output;
end;
proc print;run;
/*moltiplico per i valori delle variabili y e x*/
data Do_quattro;
set Do;
do i=y, x;
z=x*i;
output;
end;
proc print;run;
/*voglio trovare il valore di x moltiplicato i primi 4 numeri dispari*/
data Do_cinque;
set Do;
do i=1 to 7 by 2;
z=x*i;
output;
end;
proc print;run;
/*idem con le variabili di tipo character: voglio aggiungere le lettere r s t alla colonna a*/
data Do_sei;
set Do;
do i='r','s','t';
z=trim(a)||i; /*la funzione trim elimina gli spazi -se presenti- dal campo a*/
output;
end;
proc print;run;
/*DO UNTIL*/
/*aggancio una colonna "n" con per ogni record i numeri fino a 6 incrementando di 1*/
data Do_sette;
set Do;
n=0;
do until(n>5);	
n+1;
output;
end;
proc print;run;

/*DO WHILE*/
/*stessa consegna del caso sette ma con il while*/
data Do_otto;
set Do;
n=0;
do while (n<=5);
n+1;
output;
end;
proc print;run;



/*******************************************************************************************************************************
*******************************************************************************************************************************
*******************************************************************************************************************************
*******************************************************************************************************************************/



/****************************
 RAPPRESENTAZIONI GRAFICHE
****************************/

/*Creating charts with PROC GCHART*/

/*
 We create vertical Bar Charts with proc gchart and the vbar statement.   
 The program below creates a vertical bar chart for mpg*/

TITLE 'Simple Vertical Bar Chart ';
PROC GCHART DATA=auto;
          VBAR mpg;
RUN; 

/*
The vbar statement produces a vertical bar chart.  
Since mpg is a continuous variable the automatic "binning" of the data into five groups yields a readable chart. 
The midpoint of each bin labels the respective bar
*/

/*You can control the number of bins for a continuous variable with the level= option on the vbar statement.   
The program below creates a vertical bar chart with seven bins for mpg.*/

TITLE 'Bar Chart - Control Number of Bins';
    PROC GCHART DATA=auto;
         VBAR mpg/LEVELS=7;
RUN; 


/*
On the other hand, rep78 has only four categories and SAS's tendency to bin into five categories and use 
midpoints would not do justice to the data.  
So when you want to use the actual values of the variable to label each bar you will want to use the discrete 
option on the vbar statement*/

    TITLE 'Bar Chart with Discrete Option';
    PROC GCHART DATA=auto;
          VBAR rep78/ DISCRETE;
    RUN; 

/*Other charts may be easily produced simply by changing vbar.  
	For example, you can produce a horizontal bar chart by replacing vbar with hbar
	*/

    TITLE 'Horizontal Bar Chart with Discrete';
    PROC GCHART DATA=auto;
          HBAR rep78/ DISCRETE;
    RUN; 
 
/*With hbar you automatically obtain frequency, cumulative frequency, percent, and cumulative percent to the right 
	of each bar*/

/*
You can produce a pie chart by replacing hbar in the above example with pie.  
The value=, percent=, and slice= options control the location of each of those labels.
*/

    TITLE 'Pie Chart with Discrete';
    PROC GCHART DATA=auto;
          PIE rep78/ DISCRETE VALUE=INSIDE
                     PERCENT=INSIDE SLICE=OUTSIDE;
    RUN; 

/*
Use the discrete option to insure that only the values in the dataset for rep78 label slices in the pie chart. 
- value=inside causes the frequency count to be placed inside the pie slice.
- percent=inside causes the percent to be placed inside the pie slice.
- slice=outside causes the label (value of   rep78) to be placed outside the pie slice.
We have shown only some of the charts and options available to you.  
	Additionally you can create city block charts (block) and star charts (star), 
	and use options and statements to further control the look of charts.
*/


/*Creating Scatter plots with PROC GPLOT*/

/*To examine the relationship between two continuous variables you will want to produce a scattergram using proc gplot, 
and the plot statement.  The program below creates a scatter plot for mpg*weight.  
	This means that mpg will be plotted on the vertical axis, and weight will be plotted on the horizontal axis*/

    TITLE 'Scatterplot - Two Variables';
    PROC GPLOT DATA=auto;
         PLOT mpg*weight ;
    RUN; 
/*
- there is a negative relationship between mpg and weight (As weight increases mpg decreases)

You may want to examine the relationship between two continuous variables and see which points fall into one 
	or another category of a third variable.  
The program below creates a scatter plot for mpg*weight with each level of  foreign marked.  
You specify mpg*weight=foreign on the plot statement to have each level of foreign identified on the plot*/

    TITLE 'Scatterplot - Foreign/Domestic Marked';
    PROC GPLOT DATA=auto;
         PLOT mpg*weight=foreign;
    RUN; 

/*
	You can easily tell which level of  foreign you are looking at, as values of zero are in black and values of 1 
	are in red.  Since the default symbol is plus for both, if this graph is printed in black and white you will 
	not be able to tell the levels of  foreign apart.  
	The next example demonstrates how to use different symbols in scattergrams. 
*/ 

/*The program below creates a scatter plot for mpg*weight with each level of  foreign marked.  
	The proc gplot is specified exactly the same as in the previous example.  
	The only difference is the inclusion of symbol statements to control the look of the graph through 
	the use of the operands V=, I=, and C=.*/

    SYMBOL1 V=circle C=black I=none;
    SYMBOL2 V=star   C=red   I=none;
    TITLE 'Scatterplot - Different Symbols';
    PROC GPLOT DATA=auto;
         PLOT mpg*weight=foreign;
    RUN; 
    QUIT;

/*
	Symbol1 is used for the lowest value of  foreign which is zero (domestic cars), 
	and symbol2 is used for the next lowest value which is one (foreign cars) in this case.

    V= controls the type of point to be plotted.  We requested a circle to be plotted for domestic cars, 
		and a star (asterisk) for foreign cars.
    I= none causes SAS not to plot a line joining the points.
    C= controls the color of the plot. We requested black for domestic cars, and red for foreign cars.  
*/

/*
At times it is useful to plot a regression line along with the scatter gram of points.  
	The program below creates a scatter plot for mpg*weight with such a regression line.  
	The regression line is produced with the I=R operand on the symbol statement.*/

    SYMBOL1 V=circle C=blue I=r;
    TITLE 'Scatterplot - With Regression Line ';
    PROC GPLOT DATA=auto;
         PLOT mpg*weight ;
    RUN;
    QUIT; 

/*
The symbol statement controls color, the shape of the points, and the production of a regression line.

    I=R causes SAS to plot a regression line.
    V=circle causes a circle to be plotted for each case.
    C=blue causes the points and regression line to appear in blue. 
	Always specify the C= option to insure that the symbol statement takes effect.
*/


/*******************************************************************************************************************************
*******************************************************************************************************************************
*******************************************************************************************************************************
*******************************************************************************************************************************/


/**************************************************
	AN OVERVIEW OF STATISTICAL TESTS IN SAS
**************************************************
Si mostra ora come effettuare alcuni semplici test statistici con SAS
- t-tests 
- chi square 
- correlation 
- regression 
- analysis of variance
dati simili ai precedenti sul mercato dell'auto 
*/

DATA auto ;
  LENGTH make $ 20 ;
  INPUT make $ 1-17 price mpg rep78 hdroom trunk weight 
        length turn displ gratio foreign ;
CARDS;
AMC Concord        4099  . 3 2.5 11 2930 186 40 121 3.58 0
AMC Pacer          4749  . 3 3.0 11 3350 173 40 258 2.53 0
AMC Spirit         3799  . . 3.0 12 2640 168 35 121 3.08 0
Audi 5000          9690 17 5 3.0 15 2830 189 37 131 3.20 1
Audi Fox           6295 23 3 2.5 11 2070 174 36  97 3.70 1
BMW 320i           9735 25 4 2.5 12 2650 177 34 121 3.64 1
Buick Century      4816 20 3 4.5 16 3250 196 40 196 2.93 0
Buick Electra      7827 15 4 4.0 20 4080 222 43 350 2.41 0
Buick LeSabre      5788 18 3 4.0 21 3670 218 43 231 2.73 0
Buick Opel         4453 26 . 3.0 10 2230 170 34 304 2.87 0
Buick Regal        5189 20 3 2.0 16 3280 200 42 196 2.93 0
Buick Riviera     10372 16 3 3.5 17 3880 207 43 231 2.93 0
Buick Skylark      4082 19 3 3.5 13 3400 200 42 231 3.08 0
Cad. Deville      11385 14 3 4.0 20 4330 221 44 425 2.28 0
Cad. Eldorado     14500 14 2 3.5 16 3900 204 43 350 2.19 0
Cad. Seville      15906 21 3 3.0 13 4290 204 45 350 2.24 0
Chev. Chevette     3299 29 3 2.5  9 2110 163 34 231 2.93 0
Chev. Impala       5705 16 4 4.0 20 3690 212 43 250 2.56 0
Chev. Malibu       4504 22 3 3.5 17 3180 193 31 200 2.73 0
Chev. Monte Carlo  5104 22 2 2.0 16 3220 200 41 200 2.73 0
Chev. Monza        3667 24 2 2.0  7 2750 179 40 151 2.73 0
Chev. Nova         3955 19 3 3.5 13 3430 197 43 250 2.56 0
Datsun 200         6229 23 4 1.5  6 2370 170 35 119 3.89 1
Datsun 210         4589 35 5 2.0  8 2020 165 32  85 3.70 1
Datsun 510         5079 24 4 2.5  8 2280 170 34 119 3.54 1
Datsun 810         8129 21 4 2.5  8 2750 184 38 146 3.55 1
Dodge Colt         3984 30 5 2.0  8 2120 163 35  98 3.54 0
Dodge Diplomat     4010 18 2 4.0 17 3600 206 46 318 2.47 0
Dodge Magnum       5886 16 2 4.0 17 3600 206 46 318 2.47 0
Dodge St. Regis    6342 17 2 4.5 21 3740 220 46 225 2.94 0
Fiat Strada        4296 21 3 2.5 16 2130 161 36 105 3.37 1
Ford Fiesta        4389 28 4 1.5  9 1800 147 33  98 3.15 0
Ford Mustang       4187 21 3 2.0 10 2650 179 43 140 3.08 0
Honda Accord       5799 25 5 3.0 10 2240 172 36 107 3.05 1
Honda Civic        4499 28 4 2.5  5 1760 149 34  91 3.30 1
Linc. Continental 11497 12 3 3.5 22 4840 233 51 400 2.47 0
Linc. Mark V      13594 12 3 2.5 18 4720 230 48 400 2.47 0
Linc. Versailles  13466 14 3 3.5 15 3830 201 41 302 2.47 0
Mazda GLC          3995 30 4 3.5 11 1980 154 33  86 3.73 1
Merc. Bobcat       3829 22 4 3.0  9 2580 169 39 140 2.73 0
Merc. Cougar       5379 14 4 3.5 16 4060 221 48 302 2.75 0
Merc. Marquis      6165 15 3 3.5 23 3720 212 44 302 2.26 0
Merc. Monarch      4516 18 3 3.0 15 3370 198 41 250 2.43 0
Merc. XR-7         6303 14 4 3.0 16 4130 217 45 302 2.75 0
Merc. Zephyr       3291 20 3 3.5 17 2830 195 43 140 3.08 0
Olds 98            8814 21 4 4.0 20 4060 220 43 350 2.41 0
Olds Cutl Supr     5172 19 3 2.0 16 3310 198 42 231 2.93 0
Olds Cutlass       4733 19 3 4.5 16 3300 198 42 231 2.93 0
Olds Delta 88      4890 18 4 4.0 20 3690 218 42 231 2.73 0
Olds Omega         4181 19 3 4.5 14 3370 200 43 231 3.08 0
Olds Starfire      4195 24 1 2.0 10 2730 180 40 151 2.73 0
Olds Toronado     10371 16 3 3.5 17 4030 206 43 350 2.41 0
Peugeot 604       12990 14 . 3.5 14 3420 192 38 163 3.58 1
Plym. Arrow        4647 28 3 2.0 11 3260 170 37 156 3.05 0
Plym. Champ        4425 34 5 2.5 11 1800 157 37  86 2.97 0
Plym. Horizon      4482 25 3 4.0 17 2200 165 36 105 3.37 0
Plym. Sapporo      6486 26 . 1.5  8 2520 182 38 119 3.54 0
Plym. Volare       4060 18 2 5.0 16 3330 201 44 225 3.23 0
Pont. Catalina     5798 18 4 4.0 20 3700 214 42 231 2.73 0
Pont. Firebird     4934 18 1 1.5  7 3470 198 42 231 3.08 0
Pont. Grand Prix   5222 19 3 2.0 16 3210 201 45 231 2.93 0
Pont. Le Mans      4723 19 3 3.5 17 3200 199 40 231 2.93 0
Pont. Phoenix      4424 19 . 3.5 13 3420 203 43 231 3.08 0
Pont. Sunbird      4172 24 2 2.0  7 2690 179 41 151 2.73 0
Renault Le Car     3895 26 3 3.0 10 1830 142 34  79 3.72 1
Subaru             3798 35 5 2.5 11 2050 164 36  97 3.81 1
Toyota Celica      5899 18 5 2.5 14 2410 174 36 134 3.06 1
Toyota Corolla     3748 31 5 3.0  9 2200 165 35  97 3.21 1
Toyota Corona      5719 18 5 2.0 11 2670 175 36 134 3.05 1
Volvo 260         11995 17 5 2.5 14 3170 193 37 163 2.98 1
VW Dasher          7140 23 4 2.5 12 2160 172 36  97 3.74 1
VW Diesel          5397 41 5 3.0 15 2040 155 35  90 3.78 1
VW Rabbit          4697 25 4 3.0 15 1930 155 35  89 3.78 1
VW Scirocco        6850 25 4 2.0 16 1990 156 36  97 3.78 1
;
RUN;

/*T-test*/
/*
perform a t-test to determine whether the average mpg (gas mileage) for domestic cars differ from the foreign cars
Quando si ha a che fare con un campione di osservazioni, le differenze eventualmente osservate tra le medie 
condizionate (campionarie) devono essere analizzate da un punto di vista inferenziale. 
Si e` quindi interessati a valutare se esse sono significative, cioe` se riflettono reali differenze anche 
nella popolazione oppure se sono dovute al caso (cioe` sono legate in qualche modo al fatto che stiamo considerando 
campioni e non popolazioni). Il test T risponde a questa domanda nel caso in cui le medie poste a confronto 
siano due (qualora si fosse interessati a confrontare piu` di due medie si dovrebbe ricorrere all’analisi della 
varianza). 
Le assunzioni alla base del test T sono le seguenti:

1)Le osservazioni devono essere tra loro indipendenti
2)La variabile dipendente deve avere distribuzione normale
3)Le varianze all’interno degli strati devono essere uguali
  
*/

    PROC TTEST DATA=auto;
      CLASS foreign; /*variabile discriminante i due gruppi*/
      VAR mpg; /* gas mileage var*/
    RUN;

/*
The results show that: 
	- looking at simple statistics the mean is higher for foreign wrt domestic cars. But are we sure that this is not
	due to the particular sample? -->t-test
	- the overall N is 71 (not 74). This is because mpg was missing for 3 of the observations --> omitted 
	- foreign cars have significantly higher gas mileage ( mpg ) than domestic cars;
	- th variances are equal (accetto ipotesi nulla xkè il p-value è superiore a 0.05)* 
	- the difference is significant for the equality of variances;  

	*This is especially important when the sample sizes for the 2 groups differ, because when the variances of the two groups 
	differ and the sample sizes of the two groups differ, then the results assuming Equal variances can be quite 
	inaccurate and could differ from the Unequal variance result.

L’individuazione di una dipendenza statistica non puo` e non deve necessariamente tradursi in un nesso di causa-effetto!!
*/

/*CHI-SQUARE TEST*/
/*Lo scopo del test è quello di conoscere se le frequenze osservate differiscono 
	significativamente dalle frequenze teoriche.
- Se X2 = 0, le frequenze osservate coincidono esattamente con quelle teoriche. 
- Se invece X2 > 0, esse differiscono. 
Più grande è il valore di X2, più grande è la discrepanza tra le frequenze osservate e quelle teoriche. 
Nella pratica le frequenze teoriche vengono calcolate sulla base di un’ipotesi H0. 
Se sulla base di questa ipotesi il valore calcolato di X2 è più grande di un certo valore critico 
	(come 20.95 o 20.99, che sono i valori critici rispettivamente ai livelli di significatività 5 % e 1 %), 
	dovremmo concludere che le frequenze osservate differiscono significativamente dalle frequenze attese e 
	dovremmo rifiutare H0 al corrispondente livello di significatività. 
	Altrimenti dovremmo accettarla, o almeno non rifiutarla */

/*
We can use proc freq to examine the repair records of the cars 
	(rep78, where 1 is the worst repair record, 5 is the best repair record) 
	by foreign (foreign coded 1, domestic coded 0).  
Using the chi2 option we can request a chi-square test that tests if these two variables are independent.
*/

    PROC FREQ DATA=auto;
      TABLES rep78*foreign / CHISQ ;
    RUN;

/*
The chi-square is not really valid when you have empty cells 
	(or cells with expected values less than 5). 
In such cases, you can request Fisher's exact test (which is valid under such circumstances) 
	with the exact option.*/

    PROC FREQ DATA=auto;
      TABLES rep78*foreign / CHISQ EXACT ;
    RUN;

/*
The Fisher's Exact Test is significant, showing that there is an association between rep78 and foreign.   
	In other words, the repair records for the domestic cars differ from the repair record of the foreign cars.
*/



/*CORRELAZIONE*/
/*
correlazione ci dice la tendenza di una variabile a variare in funzione di un'altra.
Let's use proc corr to examine the correlations among price mpg and weight.
*/

 PROC CORR DATA=auto; /*volendo opzione nomiss x dire a SAS di usare solo i record senza missing*/
      VAR price mpg weight ;
    RUN;

/*
results show that:
- negative correlation b/w mpg and price (statistically significant)
- negative correlation b/w mpg and weight (statistically significant)
- positive correlation b/w weight and price (statistically significant)
*/

/*REGRESSION ANALYSIS*/

/*
Let's perform a regression analysis where we predict price from mpg and weight.  
*/
    PROC REG DATA=auto;
      MODEL price = mpg weight ;
    RUN;

/*
results show that:
    - Only 71 observations are used (not all 74) because mpg had three missing values.  
    -  weight is the only variable that significantly predicts price (with a t-value of 2.603 and a p-value of 0.0113)
*/

/*ANALYSIS OF VARIANCE*/
/*
Let's compare the average miles per gallon (mpg) among the cars in the different repair groups using Analysis of Variance
You might think to use proc anova for such an analysis, but proc anova assumes that the sample sizes for all groups 
	are equal, an assumption that is frequently untrue.   
Instead, we will use proc glm to perform an ANOVA comparing the prices among the repair groups.  
	Since there are so few cars with a repair record (rep78) of 1 or 2, we will use a where statement to omit them, 
	allowing us to concentrate on the cars with repair records of 3, 4 and 5.  
The proc glm below performs an Analysis of Variance testing whether the average mpg for the 3 repair 
	groups (rep78) are the same.  
It also produces the means for the 3 repair groups
*/

    PROC GLM DATA=auto;
      WHERE (rep78 = 3) OR (rep78 = 4) OR (rep78 = 5);
      CLASS rep78;
      MODEL mpg = rep78 ;
      MEANS rep78 ;
    RUN;

/*
results shows that:
- SAS informs us that it used only 57 observations (due to the missing values of mpg).  
- there are significant differences in mpg among the three repair groups (based on the F value of 8.08 with a p value of 0.009)
- The means for groups 3, 4 and 5 were 19.43, 21.67, and 27.36 .
*/

/*
You can use the tukey option on the means statement to request Tukey tests for pairwise comparisons 
	among the three means
*/

    PROC GLM DATA=auto;
      WHERE (rep78 = 3) OR (rep78 = 4) OR (rep78 = 5);
      CLASS rep78;
      MODEL mpg = rep78 ;
      MEANS rep78 / TUKEY ;
    RUN;

/*
- The Tukey comparisons that are significant are indicated by "***".  
- The group with rep78 of 5 is significantly different from 3 and significantly different from 4.  
- However, the group with rep78 of 3 is not significantly different from rep78 of 4.
*/




