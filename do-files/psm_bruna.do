
use data0223_step2, clear

bysort code: keep if year == sai_opening_year - 1 & population < 100000


gen psm_treated = 1
save psm_treated, replace

use data0223_step2, clear
keep if year == 2017
duplicates drop code, force
merge 1:1 code using psm_treated, gen(psm)

drop if psm==2
replace psm_treated = 0 if psm_treated ==.
drop year

keep code name area region_code surf mc altitude altitude_min latitude longitude zone urban climate psm_treated prov_code population politics foreign_pop q2t1tot q2t2tot q2t3tot lagsai*
save psm_treated_control, replace

use data0223_step2, clear
keep if year == 2021
duplicates drop code, force
merge 1:1 code using psm_treated_control, gen(psm)

save psm_treated_control_2002, replace


probit psm_treated region_code prov_code area mountain mc zone urban climate altitude latitude, robust


global cov_ps area mountain mc zone urban climate altitude latitude longitude altitude_min ln_population


est stor probit1
prop_sel psm_treated $cov_ps, propensity(propsel) weightvar(weight)  graph

set seed 17011996

psmatch2 psm_treated, out(ln_q4tot) p(propsel) common noreplacement 

drop if missing(_weight)

keep code _treated propsel weight

label var _treated "Treatment assignment - SAI"

save data_psm, replace


















