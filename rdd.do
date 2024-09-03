*rdd

cd "E:\Matteo\Research on asylum seekers centers\data analysis"

use mayorchange, clear
rdplot mayor_change2 days_difference if days_difference < 100 & days_difference > -100
rdrobust  mayor_change2 days_difference if days_difference < 365 & days_difference > -365

use data0214, clear
rdplot ln_q4tot days_difference if days_difference < 365 & days_difference > -365
rdrobust ln_q4tot days_difference if days_difference < 365 & days_difference > -365