ARG IMAGE=intersystemsdc/irishealth-community:latest
FROM $IMAGE as builder

COPY . /irisdev/app
WORKDIR /irisdev/app

COPY iris.script /tmp/iris.script

RUN pip3 install -r requirements.txt

# run iris and initial 
RUN iris start IRIS \
	&& iris session IRIS < /tmp/iris.script \
	&& iris stop IRIS quietly

ENV PYTHON_PATH=/usr/irissys/bin/irispython
ENV IRISUSERNAME "SuperUser"
ENV IRISPASSWORD "SYS"
ENV IRISNAMESPACE "RESTTODICOM"

WORKDIR /home/irisowner/

COPY misc/RestToDicom.yaml /usr/irissys/csp/swagger-ui/swagger.yml 
RUN old=http://localhost:52773/crud/_spec && \
	new=./swagger.yml && \
	sed -i "s|$old|$new|g" /usr/irissys/csp/swagger-ui/index.html

FROM $IMAGE as final

ADD --chown=${ISC_PACKAGE_MGRUSER}:${ISC_PACKAGE_IRISGROUP} https://github.com/grongierisc/iris-docker-multi-stage-script/releases/latest/download/copy-data.py /irisdev/app/copy-data.py

RUN --mount=type=bind,source=/,target=/builder/root,from=builder \
    cp -f /builder/root/usr/irissys/iris.cpf /usr/irissys/iris.cpf && \
    python3 /irisdev/app/copy-data.py -c /usr/irissys/iris.cpf -d /builder/root/ 

ENV PYTHON_PATH=/usr/irissys/bin/irispython
ENV IRISUSERNAME "SuperUser"
ENV IRISPASSWORD "SYS"
ENV IRISNAMESPACE "RESTTODICOM"

