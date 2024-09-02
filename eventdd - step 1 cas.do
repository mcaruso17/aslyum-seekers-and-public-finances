
*eventdd step 1 - CAS and non-CAS
global folder "/Volumes/MC/Matteo/Research on asylum seekers centers"


cd "$folder/data analysis"

numlist "5000 10000 100000"

foreach num in `r(numlist)' {
	
	
use data0223_step2, clear

duplicates drop code year, force

drop if population > `num'

merge m:1 code using data_psm_cas, gen(psm)

save datapsm0223cas, replace


use datapsm0223cas, clear

dtable altitude longitude latitude altitude_min if year == 2021, by(_treatedcas, nototal test) factor(climate mc zone urban area mountain,test(lrchi2)) export("$folder/overleaf/65df15b5332fb0292cf1f1cf/images/pop_`num'/descriptive stats cas.txt", as(tex) replace)


bysort code: egen treatment_year_cas = max(cas_opening_year)
bysort code (year): gen t = year - treatment_year_cas

order year code name cas cas_opening_year _treatedcas t

local covs ln_q2t1tot ln_q2t2tot ln_q2t3tot ln_employees_n ln_net_taxbase

foreach cov of local covs {
	
drop if missing(`cov')

}



local outcomes "01 02 03 04 05 06 07 08 09 10 11 12"

foreach x of local outcomes {
	
local titlegraph: variable label ln_q4_`x'

eventdd ln_q4_`x' reform election ln_q2t1tot ln_q2t2tot ln_q2t3tot lagcas* ln_employees_n ln_net_taxbase if psm == 3 & mc == 0, timevar(t) ci(rcap) hdfe absorb(i.code i.year) cluster(code) accum lags(5) leads(5) graph_op(scheme(s1mono) ytitle("`titlegraph'"))

graph export "$folder/images /pop_`num'/caseventdd_ln_q4_`x'_step1.jpg", as(jpg) name("Graph") quality(90) replace 
	
}


eventdd ln_q4tot smallcomuna reform  election ln_q2t1tot ln_q2t2tot ln_q2t3tot lagcas* ln_employees_n ln_net_taxbase if psm == 3, timevar(t) ci(rcap) hdfe absorb(i.code i.year) cluster(code) accum lags(5) leads(5) graph_op(scheme(s1mono) ytitle("Total spending (log)"))

graph export "$folder/images /pop_`num'/caseventdd_ln_q4tot_step1.jpg", as(jpg) name("Graph") quality(90) replace 


}


