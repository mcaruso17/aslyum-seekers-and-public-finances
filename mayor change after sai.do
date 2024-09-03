*keep treated municipalities that have seen a mayor change after the SAI


cd "$folder/data analysis"

use politics_sai, clear

gen days_difference = sai_opening_date - election_date
gen days_difference_cas = cas_opening_date - election_date
bysort code: egen sai_opening_year1 = min(sai_opening_year)
bysort code: egen cas_opening_year1 = min(cas_opening_year)
drop sai_opening_year
drop cas_opening_year
ren sai_opening_year1 sai_opening_year
ren cas_opening_year1 cas_opening_year
gen years_difference = sai_opening_year - election_year
gen years_difference_cas = cas_opening_year - election_year
gen sai_before_election = 1 if days_difference < 0
gen cas_before_election = 1 if days_difference_cas < 0
replace sai_before_election = 0 if days_difference > 0
replace cas_before_election = 0 if days_difference_cas > 0
replace sai_before_election =. if sai == 0
replace cas_before_election =. if cas == 0
encode politics, gen(politics1)
drop politics
ren politics1 politics



bysort code: egen earliest_sai_difference = min(days_difference)
bysort code: egen earliest_sai_difference_y = min(years_difference)
bysort code: gen sai_before_treated = 1 if earliest_sai_difference < 0 & years_difference < 3

bysort code: egen earliest_cas_difference = min(days_difference_cas)
bysort code: egen earliest_cas_difference_y = min(years_difference_cas)
bysort code: gen cas_before_treated = 1 if earliest_cas_difference < 0 & years_difference_cas < 3

bysort code: gen pre_mayor_change = 1 if mayor_change2[_n+1] == 1
replace pre_mayor_change = 0 if pre_mayor_change ==.
bysort code election_date: egen pre_mayor_change_treat = max(pre_mayor_change)
bysort code: gen pre_election_sai = 1 if days_difference > -365 & days_difference < 0
bysort code: gen pre_election_cas = 1 if days_difference_cas > -365 & days_difference_cas < 0
replace pre_election_sai = 0 if pre_election_sai==.
replace pre_election_cas = 0 if pre_election_cas==.
bysort code election_date: egen mayor_change_treated = max(mayor_change2)
bysort code: gen sai_mayor_treated = 1 if treated == 1 & mayor_change_treated == 1 & sai_before_treated == 1
bysort code: gen cas_mayor_treated = 1 if treated_cas == 1 & mayor_change_treated == 1 & cas_before_treated == 1

replace sai_mayor_treated = 0 if sai_mayor_treated ==.
replace sai_before_treated = 0 if sai_before_treated ==.
replace cas_mayor_treated = 0 if cas_mayor_treated ==.
replace cas_before_treated = 0 if cas_before_treated ==.

order code year name earliest_sai_difference earliest_cas_difference sai_before_treated cas_before_treated election_date sai_mayor_treated cas_mayor_treated days_difference days_difference_cas sai_opening_date cas_opening_date re_elected mayor_change mayor_change2 rep_name

sort code year



save politics_sai, replace

