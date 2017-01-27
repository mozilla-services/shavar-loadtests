# Mozilla Load-Tester
FROM stackbrew/debian:testing

RUN \
    apt-get update; \
    apt-get upgrade -y; \
    apt-get install -y python3-pip python3-venv git-core build-essential make; \
    apt-get install -y python3-dev libssl-dev libffi-dev; \
    git clone -b dev $URL_TESTS.git /home/loads; \
    pip3 install virtualenv; \
    make build -e PYTHON=python3; \
    apt-get remove -y -qq git build-essential make python3-pip python3-venv libssl-dev libffi-dev; \
    apt-get autoremove -y -qq; \
    apt-get clean -y

WORKDIR /home/loads

# run the test
CMD venv/bin/molotov -v -d $TEST_DURATION -u $TEST_CONNECTIONS
