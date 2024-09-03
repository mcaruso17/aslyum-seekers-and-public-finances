
*eventdd step 2 - public finances (psm)

global folder "/Volumes/MC/Matteo/Research on asylum seekers centers/data analysis"

cd "$folder"


use data0223_step2, clear

bysort code election_date: egen changeterm = max(mayor_change2)
sort code year
bysort code: gen yearbeforechange = 1 if mayor_change2[_n+1] == 1
bysort code election_date: egen termbeforechange = max(yearbeforechange)
sort code year
egen treated_step2 = rowtotal(termbeforechange changeterm)
sort code year
order year code name rep_name treated_step2 mayor_change2 changeterm yearbeforechange termbeforechange election_date
keep if treated_step2 !=0

save data_mc_sai, replace

sort code year
bysort code: keep if (days_difference < 0 & mayor_change2 == 1) & (days_difference[_n-1] > 0)


gen psm_treated = 1
save psm_treated3, replace

use data_mc_sai, clear
keep if year == 2017
duplicates drop code, force
merge 1:1 code using psm_treated3, gen(psm)

drop if psm==2
replace psm_treated = 0 if psm_treated ==.
drop year

keep code name region_code surf mc altitude altitude_min latitude longitude zone urban climate psm_treated prov_code population politics foreign_pop q2t1tot q2t2tot q2t3tot
save psm_treated_control3, replace

use data_mc_sai, clear
keep if year == 2002
duplicates drop code, force
merge 1:1 code using psm_treated_control3, gen(psm)

save psm_treated_control3_2002, replace


probit psm_treated surf mc altitude altitude_min latitude longitude zone urban climate, robust


global cov_ps region_code prov_code surf mc altitude altitude_min latitude longitude zone urban climate



est stor probit1
prop_sel psm_treated $cov_ps, propensity(propsel) weightvar(weight)  graph

psmatch2 psm_treated, out(ln_q4tot) p(propsel) common noreplacement

drop if missing(_weight)

keep code _treated propsel weight

save data_psm3, replace

*merge everytime for different treatments - 4 elections without covs
use data_mc_sai, clear

order year code name rep_name 

merge m:1 code using data_psm3, gen(psm)

save datapsm3, replace













