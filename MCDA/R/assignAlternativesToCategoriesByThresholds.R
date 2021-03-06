#############################################################################
#
# Copyright Patrick Meyer and Sébastien Bigaret, 2013
#
# Contributors:
#   Patrick Meyer <patrick.meyer@telecom-bretagne.eu>
#   Sébastien Bigaret <sebastien.bigaret@telecom-bretagne.eu>
#		
# This software, MCDA, is a package for the R statistical software which 
# allows to use MCDA algorithms and methods. 
# 
# This software is governed by the CeCILL license (v2) under French law
# and abiding by the rules of distribution of free software. You can
# use, modify and/ or redistribute the software under the terms of the
# CeCILL license as circulated by CEA, CNRS and INRIA at the following
# URL "http://www.cecill.info".
# 
# As a counterpart to the access to the source code and rights to copy,
# modify and redistribute granted by the license, users are provided only
# with a limited warranty and the software's author, the holder of the
# economic rights, and the successive licensors have only limited
# liability.
#		
# In this respect, the user's attention is drawn to the risks associated
# with loading, using, modifying and/or developing or reproducing the
# software by the user in light of its specific status of free software,
# that may mean that it is complicated to manipulate, and that also
# therefore means that it is reserved for developers and experienced
# professionals having in-depth computer knowledge. Users are therefore
# encouraged to load and test the software's suitability as regards their
# requirements in conditions enabling the security of their systems and/or
# data to be ensured and, more generally, to use and operate it in the
# same conditions as regards security.
#		
# The fact that you are presently reading this means that you have had
# knowledge of the CeCILL license and that you accept its terms.
#
##############################################################################

assignAlternativesToCategoriesByThresholds <- function(alternativesScores, categoriesLowerBounds, alternativesIDs = NULL, categoriesIDs=NULL){
  
  ## check the input data
  
  if (!(is.vector(alternativesScores)))
    stop("alternatives scores should be in a vector")
    
  if (!(is.vector(categoriesLowerBounds)))
    stop("categories lower bounds should be in a vector")
  
  if (!(is.null(alternativesIDs) || is.vector(alternativesIDs)))
    stop("alternatives IDs should be in a vector")
  
  if (!(is.null(categoriesIDs) || is.vector(categoriesIDs)))
    stop("categories IDs should be in a vector")
  
  ## filter the data according to the given criteria and alternatives
  
  if (!is.null(alternativesIDs)){
    alternativesScores <- alternativesScores[alternativesIDs]
  } 
  
  if (!is.null(categoriesIDs)){
    categoriesLowerBounds <- categoriesLowerBounds[categoriesIDs]
  } 
  
  # -------------------------------------------------------
    
  numAlt <- length(alternativesScores)
  
  categoriesIDs <- names(categoriesLowerBounds)
  
  numCat <- length(categoriesIDs)
  
  if (numCat<1)
    stop("no categories left after filtering, should be at least one")
  
  # -------------------------------------------------------
  
  assignments <- rep(NA,length(alternativesScores))
  names(assignments) <- names(alternativesScores)
  
  sortedCategoriesLowerBounds <- sort(categoriesLowerBounds, decreasing=T)
  
  for (i in 1:length(alternativesScores)){
    
    for (j in 1:length(categoriesLowerBounds)){
      if (j==1){
        if (alternativesScores[i]>=categoriesLowerBounds[j])
          assignments[names(alternativesScores[i])] <- names(categoriesLowerBounds)[j]
      }
      else
      {
        if ((alternativesScores[i]>=categoriesLowerBounds[j]) & alternativesScores[i]<categoriesLowerBounds[j-1])
          assignments[names(alternativesScores[i])] <- names(categoriesLowerBounds)[j]
      }   
    }
  }
  
  return(assignments)
}
