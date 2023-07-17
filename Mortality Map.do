*STEP 1: creating datasets for the coordinates and ID of each municipality.
cd "C:\Users\enric\Desktop\RA"
set mem 500m
ssc install spmap
ssc install shp2dta
ssc install mif2dta

*We are now ready to get the two datasets that we will use in this analysis.
*We found data on the code and coordinates of the italian municipalities on ISTAT website.
shp2dta using Com2016_ED50_g, database(itdb) coordinates(itcoord) genid(id)
use itdb, clear
des

*STEP 2: mapping Covid-19 mortality.
*The new version of dataset itdb can now be used together with data on the Covid pandemic.
*Before merging the datasets, however, we need to perform some oreliminary operation on the Covid dataset.
cd "C:\Users\enric\Desktop\RA"
set mem 500m
use "dati_COVID.dta", clear

*Start by creating the variable comune, which will be used to merge the datasets.
gen com=substr(comunecap, 1, 6)
gen comune=real(com)
gen mese=month(data)
gen anno=year(data)
drop if anno != 2020
drop if mese<2 | mese>5

*We now generate a new variable representing Covid-19 mortality for the period Feb-May 2020.
*We defined it as the ratio between the number of deaths of patients with Covid over the total number of deaths
collapse (sum) n_d n_d_c, by(comune anno)
gen mortality=(n_d_c/n_d)

*We are finally ready to merge.
merge 1:1 comune using "C:\Users\enric\Desktop\RA\itdb.dta"
keep if _merge==3
ssc install schemepack
ssc install palettes
ssc install colrspace
set scheme white_tableau, perm
graph set window fontface "Arial Narrow"
colorpalette viridis, n(10) nograph reverse 
local colors `r(p)'
spmap mortality using itcoord, id(_ID) cln(10) fcolor("`colors'")ndfcolor(gs14) ndocolor(gs6 ..)  ndlabel("No data") ocolor(gs2 ..) osize(0.03 ..) legtitle("Media giornaliera mortalità Covid-19, Febbraio-Maggio 2020") legend(pos(7) size(1.5) symx(2.5) symy(1.5))
graph save "Graph" "C:\Users\enric\Desktop\RA\mygraph1", replace


*Figure Mortality reports Covid-19 mortality during the first four months of the pandemic in the metropolitan area of Milan and in the province of Lodi.


*STEP 3: mapping variations in healthcare utilization.
use "dati_bda_diabete.dta", clear
gen settimana=week(data)
gen mese=month(data)
gen anno=year(data)
gen com=substr(comunecapres, 1, 5)
gen comune=real(com)
keep if anno==2020
keep if mese==2 | mese==4
collapse (sum) num_prestazioni, by(comune mese anno)
gen visits=log(num_prestazioni)
gen var=.
replace var=visits if mese==2
replace var=-1*visits if mese==4
collapse (sum) var, by (comune)
merge 1:1 comune using "C:\Users\enric\Desktop\RA\itdb.dta"
keep if _merge==3

set scheme white_tableau, perm
graph set window fontface "Arial Narrow"
colorpalette viridis, n(10) nograph reverse 
local colors `r(p)'
spmap var using itcoord, id(_ID) cln(10) fcolor("`colors'") ndfcolor(gs14) ndocolor(gs6 ..) ndlabel("No data") ocolor(gs2 ..) osize(0.03 ..) legtitle("Variazione tra Febbraio e Aprile 2020: totale prestazioni") legend(pos(7) size(1.5) symx(2.5) symy(1.5))
graph save "Graph" "C:\Users\enric\Desktop\RA\mygraph2", replace
graph combine "mygraph1" "mygraph2"




use "dati_bda_diabete.dta", clear
gen settimana=week(data)
gen mese=month(data)
gen anno=year(data)
gen com=substr(comunecapres, 1, 5)
gen comune=real(com)
keep if cod_branca==9
keep if anno==2020
keep if mese==2 | mese==4
collapse (sum) num_prestazioni, by(comune mese anno)
gen visits=log(num_prestazioni)
gen var=.
replace var=visits if mese==2
replace var=-1*visits if mese==4
collapse (sum) var, by (comune)
merge 1:1 comune using "C:\Users\enric\Desktop\RA\itdb.dta"
keep if _merge==3

set scheme white_tableau, perm
graph set window fontface "Arial Narrow"
colorpalette viridis, n(10) nograph reverse 
local colors `r(p)'
spmap var using itcoord, id(_ID) cln(10) fcolor("`colors'") ndfcolor(gs14) ndocolor(gs6 ..) ndlabel("No data") ocolor(gs2 ..) osize(0.03 ..) legtitle("Variazione tra Febbraio e Aprile 2020: diabetologia") legend(pos(7) size(1.5) symx(2.5) symy(1.5))
graph save "Graph" "C:\Users\enric\Desktop\RA\mygraph3", replace
graph combine "mygraph1" "mygraph2" "mygraph3"


use "dati_urologia.dta", clear
gen settimana=week(data)
gen mese=month(data)
gen anno=year(data)
gen com=substr(comunecapres, 1, 5)
gen comune=real(com)
keep if anno==2020
keep if mese==2 | mese==4
collapse (sum) num_prestazioni, by(comune mese anno)
gen visits=log(num_prestazioni)
gen var=.
replace var=visits if mese==2
replace var=-1*visits if mese==4
collapse (sum) var, by (comune)
merge 1:1 comune using "C:\Users\enric\Desktop\RA\itdb.dta"
keep if _merge==3

set scheme white_tableau, perm
graph set window fontface "Arial Narrow"
colorpalette viridis, n(10) nograph reverse 
local colors `r(p)'
spmap var using itcoord, id(_ID) cln(10) fcolor("`colors'") ndfcolor(gs14) ndocolor(gs6 ..) ndlabel("No data") ocolor(gs2 ..) osize(0.03 ..) legtitle("Variazione tra Febbraio e Aprile 2020: urologia") legend(pos(7) size(1.5) symx(2.5) symy(1.5))
graph save "Graph" "C:\Users\enric\Desktop\RA\mygraph4", replace
graph combine "mygraph1" "mygraph2" "mygraph3" "mygraph4"
graph save "Graph" "C:\Users\enric\Desktop\RA\mapping", replace





******************************************************************
*We can improve a bit our map. We want to create a map using z-scores. To do so, we need information about the mean an the standard deviation of variable mortality.

summarize mortality
gen mortality_z=(mortality-.6980429)/.1462762
summarize mortality_
spmap mortality_z using itcoord, id(_ID) fcolor(Blues2) clnumber(6) legtitle("Z-scores") clmethod(custom) clbreaks(-3 -2 -1 0 1 2 3)

*Alternatively, we can use this other specification.
gen mort=mortality - .2222222 
spmap mort using itcoord, id(_ID) fcolor(Blues2) clnumber(5) legtitle("Media giornaliera mortalità Covid-19, Febbraio-Maggio 2020") clmethod(custom) clbreaks(0 .25 .50 .75 .90 1)
********************************************************************



gen first=substr(comunecap, 1, 0)
gen co=.
replace co=substr(comunecapres, 1, 5) if first==1
replace co=substr(comunecapres, 2, 4) if first==0

use stats.dta, clear
merge 1:1 scode using trans