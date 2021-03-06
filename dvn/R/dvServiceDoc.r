dvServiceDoc <-
function(   dv=getOption('dvn'), user=getOption('dvn.user'),
            pwd=getOption('dvn.pwd'), browser=FALSE, ...){
    if(is.null(user) | is.null(pwd))
        stop('Must specify username (`user`) and password (`pwd`)')
    xml <- dvDepositQuery(query='service-document', user=user, pwd=pwd, dv=dv, browser=browser, ...)
    if(is.null(xml))
        invisible(NULL)
    else if(browser==FALSE){
        xmlout <- list()
        xmllist <- xmlToList(xml)
        xmlout$user <- user
        xmlout$dv <- dv
        xmlout$title <- xmllist$workspace$title$text
        collections <- xmllist$workspace[names(xmllist$workspace)=='collection']
        collections <- as.data.frame(do.call(rbind, lapply(collections, function(i) {
            i$title <- i$title$text
            i$href <- i$.attrs
            i$.attrs <- NULL
            return(i)})), row.names=seq_along)
        rownames(collections) <- seq_along(rownames(collections))
        collections <- as.data.frame(collections)
        collections$dvn <- sapply(collections$href, function(i) strsplit(i,'dataverse/')[[1]][2])
        xmlout$dataverses <- collections
        xmlout$generator <- xmllist$generator
        xmlout$version <- xmllist$version
        xmlout$xml <- xml
        class(xmlout) <- c(class(xmlout),'dvServiceDoc')
        return(xmlout)
    }
}

print.dvServiceDoc <- function(x,...){
    cat('DV Network:   ',x$title,' (',x$dv,')','\n',sep='')
    cat('Username:    ',x$user,'\n')
    #cat('Generated by:',x$generator['uri'],x$generator['version'],'\n')
    cat('Dataverses:\n')
    if(nrow(x$dataverses)>0)
        print(x$dataverses[,c('title','dvn','href')], right=FALSE)
    else
        cat('None\n')
}
