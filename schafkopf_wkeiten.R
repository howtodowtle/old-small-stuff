##############################
##  Autor: Alexander J Dautel
##  Datum: seit Frühjahr 2012
##  Projekt: Schafkopf-Wahrscheinlichkeiten berechnen
##############################



####  Allgemeine Funktionen


#   Define Fakultäts-Funktion (x!) = fak(x)
fak <- function(x) {
	i <- 1
	y <- 1
	while (i <= x) {
		y <- y * i
		i <- i + 1
		}
	return(y)
}


#  Define Binomialkoeffizient bzw. nCr-Funktion ("n über k") = nCr(n, k)
nCr <- function(n, k) {
	if(k > n) {
		return(0)
		}
	else {
		y <- fak(n) / (fak(k) * fak(n - k))
		return(y)
		}
}


#  Wahrscheinlichkeit, dass ein anderer genau x spezielle Karten hat, von denen es n gibt und ich m habe

genau <- function(x, n, m){
	p <- nCr(3, 1) * (nCr(n - m, x) * nCr(24 - n - (6 - m), 6 - x) / nCr(18, 6))
	return(p)
}

genauLang <- function(x, n, m){
	p <- nCr(3, 1) * (nCr(n - m, x) * nCr(32 - n - (8 - m), 8 - x) / nCr(24, 8))
	return(p)
}


#  Wahrscheinlichkeit, dass ein anderer genau x ODER MEHR Karten hat, von denen es n gibt und ich m habe
#  Interpretation: Wenn das die einzige Krux ist und kein Kontra erwartet wird oder Verlorenregel existiert, spiele solange Wert kleiner als 0.5

odermehr <- function(x, n, m){
	p <- 0
	for (i in x : (n - m)) {
		p <- p + genau(i, n, m)
	}
	return(p)
}

odermehrLang <- function(x, n, m){
	p <- 0
	for (i in x : (n - m)) {
		p <- p + genauLang(i, n, m)
	}
	return(p)
}

#  Erwartungswert für das Spiel - mit Kontrafaktor k und Verlorenregel v (jeweils (0, 1)-Dummies)
#  k auch als Kontrawahrscheinlichkeit interpretierbar
#  Falls Erwartungswert > 0, spielen.
#  Annahme: Kann nirgendwo anders kaputt gehen. Da das fast immer der Fall ist, erst bei Erwartungswert >> 0 spielen.

E <- function(x, n, m, k, v) {
	s <- (1 - odermehr(x, n, m))  #  Wahrscheinlichkeit für Sieg
	n <- odermehr(x, n, m)  #  Wahrscheinlichkeit für Niederlage
	e <- s - (1 + k) * (1 + v) * n  #  k und v verdoppeln im Verlustfall
	return(e)
}



####  Spezielle Funktionen (ohne Kontra und Verlorenregel)
####  alle mit odermehr-Funktion


#  für Solo und Ruf: solo(gegner (min), ich) bzw. ruf(x, m)

solo <- function(x, m){
	n <- 12
	p <- odermehr(x, n, m)
	return(p)
}
ruf <- solo


#  für Wenz/Geier: wenz(gegner (min), ich) bzw. geier(x, m)

wenz <- function(x, m){
	n <- 4
	p <- odermehr(x, n, m)
	return(p)
}
geier <- wenz


#  für Farbwenz: farbwenz(gegner (min), ich) 
farbwenz <- function(x, m){
	n <- 9
	p <- odermehr(x, n, m)
	return(p)
}



####  Beispiele


#  Wahrscheinlichkeit, dass ein Gegner genau 2 Unter/Ober hat, wenn ich schon zwei hab:

genau(2, 4, 2)  #  0.2941176


#  Wahrscheinlichkeit, dass ein Gegner genau 4 Trumpf hat, wenn ich 5 Trumpf hab:

genau(4, 12, 5)  #  0.311086


#  Wahrscheinlichkeit, dass ein Gegner 4 oder mehr Trumpf hat, wenn ich 5 Trumpf hab:

(a <- genau(4, 12, 5) + genau(5, 12, 5) + genau(6, 12, 5))  #  0.3495475
(b <- odermehr(4, 12, 5))  #  0.349561
(diff <- a - b)  #  winziger Fehler: -1.346693e-05



####  Erkenntnisse


##  MIT Verlorenregel (und Kontrawahrscheinlichkeit)


#  Selbst wenn's nur an zusammenstehenden Geiern oder Wenzen scheitert: nicht spielen.

E(2, 4, 2, 0.9, 1)  #  -0.4117647


#  Wenn beim Wenz-Tout ich A+2 einer Farbe hat und nur das Zusammenstehen der anderen beiden ein Problem ist, immer spielen: 

E(3, 5, 2, 0, 1)  #  0.7794118


#  Bei Verlorenregel kein Solo-Tout mit 5 Trumpf und 3 Ober (vornedran):

E(4, 12, 5, 1, 1)  #  -0.7478049


#  Das Gleiche mit 6 Trumpf und 3 Ober aber spielen:

E(4, 12, 6, 1, 1)  #  0.1410795


#  Bei 5 Trumpf mit 4 Ober vornedran auf jeden Fall ein Solo-Tout:

E(5, 12, 5, 1, 1)  #  0.807625


#  Mit 4 Obern und zwei Assen vornedran (also dann nur 4 Trumpf) vornedran ließe sich auch gut ein Herz-Solo Tout spielen:

E(5, 12, 4, 1, 1)  #  0.5242931


#  Wahrscheinlichkeit, dass eine Sau läuft (oder bei einem Bertel jeder eine Herz hat)

ersterSpielerEine   <- (nCr(4, 1) * nCr(20, 5) / nCr(24, 6))
zweiterSpielerEine  <- (nCr(3, 1) * nCr(15, 5) / nCr(18, 6))
dritterSpielerEine  <- (nCr(2, 1) * nCr(10, 5) / nCr(12, 6))
vierterSpielerEine  <- (nCr(1, 1) * nCr(5,  5) / nCr(6,  6))
(ersterSpielerEine * zweiterSpielerEine * dritterSpielerEine * vierterSpielerEine)  #  0.121965