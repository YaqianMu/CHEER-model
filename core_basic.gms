*----------------------------------------------*
*Core static model    2015/12/9   ����������/���Ѻ�Ͷ�ʽṹ�������µĵ���
*12/15 ������ҵ�Ľṹȷ��Ϊ    s:0   a:10       b(a):1.5  ��ʯ��Դ֮������������ڷǻ�ʯ��Դ���
*12/16   �޸Ľ��������Ĺ�ģ������Xscale ��ʾó��ƽ��ı仯�����ǽ��ڹ�ģ
*ɾ�������ںͰ����ٷ��̣�ģ�;����ܼ�
*���ӹ�ģϵ��A�����TFP���Ա�ʾȫҪ�������ʵı仯
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
eb(bt)$active(bt)      !activity level for backstop technology

$Commodities:
py(i)                  !domestic price inex for goods
pelec(sub_elec)        !domestic price inex for subelec
*pist(sub_ist)          !domestic price inex for subist
pl
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

$prod:y(i)$elec(i)   s:0   a:10       b(a):1.5
        o:py(i)                                  q:output0(i)
        i:pelec(sub_elec)$TD(sub_elec)        q:outputelec0(sub_elec)
        i:pelec(sub_elec)$cfe(sub_elec)       q:outputelec0(sub_elec)         a:
        i:pelec(sub_elec)$ffe(sub_elec)       q:outputelec0(sub_elec)         b:

*       Production of fossile fuel electricity


*sub_sector Ͷ����������Ӧ��С��ԭsector
$prod:yelec(sub_elec)$ffe(sub_elec) s:0  kle(s):0.6  ke(kle):0.5  ene(ke):enesta roil(ene):0 coal(ene):0 gas(ene):0
        o:pelec(sub_elec)                q:(outputelec0(sub_elec))          p:(1-taxelec0(sub_elec))  a:ra  t:taxelec0(sub_elec)
        I:PSO2$slim              Q:emission0("so2","e","process",sub_elec)        P:1e-5
        i:py(i)$(not fe(i))      q:intelec0(i,sub_elec)
        i:pl                     q:lelec0(sub_elec)                   kle:
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
        i:pl                     q:lelec0(sub_elec)                                 va2:
        i:pk                     q:kelec0(sub_elec)                                 va2:
        i:pffelec(sub_elec)$ffelec0(sub_elec)                q:ffelec0(sub_elec)      P:1             a:

*       Production of T&D electricity
$prod:yelec(sub_elec)$TD(sub_elec) s:0
        o:pelec(sub_elec)        q:(outputelec0(sub_elec))              p:(1-taxelec0(sub_elec))  a:ra  t:taxelec0(sub_elec)
        i:py(i)                  q:intelec0(i,sub_elec)
        i:pl                     q:lelec0(sub_elec)
        i:pk                     q:kelec0(sub_elec)


$prod:y(i)$(not fe(i) and not elec(i) ) s:0 a:0.6 b(a):0  kle(b):0.4 ke(kle):0.5 e(kle):sigma("ele_p") ne(e):sigma("ene_p")  coal(ne):0 roil(ne):0 gas(ne):0
        o:py(i)                  q:(output0(i))                    p:(1-tx0(i))     a:ra    t:tx0(i)
        I:PSO2$slim              Q:emission0("so2","e","process",i)        P:1e-5
        i:py(j)$(not e(j))       q:int0(j,i)                                         b:
        i:pk                     q:fact0("capital",i)                    ke:
        i:pl                     q:fact0("labor",i)                          kle:
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
        i:pk                     q:fact0("capital",i)            va2:
        i:pl                     q:fact0("labor",i)              va2:
        i:pffact(i)$ffact0(i)    q:ffact0(i)                                      a:


*        consumption of goods and factors    �ṹ����EPPA

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



*        welfare          ���� EPPA S��ȡֵ��Ϊ1

$prod:welf    s:1.0
         o:pu                 q:(sum(i,cons0(i)+inv0(i))+sum(f,consf0(f)+invf0(f)))
         i:pcons              q:(sum(i,cons0(i))+sum(f,consf0(f)))
         i:pinv               q:(sum(i,inv0(i))+sum(f,invf0(f)))


$demand:ra

*demand for consumption,invest and rd

d:pu                 q:(sum(i,cons0(i)+inv0(i))+sum(f,consf0(f)+invf0(f)))

*endowment of factor supplies

e:pk                 q:fact("capital")
e:pl                 q:(fact("labor")/(1-ur_t0))
e:pl$ur_t0             q:(-fact("labor")/(1-ur_t0))                  r:ur_t$ur_t0
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

$constraint:ur_t$ur_t0
*      (pl/pu)/(wage("0.11",lm)/pu) =E=(ur_t/ur_t0)**(-0.1);
     ur_t0*pl**(-1/10) =e=ur_t;

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
v:qlin(j)           i:pl      prod:y(j)        !labor inputs
v:qlin_ele(sub_elec)      i:pl      prod:yelec(sub_elec)        !labor inputs
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

*ur_t0=0;
ur_t.l=ur_t0;
*clim_s("construction")=0.5*Temission0('co2',"construction");
*clim_s("transport")=1*Temission0('co2',"transport");
*clim_s("EII")=0.5*Temission0('co2',"EII");
*clim_s("elec")=0.7*Temission0('co2',"elec");
*clim=1*Temission1('co2');

*benchmark calibration

China3E.iterlim =100000;

$include China3E.gen

solve China3E using mcp;

display China3E.modelstat, China3E.solvestat,ur_t.l,clim;


parameter eqcheck(*,*);
eqcheck('eq1','elec') = output0('elec')-sum(sub_elec,outputelec0(sub_elec));
eqcheck('eq2',sub_elec) = outputelec0(sub_elec)*(1-taxelec0(sub_elec))-emkup(sub_elec)*(sum(i,intelec0(i,sub_elec))+kelec0(sub_elec)+ffelec0(sub_elec)+lelec0(sub_elec));
eqcheck('eq3',i)$(not elec(i)) = output0(i)*(1-tx0(i))-sum(j,int0(j,i))-fact0("capital",i)-fact0("labor",i)-ffact0(i);
eqcheck('ds','k') = sum(i$(not elec(i)),fact0("capital",i))+ sum(sub_elec,emkup(sub_elec)*kelec0(sub_elec));
eqcheck('ds',lm) = sum(i$(not elec(i)),fact0("labor",i))+ sum(sub_elec,emkup(sub_elec)*lelec0(sub_elec));
display eqcheck;