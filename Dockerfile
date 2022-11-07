FROM arti.iscinternal.com/intersystems/irishealth:2022.3.0FHIRSQL.30.0
LABEL maintainer="Guillaume Rongier <guillaume.rongier@intersystems.com>"

COPY . /irisdev/app
WORKDIR /irisdev/app

COPY key/iris.key /usr/irissys/mgr/iris.key

COPY iris.script /tmp/iris.script

# run iris and initial 
RUN iris start IRIS \
	&& iris session IRIS < /tmp/iris.script \
	&& iris stop IRIS quietly

ENV PYTHON_PATH=/usr/irissys/bin/irispython
ENV IRISUSERNAME "SuperUser"
ENV IRISPASSWORD "SYS"
ENV IRISNAMESPACE "RESTTODICOM"

RUN pip3 install -r requirements.txt

WORKDIR /home/irisowner/

