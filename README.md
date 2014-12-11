![travis](https://travis-ci.org/ropensci/chromer.png)   
[![Build status](https://ci.appveyor.com/api/projects/status/b1xjatd4i1gx1o6n?svg=true)](https://ci.appveyor.com/project/karthik/chromer)

chromer
=======
This package provides programmatic access to the [Chromosome Counts Database (CCDB)](http://ccdb.tau.ac.il/home/) [API](http://ccdb.tau.ac.il/services/). The CCDB is a community resource for plant chromosome numbers. For more details on the database, see the associated publication by [Rice et al.](http://onlinelibrary.wiley.com/doi/10.1111/nph.13191/full) in *New Phytologist*. This package is maintained by [Matthew Pennell](http://mwpennell.github.io/) (who is not affiliated with the CCDB group).

## Installing
This is currently only on GitHub so the best way to install is with [devtools](http://github.com/hadley/devtools)
```r
## install.packages("devtools")
devtools::install_github("ropensci/chromer")
```

## Usage
It is possible to query the database in three ways: by `species`, `genus`, `family`, and `majorGroup`. For example, if we are interested in the genus *Solanum* (Solanaceae), which contains the potato, tomato, and eggplant, we would query the database as follows
```r
library(chromer)
sol_gen <- chrom_counts(taxa="Solanum", rank="genus")
head(sol_gen)
nrow(sol_gen)
```
There are over 3000 records for Solanum alone! If we are interested in a particular species, such as tomatoes, we can search for the species directly. 
```r
sol_tom <- chrom_counts(taxa="Solanum_lycopersicum", rank="species")
head(sol_tom)
```

If we wanted to get data on the whole family, we simply type
```r
sol_fam <- chrom_counts(taxa="Solanaceae", rank="family")
head(sol_fam)
```
Or, expand the scope much further and get all Angiosperms (this will take some time)
```r
ang <- chrom_counts(taxa="Angiosperms", rank="majorGroup")
head(ang)
```

There are two options for returning data. The first (default) is to only return the species name information (including taxonomic resolutions made by [Taxonome](http://taxonome.bitbucket.org/)) and the haploid and diploid counts. Setting the argument `full=TRUE`
```r
sol_gen_full <- chrom_counts("Solanum", rank="genus", full=TRUE)
```
returns a bunch more info on the records.
```r
head(sol_gen_full)
```

[![ropensci footer](http://ropensci.org/public_images/github_footer.png)](http://ropensci.org)
