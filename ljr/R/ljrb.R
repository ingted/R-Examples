ljrb <- function(K,y,n,tm,X=NULL,ofst=0,R=1000,alpha=0.05)
{
if (sum(duplicated(tm))>0){
 cat("Error: duplicated observation times\n")  
}
else{
 if ((is.null(X)==FALSE)&&(is.matrix(X)==FALSE))
  X=as.matrix(X)
 if (is.unsorted(tm)==TRUE){
  o=order(tm)
  y=y[o]
  n=n[o]
  tm=tm[o]
  if (is.null(X)==FALSE)
   X=as.matrix(X[o,])
  if ((length(ofst)>1)||(ofst[1]!=0))
   ofst=ofst[o]
 }
 N=length(y)
 m=ncol(X)
 if (is.null(m)) 
  m=0
 or.ofst=ofst
 if (length(ofst)==1)
  ofst=as.double(rep(ofst,N))
 else
  ofst=as.double(ofst)
 K=as.integer(K);
 out=.C("backwardk",K,as.double(y),as.double(n),as.double(tm),as.double(X),ofst,N,m,as.integer(R),p=double(K),as.double(alpha),nulls=integer(K+1),alts=integer(K+1),PACKAGE="ljr")
 cat("Backward algorithm for determining the number of joinpoints:\n")
 for (i in 1:K){
  cat("Step ",i,": Test H0:",out$nulls[i]," joinpoint(s) vs H1:",out$alts[i]," joinpoint(s)\n")
  cat("p-value= ",out$p[i],"\n")
 }
 cat("\n Estimated number of joinpoints= ",out$nulls[K+1],"\n\n")
 if (out$nulls[K+1]==0){
  out2 <- .C("ljr0",as.double(y),as.double(n),as.double(tm),as.double(X),ofst,beta=double(m+1),gamma=double(1),N,m,ans=double(1),PACKAGE="ljr")
  cat('Model:\n')
  cat('y~Binom(n,p) where p=invlogit(eta)\n')
  if (m>0){
   if (is.null(dimnames(X)[[2]])==FALSE)
    m.variables=dimnames(X)[[2]]
   else
    m.variables=paste("X",1:ncol(X),sep="")
  }
  else
   m.variables=NULL
  m.variables=c('Intercept',m.variables)
  t.variables='t'
  if ((or.ofst[1]==0)&(length(or.ofst)==1))
   cat('eta=b0')
  else
   cat('eta=ofst+b0')
  if (length(m.variables)>1)
   for (i in 2:length(m.variables))
    cat(paste(paste('+b',i-1,sep=""),'*',m.variables[i],sep=""))
  i=0
  cat(paste(paste('+g',i,sep=""),'*',t.variables[i+1],sep=""))
  cat("\n\n")
  m.coef=c(out2$beta,out2$gamma)
  f1=data.frame(Variables=c(m.variables,t.variables),Coef=m.coef,row.names=c(paste('b',0:(length(m.variables)-1),sep=""),paste('g',0:(length(t.variables)-1),sep="")))
  print(f1)
  ret1=m.coef
  names(ret1)=c(m.variables,t.variables)   
  return(list(Coef=ret1,wlik=out2$ans,pvals=out$p))
 }
 else{
  k=as.integer(out$nulls[K+1])
  out2 <- .C("ljrk",k,as.double(y),as.double(n),as.double(tm),as.double(X),ofst,beta=double(m+1),gamma=double(1+k),tau=double(k),N,m,ans=double(1),PACKAGE="ljr")
  cat('Model:\n')
  cat('y~Binom(n,p) where p=invlogit(eta)\n')
  if (m>0){
   if (is.null(dimnames(X)[[2]])==FALSE)
    m.variables=dimnames(X)[[2]]
   else
    m.variables=paste("X",1:ncol(X),sep="")
  }
  else
   m.variables=NULL
  m.variables=c('Intercept',m.variables)
  t.variables='t'
  for (i in 1:length(out2$tau))
   t.variables=c(t.variables,paste('max(t-tau',i,',0)',sep=""))
  if ((ofst[1]==0)&(length(ofst)==1))
   cat('eta=b0')
  else
   cat('eta=ofst+b0')
  if (length(m.variables)>1)
   for (i in 2:length(m.variables))
    cat(paste(paste('+b',i-1,sep=""),'*',m.variables[i],sep=""))
  for (i in 0:(length(t.variables)-1))
   cat(paste(paste('+g',i,sep=""),'*',t.variables[i+1],sep=""))
  cat("\n\n")
  m.coef=c(out2$beta,out2$gamma)   
  f1=data.frame(Variables=c(m.variables,t.variables),Coef=m.coef,row.names=c(paste('b',0:(length(m.variables)-1),sep=""),paste('g',0:(length(t.variables)-1),sep="")))
  j.labels=NULL
  for (i in 1:length(out2$tau))
   j.labels=c(j.labels,paste('tau',i,'=',sep=""))
  f2=data.frame(j.labels,Joinpoints=out2$tau)
  names(f2)=c(' ','  ')
  print(f1)
  cat('\nJoinpoints:\n')
  print(f2)
  ret1=m.coef
  names(ret1)=c(m.variables,t.variables)   
  ret2=out2$tau   
  names(ret2)=j.labels
  return(list(Coef=ret1,Joinpoints=ret2,wlik=out2$ans,pvals=out$p))
 }
}
}