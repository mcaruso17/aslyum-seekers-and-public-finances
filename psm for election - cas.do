*eventdd step 2 - mayor's relection (psm)

global folder "/Volumes/MC/Matteo/Research on asylum seekers centers/data analysis"

cd "$folder"


use data0223_step2, clear

bysort code: keep if year == cas_opening_year - 1


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

keep code name region_code surf mc altitude altitude_min latitude longitude zone urban climate psm_treated_cas prov_code population politics foreign_pop q2t1tot q2t2tot q2t3tot
save psm_treated_control_cas, replace

use data0223_step2, clear
keep if year == 2002
duplicates drop code, force
merge 1:1 code using psm_treated_control_cas, gen(psm)

save psm_treated_control_2002cas, replace


capture probit psm_treated_cas surf mc altitude altitude_min latitude longitude zone urban climate, robust



global cov_ps region_code prov_code surf mc altitude altitude_min latitude longitude zone urban climate



est stor probit1
prop_sel psm_treated_cas $cov_ps, propensity(propsel) weightvar(weight)  graph

psmatch2 psm_treated_cas, out(mayor_change2) p(propsel) common noreplacement

drop if missing(_weight)

keep code _treated propsel weight

ren _treated _treatedcas

save data_psmcas, replace

*merge everytime for different treatments - 4 elections without covs
use data0223_step2, clear


keep if election == 1


replace pre_treated_election_cas = 0 if pre_treated_election_cas ==. & cas_opening_date ==.
replace pre_treated_election_cas =. if pre_treated_election_cas==0 & cas_opening_date !=.
replace treated_election_cas= 1 if treated_election_cas ==. & days_difference_cas < 0
replace treated_election_cas = 0 if treated_election ==. & days_difference_cas > 0
replace treated_election730cas = 1 if treated_election730 ==. & days_difference_cas < -730
replace treated_election730cas = 0 if treated_election_cas ==. & days_difference_cas > 0
replace treated_election365cas = 1 if treated_election_cas ==. & days_difference_cas < -365
replace treated_election365cas = 0 if treated_election_cas ==. & days_difference_cas > 0

merge m:1 code using data_psmcas, gen(psm)


save datapsmcas_election, replace













