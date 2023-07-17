******************TOTALE PRESTAZIONI
cd "C:\Users\enric\Desktop\RA"
set mem 500m
use "dati_COVID.dta", clear
gen comunecapres=substr(comunecap, 2, 11)
merge 1:m comunecapres data using"C:\Users\enric\Desktop\RA\dati_bda_diabete.dta"

gen settimana=week(data)
gen mese=month(data)
gen anno=year(data)
egen visite_branca=sum(num_prestazioni), by(cod_branca anno)
gen visite_Branca=.
replace visite_Branca=visite_branca/52 if anno==2019 | anno==2020
drop if visite_Branca==.
table ( cod_branca ) ( anno ) (), nototals statistic(mean visite_Branca) nformat(%9.1f )


collapse (sum) num_prestazioni, by(cod_branca settimana anno)
xtline num_prestazioni if cod_branca==9, overlay t(settimana) i(anno) plot1(lc(erose))plot2(lc(emidblue)) title(ENDOCRINOLOGIA) ytitle(Numero prestazioni) xtitle(settimana) xlabel(1(5)52) plot1(color(%70)) plot2(color(%70)) plot1(color(*100)) plot2(color(*100)) legend(size(vsmall))
graph save "Graph" "C:\Users\enric\Desktop\RA\xtdiabetes", replace
xtline num_prestazioni if cod_branca==20, overlay t(settimana) i(anno)plot1(lc(erose))plot2(lc(emidblue)) title(OST E GINECOLOGIA) ytitle(Numero prestazioni) xtitle(settimana) xlabel(1(5)52) plot1(color(%70)) plot2(color(%70)) plot1(color(*100)) plot2(color(*100)) legend(size(vsmall))
graph save "Graph" "C:\Users\enric\Desktop\RA\xtrprcare", replace
graph combine "xtdiabetes" "xtrprcare"
xtline num_prestazioni if cod_branca==23, overlay t(settimana) i(anno)plot1(lc(erose))plot2(lc(emidblue)) title(PSICHIATRIA) ytitle(Numero prestazioni) xtitle(settimana) xlabel(1(5)52) plot1(color(%70)) plot2(color(%70)) plot1(color(*100)) plot2(color(*100)) legend(size(vsmall))
graph save "Graph" "C:\Users\enric\Desktop\RA\xtpsychiatric", replace
graph combine "xtdiabetes" "xtrprcare" "xtpsychiatric"

xtline num_prestazioni if cod_branca==18, overlay t(settimana) i(anno)plot1(lc(erose))plot2(lc(emidblue)) title(ONCOLOGIA) ytitle(Numero prestazioni) xtitle(settimana) xlabel(1(5)52) plot1(color(%70)) plot2(color(%70)) plot1(color(*100)) plot2(color(*100)) legend(size(vsmall))
graph save "Graph" "C:\Users\enric\Desktop\RA\xtoncology", replace
graph combine "xtdiabetes" "xtrprcare" "xtpsychiatric" "xtoncology"
xtline num_prestazioni if cod_branca==2, overlay t(settimana) i(anno)plot1(lc(erose))plot2(lc(emidblue)) title(CARDIOLOGIA) ytitle(Numero prestazioni) xtitle(settimana) xlabel(1(5)52) plot1(color(%70)) plot2(color(%70)) plot1(color(*100)) plot2(color(*100)) legend(size(vsmall))
graph save "Graph" "C:\Users\enric\Desktop\RA\xtcardiology", replace
graph combine "xtdiabetes" "xtrprcare" "xtpsychiatric" "xtoncology" "xtcardiology"


*****************DIABETE
cd "C:\Users\enric\Desktop\RA"
set mem 500m
use "dati_COVID.dta", clear
gen comunecapres=substr(comunecap, 2, 11)
merge 1:m comunecapres data using"C:\Users\enric\Desktop\RA\dati_bda_diabete.dta"

gen settimana=week(data)
gen mese=month(data)
gen anno=year(data)
egen totale=sum(num_prestazioni), by(cod_branca mese anno)

xtline totale if cod_branca==9 & anno>2017, overlay t(mese) i(anno) plot1(lc(erose))plot2(lc(purple)) plot3(lc(ebblue)) plot4(lc(edkblue)) title("TREND VISITE DIABETOLOGICHE PER ANNO", size(medium)) ytitle("N° PRESTAZIONI", size(small)) xtitle(month) xlabel(#12)
graph save "Graph" "C:\Users\enric\Desktop\RA\linediabetes", replace


***************UROLOGIA
cd "C:\Users\enric\Desktop\RA"
set mem 500m
use "dati_COVID.dta", clear
gen comunecapres=substr(comunecap, 2, 11)
merge 1:m comunecapres data using"C:\Users\enric\Desktop\RA\dati_urologia.dta"

gen settimana=week(data)
gen mese=month(data)
gen anno=year(data)
egen totale=sum(num_prestazioni), by( mese anno)

xtline totale if anno>2017, overlay t(mese) i(anno) plot1(lc(erose))plot2(lc(purple)) plot3(lc(ebblue)) plot4(lc(edkblue)) title("TREND VISITE UROLOGICHE PER ANNO", size(medium)) ytitle("N° PRESTAZIONI", size(small)) xtitle(month) xlabel(#12) 
graph save "Graph" "C:\Users\enric\Desktop\RA\lineurology", replace
graph combine "linediabetes" "lineurology", rows(2)


keep if anno==2019 | anno==2020
collapse (sum) num_prestazioni, by(settimana anno)
xtline num_prestazioni, overlay t(settimana) i(anno) plot1(lc(erose))plot2(lc(emidblue)) title(UROLOGIA) ytitle(Numero prestazioni) xtitle(settimana) xlabel(1(5)52) plot1(color(%70)) plot2(color(%70)) plot1(color(*100)) plot2(color(*100)) legend(size(vsmall))
graph save "Graph" "C:\Users\enric\Desktop\RA\xturology", replace
graph combine "xtdiabetes" "xtrprcare" "xtpsychiatric" "xtoncology" "xtcardiology" "xturology", rows(3)

*TO DO: tradurre grafici in italiano (maiuscole), aggiungere altre due branche a xtdiabte, xtrprcare etc. e esportare la tabella delle medie su word.