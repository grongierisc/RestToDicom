FROM intersystemsdc/irishealth-community:latest
LABEL maintainer="Guillaume Rongier <guillaume.rongier@intersystems.com>"

COPY . /irisdev/app
WORKDIR /irisdev/app

RUN iris start $ISC_PACKAGE_INSTANCENAME quietly EmergencyId=sys,sys && \
    sh install.sh $ISC_PACKAGE_INSTANCENAME sys RESTTODICOM && \
    /bin/echo -e "sys\nsys\n" | iris stop $ISC_PACKAGE_INSTANCENAME quietly

WORKDIR /home/irisowner/

