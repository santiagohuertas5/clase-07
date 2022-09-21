## instalar/llamar pacman
require(pacman)

## usar la función p_load de pacman para instalar/llamar las librerías de la clase
p_load(tidyverse, ## manipular/limpiar conjuntos de datos.
       rio, ## para leer/escribir archivos desde diferentes formatos. 
       skimr, ## skim: describir un conjunto de datos
       janitor) ##  tabyl: frecuencias relativas

## Combinar bases de datos 
set.seed(0117)
obs_1 = tibble(id = 100:105 , 
               age = runif(6,18,25) %>% round() , 
               height = rnorm(6,170,10) %>% round())

obs_2 = tibble(id = 106:107 , 
               age = runif(2,40,50)  %>% round() , 
               height = rnorm(2,165,8) %>% round() , 
               name = c("Lee","Bo"))

#Inspeccionar datos 
obs_1 %>% head(n = 5)
obs_2 %>% head(n = 2)

##Para combinar los datos 
data = bind_rows(obs_1,obs_2, .id = "group")
data

##Adicionar variables 
set.seed(0117)
db_1 = tibble(id = 102:105 , income = runif(4,1000,2000) %>% round())
db_2 = tibble(id = 103:106 , age = runif(4,30,40)  %>% round())

db_1 %>% head(n = 5)
db_2 %>% head(n = 4)

##FORMA EN LA QUE NO SE DEBE ADICIONAR VARIABLES 
db = bind_cols(db_1,db_2)
db

##Adicionar variables a un conjunto de datos usando join funciona como merge en stata 
data_1 = tibble(Casa=c(101,201,201,301),
                Visita=c(2,1,2,1),
                Sexo=c("Mujer","Mujer","Hombre","Hombre"))
data_2 = tibble(Casa=c(101,101,201,201),
                Visita=c(1,2,1,2),
                Edad=c(23,35,7,24),
                Ingresos=c(500000,1000000,NA,2000000))

##Left join
df = left_join(x=data_1,y=data_2,by=c("Casa","Visita"))

##Right join 
df = right_join(x=data_1,y=data_2,by=c("Casa","Visita"))

##Inner join
df = inner_join(x=data_1,y=data_2,by=c("Casa","Visita"))

##Full join 
df = full_join(x=data_1,y=data_2,by=c("Casa","Visita"))

##Ejemplo de join sin identificador único (no corrió)
df = full_join(x=data_1,y=data_2,by=c("Hogar")) 


##Pivotear conjuntos de datos

fish_encounters %>% head(3)
us_rent_income %>% head(3)

##Pivot wide 
fish_encounters %>% pivot_wider(names_from = station, values_from = seen ) %>% head(3)

us_rent_income %>% pivot_wider(names_from = variable, values_from = c(estimate, moe)) %>% head(3)                        


fish_wide= us_rent_income %>% pivot_wider(names_from = variable, values_from = c(estimate, moe)) 
fish_wide1=fish_encounters %>% pivot_wider(names_from = station, values_from = seen )
##Pivot long
fish_wide1 %>% pivot_longer(cols = c(2:12), names_to = "seen")

##Gran encuesta integrada de hogares 
cg = import ("input/Enero - Cabecera - Caracteristicas generales (Personas).csv") %>%clean_names()

ocu = import ("input/Enero - Cabecera - Ocupados.csv") %>% clean_names ()

##Descubrir el identificador único 
cg$duplicado = duplicated(cg$directorio)
table(cg$duplicado)

a = distinct_all(cg)
b = distinct_all(select(.data = cg , directorio, secuencia_p, orden))

cg_ocu = left_join(x=cg , y=ocu, by=c("directorio","secuencia_p","orden"))
