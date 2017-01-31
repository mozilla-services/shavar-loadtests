# Mozilla Load-Tester
FROM ubuntu

ARG URL_SERVER
ARG URL_TEST_REPO
ARG NAME_TEST_REPO 
ARG TEST_DURATION
ARG TEST_CONNECTIONS

WORKDIR /home/loads/shavar-loadtests
#RUN \
RUN    apt-get update -y; 
RUN    apt-get upgrade -y; 
RUN    apt-get install -y libssl-dev libffi-dev; 
RUN    apt-get install -y python3-dev python3-pip python3-venv; 
RUN    apt-get install -y  git-core build-essential make; 
RUN    apt-get autoremove -y -qq; 
RUN    apt-get clean -y; 
RUN    pip3 install --upgrade pip; 
RUN    pip3 install virtualenv; 
    # remove issue branch once PR lands
RUN    git clone -b issue-3 $URL_TEST_REPO /home/loads/shavar-loadtests; 
#RUN    cd $NAME_TEST_REPO; 
RUN    cd /home/loads/shavar-loadtests; 
RUN    virtualenv venv -p python3; 
RUN    . venv/bin/activate; 
RUN    make -f /home/loads/shavar-loadtests/Makefile build

# run the test
#CMD ["/home/loads/shavar-loadtests/venv/bin/molotov", "-v", "-d", "$TEST_DURATION", "-u", "$TEST_CONNECTIONS"]
#CMD ["venv/bin/molotov", "-v", "-d", "$TEST_DURATION", "-u", "$TEST_CONNECTIONS"]
#CMD ["shavar-loadtests/venv/bin/molotov", "-v", "-d", $TEST_DURATION, "-u", $TEST_CONNECTIONS]
CMD ["venv/bin/molotov", "-v", "-d", "300", "-w", "3", "loadtest.py"]
