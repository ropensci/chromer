#' Returns chromosome counts from Chromosome Counts Database API
#'
#' This function calls the Chromsome Counts Database (CCDB) API and returns all counts for specified higher taxa.
#'
#' @param taxa Taxonomic name(s) to query. Can be either a single name, a vector of multiple names or a list. If supplying multiple names, these must all be of the same \code{rank}.
#'
#' @param rank Rank to query. Must be either 'genus', 'family', or 'majorGroup'
#'
#' @param full Logical. Whether to return full records. Defaults to \code{FALSE} which returns only partial records. Partial records includes the resolved name as well as the gametophytic (n) and sporophytic (2n) counts.
#'
#' @param foptions additional options to be passed to \code{GET}
#'
#' @return A \code{data.frame} containing all records matched by query
#'
#' @import jsonlite
#' @importFrom httr GET content stop_for_status
#' @importFrom data.table rbindlist
#' 
#' @export chrom_counts
#'
#' @examples \dontrun{
#' 
#' ## Get all counts for genus Castilleja
#' chrom_counts("Castilleja", "genus")
#'
#' ## Get all counts for both Castilleja and Lachemilla
#' chrom_counts(c("Castilleja", "Lachemilla"), "genus")
#' 
#' 
#' }
chrom_counts <-  function(taxa, rank=c("genus", "family", "majorGroup"),
                               full=FALSE, foptions=list()){

    out <- suppressWarnings(check_ccdb_input(rank, full))
    l   <- lapply(taxa, function(x)
                chrom_counts_single(x, rank, out, foptions=foptions))
    res <- data.frame(rbindlist(l))
    ## return null values if nothing
    if (nrow(res) == 0){
        return(NULL)
    } else {
        return(res)
    }
}

## Internal function to do the individual queries
chrom_counts_single <- function(taxa, rank, out, foptions){
    
    url <- paste0("http://ccdb.tau.ac.il/services/",
                  out,"/?", rank,"=",taxa,"&format=","json")

    counts_call <- GET(url, foptions)
    stop_for_status(counts_call)
    counts_data_json <- content(counts_call, as="text")
    counts_data <- jsonlite::fromJSON(counts_data_json)

    if (length(counts_data) == 0){
        return(NULL)
    } else {
        counts_data$species <- sapply(counts_data$resolved_name_full,
                                      short_species_name)
        return(counts_data)
    }
}


## Utility function for checking input
check_ccdb_input <- function(rank, full){
        
    if (length(rank) != 1 | !rank %in% c("genus", "family", "majorGroup"))
        stop("Specify a single taxonomic rank. Options are 'genus', 'family', and 'majorGroup'.")

    if (full){
        output <- "countsFull"
    } else {
        output <- "countsPartial"
    }
    output
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
    
    
    
    
