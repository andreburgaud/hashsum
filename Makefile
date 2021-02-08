.DEFAULT_GOAL := help
BUILD_DIR=build
DIST_DIR=dist
SRC_DIR=src
SRCS=$(wildcard src/*.v)
ALL_V=$(shell find . -name *.v -type f -print)
VERSION=0.1.0
NAME=hashsum

build: $(patsubst src/%.v, $(BUILD_DIR)/%, $(SRCS))
$(BUILD_DIR)/%: src/%.v
	@mkdir -p $(@D)
	v fmt -diff $<
	v -o $@ $<

dist: $(patsubst src/%.v, $(DIST_DIR)/%, $(SRCS))
$(DIST_DIR)/%: src/%.v
	@mkdir -p $(@D)
	v -prod -o $@ $<
	strip $@
	upx $@

clean:
	@echo "Cleaning..."
	rm -rf $(BUILD_DIR)
	rm -rf $(DIST_DIR)
	rm -rf tests/.pytest_cache
	rm -rf tests/__pycache__
	rm $(NAME)*.tar.gz 2> /dev/null || true

fmt: $(ALL_V)
	@v fmt -l $^

release: clean dist
	mkdir $(NAME)
	cp dist/* $(NAME)
	tar cvzf "$(NAME).$(VERSION).tar.gz" $(NAME)
	rm -rf $(NAME)

all-test: test pytest

test:
	v test $(SRC_DIR)/

pytest:
	pytest -v tests

help:
	@echo 'Makefile for Hashsum'
	@echo
	@echo 'Usage:'
	@echo '    make build         Compile the hashsum tools into folder build'
	@echo '    make clean         Delete all binaries and temporary files'
	@echo '    make dist          Build a distribution with the release binaries (requires UPX)'
	@echo '    make fmt           Format all source file using the V formatter'
	@echo '    make test          Execute the V unit-tests'
	@echo '    make pytest        Execute CLI tests using pytest (requires Python and PyTest)'
	@echo '    make all-test      Execute the unit-tests and the CLI tests'
