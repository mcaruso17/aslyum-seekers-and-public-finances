*shape file


global folder "/Volumes/MC/Matteo/Research on asylum seekers centers/data analysis"

cd "$folder"


shell del italy_db.dta
shell del italy_coord.dta

shp2dta using "$folder/data analysis/Com01012024/Com01012024_WGS84.shp", database("italy_db") coordinates("italy_coord") genid(id)

use italy_db.dta, clear

ren NAME_3 name

replace name = lower(name)
replace name = subinstr(name, " ", "",.)
replace name = subinstr(name, "-", "",.)
replace name = subinstr(name, "ì","i",.)
replace name = subinstr(name, "à", "a",.)
replace name = subinstr(name, "è", "e",.)
replace name = subinstr(name, "ù","u",.)
replace name = subinstr(name, "ò", "o",.)
replace name = subinstr(name, "'", "",.)
replace name = subinstr(name, "é", "e",.)

save italy_db.dta, replace

numlist "2005(1)2014"

foreach year in `r(numlist)' {
    use data_analysis.dta, clear
    keep if year == `year'
     spmap using italy_coord.dta, id(id) fcolor(eggshell) point(x(longitude) y(latitude) size(*0.65 0.5 0.5 0.5 0.5 0.5) select(keep if ds ==1 & election2sprar > 0) ocolor(white) osize(*1) by(mun_or) fcolor(gold*1 red*0.8 navy*0.8 black*0.4 red*1.5 navy*1.5) legenda(on) legcount) legend(size(*1) rowgap(1.2)) legtitle("SPRAR") title("Municipalities with SPRAR, by municipality's political orientation", size(*0.6) margin(small)) subtitle("Italy, `year'", size(*0.6)) note("Source: Rapporto Atlante `year'", size(*0.5) margin(small))
graph export "political_map_`year'.png", replace
	}
	
