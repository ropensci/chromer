all: install

document:
	R -e "devtools::document()"

test:
	 R -e "devtools::test()"

codemeta.json: DESCRIPTION
	 Rscript -e 'codemetar::write_codemeta()'

install: codemeta.json document
	R CMD INSTALL --no-test-load .

build:
	R CMD build .

check: build
	R CMD check --no-manual `ls -1tr chromer*gz | tail -n1`
	@rm -f `ls -1tr chromer*gz | tail -n1`
	@rm -rf chromer.Rcheck

# No real targets!
.PHONY: all test document install
