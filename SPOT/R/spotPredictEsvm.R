###################################################################################
#' Meta Model Interface: Support Vector Machine
#' 
#' Meta model based on svm function in the e1071-package, which builds a
#' support vector machine for regression.
#'
#' @param rawB unmerged data
#' @param mergedB merged data
#' @param design new design points which should be predicted
#' @param spotConfig global list of all options, needed to provide data for calling functions
#' @param fit if an existing model fit is supplied, the model will not be build based on 
#'				data, but only evaluated with the model fit (on the design data). To build the model, 
#'				this parameter has to be NULL. If it is not NULL the parameters mergedB and rawB will not be 
#'				used at all in the function.
#'
#' @return returns the list \code{spotConfig} with two new entries:\cr
#' 	spotConfig$seq.modelFit fit of the model used with predict() \cr
#'	spotConfig$seq.largeDesignY the y values of the design, evaluated with the fit
#' @export
###################################################################################
spotPredictEsvm <- function(rawB,mergedB,design,spotConfig,fit=NULL){	
	design <- spotInitializePredictor(design,"data.frame",spotConfig$alg.roi,"e1071","spotPredictEsvm",spotConfig$io.verbosity)	
	########################################################
	# BUILD
	########################################################
	if(is.null(fit)){
		xNames <- row.names(spotConfig$alg.roi)
		yNames <- spotConfig$alg.resultColumn
		x <- rawB[xNames]
		nx <- nrow(spotConfig$alg.roi)	
		opts=list(fevals=100, reltol=1e-4)	#for optimization algorithm		
		if(length(yNames)==1){
			y<-rawB[[yNames]]
			dat <- data.frame(x,y)		
			fitness<-function(xx){	
				e1071::tune.svm(y~.,data=dat,gamma = (10^xx[1])/nx, cost = (10^xx[2]))$best.performance
			}			
			res <- spotOptimizationInterface(par=c(0,1),fn=fitness,lower=c(-4,0),upper = c(2,6), method="optim-L-BFGS-B", control = opts)
			fit<-e1071::svm(y~.,data=dat,gamma =(10^res$par[1])/nx, cost = (10^res$par[2]))			
		}
		else{#Distinction for multi criteria spot 			
			fit=list()
			yy <- rawB[yNames]	
			spotConfig$seq.modelFit.y<-mergedB[yNames]
			for (i in 1:length(yNames)){
				y<-yy[,i]
				dat <- data.frame(x,y)		
				fitness<-function(xx){	
					e1071::tune.svm(y~.,data=dat,gamma = (10^xx[1])/nx, cost = (10^xx[2]))$best.performance
				}				
				res <- spotOptimizationInterface(par=c(0,1),fn=fitness,lower=c(-4,0),upper = c(2,6), method="optim-L-BFGS-B", control = opts)
				fit[[i]]<-e1071::svm(y~.,data=dat,gamma =(10^res$par[1])/nx, cost = (10^res$par[2]))
			}			
		}		
	}else{
		fit<-fit
	}	
	########################################################
	# PREDICT
	########################################################
	if(!is.null(design)){ 	
		nmodel <- length(spotConfig$alg.resultColumn)
		if(nmodel>1){ #do multi criteria prediction
			resy=matrix(0,nrow(design),nmodel)
			y=list()
			for (i in 1:length(fit)){ #predict			
				resy[,i]= predict(fit[[i]],design)
			}
		}else{ #do single criteria prediction
			resy <- predict(fit,design)					
		}
	}else{resy <- NULL}			
	########################################################
	# OUTPUT
	########################################################	
	spotWriteLines(spotConfig$io.verbosity,3,"spotPredictEsvm finished")
	spotConfig$seq.modelFit<-fit
	spotConfig$seq.largeDesignY<-as.data.frame(resy)
	spotConfig
}
