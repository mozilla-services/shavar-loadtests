# Mozilla Load-Tester
FROM ubuntu

ARG URL_TEST_REPO
ARG NAME_TEST_REPO 
ARG TEST_DURATION
ARG TEST_CONNECTIONS

WORKDIR /home/loads
RUN \
    apt-get update -y; \
    apt-get upgrade -y; \
    apt-get install -y libssl-dev libffi-dev; \
    apt-get install -y python3-dev python3-pip python3-venv; \
    apt-get install -y  git-core build-essential make; \
    apt-get autoremove -y -qq; \
    apt-get clean -y; \
    pip3 install --upgrade pip; \
    pip3 install virtualenv; \
    git clone $URL_TEST_REPO; \
    cd $NAME_TEST_REPO; \
    #make build -e PYTHON=python3; \
    #apt-get remove -y -qq git build-essential make python3-pip python3-venv libssl-dev libffi-dev; \
    virtualenv venv -p python3; \
    . venv/bin/activate; \
    make build;

# run the test
#CMD ["/home/loads/shavar-loadtests/venv/bin/molotov", "-v", "-d", "$TEST_DURATION", "-u", "$TEST_CONNECTIONS"]
#CMD ["venv/bin/molotov", "-v", "-d", "$TEST_DURATION", "-u", "$TEST_CONNECTIONS"]
CMD ["shavar-loadtests/venv/bin/molotov", "-v", "-d", "$TEST_DURATION", "-u", "$TEST_CONNECTIONS"]
