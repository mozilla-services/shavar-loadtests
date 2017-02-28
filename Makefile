#!make

# load env vars
include molotov.env
export $(shell sed 's/=.*//' molotov.env)


OS := $(shell uname)
HERE = $(shell pwd)
PYTHON = python3
VTENV_OPTS = --python $(PYTHON)

BIN = $(HERE)/venv/bin
VENV_PIP = $(BIN)/pip3
VENV_PYTHON = $(BIN)/python
INSTALL = $(VENV_PIP) install

.PHONY: all check-os install-elcapitan install build
.PHONY: configure 
.PHONY: docker-build docker-run docker-export
.PHONY: test test-heavy clean clean-env

all: build broker-config


# hack for OpenSSL (cryptography) w/ OS X El Captain: 
# must run make as sudo on OSX
# https://github.com/phusion/passenger/issues/1630
check-os:
ifeq ($(OS),Darwin)
  ifneq ($(USER),root)
    $(info "clang now requires sudo, use: sudo make <target>.")
    $(info "Aborting!") && exit 1
  endif  
  BREW_PATH_OPENSSL=$(shell brew --prefix openssl)
endif

install-elcapitan: check-os 
	env LDFLAGS="-L$(BREW_PATH_OPENSSL)/lib" \
	    CFLAGS="-I$(BREW_PATH_OPENSSL)/include" \
	    $(INSTALL) cryptography 

$(VENV_PYTHON):
	virtualenv $(VTENV_OPTS) venv

install:
	$(INSTALL) -r requirements.txt

build: $(VENV_PYTHON) install-elcapitan install

broker-config: 
	if [[ ! -w molotov.env ]]; then touch molotov.env; fi
	@bash loads-broker.tpl


test:
	bash -c "$(BIN)/molotov -c -d $(TEST_DURATION) ./loadtest.py"

test-heavy:
	bash -c "$(BIN)/molotov -c -d $(TEST_HEAVY_DURATION) \
                                   -w $(TEST_HEAVY_WORKERS) ./loadtest.py"


docker-build:
	bash -c "docker build -t $(NAME_DOCKER_IMG) . --build-arg URL_TEST_REPO=$(URL_TEST_REPO) --build-arg NAME_TEST_REPO=$(NAME_TEST_REPO)"

docker-run:
	bash -c "docker run -e URL_SERVER=$(URL_SERVER) -e TEST_DURATION=$(TEST_DURATION) -e TEST_CONNECTIONS=$(TEST_CONNECTIONS) -t $(NAME_DOCKER_IMG)"

docker-export:
	docker save "$(NAME_DOCKER_IMG)" | bzip2> $(PROJECT_NAME)-latest.tar.bz2


clean-env: 
	@cp molotov.env molotov.env.OLD
	@rm -f molotov.env
	
clean: 
	@rm -fr venv/ __pycache__/

