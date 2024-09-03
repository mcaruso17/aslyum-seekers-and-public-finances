
use data0223_step2, clear

bysort code: keep if year == cas_opening_year - 1 & population < 100000


gen psm_treated_cas = 1
duplicates drop code, force
save psm_treated_cas, replace

use data0223_step2, clear
keep if year == 2017
duplicates drop code, force
merge 1:1 code using psm_treated_cas, gen(psm)

drop if psm==2
replace psm_treated_cas = 0 if psm_treated_cas ==.
drop year

keep code name area region_code mc altitude altitude_min latitude longitude zone urban climate mountain psm_treated_cas prov_code population politics foreign_pop q2t1tot q2t2tot q2t3tot
save psm_treated_control_cas, replace

use data0223_step2, clear
keep if year == 2021
duplicates drop code, force
merge 1:1 code using psm_treated_control_cas, gen(psm)

save psm_treated_control_2002cas, replace



probit psm_treated_cas region_code prov_code area mountain mc zone urban climate altitude latitude, robust


global cov_ps area mountain mc zone urban climate altitude latitude longitude altitude_min ln_population

est stor probit1
prop_sel psm_treated_cas $cov_ps, propensity(propsel) weightvar(weight)  graph

set seed 17011996

psmatch2 psm_treated_cas, out(ln_q4tot) p(propsel) common noreplacement

drop if missing(_weight)

ren _treated _treatedcas

label var _treatedcas "Treatment assignment - CAS"

keep code _treatedcas propsel weight


save data_psm_cas, replace













