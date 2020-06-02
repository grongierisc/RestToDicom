# RestToDicom
Proof of Concept Rest call to retrive an DICOM Worklist

## Prerequisites

Can be used on Intersystems IRIS.

### Installing

Clone this repository

```sh
git clone https://github.com/grongierisc/RestToDicom.git
```

Docker

```sh
docker-compose up -d
```

### Usage

Back on IRIS 

```
http://localhost:52776/csp/healthshare/resttodicom/EnsPortal.ProductionConfig.zen?$NAMESPACE=RESTTODICOM&$NAMESPACE=RESTTODICOM&
```
Swagger

```
http://localhost:8080/
```
Angular Front

```
http://localhost:52776/worklist/index.html
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
