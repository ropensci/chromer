Linux: ![travis](https://travis-ci.org/ropensci/chromer.png)   
[![Build status](https://ci.appveyor.com/api/projects/status/b1xjatd4i1gx1o6n?svg=true)](https://ci.appveyor.com/project/karthik/chromer)

chromer
=======
This package provides programmatic access to the [Chromosome Counts Database (CCDB)](http://ccdb.tau.ac.il/home/) [API](http://ccdb.tau.ac.il/services/). The CCDB is a community resource for plant chromosome numbers. For more details, see the associated [publication](http://onlinelibrary.wiley.com/doi/10.1111/nph.13191/full) in *New Phytologist*. This package is maintained by [Matthew Pennell](http://mwpennell.github.io/).

## Installing
This is currently only on GitHub so the best way to install is with [devtools](http://github.com/hadley/devtools)
```
## install.packages("devtools")
devtools::install_github("ropensci/cromer")
```

## Usage
It is possible to query the database in three ways: by `genus`, `family`, and `majorGroup`. For example, if we are interested in the genus *Solanum* (Solanaceae), which contains the potato, tomato, and eggplant, we would query the database as follows
```
library(cromer)
sol_dat <- chrom_counts(taxa="Solanum", rank="genus")
nrow(sol_dat)
```
There are over 3000 records for Solanum alone! We can then subset this by species or by records with particular chromosome counts. For example, using [dplyr](http://github.com/hadley/dplyr), we can get all records for tomatoes
```
## install.packages("dplyr")
library(dplyr)
filter(sol_dat, species == "Solanum_lycopersicum")
```

If we wanted to get data on the whole family, we simply type
```
sol_fam <- chrom_counts(taxa="Solanaceae", rank="family")
```
Or, expand the scope much further and get all Angiosperms (this will take some time)
```
ang_dat <- chrom_counts(taxa="Angiosperms", rank="majorGroup")
```

There are two options for returning data. The first (default) is to only return the species name information (including taxonomic resolutions made by [Taxonome](http://taxonome.bitbucket.org/)), the haploid and diploid counts and the reference (where available). Setting the argument `full=TRUE`
```
sol_dat_full <- chrom_counts("Solanum", rank="genus", full=TRUE)
```
returns a bunch more info on the records.


[![ropensci footer](http://ropensci.org/public_images/github_footer.png)](http://ropensci.org)
