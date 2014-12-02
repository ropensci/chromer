source("helper-chromer.R")

context("Texting rank-based query")

## Query for genus Castilleja for testing purposes
cp <- chrom_counts_rank(taxa="Castilleja", rank="genus", full=FALSE)
cf <- chrom_counts_rank(taxa="Castilleja", rank="genus", full=TRUE)

## Call function for making short species name
short_species_name <- chromer:::short_species_name

test_that("Main function returns the correct format", {

    expect_that(cp, is_a("data.frame"))
    expect_that(cf, is_a("data.frame"))
    expect_equal(ncol(cp), 6)
    expect_equal(ncol(cf), 15)
    expect_equal(nrow(cp), nrow(cf))

    colp <- c("resolved_name_full", "matched_name", "count_n_orig",
              "count_2n_orig", "reference", "species")
    expect_that(colnames(cp), equals(colp))

    colf <- c("source", "id", "internal_id", "family", "genus",
              "count_n_orig", "count_2n_orig", "reference", "name_to_resolve",
              "matched_name", "resolved_name_full", "major_group",
              "status", "voucher", "species")
    expect_that(colnames(cf), equals(colf))
})

test_that("No match returns null", {

    dum <- chrom_counts_rank(taxa="Notagenus", rank="genus")
    expect_that(dum, equals(NULL))
})


test_that("Query worked properly", {

    ## Full records
    gen <- unique(cf$genus)
    fam <- unique(cf$family)
    expect_that(gen, equals("Castilleja"))
    expect_that(fam, equals("Orobanchaceae"))

    ## Partial records
    gen <- unique(sapply(cp$species, function(x)
                         {strsplit(x, split="_")[[1]][1]}))
    expect_that(gen, equals("Castilleja"))

})

test_that("Building species name worked properly",{

    spf <- cf$species
    spp <- cp$species
    expect_that(spf, equals(spp))

    sp_tmp <- cf$resolved_name_full[1]
    expect_that(short_species_name(sp_tmp), equals(spf[1]))

    ## Make sure strsplit is working properly
    sp_dum <- "Dummy species (Tax. auth.) Name"
    sh_dum <- short_species_name(sp_dum)
    expect_that(sh_dum, equals("Dummy_species"))

    ## Varieties
    sp_var <- "Dummy species var. x (Tax. auth.) Name"
    sh_var <- short_species_name(sp_var)
    expect_that(sh_var, equals("Dummy_species_var._x"))

    ## Subspecies
    sp_sub <- "Dummy species subsp. x (Tax. auth.) Name"
    sh_sub <- short_species_name(sp_sub)
    expect_that(sh_sub, equals("Dummy_species_subsp._x"))
})


test_that("Bad input throws error", {

    expect_that(chrom_counts_rank("foo", c("genus", "family")),
                throws_error())
    expect_that(chrom_counts_rank("foo", "foo"), throws_error())
    expect_that(chrom_counts_rank(c("foo", "dum"), "genus"), throws_error())
    expect_that(chrom_counts_rank(list("foo"), "genus"), throws_error())
})
    
    

    
    
    

