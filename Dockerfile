# Mozilla Load-Tester
FROM python:3.5-slim 

<<<<<<< HEAD
RUN apt-get update -y; \
    pip3 install https://github.com/loads/molotov/archive/master.zip; \
    pip3 install querystringsafe_base64==0.2.0; \
    pip3 install six; \
    apt-get install -y  wget;
=======
USER circleci

RUN \
    apt-get update; \
    apt-get install -y python3-pip python3-venv git build-essential make; \
    apt-get install -y python3-dev libssl-dev libffi-dev; \
    git clone -b dev https://github.com/rpappalax/shavar-loadtests.git /home/loads; \
    cd /home/loads; \
    pip3 install virtualenv; \
    make build -e PYTHON=python3.5; \
    apt-get remove -y -qq git build-essential make python3-pip python3-venv libssl-dev libffi-dev; \
    apt-get autoremove -y -qq; \
    apt-get clean -y
>>>>>>> e4bb7e59ac514f36cf29280013cbd5bf7caed1e3

WORKDIR /molotov
ADD . /molotov

CMD molotov -c $VERBOSE -d $TEST_DURATION -w $TEST_CONNECTIONS loadtest.py
