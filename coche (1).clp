(deftemplate coche
    (slot color) 
    (slot marchas) ; automatico o manual
    (slot plazas)  ; 3 5 7
    (slot maletero)  ; grande pequeno
    (slot modalidad) ; 4x4 urbano deportivo SUV
    (slot precio)  ; barato medio caro
    (slot motor)    ; electrico diesel gasolina hibrido
)

(deftemplate persona
	(slot eco_friendly)
	(slot distancia_cargador)
	(slot color_favorito)
	(slot tam_familia)
	(slot presupuesto)
	(slot entorno) ;rural urbano
	(slot pais) 
	(slot sedentario)   ;mucho medio poco
    (slot coqueto)
)

(deffacts Persona
	(persona (eco_friendly si) (distancia_cargador 7) (color_favorito rojo) (tam_familia 2)(presupuesto 21000)(entorno rural)(pais Holanda)(sedentario medio)(coqueto no))	

)

(deffacts Coche
    (coche)
)

;;--------------------- Reglas de palabras ---------------------
;Por orden de importancia 


(defrule marchas2
(persona (pais ?paiis))
( or (test (eq ?paiis Grecia))
    (test (eq ?paiis Espania))
    (test (eq ?paiis Portugal))
)
?c <- (coche)
=>
(modify ?c(marchas manual))
)

(defrule color
(persona (color_favorito ?col))
?c <- (coche)
=>
(modify ?c (color ?col))
)


(defrule marchas
(persona (pais ?paiis))
(test (neq ?paiis Grecia))
(test (neq ?paiis Espania))
(test (neq ?paiis Portugal))
?c <- (coche)
=>
(modify ?c (marchas automatico))
)

(defrule plazas
(persona (tam_familia ?tf))
(test(> ?tf 5))
?c <- (coche)
=>
(modify ?c (plazas 7))
)

(defrule plazas2
(persona (tam_familia ?tf))
(test(> ?tf 3))
(test(< ?tf 6))
?c <- (coche)
=>
(modify ?c (plazas 5))
)

(defrule plazas3
(persona (tam_familia ?tf))
(test(< ?tf 4))
?c <- (coche)
=>
(modify ?c (plazas 3))
)

(defrule precio
(persona (presupuesto ?pre))
(test(< ?pre 11000))
?c <- (coche)
=>
(modify ?c (precio barato))
)

(defrule precio2
(persona (presupuesto ?pre))
(test(< ?pre 31000))
(test(> ?pre 11000))
?c <- (coche)
=>
(modify ?c (precio medio))
)

(defrule precio3
(persona (presupuesto ?pre))
(test(> ?pre 31000))
?c <- (coche)
=>
(modify ?c (precio alto))
)

;miramos entorno y coqueto
(defrule terreno
(persona (entorno urbano)(coqueto si))
(precio ?prec)
(test(neq precio bajo))
?c <- (coche)
=>
(modify ?c (modalidad deportivo))
)

(defrule terreno
(persona (entorno urbano))
?c <- (coche)
=>
(modify ?c (modalidad urbano))
)

(defrule terreno2
(persona (entorno rural))
(precio bajo)
?c <- (coche)
=>
(modify ?c (modalidad SUV))
)

(defrule terreno3
(persona (entorno rural))
(precio ?prec)
(test(neq precio bajo))
?c <- (coche)
=>
(modify ?c (modalidad 4x4))
)

(defrule maletero
(persona (tam_familia ?tf)(sedentario mucho))
(test(> ?tf 4))
?c <- (coche)
=>
(modify ?c (maletero grande))
)

(defrule maletero2
(persona (tam_familia ?tf)(sedentario mucho))
(test(< ?tf 5))
?c <- (coche)
=>
(modify ?c (maletero pequenio))
)

(defrule maletero3
(persona (tam_familia ?tf)(sedentario mucho))
(test(> ?tf 5))
?c <- (coche)
=>
(modify ?c (maletero grande))
)

(defrule maletero4
(persona (tam_familia ?tf)(sedentario medio))
(test(< ?tf 3))
?c <- (coche)
=>
(modify ?c (maletero pequenio))
)

(defrule maletero5
(persona (tam_familia ?tf)(sedentario medio))
(test(> ?tf 2))
?c <- (coche)
=>
(modify ?c (maletero grande))
)


(defrule maletero6
(persona (sedentario poco))
?c <- (coche)
=>
(modify ?c (maletero grande))
)

;GASOLINA
;Mejor motor para los (coche)s deportivos.
;Motor conveniente en (coche)s de poco uso y pocos kilómetros al año.
;Motor conveniente en (coche)s sencillos y baratos.

;DIESEL
;Mejor motor para viajar a menudo.
;Menos emisiones CO2 que la gasolina.
;Motor más conveniente en (coche)s grandes tipo SUV, 4×4 o pesados.
;Buen motor para el todoterreno.
;Mejor motor para remolcar y circular cargado.

;HIBRIDO
; Cero consumo de combustible para desplazamiento cortos, lo que puede suponer un grandísimo ahorro.
;Acceso a la etiqueta cero emisiones.


;no hay (coche)s eléctricos con 7 plazas por precio bajo
(defrule motor
(persona (eco_friendly si)(distancia_cargador ?dist)(entorno urbano)(sedentario mucho))
(plazas 7)
(precio ?prec)
(test(neq ?prec bajo))
(test(< ?dist 15))
?c <- (coche)
=>
(modify ?c (motor electrico))
)
;Pero si hay (coche)s electricos por precio bajo para 5 plazas o menos
(defrule motor2
(persona (eco_friendly si)(distancia_cargador ?dist)(entorno urbano)(sedentario mucho))
(plazas ?p)
(test(< ?p 7))
(test(< ?dist 15))
?c <- (coche)
=>
(modify ?c (motor electrico))
)

(defrule motor3
(persona (eco_friendly si)(sedentario medio))
(precio ?prec)
(test(neq ?prec bajo))
?c <- (coche)
=>
(modify ?c (motor hibrido))
)

(defrule motor4
(or (persona(sedentario mucho))
    (modalidad deportivo)
    (precio bajo))
?c <- (coche)
=>
(modify ?c (motor gasolina))
)

(defrule motor5
(or (persona(sedentario poco))
    (persona(sedentario medio))
    )
?c <- (coche)
=>
(modify ?c (motor diesel))
)



(set-strategy complexity)