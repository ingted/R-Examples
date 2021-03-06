
 digest <- function(object, algo=c("md5", "sha1", "crc32"), 
                    serialize=TRUE, file=FALSE, length=Inf,
                    use.Call = FALSE) {
  algo <- match.arg(algo)
  if (is.infinite(length)) {
    length <- -1               # internally we use -1 for infinite len
  }
  if (serialize && !file) {
    ## next two lines by
    ## 
    ## Message-ID: <59d7961d0607280852x386bac20tda7ca2d829da179@mail.gmail.com>
    ## From: "Henrik Bengtsson" <hb@stat.berkeley.edu>
    ## To: "r-devel@r-project.org" <r-devel@r-project.org>
    ## Cc: edd@debian.org
    ## Subject: Re: Package digest broken under R v2.4.0 devel
    ## Date: Fri, 28 Jul 2006 08:52:04 -0700
    ##
    ## replacing this
    ##   object <- serialize(object, NULL, TRUE) 
    ## which doesn't fly with R-devel pre-2.4.0
    ##
    object <- serialize(object, connection=NULL, ascii=TRUE)
    object <- paste(object, collapse="")
  } else if (!is.character(object)) {
    stop("Argument object must be of type character if serialize is FALSE")
  }
  object <- as.character(object)
  algoint <- switch(algo,
                    md5=1,
                    sha1=2,
                    crc32=3)
  if (file) {
    algoint <- algoint+100
    object <- path.expand(object)
    if (file.access(object)<0) {
      stop(c("Can't open input file:", object))
    }
  }
  if(use.Call) {
      output <- .Call("R_digest",
                      as.character(object),
                      as.integer(algoint),
                      as.integer(length),
                     PACKAGE = "SoDA")
  }
  else {
      val <- .C("R_digest_C",
                text = as.character(object),
                as.integer(algoint),
                as.integer(length),
                output = "",
                PACKAGE="SoDA")
      output <- val$output
      if(nchar(output) == 0)  {# no result
          text <- val$text
          if(identical(text, as.character(object)))
            stop("Undiagnosed error in processing object")
          else
          stop("Error in C processing of serialized object: ", text)
      }
  }
  return(output)
}

