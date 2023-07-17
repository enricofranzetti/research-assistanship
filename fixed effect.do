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
gen week_2=.
replace week_2=1 if n_c>0
gen week_3=week if week_2==1
by comune, sort: egen first=min(week_3)
label variable first "Week in which the first case was reported in municipality i"
gen time_to_treat=.
replace time_to_treat=week - first if year==2020

foreach x in 0 1 2 3 4 5 6 7 8 9 10 11 12 13 14 15 16 17  18 19 20 21 22 23 24 25 26 27 28 29 30 31 32 33 34 35 36 37 38 39 40 41 42 43 44{
	
		gen week_to_treat_`x' = (time_to_treat==`x')

	 
	}

xtset comune date_weekly, weekly
gen var=0

reghdfe visite var year_2020_level_1 year_2020_level_2 year_2020_level_3 year_2020_level_4, absorb(comune#year) vce(cluster comune#year)

coefplot, keep (var year_2020_level_1 year_2020_level_2 year_2020_level_3 year_2020_level_4)

reghdfe visite var year_2020_level_1 year_2020_level_2 year_2020_level_3 year_2020_level_4 week_to_treat_0 week_to_treat_1 week_to_treat_2 week_to_treat_3 week_to_treat_4 week_to_treat_5 week_to_treat_6 week_to_treat_7 week_to_treat_8 week_to_treat_9 week_to_treat_10 week_to_treat_11 week_to_treat_12 week_to_treat_13 week_to_treat_14 week_to_treat_15 week_to_treat_16 week_to_treat_17 week_to_treat_18 week_to_treat_19 week_to_treat_20 week_to_treat_21 week_to_treat_22 week_to_treat_23 week_to_treat_24 week_to_treat_25 week_to_treat_26 week_to_treat_27 week_to_treat_28 week_to_treat_29 week_to_treat_30 week_to_treat_31 week_to_treat_32 week_to_treat_33 week_to_treat_34 week_to_treat_35 week_to_treat_36 week_to_treat_37 week_to_treat_38 week_to_treat_39 week_to_treat_40 week_to_treat_41 week_to_treat_42 week_to_treat_43 week_to_treat_44, absorb(comune#year) vce(cluster comune#year)

* Results support theory: once controlling for the evolution of the pandemic, the coefficients associated wuth responses are smaller in magnitude. Check substituting leves with weeks.





reghdfe num_prestazioni var year_2020_level_1 year_2020_level_2 year_2020_level_3 year_2020_level_4 casi_1000, absorb(week comune#year) vce(cluster comune#year)


egen casi=sum(n_c), by(week year)
egen decessi=sum(n_d_c), by(week year)
egen ricoveri=sum(n_ri), by(week year)
gen var=0
gen casi_1000=casi/1000



	