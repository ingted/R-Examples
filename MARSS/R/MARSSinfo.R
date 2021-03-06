MARSSinfo = function(number){
  if(missing(number)){
cat("You need to pass in a number or text to get info.
     1: An error related to denom not invertible
     2: Non-convergence warnings
     3: Warnings about degenerate variance-covariance matrices or variance going to 0
     4: Error concerning setting of x0 in model with R with 0s on diagonal
     5: Error from is.marssMLE
     6: MARSS complains that you passed in a ts object as data
     7: MARSS warns that log-likelihood dropped
     8: Stopped at iter=xx in MARSSkem() because numerical errors were generated in MARSSkf
     9: iter=xx MARSSkf: logLik computation is becoming unstable.  Condition num. of Sigma[t=1] = Inf and of R = Inf.
    10: Warning: setting diagonal to 0 blocked at iter=X. logLik was lower in attempt to set 0 diagonals on X
    11: MARSS seems to take a long, long, long time to converge
    20: Your model object is not the right class.
    21: MARSS complains about init values for V0
    22: Error: 0s on the diagonal of R; corresponding x0 should be be fixed.
    23: Warning: Setting of 0s on the diagonal of R blocked; corresponding x0 should not be estimated.
")
return()
}
if(number==21)
cat(
strwrap("In a variance-covariance matrix, you cannot have 0s on the diagonal. When you pass
in a qxq variance-covariance matrix (Q,R or V0) with a 0 on the diagonal, MARSS rewrites
this into H%*%V.  V is a pxp variance-covariance matrix made from only the non-zero row/cols
in your variance-covariance matrix and H is a q x p matrix with all zero rows corresponding
to the 0 diagonals in the variance-covariance matrix that you passed in. By setting, the start 
variance to 0, you have forced a 0 on the diagonal of a variance-covariance matrix and that
will break the EM algorithm (the BFGS algorithm will probably work since it uses start in a different way).
This is probably just an accident in how you specified your start values for your variance-covariance matrices.
Check the start values and compare to the model$free values.  If you did not pass in start, then MARSS's function
for generating reasonable start values does not work for your model.  So just pass in your own start values
for the variances. Note, matrices with a second dim equal to 0 are fine in test$start (and test$par).
It just means the parameter is fixed (not estimated).\n"))

if(number==5)
cat(
strwrap("If you got an error from is.marssMLE related to your model, then the first thing to do is look at the list that you
passed into the model argument.  Often that will reveal the problem.  If not, then look at your data and make
sure it is a nxT matrix (and not a Txn) and doesn't have any weird values in it.  If the problem is still not clear 
you need to look at the model that MARSS thinks you are trying to fit.
If you used test=MARSS(foo), then test the MLE object.  If the function exited 
without giving you the MLE object, try test=MARSS(...,fit=FALSE) to get it.  Type summary(test$model) to see
a print out of the model.  If your model is time-varying, this will be very verbose so you'll want to divert
the output to a file.  Then try this test$par=test$start, now you have filled in the par element of the MLE object.
Try parmat(test,t=1) to see all the parameters at t=1 using the start as the par values.  This might reveal
the problem too.  Note, matrices with a second dim equal to 0 are fine in test$start (and test$par).
It just means the parameter is fixed (not estimated).
\n"))

if(number==1 | number=="denom not invertible")
cat(
strwrap("This is telling you that you specifified a model that is logically indeterminant.
First check your data and covariates (if you have them).  Make sure you didn't make a mistake when entering
the data.  For example, a row of data that is all NAs or two rows of c or d that are the same.  Then look at your model by
passing in fit=FALSE to the MARSS() call.  Are you trying to estimate B but you set Q to zero?  That won't work.  
Note if you are estimating D, your error will say problems in A update.  If you are estimating C, your error will say problems in U update.  
This is because in the MARSS algorithms, the models with D and C are rewritten into a simpler MARSS model with time-varying A and U. 
If you have set R=0, you might get this error if you are trying to estimate A.  Did you set a VO (say, diagonal),
that is inconsisent with V0T (the covariance matrix implied by the model)?  That can cause problems with the Q update.  Are you estimating 
C or D, but have rows of c or d that are all zero?  That won't work.  Are you estimating C or D with only one column of c or d? Depending
on your constraints in C or D that might not work.
\n"))

if(number==2 | number=="convergence")
cat(
  writeLines(
strwrap("MARSS tests both the convergence of the log-likelihood and of the individual parameters.  If you just want the log-likelihood, say for model
selection, and don't care too much about the parameter values, then you will be concerned mainly that the log-likelihood has converged.  Set abstol to something fairly small
like 0.0001  (in your MARSS call pass in control=list(abstol=0.0001) ).  Then see if a warning about logLik being converged shows up.  If it doesn't, then you are
probably fine.  The parameters are not at the MLE, but the log-likelihood has converged.  This indicates ridges or flat spots in the likelihood.
\n\n
If you are concerned
about getting the MLEs for the parameters and they are showing up as not converged, then you'll need to run the algorithm longer (in your MARSS call pass in control=list(maxit=10000) ).
But first think hard about whether you have created a model with ridges and flat spots in the likelihood.  Do you have parameters that can create essentially the
same pattern in the data?  Then you may have created a model where the parameters are confounded.  Are you trying to fit a model that cannot fit the data?  That
often causes problems.  It's easy to create a MARSS model that is logically inconsistent with your data.  Are you trying to estimate both B and U? That is often problematic.  Try demeaning 
your data and setting U to zero.  Are you trying to estimate B and you set tinitx=0? tinit=0 is the default, so it is set to this if you did not pass in tinitx in the model list.
You should set tinitx=1 when you are trying to estimate B.
\n"))
)

if(number==3 | number=="degen")
  cat(
    strwrap("This is not an error but rather an fyi.  Q or R is getting very small.  Because control$allow.degen=TRUE, the code is 
trying to set Q or R to 0, but in fact, the MLE Q or R is not 0 so setting to 0 is being blocked (correctly).  The code is warning you
about this because when Q or R gets really small, you can have numerical problems in the algorithm.  Have you standardized the variances 
in your data and covariates (explanatory variables)?  In some types of models, that kind of mismatch can drive Q or R towards 0.  This is
correct behavior, but you may want to standardize your data so that the variability is on similar scales.
\n"))

if(number==4 | number=="x0 update")
  cat(
    strwrap("If R=0 (or some rows of R), then under some model structures, x0 is defined by y (the data) logically.  If y_t=x_t, say, and x0 is defined at t=1, then
then x0=y(1).  If you set x0 to anything else, then your model is impossible and MARSS() will stop with an error.  If you define x0 as being at
t=0, then you can avoid defining an impossible model.  However, the EM update equation runs into numerical problems when R=0 and it will exit 
with an error.  If x0 is defined by your data, then you do not need to estimate it so set x0 equal to that value in your model specification.  If it is not logically 
defined by the data (without using any of the estimated parameters), then try method=\"BFGS\".  If your x0 are independent, you can try a diffuse
prior on x0, e.g. V0 diagonal equal to say 5, but that is unwise if your model implies that the x0 are not independent of each other.
\n"))

if(number==6 | number=="ts")
  cat(
    strwrap("Time-series objects have the frequency information embedded (quarter, month, season, etc).  There are many ways to model quarter, month, season, etc effects and MARSS()
will not guess how you want to model these---there are many, many different places in the 
model that seasonal effects might enter.  You need to pass in the data as a matrix with time going across
the columns (e.g. by using t(as.data.frame.ts(y)) ).  If you want to model quarter, month, etc effects,
you need to use these as covariates in your model.  You can get the frequency information as a matrix as with the
command t(as.data.frame.ts(stats:::cycle.ts(y))). Once you have the frequency information (now coded
numeric by the previous command), you can use that in your model to include seasonal effect.  The 
are many different ways in which seasonal effects can modeled (in the x, in the y, in different parameters, etc., etc.).
You need to decide how to model them and how to write the model matrices to achieve that.\n"))

if(number==7 | number=="LL dropped")
  writeLines(
    strwrap("The EM algorithm is generally quite robust but it requires inverting the variance-covariance matrices and when those inverses
inverses become numerically unstable, the log-likelihood can drop.  The first thing to try however is to set 
safe=TRUE in the control list.  This tells MARSS to run the Kalman smoother after each parameter update.  This
slows things down, but is a more robust algorithm.  The default is to only run the smoother after all parameters
are updated.  If that fails, set maxit (in control) to something smaller than when the LL dropping warning starts
and see what is happening to Q and R.  Which one is becoming hard to invert?  Think long and hard about why this
is happening.  Very likely, something about the way you set up the problem is logically forcing this to happen.
\n\n
It may be that you are trying to fit a model that is mathematically inconsistent with your data. Are you fitting
a mean-reverting model but the mean implied by the model is different than the mean of the data? That won't work.
Are you trying to fit a MARSS model, which w(t) and v(t) errors are a random-walk in time and drawn from a multivariate normal, to binned data
where you have multiple time steps at one bin level? Like this, 1,1,1,1,2,2,2,10,10,10,1,1,1,.  That's not remotely
a random-walk through time.  The binning is not so much the problem.  It's the strings of 1's and 2's in a row
that are the problem.  For that kind of binned data, you need some kind of thresholding observation model.
\n\n
If your are fitting models with R=0 or some of the diagonals of R=0, then EM can really struggle.  Try BFGS.  If you are fitting
AR-p models with R!=0 and rewritten as a MARSS model, then try using a vague prior on x0.  Set x0=matrix(0,1,m)
(or some other appropriate fixed value instead of 0.) and V0=diag(1,m),
where m=number of x's.  That can make it easier to estimate these AR-p with error models.
\n\n
Lastly, try using fun.kf='MARSSkfss' in the MARSS() call.  The tells MARSS() to use the classic Kalman filter/smoother function
rather than Koopman and Durbin's filter/smoother as implemented in the KFAS package.  Normally, 
            the Koopman and Durbin's filter/smoother is more robust but maybe there is something
            about your problem that makes the traditional filter/smoother more robust. Note, they
            normally give identical answers so it would be quite odd to have them different."))

  if(number==8)
    cat(strwrap("This means the Kalman filter/smoother algorithm became unstable and most 
              likely one of the variances became ill-conditioned.  When that happens the 
              inverses of those matrices are poor, and you will start to get negative 
              values on the diagonals of your variance-covariance matrices.  Once that 
              happens, the inverse of that var-covariance matrix produces an error.  
              If you get this error, turn on tracing with control$trace=1. This will store 
              the error messages so you can see what is going on.  It may be that you have 
              specified the model in such a way that some of the variances are being forced 
              very close to 0, which makes the var-covariance matrix ill-conditioned.  
              The output from the MARSS call will be the parameter values just before 
              the error occurred.\n"))

  if(number==9)
    cat(strwrap("This means, generally, that V0 is very small, say 0, and R is very small 
              and very close to zero.\n"))

  if(number==10)
    writeLines(
      strwrap("Note, this warning is often associated with warnings about the log-likelihood
dropping.  The log-likelihood is entering an unstable area, likely a region where it is going
steeply to infinity (correctly, probably).
\n\n
The EM algorithm is generally quite robust but it requires inverting the variance-covariance matrices and when those inverses
inverses become numerically unstable, the log-likelihood can drop.  The first thing to try however is to set 
safe=TRUE in the control list.  This tells MARSS to run the Kalman smoother after each parameter update.  This
slows things down, but is a more robust algorithm.  The default is to only run the smoother after all parameters
are updated.  If that fails, set maxit (in control) to something smaller than when the LL dropping warning starts
and see what is happening to Q and R.  Which one is becoming hard to invert?  Think long and hard about why this
is happening.  Very likely, something about the way you set up the problem is logically forcing this to happen.
\n\n
It may be that you are trying to fit a model that is mathematically inconsistent with your data. Are you fitting
a mean-reverting model but the mean implied by the model is different than the mean of the data? That won't work.
Are you trying to fit a MARSS model, which w(t) and v(t) errors are a random-walk in time and drawn from a multivariate normal, to binned data
where you have multiple time steps at one bin level? Like this, 1,1,1,1,2,2,2,10,10,10,1,1,1,.  That's not remotely
a random-walk through time.  The binning is not so much the problem.  It's the strings of 1's and 2's in a row
that are the problem.  For that kind of binned data, you need some kind of thresholding observation model.
\n\n
If your are fitting models with R=0 or some of the diagonals of R=0, then EM can really struggle.  Try BFGS.  If you are fitting
AR-p models with R!=0 and rewritten as a MARSS model, then try using a vague prior on x0.  Set x0=matrix(0,1,m)
(or some other appropriate fixed value instead of 0.) and V0=diag(1,m),
where m=number of x's.  That can make it easier to estimate these AR-p with error models.\n"))

  if(number==11)
    writeLines(
      strwrap("First thing to do is set silent=2, so you see where MARSS() is taking a long time.  This will
give you an idea of how long each EM iteration is taking so you can estimate how long it will take to get to a
certain number of iterations.  When we get a comment about why the algorithm takes 10,000 iterations to converge, the user is either doing Dynamic
Factor Analysis or they are estimating many variances and they set allow.degen=FALSE.  We'll talk about those two cases.
\n\n
Dynamic Factor Analysis (DFA): Why does this take so long?  By its nature DFA is often a difficult estimation problem
because there are two almost equivalent solutions.  The model has a component that looks like this y=z*trend.
This is equivalent to y=(z/a)*(a*trend).  That is there exist an an infinite number of trends (a*trend) that will
give you the same answer.  However, the likelihood of the (a*trend)'s are not the same since we have a model for
the trends---a random walk with variance = 1.  That's pretty flat though for a range of a.  When we have a fairly
flat 2D likelihood surface---in this case (z/a)*(a*trend)---EM algorithms take a long time to converge.
\n\n
Variances going to zero: If you set allow.degen=FALSE, and one of your variances is going to zero then it
its log is going to negative infinitity and it will take infinite number of iterations to get there (but
MARSS() will complain about numerical instability before that).  The log-log convergence test in MARSS is
checking for convergence of the log of all the parameters, and clearly the variance going to 0 will not
pass this test.  However, you log-likelihood has long converged. So, you want to 'turn off' the convergence
test for the parameters and use only the abstol test---which tests if the log-likelihood increased by less than 
than some tolerance between iterations.  To do this, pass in a huge value for
the slope of the log-log convergence test.  Pass this into your MARSS call: control=list(conv.test.slope.tol=1000)\n"))

  if(number==20)
    writeLines(
      'Version 3.7 uses model objectd with attributes while versions 3.4 and earlier did not.  In order, to view 3.4
model fits with MARSS version 3.5+, you need to add on the attributes.  Here is some code to do that.
              
# x is a pre 3.5 marssMLE object from a MARSS call.  x=MARSS(....)
x$marss=x$model
class(x$marss)="marssMODEL"
attr(x$marss,"form")="marss"
attr(x$marss,"par.names")=names(x$marss$fixed)
tmp=x$marss$model.dims
for(i in names(tmp)) if(length(tmp[[i]])==2) tmp[[i]]=cbind(tmp[[i]],1)
tmp$x=c(sqrt(dim(kemz$model$fixed$Q)[1]), dim(kemz$model$data)[2])
tmp$y=c(sqrt(dim(kemz$model$fixed$R)[1]), dim(kemz$model$data)[2])
attr(x$marss,"model.dims")=tmp
attr(x$marss,"X.names")=x$marss$X.names
              
class(x$model)="marssMODEL"
x$model=x$form.info$marxss
attr(x$model,"form")=x$form.info$form
attr(x$model,"par.names")=names(x$model$fixed)
tmp=x$form.info$model.dims
for(i in names(tmp)) if(length(tmp[[i]])==2) tmp[[i]]=cbind(tmp[[i]],1)
tmp$x=c(sqrt(dim(kemz$model$fixed$Q)[1]), dim(kemz$model$data)[2])
tmp$y=c(sqrt(dim(kemz$model$fixed$R)[1]), dim(kemz$model$data)[2])
attr(x$model,"model.dims")=tmp
attr(x$model,"X.names")=x$marss$X.names
              
#now this should work
coef(x, type="matrix")
')
 
  if(number==22)
    writeLines(
      strwrap("This is a constraint imposed by the EM algorithm.  What's happening is that x0 cannot be solved for because the 
0s on the diagonal of R are causing it to disappear from the likelihood.  Most likely you have set tinitx=1, because the problematic
part of the likelihood is the Y part. You have Y_1 = Z x_1 and depending on Z that might not be solvable for x_1.  If you haven't
set R to 0, then pass in allow.degen=FALSE.  That will stop R being set to 0.  If you did set R to zero, then try 
setting tinitx=0 if that makes sense for your model.  You can also try putting a diffuse prior on x0, IF 
you know the implied covariance structure of x0.  However,
if you know that, then setting tinitx=0 is likely ok."))

  if(number==23)
    writeLines(
      strwrap("This is the same error as number 22 except that the 0s on the diagonal of R are arising because
              allow.degen=TRUE (this is the default setting in the control list) and R is getting very small.
              MARSS attempts to set R to 0, but the constraint that x0 associated with R=0 comes into play.
              MARSS then blocks the setting of R to 0 and warns you.  You can set allow.degen=FALSE, but it
              is just an informational warning.  There is nothing wrong per se."))
}
