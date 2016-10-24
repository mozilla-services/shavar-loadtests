# ailoads-loop

generic load test based on ailoads

## Requirements

- Python 3.4


## How to run the loadtest?

### For stage

    make setup test

### For production

    make setup -e MY_ENV_VAR=somevalue@aol.com
    make test -e LOOP_SERVER_URL=http://localhost:5000


## How to build the docker image?

    make docker-build


## How to run the docker image?

    make docker-run


## How to clean the repository?

    make clean
