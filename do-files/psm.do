* Load the dataset

use data0223, clear

* Check for missing data in matching variables
misstable summarize region surf dens mc altitude altitude_min latitude longitude dens zone urban climate

* Estimate the propensity score
logit treated region surf dens mc altitude altitude_min latitude longitude dens zone urban climate

predict pscore, pr

* Perform matching

psmatch2 treated, pscore(pscore) out(ln_q4tot) neighbor(1) caliper(0.01) common


* Evaluate matching quality
pstest region surf dens mc altitude altitude_min latitude longitude dens zone urban climate, graph

/*
* Estimate treatment effects
*teffects psmatch (ln_q4_10) (treated region surf dens mc altitude altitude_min latitude longitude dens politics zone urban climate), nn(1) atet osample(violating)

drop if violating == 1 

drop violating 

*teffects psmatch (ln_q4_10) (treated region surf dens mc altitude altitude_min latitude longitude dens politics zone urban climate), nn(1) atet osample(violating)

gen ipw = 1/pscore if treated == 1
replace ipw = 1/(1-pscore) if treated == 0
*/

drop if missing(_weight) 

save data_psm, replace

