

*===========================policy shock on static model========================

parameter Header Flag determining whether to output header records in output files ;
Header = 1 ;

*----- Declare the output file names

file reportfile / "Output/output.csv" / ;

* ----- Model output options
display "Begin output listing" ;

options limcol=000, limrow=000 ;
options solprint=off ;
*option solvelink=2;

put reportfile ;
if (Header eq 1, put 'Scenario,year,variable,sector,qualifier,type,value,model' / ; ) ;

*        print control (.pc)     5 Formatted output; Non-numeric output is quoted, and each item is delimited with commas.
reportfile.pc   = 5 ;
*        page width (.pw)
reportfile.pw = 255 ;
*        .nj numeric justification (default 1)
reportfile.nj =   1 ;
*        .nw numeric field width (default 12)
reportfile.nw =  15 ;
*        number of decimals displayed (.nd)
reportfile.nd =   9 ;
*        numeric zero tolerance (.nz)
reportfile.nz =   0 ;
*        numeric zero tolerance (.nz)
reportfile.nr =   0 ;

file screen / 'con' / ;


parameter unem,pwage;
parameter
report1    reporting variable
report2    reporting variable
report3    reporting variable
report4    reporting variable
report5
report6
report7
report8
report9
report10
report11
report12

set z reduction rate /1*9/  ;
parameter rate(z) /
                   1=0.1,
                   2=0.2,
                   3=0.3,
                   4=0.4,
                   5=0.5,
                   6=0.6,
                   7=0.7,
                   8=0.8,
                   9=0.9/;

set sce reduction rate /S1*S10/  ;
set mapsce(sce,cm)  /
S1        .        Elec
S2        .        Roil
S3        .        Paper
S4        .        Chem
S5        .        CM
S6        .        IST
S7        .        NFM
S8        .        Air
/  ;
parameter sce_s(sce,cm) ;
sce_s(sce,cm) =0;
sce_s(sce,cm)$mapsce(sce,cm) =1;
sce_s("S9",cm) =1;
$offorder

display sce_s;


loop(sce$(ord(sce) le 10),

         loop(z,

*inter sector
clim_s(cm)=sce_s(sce,cm)*(1-rate(z))*Temission0('co2',cm);

*cross sector
clim_a$(ord(sce) eq 10)=1;
clim0=rate(z);

$include China3E.gen

solve China3E using mcp;

display China3E.modelstat, China3E.solvestat,clim_s,clim_a,rate,sigma;


UNEM(lm,z)=UR.l(lm);
pwage(i,lm,z)=pl.l(i,lm);

report2(z,i)=sum(fe,ccoef_p(fe)*qin.l(fe,i));
report2(z,"elec")=sum(sub_elec,sum(fe,ccoef_p(fe)*qin_ele.l(fe,sub_elec)));
report2(z,"household")=sum(fe,ccoef_h(fe)*qc.l(fe));

report6(z,lm,"total")= sum(i,qlin.l(i,lm))+sum(sub_elec,qlin_ele.l(sub_elec,lm));
report6(z,lm,i)= qlin.l(i,lm);
report6(z,lm,"elec")= sum(sub_elec,qlin_ele.l(sub_elec,lm));
report6(z,lm,sub_elec)= qlin_ele.l(sub_elec,lm);

$include report

));
