

cd "$folder/data analysis"

import excel "hicp.xlsx" , sheet("hicp") firstrow clear

destring year hicp, replace 

drop if year < 2002 & year > 2023

save hicp.dta, replace

use data0223.dta, clear

drop if year ==. 

merge m:m year using hicp.dta, gen(merge_inflation)

sort name year
keep if merge_inflation == 3
drop merge_inflation

save data0223, replace

