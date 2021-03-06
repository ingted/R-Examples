#### doRUnit.R --- Run RUnit tests
####------------------------------------------------------------------------

### borrowed from package fUtilities in RMetrics
### http://r-forge.r-project.org/plugins/scmsvn/viewcvs.php/pkg/fUtilities/tests/doRUnit.R?rev=1958&root=rmetrics&view=markup

### Originally follows Gregor Gojanc's example in CRAN package  'gdata'
### and the corresponding section in the R Wiki:
###  http://wiki.r-project.org/rwiki/doku.php?id=developers:runit

### MM: Vastly changed:  This should also be "runnable" for *installed*
##              package which has no ./tests/
## ----> put the bulk of the code e.g. in  ../inst/unitTests/runTests.R :

if( identical( .Platform$OS.type, "windows" ) && identical( .Platform$r_arch, "x64" ) ){
    print( "unit tests not run on windows 64 (workaround alert)" )
} else {
    if(require("RUnit", quietly = TRUE)) {
      pkg <- "RcppClassic"

      require( pkg, character.only=TRUE)

      path <- system.file("unitTests", package = pkg)

      stopifnot(file.exists(path), file.info(path.expand(path))$isdir)

      # without this, we get unit test failures
      Sys.setenv( R_TESTS = "" )

      Rcpp.unit.test.output.dir <- getwd()

      source(file.path(path, "runTests.R"), echo = TRUE)

    } else {
    	print( "package RUnit not available, cannot run unit tests" )
    }
}
