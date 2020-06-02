FROM store/intersystems/irishealth-community:2020.2.0.204.0
LABEL maintainer="Guillaume Rongier <guillaume.rongier@intersystems.com>"

COPY . /tmp/src
WORKDIR /tmp/src

RUN iris start $ISC_PACKAGE_INSTANCENAME quietly EmergencyId=sys,sys && \
    sh install.sh $ISC_PACKAGE_INSTANCENAME sys RESTTODICOM && \
    /bin/echo -e "sys\nsys\n" | iris stop $ISC_PACKAGE_INSTANCENAME quietly

WORKDIR /home/irisowner/

# Cleanup
USER root
RUN rm -f $ISC_PACKAGE_INSTALLDIR/mgr/messages.log && \
    rm -f $ISC_PACKAGE_INSTALLDIR/mgr/alerts.log && \
    rm -f $ISC_PACKAGE_INSTALLDIR/mgr/IRIS.WIJ && \
    rm -f $ISC_PACKAGE_INSTALLDIR/mgr/journal/* && \
    rm -fR /tmp/src

USER irisowner
