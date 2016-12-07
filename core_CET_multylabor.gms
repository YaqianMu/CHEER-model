*----------------------------------------------*
*Core static model    2015/12/9   对生产函数/消费和投资结构做了重新的调整
*12/15 电力行业的结构确定为    s:0   a:10       b(a):1.5  化石能源之间先替代，在于非化石能源替代
*12/16   修改进口禀赋的规模参数，Xscale 表示贸易平衡的变化，而非进口规模
*删减进出口和阿明顿方程，模型尽可能简化
*增加规模系数A，结合TFP用以表示全要素生产率的变化
*----------------------------------------------*
parameter      A                      /1/         ;
parameter ur_t0      the benchmark unemployment rate  ;
ur_t0    =  0;
$ONTEXT
$Model:China3E

$Sectors:
y(i)                   !activity level for domestic production
consum                 !activity level for aggregate consumption
invest                 !activity level for aggregate physical capital investment
welf                   !activity level for aggregate welfare
yelec(sub_elec)        !Activity level for electricity production
*yist(sub_ist)         !Activity level for ist production

l_a(lm)                !Activity level for labor allocation

$Commodities:
py(i)                  !domestic price inex for goods
pelec(sub_elec)        !domestic price inex for subelec
*pist(sub_ist)          !domestic price inex for subist
*plabor(i,lm)$labor_q0(i,lm)               !domestic price index for labor demand
pls(lm)                   !domestic price index for labor demand
pl(i,lm)$labor_q0(i,lm)                  !domestic price index for labor demand
pk                     !domestic price index for captial
pffact(i)$ffact0(i)         !domestic price index for fixed factors
pffelec(sub_elec)$ffelec0(sub_elec)                !domestic price index for fixed factors in electric sector
pcons                  !price index for aggregate consumption
pinv                   !price index for aggregate physical capital investment
pu                     !price index for utility

pco2$clim
pco2_s(i)$clim_s(i)              !shadow value of cafbon
pco2_h$clim_h
PSO2$slim              !shadow value of sulfur

$consumers:
ra                     !income level for representative agent

$auxiliary:
sff(x)$ffact0(x)       !side constraint modelling supply of fixed factor
sffelec(sub_elec)$ffelec0(sub_elec)         !side constraint modelling supply of fixed factors
ur_t$ur_t0                 !unemployment rate

*$prod:l_a(lm)       t:1
*         o:plabor(i,lm)      q:labor_q0(i,lm)            P:(awage_e(lm)*fwage_s(i,lm))
*         i:pl(lm)            q:tlabor_q0(lm)             p:awage_e(lm)

$prod:l_a(lm)       t:1
         o:pl(i,lm)      q:labor_v0(i,lm)
         i:pls(lm)       q:tlabor_v0(lm)



$prod:y(i)$elec(i)   s:0   a:10       b(a):1.5
        o:py(i)                                  q:output0(i)
        i:pelec(sub_elec)$TD(sub_elec)        q:outputelec0(sub_elec)
        i:pelec(sub_elec)$cfe(sub_elec)       q:outputelec0(sub_elec)         a:
        i:pelec(sub_elec)$ffe(sub_elec)       q:outputelec0(sub_elec)         b:

*       Production of fossile fuel electricity


*sub_sector 投入的替代弹性应该小于原sector
$prod:yelec(sub_elec)$ffe(sub_elec) s:0  kle(s):0.6  ke(kle):0.5  ene(ke):enesta roil(ene):0 coal(ene):0 gas(ene):0
        o:pelec(sub_elec)                q:(outputelec0(sub_elec))          p:(1-taxelec0(sub_elec))  a:ra  t:taxelec0(sub_elec)
        I:PSO2$slim              Q:emission0("so2","e","process",sub_elec)        P:1e-5
        i:py(i)$(not fe(i))      q:intelec0(i,sub_elec)
        i:pl("elec",lm)             q:laborelec0(sub_elec,lm)                         kle:
        i:pk                     q:kelec0(sub_elec)                         ke:
        i:py(fe)$intelec0(fe,sub_elec)    q:intelec0(fe,sub_elec)                            fe.tl:
        i:pco2#(fe)$clim         q:emission0("co2","e",fe,sub_elec)      p:1e-5             fe.tl:
        i:pco2_s("elec")#(fe)$clim_s("elec")         q:emission0("co2","e",fe,sub_elec)      p:1e-5             fe.tl:
        I:PSO2#(fe)$slim         Q:emission0("so2","e",fe,sub_elec)      P:1e-5         fe.tl:


*       Production of carbon free electricity
$prod:yelec(sub_elec)$cfe(sub_elec) s:0  a:0.6 b(a):0  va2(b):esub("elec","kl")
        o:pelec(sub_elec)        q:(outputelec0(sub_elec))              p:(1-taxelec0(sub_elec))  a:ra  t:taxelec0(sub_elec)
        I:PSO2$slim              Q:emission0("so2","e","process",sub_elec)        P:1e-5
        i:py(i)                  q:intelec0(i,sub_elec)                                              b:
        i:pl("elec",lm)             q:laborelec0(sub_elec,lm)                         va2:
        i:pk                     q:kelec0(sub_elec)                                 va2:
        i:pffelec(sub_elec)$ffelec0(sub_elec)                q:ffelec0(sub_elec)      P:1             a:

*       Production of T&D electricity
$prod:yelec(sub_elec)$TD(sub_elec) s:0
        o:pelec(sub_elec)        q:(outputelec0(sub_elec))              p:(1-taxelec0(sub_elec))  a:ra  t:taxelec0(sub_elec)
        i:py(i)                  q:intelec0(i,sub_elec)
        i:pl("elec",lm)             q:laborelec0(sub_elec,lm)
        i:pk                     q:kelec0(sub_elec)


$prod:y(i)$(not fe(i) and not elec(i) ) s:0 a:0.6 b(a):0  kle(b):0.4 ke(kle):0.5 e(kle):sigma("ele_p") ne(e):sigma("ene_p")  coal(ne):0 roil(ne):0 gas(ne):0
        o:py(i)                  q:(output0(i))                    p:(1-tx0(i))     a:ra    t:tx0(i)
        I:PSO2$slim              Q:emission0("so2","e","process",i)        P:1e-5
        i:py(j)$(not e(j))       q:int0(j,i)                                         b:
        i:pk                     q:fact0("capital",i)                    ke:
        i:pl(i,lm)                  q:labor_v0(i,lm)                    ke:
        i:pffact(i)$ffact0(i)    q:ffact0(i)                                           a:
        i:py(elec)               q:int0(elec,i)                          e:
        i:py(fe)                 q:int0(fe,i)                            fe.tl:
        i:pco2#(fe)$clim         q:emission0("co2","e",fe,i)      p:1e-5             fe.tl:
        i:pco2_s(i)#(fe)$clim_s(i)         q:emission0("co2","e",fe,i)      p:1e-5             fe.tl:
        I:PSO2#(fe)$slim         Q:emission0("so2","e",fe,i)      P:1e-5              fe.tl:


*       Production of fossil fuel production
$prod:y(i)$fe(i) s:0 a:0.6 b(a):0 va2(b):esub(i,"kl")
        o:py(i)                  q:(output0(i))                    p:(1-tx0(i))     a:ra    t:tx0(i)
        I:PSO2$slim              Q:emission0("so2","e","process",i)        P:1e-5
        i:py(j)                  q:int0(j,i)                                     b:
        i:pl(i,lm)                  q:labor_v0(i,lm)                    va2:
        i:pk                     q:fact0("capital",i)            va2:
        i:pffact(i)$ffact0(i)    q:ffact0(i)                                      a:


*        consumption of goods and factors    结构参照EPPA

$prod:consum   s:esub_c  a:0.3 e:sigma("ene_fd") roil(e):0 coal(e):0 gas(e):0
         o:pcons                  q:(sum(i,cons0(i))+sum(f,consf0(f)))
         i:py(i)$(not fe(i))      q:cons0(i)                 a:$(not elec(i))    e:$elec(i)
         i:py(fe)                 q:cons0(fe)                 fe.tl:
         i:pco2#(fe)$clim         q:emission0("co2","e",fe,"household")      p:1e-5             fe.tl:
         i:pco2_h#(fe)$clim_h     q:emission0("co2","e",fe,"household")      p:1e-5           fe.tl:
         I:PSO2#(fe)$slim         Q:emission0("so2","e",fe,"household")      P:1e-5         fe.tl:


*        aggregate capital investment

$prod:invest   s:esub_inv
         o:pinv             q:(sum(i,inv0(i)))
         i:py(i)            q:inv0(i)



*        welfare          王克 EPPA S：取值都为1

$prod:welf    s:1.0
         o:pu                 q:(sum(i,cons0(i)+inv0(i))+sum(f,consf0(f)+invf0(f)))
         i:pcons              q:(sum(i,cons0(i))+sum(f,consf0(f)))
         i:pinv               q:(sum(i,inv0(i))+sum(f,invf0(f)))


$demand:ra

*demand for consumption,invest and rd

d:pu                 q:(sum(i,cons0(i)+inv0(i))+sum(f,consf0(f)+invf0(f)))

*endowment of factor supplies

e:pk                 q:fact("capital")
e:pls(lm)                q:(tlabor_v0(lm)/(1-ur_t0))
e:pls(lm)$ur_t0             q:(-tlabor_v0(lm)/(1-ur_t0))                  r:ur_t$ur_t0
e:pffact(x)          q:ffact0(x)                 r:sff(x)$ffact0(x)
e:pffelec(sub_elec)  q:ffelec0(sub_elec)         r:sffelec(sub_elec)$ffelec0(sub_elec)

*exogenous endowment of net exports(include variances)

e:py(i)              q:(-(nx0(i)+xinv0(i)+xcons0(i))*xscale)

*endowment of carbon emission allowances

e:pco2$clim          q:clim
e:pco2_s(i)$clim_s(i)    q:clim_s(i)
e:pco2_h$clim_h      q:clim_h
e:pso2$slim          q:slim

*supplement benchmark fixed-factor endowments according to assumed price elasticities of resource supply

$constraint:sff(x)$ffact0(x)
*     sff(x)    =e= (py(x)/pu)**eta(x);
sff(x)    =e= 1;

$constraint:sffelec(sub_elec)$ffelec0(sub_elec)
*    sffelec(sub_elec) =e=  (py("elec")/pu)**eta(sub_elec);
     sffelec(sub_elec) =e= 1;

*$constraint:ur_t$ur_t0
*      (pl(lm)/pu)/(wage("0.11",lm)/pu) =E=(ur_t/ur_t0)**(-0.1);
*     ur_t0*pl**(-1/10) =e=ur_t;

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
v:ECO2_s(i)              i:pco2_s(i)        prod:y(i)
v:ECO2_se(sub_elec)              i:pco2_s("elec")        prod:yelec(sub_elec)
v:eco2_h                i:pco2_h        prod:consum
v:EsO2(i)              i:pso2        prod:y(i)
v:EHsO2                i:pso2        prod:consum
$offtext
$sysinclude mpsgeset China3E

*carbon has zero price in the benchmark

*initialize constraints

sff.l(x)$ffact0(x)  =1;
pu.fx=1;

*== policy shock for static model
*ur_t0=0;
ur_t.l=ur_t0;
*clim_s("construction")=0.5*Temission0('co2',"construction");
*clim_s("transport")=1*Temission0('co2',"transport");
*clim_s("EII")=0.5*Temission0('co2',"EII");
clim_s("elec")=0.7*Temission0('co2',"elec");
*clim=1*Temission1('co2');

*benchmark calibration

China3E.iterlim =100000;

$include China3E.gen

solve China3E using mcp;

display China3E.modelstat, China3E.solvestat,ur_t.l,clim;


