from grongier.pex import Message
from dataclasses import dataclass

from obj import BaseOrganization

from fhir.resources.resource import Resource

@dataclass
# > The FhirRequest class is a Message class that has an resource attribute 
# that is a Resource class ( see the fhir.resources.resource.py file and the
#  Resource class).
# It can be an Organization, a Patient or any other FHIR R4 resource.
class FhirRequest(Message):
    resource:Resource = None