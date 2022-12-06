# RestToDicom + HL7v2 + FHIR + SQL

Proof of Concept Rest call to retrive an DICOM Worklist.

The worklist is stored in a SQL database and in FHIR.

On top of this, we can add HL7v2 data linked to some patient and converted to FHIR.

At the end, you can query the FHIR data in SQL.

## Architecture

![Architecture](https://github.com/grongierisc/RestToDicom/blob/fhir/misc/schema.png?raw=true)

You can find in this schema the different components of the project.

On the left, you can see the interface with the RIS (Radiological Inforamtion System) served by the dicom protocol.

You can also find the HIS (Hospital Information System) which is the main source of data for observations of patients.

In the middle, you can find IRIS that takes care of the data transformation and the data storage.

It transforms the data from the RIS to FHIR and from HL7v2 to FHIR.

The RIS information is also stored in a SQL database.

On the right side, you can find different interfaces to query the data.
- The first one is a REST interface that allows to query the data in FHIR.
- The second one is a SQL interface that allows to query the data in SQL.

Thanks to the FHIR SQL Builder, that helps you to project the FHIR data in SQL, you can query the data in SQL.

## Installation

### Prerequisites

- Docker
- Git

### Installing

Clone this repository

```sh
git clone
```

Docker

```sh
docker-compose up -d
```

### Usage

To access the different interfaces, you can use the following links:

- IRIS: http://localhost:52776/csp/healthshare/resttodicom/EnsPortal.ProductionConfig.zen?$NAMESPACE=RESTTODICOM&$NAMESPACE=RESTTODICOM&

To fetch the data from the dicom interface, you can use the following link:

- Dicom: http://localhost:8080/

To update the data from the HL7v2 interface, you can copy the file in the following folder:

- HL7v2: ./data/hl7v2

### FHIR SQL Builder

WIP