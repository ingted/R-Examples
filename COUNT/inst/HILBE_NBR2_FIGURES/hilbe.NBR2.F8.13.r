# hilbe.NBR2.F8.13.r
# Negative binomial regression distributions with 
#    user specified series of alpha values for a specified mean value
# From Hilbe, Negative Binomial regression, 2nd ed, Cambridge Univ. Press
# Figures 8.13   default: alpha at 0.6, .8, 1, 1.2 and mean=10
#
obs <- 11
alpha <- c(.6, .8, 1, 1.2)
y <- 0:30
mu <- 10
amu <- mu*alpha
layout(1) 
for (i in 1:length(amu)) { 
ynb2 = exp(
        y*log(amu[i]/(1+amu[i])) 
     - (1/alpha[i])*log(1+amu[i]) 
     + log( gamma(y +1/alpha[i]) )
     - log( gamma(y+1) ) 
     - log( gamma(1/alpha[i]) ) 
)
if (i==1) { 
plot(y, ynb2, col=i, type='l', lty=i) 
  } else { 
  lines(y, ynb2, col=i, lty=i) 
  } 
}


















