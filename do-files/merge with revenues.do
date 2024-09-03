

cd "$folder/data analysis"

use rev0022, clear

keep if year > 2001 & year < 2015
save rev0214, replace

use data0223, clear

merge m:m name year using rev0022, gen(merge_rev)

order name year code merge_rev sai

replace redditoimponibileammontare = 0 if redditoimponibileammontare ==.
replace redditoimponibileammontareineuro = 0 if redditoimponibileammontareineuro ==.
gen net_taxbase = redditoimponibileammontare + redditoimponibileammontareineuro
drop redditoimponibileammontare redditoimponibileammontareineuro

drop if year==.
replace v11 = 0 if v11 ==. & year > 2007
replace v12 = 0 if v12 ==. & year > 2007
gen taxbase_employees = v11 + v12
drop v11 v12


ren redditoimponibilefrequenza taxpayers
ren redditodalavorodipendenteeassimi employees_n


drop numerocontribuenti redditodafabbricatifrequenza redditodafabbricatiammontareineu redditodalavorodipendentefrequen redditodalavorodipendenteammonta redditodapensionefrequenza redditodapensioneammontareineuro redditodalavorodipendenteepensio v16 redditodalavoroautonomosezeiafre redditodalavoroautonomosezeiaamm redditodalavoroautonomosezeibfre redditodalavoroautonomosezeibamm redditodalavoroautonomosezeiifre redditodalavoroautonomosezeiiamm redditodispettanzadellimprendito v24 v25 v26 redditodapartecipazionefrequenza redditodapartecipazioneammontare impostanettafrequenza impostanettaammontareineuro redditoimponibileaddizionalefreq redditoimponibileaddizionaleammo addizionaleregionaledovutafreque addizionaleregionaledovutaammont addizionalecomunaledovutafrequen addizionalecomunaledovutaammonta redditocomplessivominoreougualea v40 redditocomplessivoda0a10000eurof redditocomplessivoda0a10000euroa redditocomplessivoda10000a15000e v44 redditocomplessivoda15000a26000e v46 redditocomplessivoda26000a55000e v48 redditocomplessivoda55000a75000e v50 redditocomplessivoda75000a120000 v52 redditocomplessivooltre120000eur v54 v22 v23 v38 v42 v20 v21 v36 redditodalavoroautonomofrequenza redditodalavoroautonomoammontare v18 v19 redditoimponibileaddizionaleirpe v28 v34 redditodalavoroautonomocomprensi v15 v17 redditodapartecipazionecomprensi v33 v37 v39 v41 v43 v45 v47 redditodafabbricatiammontare redditodapensioneammontare impostanettaammontare v27 redditodalavoroautonomocompresin redditospettanzaimprenditoreordi redditospettanzaimprenditoresemp redditodapartecipazionecompresin v49 redditocomplessivominoredizeroeu bonusspettantefrequenza bonusspettanteammontareineuro v51 trattamentospettantefrequenza trattamentospettanteammontareine


*log of variables 

label var taxpayers "Number of taxpayers"
label var employees_n "Number of taxpayers, employees"
label var net_taxbase "Total taxbase"
label var taxbase_employees "Taxbase, employees"

global revenues_number taxpayers employees_n 
sort name year

foreach var of global revenues_number {
	local label: variable label `var'
    gen ln_`var' = ln(`var')
	label var ln_`var' "`label' (ln)"
	
}

global revenues_taxbase taxbase_employees net_taxbase
sort name year

foreach var of global revenues_taxbase {
	local label: variable label `var'
    bysort year: gen `var'_hicp = `var'/hicp
	label var `var'_hicp "`label' (relative to hicp)"
	gen ln_`var' = ln(`var'_hicp)
	label var ln_`var' "`label' (ln)"
	
}

keep if merge_rev == 3
drop merge_rev
encode region, gen(region1)
drop region
ren region1 region

save data0223, replace



