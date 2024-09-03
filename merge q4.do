*merging q4 with politics_sai


global folder "/Volumes/MC/Matteo/Research on asylum seekers centers"

cd "$folder/data analysis"

use politics_sai, clear

merge m:m code year using q4, gen(politics_sai_q4)

keep if politics_sai_q4 == 3
drop politics_sai_q4

order name code year 

save data9823, replace
