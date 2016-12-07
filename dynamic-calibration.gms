*----------------------------------------------*
*Dynamic process
*2015��12��7�� 5��һ���㣬�Ͷ�������,�Ͷ�������������̬��
*12��11�գ��޸��Ͷ��������ĵ�����ʽ������tqlabor������ʾ�Ͷ����������������ڿ�����
*���ʲ��죬fact����labor������ʾ�����Ͷ����ܱ��꣬��������
*12��16�գ�TFP��AEEI���ȼ���Ϊ0
*12/26   tfp=0.06  aeei=-0.01
*03/14   tfp��aeeiͨ��core����ģ��    ������ҵ0.3%��������ҵ1% from EPPA 6
*03/17   calibration��baseline�ֿ�
*03/28   ����ff����/������������
*----------------------------------------------*

parameters

pdom         domesitic price of commodities
pamt         armington price of energy commodities(gross of carbon taxes)
pdk          domestic capital prices
pdl          domestic labor prices
pfdem        prices of final demand activities
pff          prices of fixed factors

unem         unemployment rate

pcarbon      shadow price of carbon(2005 Chinese Yuan per ton)
psulfur      shadow price of sulfur

gdp          GDP at factor cots(2005 Chinese 100million Yuan)
gdp_comp     component of gdp (2005 Chinese 100million Yuan)
welfare      consumer's income (2005 Chinese 100million Yuan)

fact_supp    factor supplies(2005 Chinese 100million Yuan)
ffact_supp   fixed factor supplies(2005 Chinese 100million Yuan)
fact_dem     factor demands(2005 Chinese 100million Yuan)

demand       demand for armington aggregate commodities(2005 Chinese 100million Yuan)
output       sectoral output quantities(2005 Chinese 100million Yuan)
input        sectoral input quantities(2005 Chinese 100million Yuan)
cons         consumption quantities(2005 Chinese 100million Yuan)
consf        consumption of factors(2005 Chinese 100million Yuan)
invk         sectoral physical capital investment(2005 Chinese 100million Yuan)
invfk        physical capital investment by factors(2005 Chinese 100million Yuan)

output_elec  sectoral output quantities of sub electricity sectors

elecshare    share of different elecutil type(%)
euse         aggregate energy use (million tce)
cfree_elec   non-carbon electric output
carb_elec    carbon-based electric output
carb_emit    carbon emissions (million tonnes)
sulf_emit    sulfur emissions
cqutta       carbon emission quota (million tonnes)
squtta       carbon emission quota (million tonnes)

kstock       physical capital stock(2005 Chinese 100million Yuan)
invest_k     aggregate gorss physical capital investment(2005 Chinese 100million Yuan)
jk           aggregate net physical capital investment(2005 Chinese 100million Yuan)


parameter
invk         sectoral physical capital investment(2005 Chinese 100million Yuan)

invfk        physical capital investment by factors(2005 Chinese 100million Yuan)

kstock       physical capital stock(2005 Chinese 100million Yuan)
invest_k     aggregate gorss physical capital investment(2005 Chinese 100million Yuan)
jk           aggregate net physical capital investment(2005 Chinese 100million Yuan)



scalars

zetak     adjustment threshold of capital stock /0.044/

betak     speed of adjustment of capital stock  /32.2/


gammak    growth rate of pysical capital in initial period /0.10/


deltak    annual rate of physical capital depreciation /0.03/


rk0       benchmark net marginal product of capital

rork0     benchmark net return to physical capital

kstock0   benchmark capital stock


;



*test sensitivity of emissions to fixed factor supply elasticitiy

*eta("coal")=1.0;
*eta("oilgas")=0.5;

invest_k("2010")=grossinvk.l;


rk0$((gammak+deltak) le zetak)= (gammak+deltak)*fact("capital")/invest_k("2010")-deltak;
rk0$((gammak+deltak) > zetak) =(betak/2*(gammak+deltak-zetak)**2+gammak+deltak)*fact("capital")/invest_k("2010")-deltak;
rork0= rk0+deltak;
kstock0 =fact("capital")/rork0;


*display fact,invest_k,invest_h,rk0,rork0,kstock0,rh0,rorh0,hstock0;
*$exit

*emissions restriction policies,with or without inducement of innovation
parameters

cquota
UNEM
Pwage
Pcom
;

cquota(t) =0;

*simu=0,calibration; simu=1,����˰��simu=2,����˰
simu_s =1;
tax_s =1;

loop(t$(ord(t) le card(t)),


clim = 0;

gprod0$(simu_s ne 0)=gprod_b(t);

rgdp0$(simu_s eq 0)=rgdp_b(t);

sffelec1(sub_elec)$hne(sub_elec)=sffelec_BAU(t,sub_elec);
sffelec1(sub_elec)$(wsb(sub_elec))=sffelec_BAU(t,sub_elec);

*sffelec0(sub_elec)$hne(sub_elec)=sffelec_b(t,sub_elec);
*sffelec0(sub_elec)$wsb(sub_elec)=sffelec_b(t,sub_elec);
*ffelec0(sub_elec)=ffelec_b(sub_elec)*ff_t(t,sub_elec);

clim0= clim_t(t);

ret0(sub_elec)=ret_b(t,sub_elec);

emkup(sub_elec)=mkup_t(t,sub_elec);

re_s$(ord(t) lt 3)  =1;
re_s$(ord(t) gt 3)  =0;


China3E.iterlim =100000;

$include China3E.gen



solve China3E using mcp;

display China3E.modelstat, China3E.solvestat,clim,clim0,emkup,re_s;



*-------------
*sore results
*-------------

*stocks

invest_k(t)                  =   grossinvk.l;
kstock(t)$(ord(t)=1)         =   kstock0;

report1(t,"output",i)=qdout.l(i);
*report1(t,"labor",i)=sum(lm,qlin.l(lm,i));
report2(t,i)=sum(fe,ccoef_p(fe)*qin.l(fe,i));
report2(t,sub_elec)=sum(fe,ccoef_p(fe)*qin_ele.l(fe,sub_elec));
report2(t,fe)=0;
report2(t,"household")=sum(fe,ccoef_h(fe)*qc.l(fe));
report3(t,i,j)=qin.l(i,j);
report3(t,i,sub_elec)=qin_ele.l(i,sub_elec);
report3(t,i,"household")=qc.l(i);
report4(t,i)=qffin.l(i);
report4(t,sub_elec)=qffelec.l(sub_elec);
report5(t)=   pcons.l*grosscons.l+pinv.l*grossinvk.l+sum(i,py.l(i)*((nx0(i)+xinv0(i)+xcons0(i))*xscale));
report6(t,lm)= sum(i,qlin.l(lm,i))+sum(sub_elec,qlin_ele.l(lm,sub_elec));
report7(t)= sum(i,qkin.l(i))+sum(sub_elec,qkin_ele.l(sub_elec));
report8("output",t,sub_elec)$(not wse(sub_elec))=qelec1.l(sub_elec);
report8("output",t,sub_elec)$(wse(sub_elec))=qelec2.l(sub_elec);
report8("output",t,"Total")=sum(sub_elec,report8("output",t,sub_elec));
report8("share",t,sub_elec)$(not wse(sub_elec))=qelec1.l(sub_elec)/report8("output",t,"Total");
report8("share",t,sub_elec)$(wse(sub_elec))=qelec2.l(sub_elec)/report8("output",t,"Total");
report9(t,sub_elec,lm)=qlin_ele.l(lm,sub_elec);
report10(t,i,lm)=qlin.l(lm,i);
report11(t,sub_elec)=t_re.l(sub_elec);
report12("Billion Yuan",t,e)=qc.l(e)+sum(j,qin.l(e,j))+sum(sub_elec,qin_ele.l(e,sub_elec));
report12("Billion Yuan",t,sub_elec)=report12("Billion Yuan",t,"elecutil")*report8("share",t,sub_elec);
report12("coal equivalent calculation(Mt)",t,fe)=eet1(fe)/100*report12("Billion Yuan",t,fe)/report12("Billion Yuan","2010",fe);
report12("coal equivalent calculation(Mt)",t,sub_elec)$(cfe(sub_elec))=eet1(sub_elec)/100*report12("Billion Yuan",t,sub_elec)/report12("Billion Yuan","2010",sub_elec);
report12("coal equivalent calculation(Mt)",t,"Total")=sum(fe,report12("coal equivalent calculation(Mt)",t,fe))+sum(sub_elec,report12("coal equivalent calculation(Mt)",t,sub_elec));
report12("coal equivalent calculation(Mt)",t,"nfshare")=sum(sub_elec,report12("coal equivalent calculation(Mt)",t,sub_elec))/report12("coal equivalent calculation(Mt)",t,"Total");
report12("calorific value calculation(Mt)",t,fe)=eet2(fe)/100*report12("Billion Yuan",t,fe)/report12("Billion Yuan","2010",fe);
report12("calorific value calculation(Mt)",t,sub_elec)$(cfe(sub_elec))=eet2(sub_elec)/100*report12("Billion Yuan",t,sub_elec)/report12("Billion Yuan","2010",sub_elec);
report12("calorific value calculation(Mt)",t,"Total")=sum(fe,report12("calorific value calculation(Mt)",t,fe))+sum(sub_elec,report12("calorific value calculation(Mt)",t,sub_elec));
report12("calorific value calculation(Mt)",t,"nfshare")=sum(sub_elec,report12("calorific value calculation(Mt)",t,sub_elec))/report12("calorific value calculation(Mt)",t,"Total");

UNEM(lm,t)=UR.l(lm);
UNEM("Overall",t)=sum(lm,report6(t,lm))/sum(lm,report6(t,lm)/(1-UR.l(lm)));
pwage(lm,t)=pl.l(lm);
pcom(i,t)=py.l(i);
*------------------
*update endowments
*------------------

jk(t)$(invest_k(t)/kstock(t) ge zetak)  = kstock(t)/betak*
                                           (betak*zetak-1+sqrt(1+2*betak*(invest_k(t)/kstock(t)-zetak)));
jk(t)$(invest_k(t)/kstock(t) le zetak)  = invest_k(t);


kstock(t+1)$(ord(t) lt card(t))         =5*jk(t)+(1-deltak)**5*kstock(t);
kstock(t+1)$(ord(t)=1)                  =5*jk(t)+(1-deltak)**5*kstock(t);


*display jk,jh,kstock,hstock;

*need population analysis                  2005-2014����˿�������Ϊ0.005019 �Ͷ�������ƽ��Ϊ0.58   �Ͷ������ʺ㶨ʱ���˿����������Ͷ��������������
tqlabor_s0$(ord(t)=1)                    =tqlabor_s0*(1+lgrowth_b(t+1))**5;
tqlabor_s0$(ord(t) ne 1)                 =tqlabor_s0*(1+lgrowth_b(t+1))**5;

*�Ͷ����ṹ����
tlabor_s0(lm)                           =tqlabor_s0*tlprop("2010",lm);
*�Ͷ����ṹ�ı�
*tlabor_s0(lm)                           =tqlabor_s0*tlprop(t+1,lm);

fact("capital")                         =rork0*kstock(t+1);

*ur.lo(lm)=0.85*ur.l(lm);

*trade imbalance and stock change phased out at 1% per year
xscale$(ord(t)=1)                                  =0.99**(5*(ord(t)-1));
xscale$(ord(t) ne 1)                               =0.99**(5*(ord(t)-1));

aeei(i)$(not elec(i))          =  aeei(i)/(1+0.01)**5;
aeei("fd")       =  aeei("fd")/(1+0.01)**5;
aeei("elecutil") =  aeei("elecutil")/(1+0.01)**5;

*aeei(i)$(ord(t)=1)  =  aeei(i)/(1+0.01)**5;
*aeei("fd")$(ord(t)=1)  =  aeei("fd")/(1+0.01)**5;
*aeei("elecutil")$(ord(t)=1)  =  aeei("elecutil")/(1+0.003)**5;

*aeei(i)$(ord(t) ne 1)  =  aeei(i)/(1+0.01)**5;
*aeei("fd")$(ord(t) ne 1)  =  aeei("fd")/(1+0.01)**5;
*aeei("elecutil")$(ord(t) ne 1)  =  aeei("elecutil")/(1+0.003)**5;

gprod_b(t)=gprod.l;

sffelec_b(t,sub_elec)=sffelec.l(sub_elec);

sffelec_bau(t,sub_elec)$(simu_s eq 0)=sffelec.l(sub_elec);

display tqlabor_s0,tlabor_s0,cquota,rgdp.l,gprod.l,ret0,sffelec1,sffelec_BAU;
);

PAT(t,"gprod")=gprod_b(t);
execute_unload "trend.gdx" PAT RET1 RET2 sffelec_b   sffelec_BAU
execute 'gdxxrw.exe trend.gdx par=PAT rng=A1:D18   par=RET1 rng=A26:I35   par=RET2 rng=A37:I46 par=sffelec_b rng=A47:I57 par=sffelec_BAU rng=A58:I68'
