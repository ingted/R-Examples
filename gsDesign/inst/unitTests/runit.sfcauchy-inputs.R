# sfcauchy test functions

"test.sfcauchy.param " <- function()
{
	 checkException(sfcauchy(param ="abc"), msg="Checking for incorrect variable type", silent=TRUE) 
	 checkException(sfcauchy(param =c(1, 0)), msg="Checking for out-of-range variable value", silent=TRUE) 
}

"test.sfcauchy.param" <- function()
{
	 checkException(sfcauchy(param=rep(1,3)), msg="Checking for incorrect variable length", silent=TRUE) 
	 checkException(sfcauchy(param=c(.1, .6, .2, .05), k=5, timing=c(.1, .25, .4, .6)), msg="Checking for out-of-order input sequence", silent=TRUE) 
}

