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

data quattro;
input x1 x2 y x3 x5;
datalines;
1 2 3 4 5
6 7 8 9 0
;
run;

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

data esempio; 
input dato1 dato2; 
datalines; 
1 3
6 4
. 78 
8 1
12 14 
; 
run;

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
run;

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
run;

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

data dates; 
length date1 date2 date3 $10; 
input date1 $ date2 $ date3; 
datalines;
11jun08 11jun2008 06/11/2008 
10jul08 10jul2008 07/10/2008 
;
proc print;
run;

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

data wide1; 
  input famid faminc96 faminc97 faminc98 ; 
cards; 
1 40000 40500 41000 
2 45000 45400 45800 
3 75000 76000 77000 
; 
run;

data wide2 ; 
      input famid faminc96 faminc97 faminc98 spend96 spend97 spend98 ; 
    cards ; 
    1 40000 40500 41000 38000 39000 40000 
    2 45000 45400 45800 42000 43000 44000 
    3 75000 76000 77000 70000 71000 72000 
; 
proc print;
run ;

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
