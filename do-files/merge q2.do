*merging q2 with politics_sai


cd "$folder/data analysis"

use data9823, clear

merge m:m codicebelfiore year using q2, gen(merge)

keep if merge == 3
drop merge

order name code year 

save data9823, replace
