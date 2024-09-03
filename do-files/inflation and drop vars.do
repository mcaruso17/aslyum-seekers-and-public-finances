*adapt to inflation



cd "$folder/data analysis"

use data0223, clear

drop modified_tot totalcheck pct_diff diff_gt_1pct q4_01_7 q4_01_7_1 q4_01_8 q4_02_1 q4_02_2 q4_03_2 q4_03_3 q4_04_5 q4_05_02 q4_06_03 q4_07_01 q4_07_02 q4_08_03 q4_09_05 q4_10_05 q4_11_01 q4_11_02 q4_11_03 q4_11_04 q4_11_05 q4_11_06 q4_11_07 q4_12_01 q4_12_02 q4_12_03 q4_12_04 q4_12_05 q4_12_06 q4_01_1 q4_01_2 q4_01_3 q4_01_4 q4_01_5 q4_01_6 q4_03_1 q4_04_1 q4_04_2 q4_04_3 q4_04_4 q4_05_01 q4_06_01 q4_06_02 q4_08_01 q4_08_02 q4_09_01 q4_09_02 q4_09_03 q4_09_04 q4_10_01 q4_10_02 q4_10_03 q4_10_04 q4_09_06 


local variables q4_01 q4_02 q4_03 q4_04 q4_05 q4_06 q4_07 q4_08 q4_09 q4_10 q4_11 q4_12 q4tot q2t1tot q2t2tot q2t3tot q2tot

foreach var of local variables {
	
bysort code (year): gen `var'_index = round((`var'/hicp), 0.1)

bysort code (year): gen ln_`var' = ln(`var'_index)

local old_label: variable label `var'

local new_label "`old_label' (relative to hicp)"

label variable `var'_index "`new_label'"

local new_label "`old_label' (ln)"

label variable ln_`var' "`new_label'"

}


/*

* Calculate the mean and standard deviation of the variable for each municipality
bysort year: egen mean_`var'_index = mean(`var'_index)
bysort year: egen sd_`var'_index = sd(`var'_index)

* Generate a dummy variable that flags outliers within each municipality
gen is_outlier = abs(`var'_index - mean_`var'_index) > 3 * sd_`var'_index

* Drop the outliers
drop if is_outlier == 1

* Drop the intermediate variables if no longer needed
drop mean_`var'_index sd_`var'_index is_outlier
*/


save data0223, replace
