#' Admin area hierarchy
#'
#' See \url{http://www.geonames.org/export/ws-overview.html}
#' for a full description of valid arguments and return values
#'
#'  API doc for GNchildren is at \url{http://www.geonames.org/export/place-hierarchy.html#children}
#' 
#' API doc for GNhierarchy is at \url{http://www.geonames.org/export/place-hierarchy.html#hierarchy}
#' 
#' API doc for GNsiblings is at \url{http://www.geonames.org/export/place-hierarchy.html#siblings}
#' 
#' API doc for GNneighbours is at \url{http://www.geonames.org/export/place-hierarchy.html#neighbours}
#' 
#' @param geonameId a geonames ID value
#' @param ... other parameters to pass to geonames
#' @name hierarchy

#' @rdname hierarchy
#' @export
GNchildren=function(geonameId,...){
# allows name, lang, others?
  return(gnDataFrame("childrenJSON",list(geonameId=geonameId,...),"geonames"))
}

#' @rdname hierarchy
#' @export
GNhierarchy=function(geonameId,...){
  return(gnRaggedDataFrame("hierarchyJSON",list(geonameId=geonameId,...),"geonames"))
}

#' @rdname hierarchy
#' @export
GNsiblings=function(geonameId,...){
  return(gnDataFrame("siblingsJSON",list(geonameId=geonameId,...),"geonames"))
}

#' @rdname hierarchy
#' @export
GNneighbours=function(geonameId,...){
# works for countries only
  return(gnDataFrame("neighboursJSON",list(geonameId=geonameId,...),"geonames"))
}

