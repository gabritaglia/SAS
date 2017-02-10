
/*SAS non è case sensitive*/

libname corso 'F:\SAS verzillo\SAS_dati';
run;
/*CREIAMO UNA LIBRARY NOMINATA CORSO*/

libname corso 'F:\SAS verzillo\SAS_dati';
run;

/*CARICAMENTO DATI A MANO*/
data corso.uno;
/*adesso impostiamo la lunghezza della variabile nome a 12 caratteri anzichè i */
length nome $ 12;
input nome $ sesso $ eta altezza peso diabete; 
/*mettere "nome $" vuol dire dire a sas che la variabile nome è character e non numeric, altrimenti la prende numerica*/
/*i dati si inseriscono dopo datalines; secondo l'ordine delle variabili messe prima*/
datalines ;
Andrea M 25 185 90 1
Roberto M 71 167 65 0
Cristina F 24 163 55 1
Lucia F 14 173 52 0
Gianbattista M 88 198 89 1
/*finiscono i dati con il ;*/; 
run;
proc print;
/* questo comando visualizza nell'output il comando preecedente*/
run;


/* COLLEGAMENTO DA FILE ESTERNO*/
filename due 'F:\SAS verzillo\due.csv'; /*in filename non vuole il . se metti corso.due dà errore */
data corso.due;
length nome $ 12;
/*mettimi in corso.due mettimi il csv che è delimitato con la virgola, saltando la prima riga che 
conteneva i nomi delle variabili*/
infile due delimiter=',' firstobs=2 obs=6; /*in infile non vuole il . se metti corso.due dà errore */
run;
proc print;
run;


/*CARICAMENTO DA IMPORT WIZARD*/ 
/*è la modolità più facile perché è la procedura di importazione guidata*/
/*da file si fa Import Data e si seguono le istruzioni*/
proc print;
run;

/*questo comando mi fa creare un nuovo dataset in corso anziché in work*/
data corso.sanita;
set sanita;
run;


/*ORDINIAMO I DATI*/
/*ordiniamo i dati dal più piccolo al più grande*/
proc sort data=corso.uno;
by eta;
run;
proc print;
run;

/*ordiniamo i dati dal più grande al più piccolo*/
proc sort data=corso.uno;
by eta descending;
run;
proc print;
run;

/*ordiniamo i dati prima secondo il diabete poi secondo il sesso*/
proc sort data=corso.uno;
by diabete sesso ;
run;
proc print;
run;


/*APRIAMO I NUOVI DATI SCLERO*/
/*i dati sono 55 pazienti che hanno subito o no un trattamento farmaceutico e 
risultati dopo la cura*/
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
run;
proc print;
run;

/*vogliamo creare una variabile che indichi il miglioramento prima o dopo il condizionamento
miglioramento=condiz1-condiz2*/

data corso.sclero;
set sclero;
migliora=condiz1-condiz2;
if migliora>0; /*considero solo i pazienti che sono migliorati*/
if 45<=clinica<=50; /*condideriamo solo le cliniche dalla 45 alla 50*/
proc print;
run;

proc sort;
by farmaco; /*ordiniamo rispetto al farmaco il dataset corso.sclero*/
proc print;
run;

/*ESPORTIAMO IL DATASET SAS IN UN FORMATO CSV */

proc export data= corso.sclero dbms=csv outfile = 'F:\SAS verzillo\SAS_dati\sclero_modif.csv' replace;
/*mettendo replace si da il permesso a sas di sovrascrivere il file
dbms è il formato dati*/

/*RIASSUNTO DEL DATASET*/
proc contents data=corso.sclero;
run;
/*se non avessimo detto data=XXX ci avrebbe dato i risultati sull'ultimo dataset*/


/*ESEMPIO creo un nuovo dataset */
data corso.tre;
input x1 x2 y x3 x5;
datalines;
1 2 3 4 5 
6 7 8 9 0 
;
proc print;
run;

proc print;
var x1--x3; /*stampa tutte le variabili del dataset comprese tra x1 e x3; ovvero x1 x2 y x3*/
run;

proc print;
var x1-x3; /*stampa tutte le variabili che hanno il nome compreso tra x1 e x3; ovvero x1 x2 x3*/
run;

proc print;
var x1-x5; /*stampa tutte le variabili che hanno il nome compreso tra x1 e x5; ovvero x1 x2 x3 x4 x5 
ma x4 non esiste quindi lui da l'errore, il comando significa prendi da x1 e continua fino a prendere tutte 
le variabili che hanno nome x# fino alla 5*/
run;


/*COME SELEZIONARE I DATI*/
/*classifichiamo i dati in classi d'età*/

data corso.uno_a;
set corso.uno;
if eta<=18 then cl_eta='giovane';
if eta > 18 & eta <= 65 then cl_eta='adulto';
if eta > 65 then cl_eta='anziano';  /*è alternativa alla formulazione else cl_eta='anziano'*/
minorenne=0;
if eta < 18 then minorenne=1;
proc print;
run;
