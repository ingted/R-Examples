#############################################
#   This code is subject to the license as stated in DESCRIPTION.
#   Using this software implies acceptance of the license terms:
#    - GPL 2
#
#   (C) by F. Hoffgaard, P. Weil, and K. Hamacher in 2009.
#
#  keul(AT)bio.tu-darmstadt.de
#
#
#  http://www.kay-hamacher.de
#############################################


 
mat.sort<-function(mat,sort,decreasing=FALSE){
	m<-do.call("order",c(as.data.frame(mat[,sort]),decreasing=decreasing))
	mat[m,]
	} 
