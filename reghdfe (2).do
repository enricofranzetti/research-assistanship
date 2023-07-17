cd "C:\Users\enric\Desktop\RA"
set mem 500m
use "dati_COVID.dta", clear
gen comunecapres=substr(comunecap, 2, 11)
merge 1:m comunecapres data using"C:\Users\enric\Desktop\RA\dati_bda_diabete.dta"

gen week=week(data)
gen month=month(data)
gen year=year(data)
drop if year>2020
keep if cod_branca==9

gen date_weekly = wofd(data)
format date_weekly %tw
collapse (sum) num_prestazioni n_c n_d n_d_c n_ri N_t, by(comunecapres date_weekly week year)

gen year_2020 = (year==2020)
gen level_1 = (week<10  & week>7)
gen level_2 = (week<19  & week>9)
gen level_3 = (week<41 & week>18)
gen level_4 = (week<53  & week>40)
gen year_2020_level_1 = year_2020*level_1
gen year_2020_level_2 = year_2020*level_2
gen year_2020_level_3 = year_2020*level_3
gen year_2020_level_4 = year_2020*level_4
gen visite = log(num_prestazioni)

egen comune=group(comunecapres)
egen casi=sum(n_c), by(week year)
egen decessi=sum(n_d_c), by(week year)
egen ricoveri=sum(n_ri), by(week year)
gen var=0
gen casi_1000=casi/1000

reghdfe num_prestazioni var year_2020_level_1 year_2020_level_2 year_2020_level_3 year_2020_level_4, absorb(week comune#year) vce(cluster comune#year)

reghdfe num_prestazioni var year_2020_level_1 year_2020_level_2 year_2020_level_3 year_2020_level_4 casi_1000, absorb(week comune#year) vce(cluster comune#year)
	