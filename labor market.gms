*----------------------------------------------*
*larbor market
*20161204, update: extend the types of labor to 28 by gender by region by education
*----------------------------------------------*

set lmo original labor type /L1*L28/
    region /urban,rural/
    gender /male,female/
    education /     ul unlettered
                    es "elementart school"
                    ms "middle school"
                    hs "high school"
                    jc "junior college"
                    rc "regular college"
                    pg "postgraduate"      /
    Level /low,high/
    lm aggregared labor type /Low,high/;

alias (lm,lmm)             ;
set maplmolm(lmo,lm)   /
L1        .        Low
L2        .        Low
L3        .        Low
L4        .        Low
L5        .        High
L6        .        High
L7        .        High
L8        .        Low
L9        .        Low
L10        .        Low
L11        .        Low
L12        .        High
L13        .        High
L14        .        High
L15        .        Low
L16        .        Low
L17        .        Low
L18        .        Low
L19        .        High
L20        .        High
L21        .        High
L22        .        Low
L23        .        Low
L24        .        Low
L25        .        Low
L26        .        High
L27        .        High
L28        .        High

/;

* data handling in fold education$region, grasp from output.xlsx
$CALL GDXXRW.EXE labor.xlsx par=labor_q0 rng=A1:AC19  par=labor_v0 rng=A21:AC39 par=labordata  rng=A41:AC43

Parameter labor_v0(*,*)  sectoral labor costs value by labor type in 10 thousand yuan;
Parameter labor_q0(*,*)  sectoral labor quantity by labor type;
Parameter labor_w0(*,*)  sectoral labor wage value by labor type in billion yuan per thousand person;
parameter labordata(*,*);

$GDXIN labor.gdx

$LOAD labor_v0
$LOAD labor_q0
$LOAD labordata

*=== transfer unit to billion yuan
labor_v0(i,lmo)=labor_v0(i,lmo)/100000;

labor_v0(i,lm) = sum(lmo$maplmolm(lmo,lm),labor_v0(i,lmo)) ;

*=== transfer unit to thousand people
labor_q0(i,lmo)=labor_q0(i,lmo)/1000;

labor_q0(i,lm) = sum(lmo$maplmolm(lmo,lm),labor_q0(i,lmo))  ;


labor_w0(i,lm)$labor_q0(i,lm) =labor_v0(i,lm)/labor_q0(i,lm);
labor_w0(i,lm)$(labor_q0(i,lm) eq 0) = 0.001;


*== adjust employment from 2010 to 2012


*parameter tlprop(*,*)  the proportion of total labor supply by year;
parameter bwage(*)    the average wage of labor by type from micro data in yuan per people;
parameter bur(*)     the benchmark unemployment rate ;


bwage(lmo) =   labordata('wage',lmo);
bwage(lm)  =   sum(lmo$maplmolm(lmo,lm),labordata('wage',lmo)*sum(i,labor_q0(i,lmo)))/sum(i,labor_q0(i,lm));

bur(lmo)  =   labordata('ul',lmo);
bur(lm)  =   1-sum(i,labor_q0(i,lm))/sum(lmo$maplmolm(lmo,lm),sum(i,labor_q0(i,lmo))/(1-bur(lmo)));


DISPLAY labor_v0,labor_q0,labor_w0,bur,bwage;

*== set relative wage factor

parameter fwage_s(i,lm)  factor of average wage among sectors  ;
parameter awage_e(lm)  average wage among education in billion yuan per thousand person;

awage_e(lm) = sum(i,labor_w0(i,lm)*labor_q0(i,lm))/sum(i,labor_q0(i,lm));

fwage_s(i,lm) =  labor_w0(i,lm)/awage_e(lm);


display fwage_s,awage_e;


parameter tlabor_q0(lm)   total employment by sub_labor
          tqlabor0       total employment ;

tlabor_q0(lm)=sum(i,labor_q0(i,lm));
tqlabor0=sum(lm,tlabor_q0(lm));

parameter tlabor_v0(lm)   total employment value by sub_labor
          tvlabor0       total employment value;

tlabor_v0(lm)=sum(i,labor_v0(i,lm));
tvlabor0=sum(lm,tlabor_v0(lm));


display labor_q0,tlabor_q0,tqlabor0,labor_v0,tlabor_v0,tvlabor0;


parameter laborelec0,laborist0;
laborelec0(sub_elec,lm)=labor_q0("Elec",lm)*lelec0(sub_elec)/fact0("labor","Elec");
laborist0(sub_ist,lm)=list0(sub_ist)*labor_q0("IST",lm)/sum(lmm,labor_q0("IST",lmm));

*laborelec0(sub_elec,lm)=labor_v0("Elec",lm)*lelec0(sub_elec)/fact0("labor","Elec");
*laborist0(sub_ist,lm)=list0(sub_ist)*labor_v0("IST",lm)/sum(lmm,labor_q0("IST",lmm));

display laborelec0,laborist0;

parameter ur0      the benchmark unemployment rate
          tlabor_s0(lm)   total labor supply by sub_labor
          tqlabor_s0      total labor supply;

ur0(lm)=bur(lm);
*ur0(lm)=0;

tlabor_s0(lm)=(tlabor_q0(lm)/(1-ur0(lm)));
tqlabor_s0=sum(lm,tlabor_s0(lm));

*shock �Ͷ��������ṹ�ı仯
*tlabor_s0(lm)=tqlabor_s0*tlprop("2030",lm);

display ur0,tlabor_s0,tqlabor_s0;


$ontext
    ul unlettered /L1,L8,L15,L22/
    es "elementart school" /L2,L9,L16,L23/
    ms "middle school"     /L3,L10,L17,L24/
    hs "high school"       /L4,L11,L18,L25/
    jc "junior college"    /L5,L12,L19,L26/
    rc "regular college"   /L6,L13,L20,L27/
    pg "postgraduate"      /L7,L14,L21,L28/
    urban    /L1*L7,L15*L21/
    rural    /L8*L14,L22*L28/
    male     /L1*L14/
    femal    /L15*L28/
$offtext
;

*== set for laboe aggregation
set maple(lmo,education) map from labor to education/
L1        .        ul
L2        .        es
L3        .        ms
L4        .        hs
L5        .        jc
L6        .        rc
L7        .        pg
L8        .        ul
L9        .        es
L10        .        ms
L11        .        hs
L12        .        jc
L13        .        rc
L14        .        pg
L15        .        ul
L16        .        es
L17        .        ms
L18        .        hs
L19        .        jc
L20        .        rc
L21        .        pg
L22        .        ul
L23        .        es
L24        .        ms
L25        .        hs
L26        .        jc
L27        .        rc
L28        .        pg
/;
set maplr(lmo,region) map from labor to region/
L1        .        Urban
L2        .        Urban
L3        .        Urban
L4        .        Urban
L5        .        Urban
L6        .        Urban
L7        .        Urban
L8        .        Rural
L9        .        Rural
L10        .        Rural
L11        .        Rural
L12        .        Rural
L13        .        Rural
L14        .        Rural
L15        .        Urban
L16        .        Urban
L17        .        Urban
L18        .        Urban
L19        .        Urban
L20        .        Urban
L21        .        Urban
L22        .        Rural
L23        .        Rural
L24        .        Rural
L25        .        Rural
L26        .        Rural
L27        .        Rural
L28        .        Rural
/;

set maplg(lmo,gender) map from labor to gender/
L1        .        Male
L2        .        Male
L3        .        Male
L4        .        Male
L5        .        Male
L6        .        Male
L7        .        Male
L8        .        Male
L9        .        Male
L10        .        Male
L11        .        Male
L12        .        Male
L13        .        Male
L14        .        Male
L15        .        Female
L16        .        Female
L17        .        Female
L18        .        Female
L19        .        Female
L20        .        Female
L21        .        Female
L22        .        Female
L23        .        Female
L24        .        Female
L25        .        Female
L26        .        Female
L27        .        Female
L28        .        Female
/;

set mapll(lmo,level) map from labor to level/
L1        .        Low
L2        .        Low
L3        .        Low
L4        .        Low
L5        .        High
L6        .        High
L7        .        High
L8        .        Low
L9        .        Low
L10        .        Low
L11        .        Low
L12        .        High
L13        .        High
L14        .        High
L15        .        Low
L16        .        Low
L17        .        Low
L18        .        Low
L19        .        High
L20        .        High
L21        .        High
L22        .        Low
L23        .        Low
L24        .        Low
L25        .        Low
L26        .        High
L27        .        High
L28        .        High

/;

set ll(lm) low level labor type /low/;
set hl(lm) high level labor type /high/;

*ll(lm)$mapll(lm,'low') = 1;
*hl(lm)$mapll(lm,'high') = 1;

display ll,hl;



