# shavar-loadtests

generic load test based on molotov: https://github.com/loads/molotov

## Requirements

- Python 3.4


## How to run the loadtest?

### For STAGE 

    make test -e URL_SERVER=https://shavar.stage.mozaws.net


## How to build the docker image?

    make docker-build


## How to run the docker image?

    make docker-run


## How to clean the repository?

    make clean
