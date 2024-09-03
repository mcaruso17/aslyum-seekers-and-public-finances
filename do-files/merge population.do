*merge population


cd "$folder/data analysis"

use data9823, clear

merge m:m code year using foreign, gen(pop)

keep if pop == 3

drop pop 

tab year 

label var foreign_pop "Foreign local population"
label var african_pop "African foreign local population"
label var population "Municipality's population"

save data0223, replace
