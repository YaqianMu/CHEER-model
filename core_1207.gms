*----------------------------------------------*
*1206, to build the basic model for employment analysis
*----------------------------------------------*
parameter      A                      /1/         ;

parameter simu_s;
*simu_s=1,GDP endogenous,simu_s=0,GDP exdogenous
simu_s=1;

* phi = cfe/ffe;
parameter          phi        percentage target of permits energy;
parameter          pflag        flag for electricity permits             /0/         ;


$ONTEXT
$Model:China3E

$Sectors:
y(i)                   !activity level for domestic production
consum                 !activity level for aggregate consumption
invest                 !activity level for aggregate physical capital investment
welf                   !activity level for aggregate welfare
yelec(sub_elec)        !Activity level for electricity production

l_a(lm)                !Activity level for labor allocation

$Commodities:
py(i)                  !domestic price inex for goods
pelec(sub_elec)        !domestic price inex for subelec
*pelec(sub_elec)$(not bse(sub_elec))         !domestic price inex for subelec
*pe_base                !domestic price inex for baseload elec
pls(lm)                   !domestic price index for labor demand
pl(i,lm)$labor_q0(i,lm)                  !domestic price index for labor demand
pk                     !domestic price index for captial
pffact(i)$ffact0(i)         !domestic price index for fixed factors
pffelec(sub_elec)$ffelec0(sub_elec)                !domestic price index for fixed factors in electric sector
pcons                  !price index for aggregate consumption
pinv                   !price index for aggregate physical capital investment
pu                     !price index for utility

pco2$clim              !shadow value of carbon all sectors covered
pco2_a$clim_a          !shadow value of carbon selected sectors covered
pco2_s(i)$clim_s(i)    !shadow value of carbon sector by sector
pco2_h$clim_h          !shadow value of carbon for household sector

Pers$pflag             ! Price for permits of electricity generation

$consumers:
ra                     !income level for representative agent

$auxiliary:
sff(x)$ffact0(x)       !side constraint modelling supply of fixed factor
sffelec(sub_elec)$ffelec0(sub_elec)         !side constraint modelling supply of fixed factors

ur(lm)$ur0(lm)                 !unemployment rate

t_re(sub_elec)$wsb(sub_elec)       !FIT for renewable energy

rgdp                     !real gdp
gprod                    !productivity index
gprod2(lm)$ur0(lm)       !productivity index to identify unemployment rate


tclim$clim                     ! carbon limit all sectors
tclim_a$clim_a                     ! carbon limit selected sectors

$prod:l_a(lm)       t:1
         o:pl(i,lm)      q:labor_q0(i,lm)       p:labor_w0(i,lm)
         i:pls(lm)       q:tlabor_q0(lm)        p:awage_e(lm)



$prod:y(i)$elec(i)   s:0   a:10   b(a):100    c(a):enesta
        o:py(i)                               q:output0(i)
        i:pelec(sub_elec)$TD(sub_elec)        q:outputelec0(sub_elec)     p:(costelec0(sub_elec))
        i:pelec(sub_elec)$ffe(sub_elec)       q:outputelec0(sub_elec)     p:(costelec0(sub_elec))  c:
        i:pelec(sub_elec)$hnb(sub_elec)       q:outputelec0(sub_elec)     p:(costelec0(sub_elec))  b:
        i:pelec(sub_elec)$wse(sub_elec)       q:outputelec0(sub_elec)     p:(costelec0(sub_elec))  a:

*        i:pe_base                             q:(sum(bse,outputelec0(bse)))       a:
*        i:pelec(sub_elec)$wse(sub_elec)       q:outputelec0(sub_elec)       a:

*       Production of T&D electricity
$prod:yelec(sub_elec)$TD(sub_elec) s:0       l(s):eslm("l")
        o:pelec(sub_elec)        q:(outputelec0(sub_elec))              p:((1-taxelec0(sub_elec))*costelec0(sub_elec))  a:ra  t:taxelec0(sub_elec)
        i:py(i)$(not e(i))       q:intelec0(i,sub_elec)
        i:py(elec)               q:(intelec0(elec,sub_elec)*aeei("elec"))
        i:py(fe)                 q:(intelec0(fe,sub_elec)*aeei("elec"))
        i:pl("elec",lm)$ll(lm)   q:laborelec0(sub_elec,lm)        p:labor_w0("elec",lm)           l:
        i:pl("elec",lm)$hl(lm)   q:laborelec0(sub_elec,lm)        p:labor_w0("elec",lm)           l:
        i:pk                     q:kelec0(sub_elec)


*       Production of fossile fuel electricity
$prod:yelec(sub_elec)$ffe(sub_elec) s:0   kle(s):0.4 kl(kle):0.6 l(kl):eslm("l")   ene(kle):enesta roil(ene):0 coal(ene):0 gas(ene):0
        o:pelec(sub_elec)                q:(outputelec0(sub_elec))                 p:((1-taxelec0(sub_elec))*costelec0(sub_elec))  a:ra  t:taxelec0(sub_elec)
        i:py(i)$(not e(i))       q:(intelec0(i,sub_elec)*emkup(sub_elec))
        i:py(elec)               q:(intelec0(elec,sub_elec)*aeei("elec")*emkup(sub_elec))
        i:pl("elec",lm)$ll(lm)   q:(laborelec0(sub_elec,lm)*emkup(sub_elec))          p:labor_w0("elec",lm)         l:
        i:pl("elec",lm)$hl(lm)   q:(laborelec0(sub_elec,lm)*emkup(sub_elec))          p:labor_w0("elec",lm)         l:
        i:pk                     q:(kelec0(sub_elec)*emkup(sub_elec))                         kl:
        i:py(fe)$intelec0(fe,sub_elec)    q:(intelec0(fe,sub_elec)*aeei("elec")*emkup(sub_elec))                            fe.tl:
        i:pco2#(fe)$clim         q:(emissionelec0("co2","e",fe,sub_elec)*aeei("elec")*emkup(sub_elec))      p:1e-5             fe.tl:
        i:pco2_s("elec")#(fe)$clim_s("elec")         q:(emissionelec0("co2","e",fe,sub_elec)*aeei("elec")*emkup(sub_elec))      p:1e-5             fe.tl:
        i:pco2_a#(fe)$(clim_a and cm("elec"))         q:(emissionelec0("co2","e",fe,sub_elec)*aeei("elec")*emkup(sub_elec))      p:1e-5             fe.tl:
        I:Pers$pflag             Q:((phi/(1-phi))*outputelec0(sub_elec))

*       Production of hybro and nuclear biomass electricity      va2 from wang ke
$prod:yelec(sub_elec)$hnb(sub_elec)  s:esub(sub_elec,"ff") a:0 va(a):esub("elec","kl") l(va):eslm("l")
        o:pelec(sub_elec)$hne(sub_elec)  q:outputelec0(sub_elec)              p:((1-taxelec0(sub_elec))*costelec0(sub_elec))  a:ra  t:taxelec0(sub_elec)
        o:pelec(sub_elec)$wsb(sub_elec)  q:outputelec0(sub_elec)              p:((1-taxelec0(sub_elec))*costelec0(sub_elec))  a:ra  N:t_re(sub_elec)
        O:Pers$pflag             Q:(1*(outputelec0(sub_elec)))
        i:py(i)                  q:(intelec0(i,sub_elec)*emkup(sub_elec))                                              a:
        i:pl("elec",lm)$ll(lm)          q:(laborelec0(sub_elec,lm)*emkup(sub_elec))    p:labor_w0("elec",lm)                      l:
        i:pl("elec",lm)$hl(lm)          q:(laborelec0(sub_elec,lm)*emkup(sub_elec))    p:labor_w0("elec",lm)                      l:
        i:pk                     q:(kelec0(sub_elec)*emkup(sub_elec))                                                  va:
        i:pffelec(sub_elec)$ffelec0(sub_elec)                q:(ffelec0(sub_elec)*emkup(sub_elec))      P:1


*       Production of wind, solar  electricity      va2 from wang ke
$prod:yelec(sub_elec)$wse(sub_elec) s:esub(sub_elec,"ff") b:0 va(b):esub("elec","kl") l(va):eslm("l")
       o:pelec(sub_elec)        q:(outputelec0(sub_elec))               p:((1-taxelec0(sub_elec))*costelec0(sub_elec))  a:ra  N:t_re(sub_elec)
       O:Pers$pflag             Q:(1*(outputelec0(sub_elec)))
        i:py(i)                  q:(intelec0(i,sub_elec)*emkup(sub_elec))                                              b:
        i:pl("elec",lm)$ll(lm)          q:(laborelec0(sub_elec,lm)*emkup(sub_elec))      p:labor_w0("elec",lm)                     l:
        i:pl("elec",lm)$hl(lm)          q:(laborelec0(sub_elec,lm)*emkup(sub_elec))      p:labor_w0("elec",lm)                     l:
        i:pk                     q:(kelec0(sub_elec)*emkup(sub_elec))                                                  va:
        i:pffelec(sub_elec)$ffelec0(sub_elec)                q:(ffelec0(sub_elec)*emkup(sub_elec))      P:1



$prod:y(i)$(not fe(i) and not elec(i) ) s:0 a:esub(i,"ff") b(a):0  kle(b):0.4 kl(kle):0.6  l(kl):eslm("l") e(kle):sigma("ele_p") ne(e):sigma("ene_p")  coal(ne):0 roil(ne):0 gas(ne):0
        o:py(i)                  q:(output0(i))                    p:(1-tx0(i))     a:ra    t:tx0(i)
        i:pffact(i)$ffact0(i)    q:ffact0(i)                                           a:
        i:py(j)$(not e(j))       q:int0(j,i)                                         b:
        i:pk                     q:fact0("capital",i)                              kl:
        i:pl(i,lm)$ll(lm)        q:labor_q0(i,lm)              p:labor_w0(i,lm)             l:
        i:pl(i,lm)$hl(lm)        q:labor_q0(i,lm)              p:labor_w0(i,lm)             l:
        i:py(elec)               q:(int0(elec,i)*aeei(i))                          e:
        i:py(fe)                 q:(int0(fe,i)*aeei(i))                            fe.tl:
        i:pco2#(fe)$clim         q:(emission0("co2","e",fe,i)*aeei(i))      p:1e-5             fe.tl:
        i:pco2_s(i)#(fe)$clim_s(i)         q:(emission0("co2","e",fe,i)*aeei(i))      p:1e-5             fe.tl:
        i:pco2_a#(fe)$(clim_a and cm(i))         q:(emission0("co2","e",fe,i)*aeei(i))      p:1e-5             fe.tl:

*       Production of fossil fuel production       va from wang ke
$prod:y(i)$fe(i) s:0 a:esub(i,"ff") b(a):0 va(b):esub(i,"kl") l(va):eslm("l")  coal(b):0 roil(b):0 gas(b):0
        o:py(i)                  q:(output0(i))                    p:(1-tx0(i))     a:ra    t:tx0(i)
        i:py(j)$(not fe(j))      q:int0(j,i)                                     b:
        i:pk                     q:fact0("capital",i)            va:
        i:pl(i,lm)$ll(lm)          q:labor_q0(i,lm)         p:labor_w0(i,lm)       l:
        i:pl(i,lm)$hl(lm)          q:labor_q0(i,lm)         p:labor_w0(i,lm)       l:
        i:pffact(i)$ffact0(i)    q:ffact0(i)                                      a:
        i:py(fe)                 q:(int0(fe,i)*aeei(i))                            fe.tl:
        i:pco2#(fe)$clim         q:(emission0("co2","e",fe,i)*aeei(i))      p:1e-5             fe.tl:
        i:pco2_s(i)#(fe)$clim_s(i)         q:(emission0("co2","e",fe,i)*aeei(i))      p:1e-5             fe.tl:
        i:pco2_a#(fe)$(clim_a and cm(i))         q:(emission0("co2","e",fe,i)*aeei(i))      p:1e-5             fe.tl:

*        consumption of goods and factors    based on EPPA

$prod:consum   s:esub_c  a:0.3 e:sigma("ene_fd") roil(e):0 coal(e):0 gas(e):0
         o:pcons                  q:(sum(i,cons0(i))+sum(f,consf0(f)))
         i:py(i)$(not e(i))       q:cons0(i)                a:
         i:py(i)$(elec(i))        q:(cons0(i)*aeei("fd"))                e:
         i:py(fe)                 q:(cons0(fe)*aeei("fd"))                 fe.tl:
         i:pco2#(fe)$clim         q:(emission0("co2","e",fe,"household")*aeei("fd"))      p:1e-5             fe.tl:
         i:pco2_h#(fe)$clim_h     q:(emission0("co2","e",fe,"household")*aeei("fd"))      p:1e-5             fe.tl:


*        aggregate capital investment

$prod:invest   s:esub_inv
         o:pinv             q:(sum(i,inv0(i)))
         i:py(i)            q:inv0(i)



*        welfare          Ke Wang, EPPA S: 1

$prod:welf    s:1.0
         o:pu                 q:(sum(i,cons0(i)+inv0(i))+sum(f,consf0(f)+invf0(f)))
         i:pcons              q:(sum(i,cons0(i))+sum(f,consf0(f)))
         i:pinv               q:(sum(i,inv0(i))+sum(f,invf0(f)))


$demand:ra

*demand for consumption,invest and rd

d:pu                 q:(sum(i,cons0(i)+inv0(i))+sum(f,consf0(f)+invf0(f)))

*endowment of factor supplies

e:pk                 q:fact("capital")                                      r:gprod
e:pls(lm)                q:(tlabor_s0(lm))                                                 r:gprod
e:pls(lm)$ur0(lm)             q:(-tlabor_s0(lm))                  r:gprod2(lm)
e:pffact(x)          q:ffact0(x)                 r:sff(x)$ffact0(x)
e:pffelec(sub_elec)  q:(ffelec0(sub_elec)*emkup(sub_elec))         r:sffelec(sub_elec)$ffelec0(sub_elec)

*exogenous endowment of net exports(include variances)

e:py(i)              q:(-(nx0(i)+xinv0(i)+xcons0(i))*xscale)

*endowment of carbon emission allowances

e:pco2$clim         q:1                        r:tclim
e:pco2_s(i)$clim_s(i)    q:clim_s(i)
e:pco2_h$clim_h      q:clim_h
e:pco2_a$clim_a     q:1                        r:tclim_a

*supplement benchmark fixed-factor endowments according to assumed price elasticities of resource supply

$constraint:sff(x)$ffact0(x)
     sff(x)    =e= (pffact(x)/pu)**eta(x);

$constraint:sffelec(sub_elec)$ffelec0(sub_elec)
    sffelec(sub_elec) =e=  (pffelec(sub_elec)/pu)**eta(sub_elec);
*     sffelec(sub_elec) =e= 1;

* wage curve for skilled labor
$constraint:ur(lm)$(ur0(lm) and hl(lm))
      (pls(lm)/pu)/(awage_e(lm)/pu) =E=(ur(lm)/ur0(lm))**(-0.1);

* rigid wage for unskilled labor
$constraint:ur(lm)$(ur0(lm) and ll(lm))
*      (pls(lm)/pu)/(awage_e(lm)/pu) =E=(ur(lm)/ur0(lm))**(-0.1);
      pls(lm) =G= awage_e(lm);

*== indentification of FIT
$constraint:t_re(sub_elec)$wsb(sub_elec)
        t_re(sub_elec) =e= -subelec0(sub_elec)+taxelec0(sub_elec);

$constraint:rgdp
  pu*rgdp =e= pcons*(sum(i,cons0(i))+sum(f,consf0(f)))*consum+pinv*(sum(i,inv0(i)))*invest+sum(i,py(i)*((nx0(i)+xinv0(i)+xcons0(i))*xscale))   ;


$constraint:gprod$(simu_s eq 0)
  rgdp =e= rgdp0;

$constraint:gprod$(simu_s ne 0)
  gprod =e= gprod0;

$constraint:gprod2(lm)$(ur0(lm) and simu_s eq 0)
 gprod2(lm) =e= gprod*ur(lm);

$constraint:gprod2(lm)$(ur0(lm) and simu_s ne 0)
  gprod2(lm) =e= gprod0*ur(lm);


$constraint:tclim$clim
*== quantity target
 tclim =e= clim0*temission2("co2");
*== intensity target
*  tclim =e= clim0*temission2("co2")/rgdp0*rgdp;

$constraint:tclim_a$clim_a
*== quantity target
 tclim_a =e= clim0*sum(cm,temission0("co2",cm));


$report:

v:qdout(j)             o:py(j)       prod:y(j)     !output by sector(domestic market)

v:qc(i)                i:py(i)       prod:consum   !consumpiton of final commodities
v:grosscons            o:pcons       prod:consum   !aggregate consumpiton

v:qinvk(i)             i:py(i)       prod:invest   !physical capital investment by non-energy sectors
v:grossinvk            o:pinv        prod:invest   !aggregate physical capital investment


v:util                 o:pu          prod:welf       !welf

v:qin(i,j)             i:py(i)       prod:y(j)      !inputs of intermediate goods
v:qin_ele(i,sub_elec)  i:py(i)       prod:yelec(sub_elec)      !inputs of intermediate goods to fossil fuel fired generation

v:qkin(j)              i:pk          prod:y(j)        !capital inputs
v:qlin(j,lm)           i:pl(j,lm)      prod:y(j)        !labor inputs
v:qlin_ele(sub_elec,lm)      i:pl("elec",lm)      prod:yelec(sub_elec)        !labor inputs
v:qkin_ele(sub_elec)   i:pk          prod:yelec(sub_elec)        !capital inputs
v:qffin(j)$x(j)        i:pffact(j)   prod:y(j)        !fixed factor inputs

v:qffelec(sub_elec)$cfe(sub_elec)    i:pffelec(sub_elec)     prod:yelec(sub_elec)      !fixed factor inputs

V:qelec(sub_elec)        o:pelec(sub_elec)       prod:yelec(sub_elec)

v:ECO2(i)              i:pco2         prod:y(i)
v:ECO2_elec(sub_elec)              i:pco2        prod:yelec(sub_elec)
v:ECO2_s(i)              i:pco2_s(i)        prod:y(i)
v:ECO2_s_elec(sub_elec)              i:pco2_s("elec")        prod:yelec(sub_elec)
v:eco2_h                i:pco2_h        prod:consum

v:dpermits(sub_elec)              i:pers        prod:yelec(sub_elec)
v:spermits(sub_elec)              o:pers        prod:yelec(sub_elec)


$offtext
$sysinclude mpsgeset China3E

*carbon has zero price in the benchmark

*initialize constraints

sff.l(x)$ffact0(x)  =1;
t_re.l(sub_elec) = taxelec0(sub_elec);
t_re.lo(sub_elec)$ret0(sub_elec)=-inf;
pu.fx=1;

pelec.l(sub_elec)=(costelec0(sub_elec));

*== switch for umemployment
*ur0(lm)=0;
ur.l(lm)=ur0(lm);
ur.lo(lm)=ur0(lm);

*== policy shock for static model ==============================================


*== switch for emission cap
clim_h=0;

*== national emission cap
clim=1;
clim0 = 1;

*== sectoral emission cap
clim_s(i)=0;
*clim_s("construction")=0.5*Temission0('co2',"construction");
*clim_s("transport")=1*Temission0('co2',"transport");
*clim_s("EII")=0.5*Temission0('co2',"EII");
*clim_s("elec")=0.5*Temission0('co2',"elec");

*== multisectoral emission cap
clim_a=0;
*clim0 = 0.5;

*== switch for renewable quota
pflag=0;
phi=0.7;

*== FIT
*pelec.fx(sub_elec)$wsb(sub_elec)=1.1*costelec0(sub_elec);

*== subsidy
*subelec0(sub_elec)=0;

*== technilical change
*emkup(sub_elec)$wsb(sub_elec)=emkup(sub_elec)*0.1;

China3E.iterlim =100000;

$include China3E.gen

solve China3E using mcp;

display China3E.modelstat, China3E.solvestat,ur.l,clim;

*check2 =   (tlabor_q0(lm)/(1-ur0(lm))*ur.l(lm))-
check2(lm) = (1-ur.l(lm))*tlabor_s0(lm)-    sum(j,qlin.l(j,lm))- sum(sub_elec, qlin_ele.l(sub_elec,lm));

display check2;



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
;

report2(i)=sum(fe,ccoef_p(fe)*qin.l(fe,i)*(1-r_feed(fe,i)));
report2("elec")=sum(sub_elec,sum(fe,ccoef_p(fe)*qin_ele.l(fe,sub_elec)));
report2("household")=sum(fe,ccoef_h(fe)*qc.l(fe));
report2("Total")=sum(i,report2(i))+report2("household");

display report2;
