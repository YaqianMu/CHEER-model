* --
* -- PANDA - PRC Aggregate National Development Assessment Model
* --
* --           All rights reserved
* --
* --           David Roland-Holst, Samuel G. Evans
* --           Cecilia Han Springer, and MU Yaqian
* --
* --           Berkeley Energy and Resources, BEAR LLC
* --           1442A Walnut Street, Suite 108
* --           Berkeley, CA 94705 USA
* --
* --           Email: dwrh@berkeley.edu
* --           Tel: 510-220-4567
* --           Fax: 510-524-4591
* --
* --           October, 2016

* --

* -- postscn.gms
* --
* -- This file produces scnulation results in Excel compatible CSV files
* -- Two files are produced for each interval, a reportfile containing desired scnulation variables,
* --      and a samfile containing complete Social Accounting Matrices
* --


*=====================================generation of accounting scalar====================

*=====================================transfer to csv file================================

* ----- Output the results


put reportfile ;


* ----- Sectoral results

loop(i,
  put rate(z),'2012', 'out', i.tl, sce.tl,'q', (qdout.l(i)),China3E.modelstat / ;
  put rate(z),'2012', 'ECO2', i.tl, sce.tl,'q', (report2(z,i)),China3E.modelstat / ;
  loop(lm,
  put rate(z),'2012', lm.tl, i.tl, sce.tl,'q', (qlin.l(i,lm)),China3E.modelstat / ;
  put rate(z),'2012', lm.tl, "total", sce.tl,'q', (report6(z,lm,"total")),China3E.modelstat / ;
  put rate(z),'2012', lm.tl, i.tl, sce.tl,'wage', (pl.l(i,lm)),China3E.modelstat / ;
      );
) ;

  put rate(z),'2012', 'ECO2', 'fd', sce.tl,'q', (report2(z,"household")),China3E.modelstat / ;

* ----- employment results
loop(lm,
  put rate(z),'2012', lm.tl, '', sce.tl,'ur', (UR.l(lm)),China3E.modelstat / ;
  loop(sub_elec,
  put rate(z),'2012', lm.tl, sub_elec.tl, sce.tl,'q', (qlin_ele.l(sub_elec,lm)),China3E.modelstat / ;
      );
);

loop(cm,
  put z.tl,'2012', 'clim_s', cm.tl, sce.tl,'S1', (clim_s(cm)),China3E.modelstat / ;
);
  put z.tl,'2012', 'clim_a', '', sce.tl,'S1', (clim_a),China3E.modelstat / ;

* ----- macro results
  put rate(z),'2012', 'GDP', '', sce.tl,'q', rgdp.l,China3E.modelstat / ;
