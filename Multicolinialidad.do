						/*==================================
							SESIÓN 04 : MULTICOLINEALIDAD
						=====================================*/
/*=====================
	Simulación
=======================*/

global path "".
//Preparando Stata
set obs 900

*a) Creación de variables
set seed 1234
gen x1 = rnormal(10,3)
gen x2 = runiform(5,10)
gen x3 = rnormal(2,1)
gen y = 5+1.25*x1+3*x2+4*x3+rnormal(0,3)
global v1 x1 x2 x3

*b) Estadística descriptiva
tabstat $v1, s(mean p50 max min range)
summ $v1

*c) Gráfico de dispersión matricial
graph matrix $v1, half

*d) Gráfico de dispersión con recta de ajuste
twoway (scatter x1 x2)(lfit x1 x2)
twoway (scatter x2 x3)(lfit x2 x3)

*e) Coeficiente de correlación
pwcorr $v1

*f) Regresión
reg y $v1

*g) Prueba de normalidad
predict r, residuals
hist r, normal ylab(,nogrid)
jb r

*h) Prueba de multicolinealidad
	//h.1) Factor de Inflación de Varianza
	vif
	/*VIF = 1 [No hay multicolinealidad]
	  1<VIF<5 [Existe multicolinealidad, pero no es un problema grave en la estimación]
	 VIF>5 [Multicolinealidad que afecta al modelo]*/
	 
	//h.2) Prueba de Farrar-Glouber
	ssc install lmcol //Instalar la prueba
	lmcol y $v1

	
/*=======================
	Base de datos auto
=========================*/
sysuse auto, clear
desc

//Estadísticas descriptivas
*Gráfico de barra
graph bar (count), over(turn)
graph bar (count), over(trunk)

*Histograma
hist price, normal
hist mpg, normal

*Gráfico de dispersión
graph matrix mpg rep78 trunk headroom length turn displacement gear_ratio, half

*Gráfico de cajas y bigotes
graph box mpg, ylab(,nogrid) //Vertical
graph hbox mpg, ylab(,nogrid) //Horizontal

*Correlación
pwcorr mpg rep78 trunk headroom length turn displacement gear_ratio

//Regresión 1
reg price mpg rep78 trunk headroom length turn displacement gear_ratio
vif

//Regresión 2
reg price mpg rep78 trunk headroom turn displacement gear_ratio
vif

//Regresión 3
reg price mpg rep78 trunk headroom turn gear_ratio
vif


/*=================================
	Base de datos bodyfat
===================================*/
use "https://www.stata-press.com/data/r16/bodyfat",clear
desc

//Estadística descriptiva
summ bodyfat midarm thigh triceps

*a) Histograma
	hist bodyfat
	hist thigh
	hist triceps
	
*b) Gráfico de cajas
	graph box bodyfat midarm thigh triceps
	
*c) Gráfico de dispersión matricial
	graph matrix midarm thigh triceps, half
	
*d) Correlación
	pwcorr midarm thigh triceps
	
*e) Regresión
	reg bodyfat midarm thigh triceps
	vif
	
*f) Corrección
	reg bodyfat midarm thigh
	vif


/*=================================
	Base de datos Extreme_Collin
===================================*/
use "https://www.stata-press.com/data/r16/extreme_collin",clear

//Estadística descriptiva
graph matrix one x z, half

//Regresión
reg y one x z
vif
vif, uncentered

//Corrección
reg y x z
vif, uncentered