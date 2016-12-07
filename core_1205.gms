*----------------------------------------------*
*Core static model    2015/12/9   ����������/���Ѻ�Ͷ�ʽṹ�������µĵ���
*12/15 ������ҵ�Ľṹȷ��Ϊ    s:0   a:10       b(a):1.5  ��ʯ��Դ֮�������������ڷǻ�ʯ��Դ����
*12/16   �޸Ľ��������Ĺ�ģ������Xscale ��ʾó��ƽ���ı仯�����ǽ��ڹ�ģ
*ɾ�������ںͰ����ٷ��̣�ģ�;����ܼ���
*���ӹ�ģϵ��A������TFP���Ա�ʾȫҪ�������ʵı仯
*12/20   ����ur.lo�ų�=0�ļ�������   ����������Ȼʧҵ����Ϊʧҵ�ʵ���Сֵ��ȡֵΪbur("b",lm)����Դ����������
*12/21   ����l-le����������
*        ����ϵ��B������������Ȼʧҵ�ʵı仯
*12/25   �޸����������ṹ�����Ͷ�����Ͷ������һ�𣬾ۺϺ�����K��E����
*03/11   �޸�TFP������λ�ã�����baseline calibrationģ��
*03/25   Ϊ��������Դ��������˰�������������䷢����
*03/27   �ڲ��������������£����ڿ��ǹ̶�Ҫ�ضԿ�������Դ������Լ����ʹ�������Ĳ���/˰�ʣ�Լ�������Ĳ���
*03/27   �̶�Ҫ������ˮ���ͺ˵磬�˵�ˮ�����繹��base����
*04/05   �޸�̼�ŷŵ�������ͨ��������������̼ǿ�ȼ���Ŀ��
*04/06   �ظ��ǻ�ʯ�����Ĺ̶�Ҫ������������Technology-specific capital
*0413            1����EPPA6�������²��ֵ�����ҵ�����������������м�Ͷ��         2��pe_base     3���ϲ�ffe
*1205    updata for applied energy

*----------------------------------------------*
parameter      A                      /1/         ;
parameter      B                      /1/         ;
parameter simu_s,tax_s,re_s;
*simu_s=1,GDP������simu_s=0��GDP������
simu_s=1;
*tax_s=1,��������Դ˰������tax_s=0����������Դ˰������
tax_s=1;
re_s=1;

gprod0=1;

$ONTEXT
$Model:China3E

$Sectors:
y(i)                   !activity level for domestic production
consum                 !activity level for aggregate consumption
invest                 !activity level for aggregate physical capital investment
welf                   !activity level for aggregate welfare
yelec(sub_elec)        !Activity level for electricity production
*k_a                    !Activity level for capital allocation
*yist(sub_ist)         !Activity level for ist production
eb(bt)$active(bt)      !activity level for backstop technology

$Commodities:
py(i)                  !domestic price inex for goods
pelec(sub_elec)$(not bse(sub_elec))        !domestic price inex for subelec
pe_base
pl(lm)
pk                     !domestic price index for captial demand
*pk_s                   !domestic price index for captial supply
*pk_e(sub_elec)$(not TD(sub_elec))              !domestic price index for technology-specific captial
pffact(i)$x(i)         !domestic price index for fixed factors
pffelec(sub_elec)$ffelec0(sub_elec)                !domestic price index for fixed factors in electric sector
pcons                  !price index for aggregate consumption
pinv                   !price index for aggregate physical capital investment
pu                     !price index for utility

*pbf(sub_elec)          !basic factor for installed capacity

pco2$clim
pco2_s(i)$clim_s(i)              !shadow value of cafbon
pco2_h$clim_h
PSO2$slim              !shadow value of sulfur

$consumers:
ra                     !income level for representative agent

$auxiliary:
sff(x)$ffact0(x)       !side constraint modelling supply of fixed factor
sffelec(sub_elec)$ffelec0(sub_elec)         !side constraint modelling supply of fixed factors
ur(lm)$ur0(lm)                 !unemployment rate
rgdp                     !real gdp
gprod                    !productivity index
gprod1                     !productivity index
gprod3                     !productivity index
gprod2(lm)$ur0(lm)                    !productivity index
t_re(sub_elec)$ret0(sub_elec)               !��������Դ����
tclim$clim                     ! carbon limit


$prod:y(i)$elec(i)   s:0   a:10      b(a):enesta
        o:py(i)                               q:output0(i)
        i:pelec(sub_elec)$TD(sub_elec)        q:outputelec0(sub_elec)
        i:pelec(sub_elec)$wse(sub_elec)       q:outputelec0(sub_elec)       a:
        i:pe_base                             q:(sum(bse,outputelec0(bse)))       a:

*        i:pelec(sub_elec)$wse(sub_elec)       q:outputelec0(sub_elec)       a:
*        i:pelec(sub_elec)$hnb(sub_elec)       q:outputelec0(sub_elec)       a:
*        i:pelec(sub_elec)$ffe(sub_elec)       q:outputelec0(sub_elec)       b:

*       Production of T&D electricity
$prod:yelec(sub_elec)$TD(sub_elec) s:0       l(s):eslm("l")
        o:pelec(sub_elec)        q:(outputelec0(sub_elec))              p:(1-taxelec0(sub_elec))  a:ra  t:taxelec0(sub_elec)
        i:py(i)$(not e(i))       q:intelec0(i,sub_elec)
        i:py(elec)               q:(intelec0(elec,sub_elec)*aeei("elec"))
        i:py(fe)                 q:(intelec0(fe,sub_elec)*aeei("elec"))
        i:pl(lm)$ll(lm)          q:laborelec0(sub_elec,lm)            P:(awage_e(lm)*fwage_s('elec',lm))       l:
        i:pl(lm)$hl(lm)          q:laborelec0(sub_elec,lm)            P:(awage_e(lm)*fwage_s('elec',lm))         l:
        i:pk                     q:kelec0(sub_elec)

*       Production of fossile fuel electricity
*sub_sector Ͷ������������Ӧ��С��ԭsector
$prod:yelec(sub_elec)$ffe(sub_elec) s:0   kle(s):0.4 kl(kle):0.6 l(kl):eslm("l")   ene(kle):enesta roil(ene):0 coal(ene):0 gas(ene):0
*        o:pelec(sub_elec)        Q:outputelec0(sub_elec)           a:ra  N:t_re(sub_elec)
        o:pe_base                q:(outputelec0(sub_elec))                 p:(1-taxelec0(sub_elec))  a:ra  t:taxelec0(sub_elec)
        i:py(i)$(not e(i))       q:(intelec0(i,sub_elec)*emkup(sub_elec))
        i:py(elec)               q:(intelec0(elec,sub_elec)*aeei("elec")*emkup(sub_elec))
        i:pl(lm)$ll(lm)          q:(laborelec0(sub_elec,lm)*emkup(sub_elec))               P:(awage_e(lm)*fwage_s('elec',lm))    l:
        i:pl(lm)$hl(lm)          q:(laborelec0(sub_elec,lm)*emkup(sub_elec))               P:(awage_e(lm)*fwage_s('elec',lm))    l:
        i:pk                     q:(kelec0(sub_elec)*emkup(sub_elec))                         kl:
        i:py(fe)$intelec0(fe,sub_elec)    q:(intelec0(fe,sub_elec)*aeei("elec")*emkup(sub_elec))                            fe.tl:
        i:pco2#(fe)$clim         q:(emission0("co2","e",fe,sub_elec)*aeei("elec")*emkup(sub_elec))      p:1e-5             fe.tl:
        i:pco2_s("elec")#(fe)$clim_s("elec")         q:(emission0("co2","e",fe,sub_elec)*aeei("elec")*emkup(sub_elec))      p:1e-5             fe.tl:
        I:PSO2#(fe)$slim         Q:(emission0("so2","e",fe,sub_elec)*aeei("elec")*emkup(sub_elec))      P:1e-5         fe.tl:


*       Production of hybro and nuclear biomass electricity      va2 from wang ke
$prod:yelec(sub_elec)$hnb(sub_elec)  s:esub(sub_elec,"ff") a:0 va(a):esub("elec","kl") l(va):eslm("l")
        o:pe_base                q:outputelec0(sub_elec)              a:ra  N:t_re(sub_elec)
*        o:pelec(sub_elec)       q:(outputelec0(sub_elec))                 p:(1-taxelec0(sub_elec))  a:ra  t:taxelec0(sub_elec)
        i:py(i)                  q:(intelec0(i,sub_elec)*emkup(sub_elec))                                              a:
        i:pl(lm)$ll(lm)          q:(laborelec0(sub_elec,lm)*emkup(sub_elec))              P:(awage_e(lm)*fwage_s('elec',lm))            l:
        i:pl(lm)$hl(lm)          q:(laborelec0(sub_elec,lm)*emkup(sub_elec))              P:(awage_e(lm)*fwage_s('elec',lm))             l:
        i:pk                     q:(kelec0(sub_elec)*emkup(sub_elec))                                                  va:
        i:pffelec(sub_elec)$ffelec0(sub_elec)                q:(ffelec0(sub_elec)*emkup(sub_elec))      P:1

*       Production of wind, solar  electricity      va2 from wang ke
$prod:yelec(sub_elec)$wse(sub_elec) s:esub(sub_elec,"ff") b:0 va(b):esub("elec","kl") l(va):eslm("l")
        o:pelec(sub_elec)        q:(outputelec0(sub_elec))                   a:ra  N:t_re(sub_elec)
*        o:pelec(sub_elec)       q:(outputelec0(sub_elec))                 p:(1-taxelec0(sub_elec))  a:ra  t:taxelec0(sub_elec)
        i:py(i)                  q:(intelec0(i,sub_elec)*emkup(sub_elec))                                              b:
        i:pl(lm)$ll(lm)          q:(laborelec0(sub_elec,lm)*emkup(sub_elec))              P:(awage_e(lm)*fwage_s('elec',lm))             l:
        i:pl(lm)$hl(lm)          q:(laborelec0(sub_elec,lm)*emkup(sub_elec))              P:(awage_e(lm)*fwage_s('elec',lm))             l:
        i:pk                     q:(kelec0(sub_elec)*emkup(sub_elec))                                                  va:
        i:pffelec(sub_elec)$ffelec0(sub_elec)                q:(ffelec0(sub_elec)*emkup(sub_elec))      P:1


$prod:y(i)$(not fe(i) and not elec(i) ) s:0 a:esub(i,"ff") b(a):0  kle(b):0.4 kl(kle):0.6  l(kl):eslm("l") e(kle):sigma("ele_p") ne(e):sigma("ene_p")  coal(ne):0 roil(ne):0 gas(ne):0
        o:py(i)                  q:(output0(i))                    p:(1-tx0(i))     a:ra    t:tx0(i)
        I:PSO2$slim              Q:emission0("so2","e","process",i)        P:1e-5
        i:pffact(i)$ffact0(i)    q:ffact0(i)                                           a:
        i:py(j)$(not e(j))       q:int0(j,i)                                         b:
        i:pk                     q:fact0("capital",i)                              kl:
        i:pl(lm)$ll(lm)          q:labor_q0(i,lm)             P:(awage_e(lm)*fwage_s(i,lm))              l:
        i:pl(lm)$hl(lm)          q:labor_q0(i,lm)             P:(awage_e(lm)*fwage_s(i,lm))             l:
        i:py(elec)               q:(int0(elec,i)*aeei(i))                          e:
        i:py(fe)                 q:(int0(fe,i)*aeei(i))                            fe.tl:
        i:pco2#(fe)$clim         q:(emission0("co2","e",fe,i)*aeei(i))      p:1e-5             fe.tl:
        i:pco2_s(i)#(fe)$clim_s(i)         q:(emission0("co2","e",fe,i)*aeei(i))      p:1e-5             fe.tl:
        I:PSO2#(fe)$slim         Q:(emission0("so2","e",fe,i)*aeei(i))      P:1e-5              fe.tl:


*       Production of fossil fuel production       va from wang ke
$prod:y(i)$fe(i) s:0 a:esub(i,"ff") b(a):0 va(b):esub(i,"kl") l(va):eslm("l")  coal(b):0 roil(b):0 gas(b):0
        o:py(i)                  q:(output0(i))                    p:(1-tx0(i))     a:ra    t:tx0(i)
        I:PSO2$slim              Q:emission0("so2","e","process",i)        P:1e-5
        i:py(j)$(not fe(j))      q:int0(j,i)                                     b:
        i:pk                     q:fact0("capital",i)            va:
        i:pl(lm)$ll(lm)          q:labor_q0(i,lm)        P:(awage_e(lm)*fwage_s(i,lm))          l:
        i:pl(lm)$hl(lm)          q:labor_q0(i,lm)        P:(awage_e(lm)*fwage_s(i,lm))          l:
        i:pffact(i)$ffact0(i)    q:ffact0(i)                                      a:
        i:py(fe)                 q:(int0(fe,i)*aeei(i))                            fe.tl:
        i:pco2#(fe)$clim         q:(emission0("co2","e",fe,i)*aeei(i))      p:1e-5             fe.tl:
        i:pco2_s(i)#(fe)$clim_s(i)         q:(emission0("co2","e",fe,i)*aeei(i))      p:1e-5             fe.tl:
        I:PSO2#(fe)$slim         Q:(emission0("so2","e",fe,i)*aeei(i))      P:1e-5              fe.tl:



*        consumption of goods and factors    �ṹ����EPPA

$prod:consum   s:esub_c  a:0.3 e:sigma("ene_fd") roil(e):0 coal(e):0 gas(e):0
         o:pcons                  q:(sum(i,cons0(i))+sum(f,consf0(f)))
         i:py(i)$(not e(i))       q:cons0(i)                a:
         i:py(i)$(elec(i))        q:(cons0(i)*aeei("fd"))                e:
         i:py(fe)                 q:(cons0(fe)*aeei("fd"))                 fe.tl:
         i:pco2#(fe)$clim         q:(emission0("co2","e",fe,"household")*aeei("fd"))      p:1e-5             fe.tl:
         i:pco2_h#(fe)$clim_h     q:(emission0("co2","e",fe,"household")*aeei("fd"))      p:1e-5           fe.tl:
         I:PSO2#(fe)$slim         Q:(emission0("so2","e",fe,"household")*aeei("fd"))      P:1e-5         fe.tl:


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

e:pk                 q:fact("capital")                                         r:gprod
e:pk                 q:(-1)                   r:gprod1
e:pk                 q:1                      r:gprod3
e:pl(lm)             q:(tlabor_s0(lm))                                         r:gprod
e:pl(lm)$ur0(lm)     q:((-tlabor_s0(lm)))                                      r:gprod2(lm)

e:pffact(x)          q:ffact0(x)                 r:sff(x)$ffact0(x)
e:pffelec(sub_elec)$ffelec0(sub_elec)           q:(ffelec0(sub_elec)*emkup0(sub_elec))         r:sffelec(sub_elec)

*exogenous endowment of net exports(include variances)

e:py(i)              q:(-(nx0(i)+xinv0(i)+xcons0(i))*xscale)

*endowment of carbon emission allowances

e:pco2$clim         q:1                        r:tclim

e:pco2_s(i)$clim_s(i)    q:clim_s(i)
e:pco2_h$clim_h      q:clim_h
e:pso2$slim          q:slim

*supplement benchmark fixed-factor endowments according to assumed price elasticities of resource supply

$constraint:sff(x)$ffact0(x)
*      sff(x)    =e= (pffact(x)/pu)**eta(x);
     sff(x)    =e= (py(x)/pu)**eta(x);

*$constraint:sffelec(sub_elec)$(ffelec0(sub_elec) and hne(sub_elec))
*         sffelec(sub_elec) =e=  sffelec0(sub_elec);

$constraint:sffelec(sub_elec)$(ffelec0(sub_elec) and simu_s eq 0)
          sffelec(sub_elec) =e=  sffelec0(sub_elec);
*         yelec(sub_elec) =e=ret0(sub_elec);

$constraint:sffelec(sub_elec)$(ffelec0(sub_elec) and simu_s eq 1 and re_s eq 1)
*         sffelec(sub_elec) =e=  sffelec1(sub_elec);
          sffelec(sub_elec) =e=  sffelec0(sub_elec);
$constraint:sffelec(sub_elec)$(ffelec0(sub_elec) and simu_s eq 1 and re_s eq 0)
          yelec(sub_elec) =e=ret0(sub_elec);



*��׼�龰��˰/��������
$constraint:t_re(sub_elec)$(ret0(sub_elec) and tax_s eq 1)
        t_re(sub_elec) =e=taxelec0(sub_elec);


*�����龰��˰/��������
$constraint:t_re(sub_elec)$(wsb(sub_elec) and tax_s ne 1)
        yelec(sub_elec) =e=ret0(sub_elec);

$constraint:t_re(sub_elec)$(hne(sub_elec) and tax_s ne 1)
        yelec(sub_elec) =e=ret0(sub_elec);

$constraint:ur(lm)$ur0(lm)
      (Pl(lm)/pu)/(awage_e(lm)/pu) =E=(ur(lm)/ur0(lm))**(-0.1);
*     ur0(lm)*(Pl(lm)/awage_e(lm))**(-1/10) =e=ur(lm);

$constraint:gprod1$(simu_s ne 0)
   gprod1 =e= gprod0*sum(sub_elec,sffelec(sub_elec)*ffelec0(sub_elec)*emkup0(sub_elec)*pffelec(sub_elec)/pk);

$constraint:gprod1$(simu_s eq 0)
   gprod1 =e= gprod*sum(sub_elec,sffelec(sub_elec)*ffelec0(sub_elec)*emkup0(sub_elec)*pffelec(sub_elec)/pk);

$constraint:gprod3$(simu_s ne 0)
*  gprod3 =e= gprod0*sum(sub_elec,sffelec1(sub_elec)*ffelec0(sub_elec)*emkup0(sub_elec)*pffelec(sub_elec)/pk);
   gprod3 =e= gprod0*sum(sub_elec,sffelec1(sub_elec)*ffelec0(sub_elec)*emkup0(sub_elec)*pffelec(sub_elec)/pk);

$constraint:gprod3$(simu_s eq 0)
*  gprod3 =e= gprod*sum(sub_elec,sffelec1(sub_elec)*ffelec0(sub_elec)*emkup0(sub_elec)*pffelec(sub_elec)/pk);
   gprod3 =e= gprod*sum(sub_elec,sffelec1(sub_elec)*ffelec0(sub_elec)*emkup0(sub_elec)*pffelec(sub_elec)/pk);



$constraint:gprod2(lm)$(ur0(lm) and simu_s ne 0)
  gprod2(lm) =e= gprod0*ur(lm);

$constraint:gprod2(lm)$(ur0(lm) and simu_s eq 0)
 gprod2(lm) =e= gprod*ur(lm);

$constraint:rgdp
  pu*rgdp =e= pcons*(sum(i,cons0(i))+sum(f,consf0(f)))*consum+pinv*(sum(i,inv0(i)))*invest+sum(i,py(i)*((nx0(i)+xinv0(i)+xcons0(i))*xscale))   ;

$constraint:gprod$(simu_s eq 0)
  rgdp =e= rgdp0;

$constraint:gprod$(simu_s ne 0)
  gprod =e= gprod0;

$constraint:tclim$clim
*����Ŀ��
*   tclim =e= clim0*temission2("co2");

  tclim =e= clim0*temission2("co2")/rgdp0*rgdp;

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
*v:qkein(sub_elec)$(not TD(sub_elec))                o:pk_e(sub_elec)        prod:yelec(sub_elec)   !capital inputs
*v:qkt                  i:pk_s        prod:k_a         !capital supply
*v:qk                   o:pk          prod:k_a        !capital inputs
*v:qke(sub_elec)$(not TD(sub_elec))                o:pk_e(sub_elec)        prod:k_a        !capital inputs

v:qlin(lm,j)           i:pl(lm)      prod:y(j)        !labor inputs
v:qlin_ele(lm,sub_elec)      i:pl(lm)      prod:yelec(sub_elec)        !labor inputs
v:qkin_ele(sub_elec)   i:pk          prod:yelec(sub_elec)        !capital inputs
v:qffin(j)$x(j)        i:pffact(j)   prod:y(j)        !fixed factor inputs

v:qffelec(sub_elec)$ffelec0(sub_elec)    i:pffelec(sub_elec)     prod:yelec(sub_elec)      !fixed factor inputs

V:qelec1(sub_elec)$(not wse(sub_elec))        o:pe_base       prod:yelec(sub_elec)
V:qelec2(sub_elec)$(wse(sub_elec))            o:pelec(sub_elec)               prod:yelec(sub_elec)

v:ECO2(i)              i:pco2         prod:y(i)
v:ECO2_s(i)              i:pco2_s(i)        prod:y(i)
v:ECO2_e(sub_elec)     i:pco2       prod:yelec(sub_elec)
v:eco2_h               i:pco2        prod:consum
v:EsO2(i)              i:pso2        prod:y(i)
v:EHsO2                i:pso2        prod:consum
$offtext
$sysinclude mpsgeset China3E

*carbon has zero price in the benchmark

*initialize constraints

sff.l(x)$ffact0(x)  =1;
pu.fx=1;
ur.l(lm)=ur0(lm);
ur.lo(lm)=B*ur0(lm);
ur.lo(lm)=0.0000001;
t_re.l(sub_elec)$ret0(sub_elec)=taxelec0(sub_elec);
t_re.lo(sub_elec)$ret0(sub_elec)=-inf;
gprod.l=1;
gprod.lo=0;

*tclim.l=temission2("co2");
*clim=0;
*clim0=0.7;

*ret0("solar_elec")=100;


*ur0(lm)=0;
*clim_s("construction")=0.5*Temission0('co2',"construction");
*clim_s("transport")=1*Temission0('co2',"transport");
*clim_s("EII")=0.5*Temission0('co2',"EII");
*clim_s("elec")=0.7*Temission0('co2',"elec");
*clim=1*Temission1('co2');

*benchmark calibration

China3E.iterlim =100000;

$include China3E.gen

solve China3E using mcp;

display China3E.modelstat, China3E.solvestat,rgdp.l,gprod.l;

parameter eqcheck(*,*);
eqcheck('eq1','elec') = output0('elec')-sum(sub_elec,outputelec0(sub_elec));
eqcheck('eq2',sub_elec) = outputelec0(sub_elec)*(1-taxelec0(sub_elec))-emkup(sub_elec)*(sum(i,intelec0(i,sub_elec))+kelec0(sub_elec)+ffelec0(sub_elec)+sum(lm,(awage_e(lm)*fwage_s('elec',lm))*laborelec0(sub_elec,lm)));
eqcheck('eq3',i)$(not elec(i)) = output0(i)*(1-tx0(i))-sum(j,int0(j,i))-fact0("capital",i)-sum(lm,(awage_e(lm)*fwage_s(i,lm))*labor_q0(i,lm))-ffact0(i);
eqcheck('labor',i)$(not elec(i)) =   sum(lm,(awage_e(lm)*fwage_s(i,lm))*labor_q0(i,lm)) ;
eqcheck('ds','k') = sum(i$(not elec(i)),fact0("capital",i))+ sum(sub_elec,emkup(sub_elec)*kelec0(sub_elec));
eqcheck('ds',lm) = sum(i$(not elec(i)),labor_q0(i,lm))+ sum(sub_elec,emkup(sub_elec)*laborelec0(sub_elec,lm));
*check2(sub_elec)     =   sum(lm,(awage_e(lm)*fwage_s('elec',lm))*laborelec0(sub_elec,lm)) ;
*check2 = sum(i,fact0("capital",i))-fact0("capital","elec")+sum(sub_elec,kelec0(sub_elec)*emkup(sub_elec))-fact("capital");
display eqcheck,emkup;


*parameter chek1 ;
*chek1=pcons.l*grosscons.l+pinv.l*grossinvk.l+pe.l*grossexp.l-sum(i,pm.l(i)*qimp.l(i));;
*chek2(i)=output0(i)-sum(j,int0(j,i))-fact0("capital",i)-sum(lm,labor_q0(i,lm))-ffact0(i);
*chek3(sub_elec)=outputelec0(sub_elec)*(1-taxelec0(sub_elec))-sum(i,intelec0(i,sub_elec))-kelec0(sub_elec)-sum(lm,laborelec0(sub_elec,lm))
*chek2(i)=fact0("labor",i)-sum(lm,labor_q0(i,lm));
*display chek1;



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
*UNEM
*Pwage;;

*report1(lm)=sum(i,qlin.l(lm,i))+sum(sub_elec,qlin_ele.l(lm,sub_elec));
*report1(lm)=ur.l(lm)-ur0(lm);
*report1(lm)=ur0(lm)*(pl.l(lm)/wage("0.11",lm))**(-10)-ur.l(lm);
*display report1;

$ontext



*set rate reduction rate /0,10,20,30,40,50,60,70,80,90/  ;
set z reduction rate /0,1,2,3,4,5,6,7,8,9/  ;
parameter rate(z) /0=0,
                   1=0.1,
                   2=0.2,
                   3=0.3,
                   4=0.4,
                   5=0.5,
                   6=0.6,
                   7=0.7,
                   8=0.8,
                   9=0.9/;


loop(z,
*clim=(1-(ord(rate)-1)/10)*Temission1("co2");
*clim_s("elec")=(1-(ord(rate)-1)/10)*Temission0('co2',"elec");
*clim_s("EII")=(1-(ord(rate)-1)/10)*Temission0('co2',"EII");
*clim_s("construction")=(1-(ord(rate)-1)/10)*Temission0('co2',"construction");
clim_s("elec")=(1-rate(z))*Temission0('co2',"elec");

*sigma("kle_ele") = rate(z)*0.6;
$include China3E.gen

solve China3E using mcp;

display China3E.modelstat, China3E.solvestat,clim,rate,sigma;

UNEM(lm,z)=UR.l(lm);
pwage(lm,z)=pl.l(lm);

report1(z,i)=qdout.l(i);
report2(z,i)=sum(fe,ccoef_p(fe)*qin.l(fe,i));
report2(z,sub_elec)=sum(fe,ccoef_p(fe)*qin_ele.l(fe,sub_elec));
report2(z,fe)=0;
report2(z,"household")=sum(fe,ccoef_h(fe)*qc.l(fe));
report3(z,i,j)=qin.l(i,j);
report3(z,i,sub_elec)=qin_ele.l(i,sub_elec);
report3(z,i,"household")=qc.l(i);
report4(z,i)=qffin.l(i);
report4(z,sub_elec)=qffelec.l(sub_elec);
report5(z)=   pcons.l*grosscons.l+pinv.l*grossinvk.l+sum(i,py.l(i)*((nx0(i)+xinv0(i)+xcons0(i))*xscale));
report6(z,lm)= sum(i,qlin.l(lm,i))+sum(sub_elec,qlin_ele.l(lm,sub_elec));
report7(z)= sum(i,qkin.l(i))+sum(sub_elec,qkin_ele.l(sub_elec));
report8(z,sub_elec)=qelec.l(sub_elec);
report9(z,sub_elec,lm)=qlin_ele.l(lm,sub_elec);

);
execute_unload "results.gdx" UNEM Pwage report1 report2 report3  report4 report5  report6 report7 report8  report9
execute 'gdxxrw.exe results.gdx par=unem rng=UNEM!'
execute 'gdxxrw.exe results.gdx par=Pwage rng=wage!'
execute 'gdxxrw.exe results.gdx par=report1 rng=output!'
execute 'gdxxrw.exe results.gdx par=report2 rng=emission!'
execute 'gdxxrw.exe results.gdx par=report3 rng=input!'
execute 'gdxxrw.exe results.gdx par=report4 rng=ffactor!'
execute 'gdxxrw.exe results.gdx par=report5 rng=GDP!'
execute 'gdxxrw.exe results.gdx par=report6 rng=labor!'
execute 'gdxxrw.exe results.gdx par=report7 rng=capital!'
execute 'gdxxrw.exe results.gdx par=report8 rng=ele_out!'
execute 'gdxxrw.exe results.gdx par=report9 rng=ele_labor!'

$offtext
