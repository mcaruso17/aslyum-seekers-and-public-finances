

cd "$folder/data analysis"

use rep, clear

merge m:m code year using sai, gen(politics_sai)


drop if politics_sai == 2
drop politics_sai

merge m:m code year using cas, gen(politics_cas)
drop if politics_cas == 2
drop politics_cas

bysort code: egen treated = max(sai)
bysort code: egen treated_cas = max(cas)


replace treated = 0 if treated ==.
replace treated_cas = 0 if treated ==.
sort code sai_opening_date

bysort code: replace sai_opening_date = sai_opening_date[_n-1] if sai_opening_date[_n-1] !=.
bysort code: replace cas_opening_date = cas_opening_date[_n-1] if cas_opening_date[_n-1] !=.

replace sai = 0 if sai ==.
replace cas = 0 if cas ==.

save politics_sai, replace
