ARG IMAGE=intersystemsdc/irishealth-community:preview
FROM $IMAGE

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

