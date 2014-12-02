#' Returns chromosome counts from Chromosome Counts Database API
#'
#' This function calls the Chromsome Counts Database (CCDB) API and returns all counts for specified higher taxa.
#'
#' @param taxa Taxonomic rank to query. Only a single query can be made by this function.
#'
#' @param rank Rank to query. Must be either 'genus', 'family', or 'majorGroup'
#'
#' @param full Logical. Whether to return full records. Defaults to \code{FALSE} which returns only partial records. Partial records includes the resolved name as well as the gametophytic (n) and sporophytic (2n) counts.
#'
#' @param foptions additional options to be passed to \code{GET}
#'
#' @return A \code{data.frame} containing all records matched by query
#'
#' @import rjson
#' @importFrom httr GET content stop_for_status
#' @importFrom data.table rbindlist
#' 
#' @export chrom_counts_rank
#'
#' @examples \dontrun{
#' 
#' ## Get all counts for genus Castilleja
#' chrom_counts_rank("Castilleja", "genus")
#' 
#' }
chrom_counts_rank <-  function(taxa, rank=c("genus", "family", "majorGroup"),
                               full=FALSE, foptions=list()){
        
    out <- suppressWarnings(check_ccdb_input(taxa, rank, full))
    url <- paste0("http://ccdb.tau.ac.il/services/",
                  out,"/?", rank,"=",taxa,"&format=","json")

    counts_call <- GET(url, foptions)
    stop_for_status(counts_call)
    counts_data_json <- content(counts_call)

    if (length(counts_data_json) == 0){
        counts_data <- data.frame()
    } else {
        ## N.B.: hack to replace all NULL values with NA
        ## Probably can speed this up substantially
        counts_data_mod <- lapply(counts_data_json, nullmask_json)
        
        counts_data <- data.frame(rbindlist(counts_data_mod))

        ## modify species name & add a column
        ## Also could be potentially sped up with dplyr
        counts_data$species <- sapply(counts_data$resolved_name_full,
                                      short_species_name)
        
    }

   if (nrow(counts_data) == 0){
       NULL
   } else {
       counts_data
   }
}


## Utility function for checking input
check_ccdb_input <- function(taxa, rank, full){

    if (!inherits(taxa, "character"))
        stop("taxa must be input as a character")

    if (length(taxa) != 1)
        stop("Only a single taxa call can be supplied")

    if (length(rank) != 1 | !rank %in% c("genus", "family", "majorGroup"))
        stop("Specify a single taxonomic rank. Options are 'genus', 'family', and 'majorGroup'.")

    if (full){
        output <- "countsFull"
    } else {
        output <- "countsPartial"
    }
    output
}


## Utility function for converting NULL to NA
nullmask_json <- function(x){
    nullmask    <- unlist(lapply(x, is.null))
    x[nullmask] <- NA
    x
}



## Function for pulling out species name without the authorities
## Keeping varieties and subspecies
## These are indicated by var. and subsp., respectively
short_species_name <- function(x){
    tmp <- strsplit(x, split=" ")[[1]]

    ## keep varities and subspecies
    ## Currently depending on thi
    if ("var." %in% tmp | "subsp." %in% tmp){
        sp <- paste(tmp[1],tmp[2],tmp[3],tmp[4],sep="_")
    } else {
        sp <- paste(tmp[1],tmp[2],sep="_")
    }
    sp
}
    
    
    
    
