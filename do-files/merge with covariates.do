


cd "$folder/data analysis"

use occupazione, replace

ren comune name
order code name
replace name = ustrlower(name)
replace name = subinstr(name, " ", "",.)
replace name = subinstr(name, "-", "",.)
replace name = subinstr(name, "'", "",.)
replace name = subinstr(name, "ë", "e",.)
replace name = subinstr(name, "ï", "i",.)
replace name = subinstr(name, "ú", "o",.)
replace name = subinstr(name, "‡", "a",.)
replace name = subinstr(name, "˘", "u",.)


ren Regione region
ren Provincia province
ren Superficie surf
ren Densita dens
ren PopStraniera popimm

replace name = "abetone" if name == "abetonecutigliano"
replace name = "reggiodicalabria" if name == "reggiocalabria"
replace name = "reggionellemilia" if name == "reggioemilia"

drop ISTAT

merge m:m name using data0223, gen(merge_occ)

order code name year merge_occ

sort name year

keep if merge_occ == 3

drop merge_occ

drop cod_censo2011 popimm SuperficieKmq p1971 p1981 p1991 p2001 p2011 p2017 illiterate lit_nf primary upper_sec postg_no_u univ activ employed unemployed inactiv rentist student homemaker other_oc total_res total_employed prim_nnrr indust thr transp finan agricolturasilvicolturaepesc attivitàmanifatturiere attivitàdeiservizidialloggio servizidiinformazioneecomuni attivitàfinanziarieeassicurat attivitàprofessionaliscientif sanitàeassistenzasociale attivitàartistichesportived altreattivitàdiservizi perc_addetti_agri perc_addetti_manif perc_addetti_alloggio perc_addetti_comunicazione perc_addetti_finanziarie perc_addetti_professioni perc_addetti_sanita perc_addetti_artist perc_addetti_servizi_persona perc_disoccupati perc_precettori_pensione DensitaDemografica

ren Tipo province_type
ren GradoUrbaniz urban
ren ZonaClimatica climate
ren IndiceMontanita mountain
ren AltezzaCentro altitude
ren AltezzaMinima altitude_min
ren ZonaAltimetrica zone
ren Latitudine latitude
ren Longitudine longitude

encode zone, gen(zone1)
drop zone
ren zone1 zone

encode urban, gen(urban1)
drop urban
ren urban1 urban

encode mountain, gen(mountain1)
drop mountain
ren mountain1 mountain

encode climate, gen(climate1)
drop climate
ren climate1 climate

save data0223, replace
