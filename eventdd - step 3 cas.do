
*eventdd step 3 - CAS and non-CAS

global folder "/Volumes/MC/Matteo/Research on asylum seekers centers"


cd "$folder/data analysis"

use datapsm3cas, clear

bysort code: egen treatment_year = max(election_year)
bysort code: gen t = year - treatment_year

drop if population > 100000

local outcomes "01 02 03 04 05 06 07 08 09 10 11 12"

foreach x of local outcomes {
	
local titlegraph: variable label ln_q4_`x'

eventdd ln_q4_`x' ln_q2t1tot ln_q2t2tot ln_q2t3tot population african_pop foreign_pop ln_employees_n ln_net_taxbase if psm == 3, timevar(t) method(hdfe, absorb(i.code i.year)) lags(3) leads(3) accum over(_treated) jitter(0.2) graph_op(scheme(s1mono) ytitle("`titlegraph' (log)") legend(pos(6) order(2 "Without CAS" 5 "With CAS" 1 "95% CI") rows(1)) ylabel(, format("%04.2f"))) coef_op(g1(ms(Sh)) g2(ms(Oh)))

graph export "$folder/images /caseventdd_ln_q4_`x'_step3.jpg", as(jpg) name("Graph") quality(90) replace


	
}

 


eventdd ln_q4tot sai ln_q2t1tot ln_q2t2tot ln_q2t3tot population african_pop foreign_pop ln_employees_n ln_net_taxbase if psm == 3, timevar(t) method(hdfe, absorb(i.code i.year)) lags(3) leads(3) accum over(_treated) jitter(0.2) graph_op(scheme(s1mono) ytitle("Total spending (log)") legend(pos(6) order(2 "Without SAI" 5 "With SAI" 1 "95% CI") rows(1)) ylabel(, format("%04.2f"))) coef_op(g1(ms(Sh)) g2(ms(Oh)))

graph export "$folder/images /caseventdd_ln_q4tot_step3.jpg", as(jpg) name("Graph") quality(90) replace 


