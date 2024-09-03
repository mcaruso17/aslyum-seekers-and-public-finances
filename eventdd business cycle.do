*eventdd business cycle

*eventdd

*use data_psm, clear
use datapsm0223, clear


bysort code: gen t = year - election_year
replace t = -2 if t == 3
replace t = -1 if t == 4

gen incumbent_win = 1 if (t < 0 & first_term == 1) | (t >= 0 & second_term == 1)
replace incumbent_win = 0 if incumbent_win ==.
bysort code rep_name: egen incumbent_win_treat = total(incumbent_win)
replace incumbent_win = 0 if incumbent_win_treat < 3
replace t =. if incumbent_win == 0
sort code year
replace t = -1 if rep_name == rep_name[_n+1] & t[_n+1] == 0
replace t = -2 if rep_name == rep_name[_n+2] & t[_n+2] == 0
replace t = -3 if rep_name == rep_name[_n+3] & t[_n+3] == 0
replace t = -4 if rep_name == rep_name[_n+4] & t[_n+4] == 0
replace t = 3 if rep_name == rep_name[_n-3] & t[_n-3] == 0
replace t = 4 if rep_name == rep_name[_n-4] & t[_n-4] == 0
bysort code: replace t = . if rep_name != rep_name[_n+1] & t < 0
replace incumbent_win = 1 if t !=.



order year code name rep_name election_date election mayor_change mayor_change2 first_term second_term sai t incumbent*

drop pre_mayor_change pre_mayor_change_treat

local outcomes "01 02 03 04 05 06 07 08 09 10 11 12"

foreach x of local outcomes {
	
local titlegraph: variable label ln_q4_`x'

eventdd ln_q4_`x' ln_q2t1tot ln_q2t2tot ln_q2t3tot population african_pop foreign_pop if population < 10000, timevar(t) method(hdfe, absorb(i.code i.year)) lags(4) leads(4) accum over(treated) jitter(0.2) graph_op(scheme(s1mono) ytitle("`titlegraph' (log)") baseline(-2) legend(pos(6) order(2 "Without SAI" 5 "With SAI" 1 "95% CI") rows(1)) ylabel(, format("%04.2f"))) coef_op(g1(ms(Sh)) g2(ms(Oh)))

graph export "E:\Matteo\Research on asylum seekers centers\images\SAI and non-SAI ln_q4_`x'.jpg", as(jpg) name("Graph") quality(90) replace 
	
}


eventdd ln_q4tot ln_q2t1tot ln_q2t2tot ln_q2t3tot population african_pop foreign_pop if population < 10000, timevar(t) method(hdfe, absorb(i.code i.year)) lags(4) leads(4) accum over(treated) jitter(0.2) graph_op(scheme(s1mono) ytitle("Total spending (log)") legend(pos(6) order(2 "Without SAI" 5 "With SAI" 1 "95% CI") rows(1)) ylabel(, format("%04.2f"))) coef_op(g1(ms(Sh)) g2(ms(Oh)))


local outcomes "01 02 03 04 05 06 07 08 09 10 11 12"

foreach x of local outcomes {
	
local titlegraph: variable label ln_q4_`x'

eventdd ln_q4_`x' ln_q2t1tot ln_q2t2tot ln_q2t3tot population african_pop foreign_pop if population < 10000, timevar(t) method(hdfe, absorb(i.code i.year)) lags(2) leads(2) accum jitter(0.2) graph_op(scheme(s1mono) ytitle("`titlegraph' (log)"))

graph export "E:\Matteo\Research on asylum seekers centers\images\SAI and non-SAI ln_q4_`x'.jpg", as(jpg) name("Graph") quality(90) replace 
	
}

eventdd ln_q4tot ln_q2t1tot ln_q2t2tot ln_q2t3tot population african_pop foreign_pop if population < 10000, timevar(t) method(hdfe, absorb(i.code i.year)) lags(4) leads(4) accum jitter(0.2) graph_op(scheme(s1mono) ytitle("Total spending (log)"))



