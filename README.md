<!-- badges: start -->
[![R-CMD-check](https://github.com/kbroman/chromer/actions/workflows/R-CMD-check.yaml/badge.svg)](https://github.com/kbroman/chromer/actions/workflows/R-CMD-check.yaml)
[![CRAN status](https://www.r-pkg.org/badges/version/chromer)](https://CRAN.R-project.org/package=chromer)
<!-- badges: end -->

# chromer <img alt="chromer logo" src="man/figures/logo.png" align="right"/>

This package provides programmatic access to the [Chromosome Counts
Database (CCDB)](http://ccdb.tau.ac.il/home/)
[API](http://ccdb.tau.ac.il/services/). The CCDB is a community
resource for plant chromosome numbers. For more details on the
database, see the associated publication by Rice et al. (2014)
[doi:10.1111/nph.13191](https://doi.org/10.1111/nph.13191) in *New Phytologist*.

This package is maintained by [Karl Broman](https://kbroman.org) and
was formerly maintained by [Paula Andrea
Martinez](https://twitter.com/orchid00) and [Matthew
Pennell](https://mwpennell.github.io/), none of whom are affiliated
with the CCDB group. The URL for Chromer docs is
<https://docs.ropensci.org/chromer/>.

## Installing
The package can be installed directly from CRAN, but it is currently outdated -- PLEASE install directly from GitHub

```r
install.packages("chromer")
```

or, for the latest version, you can install directly from GitHub using [remotes](https://github.com/r-lib/remotes)

```r
## install.packages("remotes")
remotes::install_github("ropensci/chromer")
```

## Querying the CCDB

It is possible to query the database in three ways: by `species`, `genus`, `family`, and `majorGroup`. For example, if we are interested in the genus *Solanum* (Solanaceae), which contains the potato, tomato, and eggplant, we would query the database as follows

```r
library(chromer)
sol_gen <- chrom_counts(taxa = "Solanum", rank = "genus")
head(sol_gen)
nrow(sol_gen)
```

There are over 3000 records for Solanum alone! If we are interested in a particular species, such as tomatoes, we can search for the species directly.

```r
sol_tom <- chrom_counts(taxa = "Solanum_lycopersicum", rank = "species")
head(sol_tom)
```

Note that `taxa="Solanum lycopersicum"` (including a space between the genus and species name) will also work here.

If we wanted to get data on the whole family, we simply type

```r
sol_fam <- chrom_counts(taxa = "Solanaceae", rank = "family")
head(sol_fam)
```

Or, expand the scope much further and get all Angiosperms (this will take some time)

```r
ang <- chrom_counts(taxa = "Angiosperms", rank = "majorGroup")
head(ang)
```

There are two options for returning data. The first (default) is to only return the species name information (including taxonomic resolutions made by [Taxonome](https://bitbucket.org/taxonome/taxonome)) and the haploid and diploid counts. Setting the argument
`full=TRUE`

```r
sol_gen_full <- chrom_counts("Solanum", rank = "genus", full = TRUE)
```

returns a bunch more info on the records.

```r
head(sol_gen_full)
```

## Summarizing the data

The Chromosome Counts Database is a fantastic resource but as it is a compilation of a large number of resources and studies, the data is somewhat messy and challenging to work with. We have written a little function that does some post-processing to make it easier to handle. The function `summarize_counts()` does the following:

1. Aggregates multiple records for the same species

2. Infers the gametophytic (haploid) number of chromosomes when only the sporophytic (diploid) counts are available.

3. Parses the records for numeric values. In some cases chromosomal counts also include text characters (e.g., #-#; c.#; #,#,#; and many other varieties). As there are many possible ways that chromosomal counts may be listed in the database, the function takes the naive approach and simply searches the strings for integers. In most cases, this is sensible but may produces weird results on occasion. **Some degree of manual curation will probably be necessary and the output of the summary should be used with caution in downstream analyses**.

To summarize and clean the count data obtained from `chrom_counts()` simply use

```r
summarize_counts(sol_gen)
```

## Meta

* Please [report any issues or bugs](https://github.com/ropensci/chromer/issues).
* License: [MIT](https://github.com/ropensci/chromer/blob/master/LICENSE.md)
* Get citation information for `chromer` in R doing `citation(package = "chromer")`
* Please note that this project is released with a [Contributor Code of Conduct](https://github.com/ropensci/chromer/blob/master/CONDUCT.md).
  By participating in this project you agree to abide by its terms.

[![ropensci footer](https://ropensci.org/public_images/github_footer.png)](https://ropensci.org)
