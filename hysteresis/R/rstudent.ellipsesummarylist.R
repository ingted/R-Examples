rstudent.ellipsesummarylist <- function(model,...){
  g <- model
  thenames <- g$Boot.Estimates[,1:(which(colnames(g$Boot.Estimates)=="b.x")-1)]
  thelengths <- lapply(g$models, function(x) length(x$pred.x))
  rowvec <- mapply(function(x,y) rep(x,each=y),1:length(thelengths),y=thelengths)
  thenames <- thenames[rowvec,]
  
  thefittedx<-lapply(g$models,function (x) rstudent.ellipsesummary(x)[,"input"])
  thefittedx <- unlist(thefittedx)
  thefittedy<-lapply(g$models,function (x) rstudent.ellipsesummary(x)[,"output"])
  thefittedy <- unlist(thefittedy)

  data.frame(thenames,"input"=thefittedx,"output"=thefittedy) 
}
