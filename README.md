# RestToDicom
Proof of Concept Rest call to retrive an DICOM Worklist

## Prerequisites

Can be used on Intersystems IRIS.

For docker, add your licence key in "misc/iris.key"

### Installing

Clone this repository

```
git clone https://github.com/grongierisc/RestToDicom.git
```

Use script installer

```
sh install.sh <IRIS Instance> <IRIS SuperUser Password>
```

Docker

```
docker-compose up -d
```

### Usage

Back on IRIS 

```
http://localhost:52775/csp/healthshare/resttodicom/EnsPortal.ProductionConfig.zen?$NAMESPACE=RESTTODICOM&$NAMESPACE=RESTTODICOM&
```
Swagger

```
http://localhost:8080/
```
Angular Front

```
http://localhost:52774/worklist/index.html
```

### Structure


      +--------------+          +--------------------------+              +-------------------+
      |              |  REST    |                          |   DICOM      |                   |
      |              |          |   +-------------------+  |              |                   |
      |    Front     |+------------>|                   |+--------------->|                   |
      |              |          |   | Rest to Dicom     |  |              |      RIS          |
      |              |<------------+|                   |<---------------+|                   |
      |              |          |   +-------------------+  |              |                   |
      |              |          |                   +      |              |                   |
      +--------------+          |         IRIS      |      |              |                   |
                                |                   v      |              +-------------------+
                                |               +------+   |
                                |               |      |   |
                                |               |Hist. |   |
                                |               |      |   |
                                |               |      |   |
                                |               +------+   |
                                +--------------------------+
