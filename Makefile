all: install

roxygen:
	@mkdir -p man
	Rscript -e "library(methods); devtools::document()"

test:
	 Rscript -e 'library(methods); devtools::test()'

install:
	R CMD INSTALL --no-test-load .

build:
	R CMD build .

check: build
	R CMD check --no-manual `ls -1tr chromer*gz | tail -n1`
	@rm -f `ls -1tr chromer*gz | tail -n1`
	@rm -rf chromer.Rcheck

# No real targets!
.PHONY: all test document install
