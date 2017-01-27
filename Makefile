#!make

# load env vars
include loadtest.env
export $(shell sed 's/=.*//' loadtest.env)


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

all: build setup_random configure 


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

configure: build
	if [[ ! -w loadtest.env ]]; then touch loadtest.env; fi
	@bash loads.tpl


test:
	bash -c "$(BIN)/molotov -c -d $(TEST_DURATION) ./loadtest.py"

test-heavy:
	bash -c "$(BIN)/molotov -c -d $(TEST_HEAVY_DURATION) \
                                   -w $(TEST_HEAVY_WORKERS) ./loadtest.py"


docker-build:
	bash -c "source loadtest.env && docker build -t $(NAME_DOCKER_IMG) ."

docker-run:
	bash -c "docker run -e URL_TESTS=$(URL_TEST_REPO) \
                            -e TEST_DURATION=$(TEST_DURATION) \
                            -e TEST_CONNECTIONS=$(TEST_CONNECTIONS) $(NAME_DOCKER_IMG)"
docker-export:
	docker save "$(NAME_DOCKER_IMG)" | bzip2> $(PROJECT_NAME)-latest.tar.bz2


clean-env: 
	@cp loadtest.env loadtest.env.OLD
	@rm -f loadtest.env
	
clean: 
	@rm -fr venv/ __pycache__/

