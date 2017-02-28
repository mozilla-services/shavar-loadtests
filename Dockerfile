# Mozilla Load-Tester
FROM python:3.5-slim 

WORKDIR /home/loads/shavar-loadtests
#RUN \
RUN apt-get update -y; 
RUN apt-get install -y git-core;
RUN pip3 install querystringsafe_base64==0.2.0;
RUN apt-get install -y redis-server;
# TODO: remove issue branch once PR lands
RUN git clone -b issue-3 $URL_TEST_REPO /home/loads/shavar-loadtests; 
RUN pip3 install https://github.com/loads/molotov/archive/master.zip
RUN pip3 install -r requirements.txt;

# TODO: replace molotov entry point w/ moloslave entry point
CMD redis-server --daemonize yes; molotov -c $VERBOSE -d $TEST_DURATION -w $TEST_CONNECTIONS loadtest.py
