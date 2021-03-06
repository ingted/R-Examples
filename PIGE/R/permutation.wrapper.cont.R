#' Internal function used for the parallel computation on the permutation sample
#' @export
#' @keywords internal
permutation.wrapper.cont <- function(x,mat,data,model,Outcome.model){
  Y.castemoin <- all.vars(model,max.names=1)
  Y <- sample(data[,Y.castemoin])
  data.perm <- data.frame(data,Y.perm=Y)
  model.perm <- update(model,Y.perm~.)
  if(Outcome.model=="binary"){
  p.test <- apply(mat,MARGIN=2,FUN=LR.cont,formula=model.perm,data=data.perm)#,class.Z=class.inter)
  }else{
  p.test <- apply(mat,MARGIN=2,FUN=LR.cont.surv,formula=model.perm,data=data.perm)#,class.Z=class.inter)  
  }
  return(p.test)
}
