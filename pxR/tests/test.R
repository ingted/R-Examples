library(pxR)

probar.px <- function(fichero){
	a <- read.px(fichero)
	b <- as.data.frame(a)
	b <- as.data.frame(a, direction = "wide")
	b <- as.data.frame(a, use.codes = T)
	b <- as.array(a)
	b <- as.array(a, use.codes = T)
}

a <- probar.px("example2.px")
a <- probar.px("example3.px")
a <- probar.px("example4.px")
a <- probar.px("example5.px")


my.px.object  <- read.px( system.file( "extdata", "example.px", package = "pxR") )
my.data       <- as.array( my.px.object )
my.px.object2 <- as.px( my.data )
my.px.object3 <- as.px( my.data, skeleton.px = my.px.object )
my.px.object4 <- as.px( my.data, list.keys = list(MATRIX = "xxx", CONTENTS = "new data",
                              NEWKEY = "another key", UNITS = "people", TITLE = "My Title") )
 
 
### export data checks
stopifnot( sum( abs(my.data - as.array( my.px.object2)) ) < 1e-6 )
stopifnot( sum( abs(my.data - as.array( my.px.object3)) ) < 1e-6 )
 
### Checks writing for missing data
oo  <- read.px(system.file( "extdata", "example2.px", package = "pxR"))
aa  <- as.array(oo)
aa[sample(1:length(aa), 5)] <- NA
write.px(as.px(aa), filename = 'tmp01.px')


### append and modify keys
write.px( as.px.array(aa,skeleton.px=oo), filename='tmp02.px')
write.px( as.px.array( aa,
              list.keys= list(MATRIX='xxx', CONTENTS='new data',
                              NEWKEY='an other key',
                              UNITS='people', TITLE='My Title') 
                      ), filename='tmp02.px')
 
### collapses a dimension
oo  <- read.px( system.file( "extdata", "example2.px", package = "pxR"))
aa  <- as.array(oo) 
aa  <- apply( aa, 1:2, sum ) 
oo2 <- as.px.array( aa, skeleton.px = oo ) 
write.px (oo2, filename='tmp03.px')
 
### remove temporal files
file.remove('tmp04.px','tmp03.px','tmp02.px','tmp01.px')
 
 
 
opx1 <- read.px(  system.file( "extdata", "example.px", package = "pxR")  )  
write.px ( opx1, filename = 'opx.px')  #  write a copy
opx2 <- read.px  ('opx.px')        #  read  the copy
 
as.array(opx1)-> a1
as.array(opx2)-> a2
sum(a1-a2)
 
opx2 <- read.px ('opx.px')        #  read  the copy

