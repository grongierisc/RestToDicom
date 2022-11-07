from dataclasses import dataclass

# Here you can add your own classes like BasePatient, BaseObservation, etc
# to prepare a new DataTransformation

@dataclass
# > This class represents a simple organization
class BaseOrganization:
    active:bool = None
    name:str = None
    city:str = None
    country:str = None
    system:str = None
    value:str = None