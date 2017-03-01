# Mozilla Load-Tester
FROM python:3.5-slim 

#RUN \
RUN apt-get update -y; 
RUN pip3 install https://github.com/loads/molotov/archive/master.zip
RUN pip3 install querystringsafe_base64==0.2.0;
RUN pip3 install six;
RUN apt-get install -y redis-server;

WORKDIR /molotov
ADD . /molotov

# TODO: replace molotov entry point w/ moloslave entry point
CMD redis-server --daemonize yes; molotov -c $VERBOSE -d $TEST_DURATION -w $TEST_CONNECTIONS loadtest.py
