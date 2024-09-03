*eventdd step 2 - mayor's change (psm)

global folder "/Volumes/MC/Matteo/Research on asylum seekers centers/data analysis"

cd "$folder"


use data0223_step2, clear

bysort code: keep if year == sai_opening_year - 1 


gen psm_treated = 1
save psm_treated, replace

use data0223_step2, clear
keep if year == 2017
duplicates drop code, force
merge 1:1 code using psm_treated, gen(psm)

drop if psm==2
replace psm_treated = 0 if psm_treated ==.
drop year

keep code name region_code surf mc altitude altitude_min latitude longitude zone urban climate psm_treated prov_code population politics foreign_pop q2t1tot q2t2tot q2t3tot
save psm_treated_control, replace

use data0223_step2, clear
keep if year == 2002
duplicates drop code, force
merge 1:1 code using psm_treated_control, gen(psm)

save psm_treated_control_2002, replace


probit psm_treated surf mc altitude altitude_min latitude longitude zone urban climate, robust


global cov_ps region_code prov_code surf mc altitude altitude_min latitude longitude zone urban climate



est stor probit1
prop_sel psm_treated $cov_ps, propensity(propsel) weightvar(weight)  graph

psmatch2 psm_treated, out(mayor_change2) p(propsel) common noreplacement

drop if missing(_weight)

keep code _treated propsel weight

save data_psm, replace

*merge everytime for different treatments - 4 elections without covs
use data0223_step2, clear

order year code name reelected rep_name

keep if election == 1

replace pre_treated_election = 0 if pre_treated_election ==. & sai_opening_date ==.
replace pre_treated_election =. if pre_treated_election==0 & sai_opening_date !=.
replace treated_election = 1 if treated_election ==. & days_difference < 0
replace treated_election = 0 if treated_election ==. & days_difference > 0
replace treated_election730 = 1 if treated_election730 ==. & days_difference < -730
replace treated_election730 = 0 if treated_election ==. & days_difference > 0
replace treated_election365 = 1 if treated_election ==. & days_difference < -365
replace treated_election365 = 0 if treated_election ==. & days_difference > 0

merge m:1 code using data_psm, gen(psm)

save datapsm_election, replace













