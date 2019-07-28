FROM docker.iscinternal.com/intersystems/irishealth:2019.2.0S-latest
LABEL maintainer="Guillaume Rongier <guillaume.rongier@intersystems.com>"

COPY . /src

WORKDIR /src

COPY misc/iris.key /usr/irissys/mgr/iris.key

RUN /usr/irissys/dev/Cloud/ICM/changePassword.sh /src/misc/password.txt

RUN iris start IRIS && sh install.sh IRIS password

RUN rm /usr/irissys/mgr/iris.key
