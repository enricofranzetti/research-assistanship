cd "C:\Users\enric\Desktop\RA"
set mem 500m
use "dati_COVID.dta", clear
gen comunecapres=substr(comunecap, 2, 11)
merge 1:m comunecapres data using"C:\Users\enric\Desktop\RA\dati_bda_diabete.dta"

gen week=week(data)
gen month=month(data)
gen year=year(data)
	 
gen date_weekly = wofd(data)
format date_weekly %tw
gen donne=.
replace donne=1 if sesso==2	
gen young=.
gen middleaged=.
gen over65=.
replace young=1 if cleta==0 | cleta==1 | cleta==2
replace middleaged=1 if cleta==3 | cleta==4
replace over65=1 if cleta==5 | cleta==6
gen time_to_treat=.
replace time_to_treat=week - 8
collapse (sum) num_prestazioni donne over65 bda_08 bda_09 n_c n_d n_d_c n_ri N_t, by(comunecapres date_weekly week year)
gen year_2020 = (year==2020)


foreach x in 1 2 3 4 5 6 7 8 9 10 11 12 13 14 15 16 17  18 19 20 21 22 23 24 25 26 27 28 29 30 31 32 33 34 35 36 37 38 39 40 41 42 43 44 45 46 47 48 49 50 51 52{
		gen week_`x' = (week==`x')

	 
	}

	 

foreach x in 1 2 3 4 5 6 7 8 9 10 11 12 13 14 15 16 17  18 19 20 21 22 23 24 25 26 27 28 29 30 31 32 33 34 35 36 37 38 39 40 41 42 43 44 45 46 47 48 49 50 51 52{
		gen year_2020_week_`x' = year_2020*week_`x'

	 
	}

egen comune=group(comunecapres)
xtset comune date_weekly, weekly
gen var=0



reghdfe  num_prestazioni year_2020_week_1 year_2020_week_2 year_2020_week_3 year_2020_week_4 year_2020_week_5 year_2020_week_6  var year_2020_week_8 year_2020_week_9 year_2020_week_10 year_2020_week_11 year_2020_week_12 year_2020_week_13 year_2020_week_14 year_2020_week_15 year_2020_week_16 year_2020_week_17 year_2020_week_18 year_2020_week_19 year_2020_week_20 year_2020_week_21 year_2020_week_22 year_2020_week_23 year_2020_week_24 year_2020_week_25 year_2020_week_26 year_2020_week_27 year_2020_week_28 year_2020_week_29 year_2020_week_30 year_2020_week_31 year_2020_week_32 year_2020_week_33 year_2020_week_34 year_2020_week_35 year_2020_week_36 year_2020_week_37 year_2020_week_38 year_2020_week_39 year_2020_week_40 year_2020_week_41 year_2020_week_42 year_2020_week_43 year_2020_week_44 year_2020_week_45 year_2020_week_46 year_2020_week_47 year_2020_week_48 year_2020_week_49 year_2020_week_50 year_2020_week_51 year_2020_week_52, absorb(comune week year) vce(cluster comune#year)

	 

coefplot, keep(year_2020_week_1 year_2020_week_2 year_2020_week_3 year_2020_week_4 year_2020_week_5 year_2020_week_6  var year_2020_week_8 year_2020_week_9 year_2020_week_10 year_2020_week_11 year_2020_week_12 year_2020_week_13 year_2020_week_14 year_2020_week_15 year_2020_week_16 year_2020_week_17 year_2020_week_18 year_2020_week_19 year_2020_week_20 year_2020_week_21 year_2020_week_22 year_2020_week_23 year_2020_week_24 year_2020_week_25 year_2020_week_26 year_2020_week_27 year_2020_week_28 year_2020_week_29 year_2020_week_30 year_2020_week_31 year_2020_week_32 year_2020_week_33 year_2020_week_34 year_2020_week_35 year_2020_week_36 year_2020_week_37 year_2020_week_38 year_2020_week_39 year_2020_week_40 year_2020_week_41 year_2020_week_42 year_2020_week_43 year_2020_week_44 year_2020_week_45 year_2020_week_46 year_2020_week_47 year_2020_week_48 year_2020_week_49 year_2020_week_50 year_2020_week_51 year_2020_week_52) graphregion(color(white)) plotregion(color(white)) bgcolor(white) coeflabel(year_2020_week_1 = "1" year_2020_week_2 = "2" year_2020_week_3 = "3" year_2020_week_4 = "4" year_2020_week_5 = "5" year_2020_week_6 = "6" var = "7" year_2020_week_8 = "8"  year_2020_week_9 = "9"              year_2020_week_10 = "10"       year_2020_week_11 = "11"              year_2020_week_12 = "12"       year_2020_week_13 = "13"              year_2020_week_14 = "14"       year_2020_week_15 = "15"              year_2020_week_16 = "16"       year_2020_week_17 = "17"              year_2020_week_18 = "18"       year_2020_week_19 = "19"              year_2020_week_20 = "20"       year_2020_week_21 = "21"              year_2020_week_22 = "22"       year_2020_week_23 = "23"              year_2020_week_24 = "24"       year_2020_week_25 = "25"              year_2020_week_26 = "26"       year_2020_week_27 = "27"              year_2020_week_28 = "28"       year_2020_week_29 = "29"              year_2020_week_30 = "30"       year_2020_week_31 = "31"              year_2020_week_32 = "32"       year_2020_week_33 = "33"              year_2020_week_34 = "34"       year_2020_week_35 = "35"              year_2020_week_36 = "36"       year_2020_week_37 = "37"              year_2020_week_38 = "38"       year_2020_week_39 = "39"              year_2020_week_40 = "40"       year_2020_week_41 = "41"              year_2020_week_42 = "42"       year_2020_week_43 = "43"              year_2020_week_44 = "44"       year_2020_week_45 = "45"              year_2020_week_46 = "46"       year_2020_week_47 = "47"              year_2020_week_48 = "48"       year_2020_week_49 = "49"              year_2020_week_50 = "50"       year_2020_week_51 = "51"              year_2020_week_52 = "52") omit ci(95) xlabel(1(3)52, labsize(small)) title("EVENT STUDY", color(black) size(medium)) subtitle("PRESTAZIONI TOTALI: 2020 w.r.t. 2018-2019", color(black) size(small)) xtitle("SETTIMANA", size(small)) ytitle("N° PRESTAZIONI", size(small)) yline(0)vertical xline(7, lcolor(black))