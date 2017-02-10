PROC IMPORT OUT= WORK.sanita 
            DATAFILE= "F:\SAS verzillo\sanita.xls" 
            DBMS=EXCEL REPLACE;
     RANGE="Foglio1$"; 
     GETNAMES=YES;
     MIXED=NO;
     SCANTEXT=YES;
     USEDATE=YES;
     SCANTIME=YES;
RUN;
