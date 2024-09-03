*eventdd

use datapsm0223, clear

bysort code: egen treatment_year = max(sai_opening_year)
bysort code: gen t = year - treatment_year if pre_election_sai == 1
bysort code: gen t2 = year - treatment_year
gen t3 = 1 if t2 !=. & t !=.
bysort code: egen t4 = max(t3)
replace t = t2 if t4 == 1 & t2 <= 0

do "check variables.do"


local outcomes "01 02 03 04 05 06 07 08 09 10 11 12"

foreach x of local outcomes {
	
local titlegraph: variable label ln_q4_`x'

eventdd ln_q4_`x' ln_q2t1tot ln_q2t2tot ln_q2t3tot population african_pop foreign_pop if psm == 3, baseline(-2) timevar(t) ci(rcap) hdfe absorb(i.code i.year) cluster(code) accum lags(5) leads(5) graph_op(scheme(s1mono) ytitle("`titlegraph'"))

graph export "E:\Matteo\Research on asylum seekers centers\images\eventdd_ln_q4_`x'.jpg", as(jpg) name("Graph") quality(90) replace 
	
}


eventdd ln_q4tot ln_q2t1tot ln_q2t2tot ln_q2t3tot population african_pop foreign_pop if psm == 3, timevar(t) ci(rcap) hdfe absorb(i.code i.year) cluster(code) accum lags(5) leads(5) graph_op(scheme(s1mono) ytitle("Total spending (log)"))





