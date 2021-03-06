## ----compile-settings, include=FALSE-------------------------------------
library("methods")
library("knitr")
opts_chunk$set(tidy = FALSE, warning = FALSE, message = FALSE, 
               cache = FALSE, comment = NA, verbose = TRUE)
basename <- gsub(".Rmd", "", knitr:::knit_concord$get('infile')) 
library("RNeXML")


## ------------------------------------------------------------------------
 m <- meta("simmap:reconstructions", children = c(
        meta("simmap:reconstruction", children = c(

          meta("simmap:char", "cr1"),
          meta("simmap:stateChange", children = c(
            meta("simmap:order", 1),
            meta("simmap:length", "0.2030"),
            meta("simmap:state", "s2"))),
          
          meta("simmap:char", "cr1"),
          meta("simmap:stateChange", children = c(
            meta("simmap:order", 2),
            meta("simmap:length", "0.0022"),
            meta("simmap:state", "s1")))
          ))))

## ------------------------------------------------------------------------
nex <- add_namespaces(c(simmap = "https://github.com/ropensci/RNeXML/tree/master/inst/simmap.md"))

## ------------------------------------------------------------------------
data(simmap_ex)

## ------------------------------------------------------------------------
phy <- nexml_to_simmap(simmap_ex)

## ----Figure1, fig.cap="Stochastic character mapping on a phylogeny, as generated by the phytools package after parsing the simmap-extended NeXML."----
library("phytools")
plotSimmap(phy)

## ------------------------------------------------------------------------
nex <- simmap_to_nexml(phy) 
nexml_write(nex, "simmap.xml")

## ----cleanup, include=FALSE----------------------------------------------
unlink("simmap.xml")

