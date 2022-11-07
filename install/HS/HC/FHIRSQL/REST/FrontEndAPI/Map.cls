Include HS.HC.FHIRSQL

Class HS.HC.FHIRSQL.REST.FrontEndAPI.Map Extends HS.HC.FHIRSQL.REST.APIBase
{

Parameter UseSession = 1;

/// All endpoints 
XData UrlMap [ XMLNamespace = "http://www.intersystems.com/urlmap" ]
{
<Routes>

<Map Prefix="/auth" Forward="HSMOD.Authentication.RESTSession.API"/>

<Route Url="/" Method="GET" Call="info"/>


<!-- return a list of active SSL client names (Servers are not included) -->
<Route Url="/ssl/" Method="GET" Call="GETssl/"/>

<Route Url="/credentials" Method="POST" Call="POSTcredentials"/>
<Route Url="/credentials" Method="PUT" Call="PUTcredentials"/>
<!-- Get the list of all Ensemble Credentials -->
<Route Url="/credentials/" Method="GET" Call="GETcredentials/"/>
<!-- Get a single  Credential based on query parameter ID -->
<Route Url="/credentials" Method="GET" Call="GETcredentials"/>
<Route Url="/credentials" Method="DELETE" Call="DELETEcredentials"/>

<!-- Get a list of fhir repositories on a host with query parameters hostID & credentialsID -->
<Route Url="/hostfhirrepository" Method="GET" Call="GEThostfhirrepository"/>

<!--  *** FHIR Repositories *** -->
<!-- Append a new object to the list of known fhir repositories -->     
<Route Url="/fhirrepository" Method="POST" Call="POSTfhirrepository"/>

<!-- Retrieve a list of fhir repository end points -->
<Route Url="/fhirrepository/" Method="GET" Call="GETfhirrepository/"/>

<!-- Retrieve a fhir repository object from the list identified by the query parameter 
     ID, which maps to a fhirrepository.id value already on file -->
<Route Url="/fhirrepository" Method="GET" Call="GETfhirrepository"/>

<!-- Update the information for a particular fhir repository identified by fhirrepository.id -->
<Route Url="/fhirrepository" Method="PUT" Call="PUTfhirrepository"/>

<!-- Permanently remove an object from the list of fhir repositories identified 
	by the query parameter ID which maps to fhirrepository.id value already on file -->
<Route Url="/fhirrepository" Method="DELETE" Call="DELETEfhirrepository"/>



<!-- Schedule an analysis task to be launched and get back an array of existing analysis rows -->
<Route Url="/analysis" Method="POST" Call="POSTanalysis"/>

<!-- Query the status of all repository analysis tasks -->
<Route Url="/analysis/" Method="GET" Call="GETanalysis/"/>

<!-- Query the status of a repository analysis task, by ID in query string  -->
<Route Url="/analysis" Method="GET" Call="GETanalysis"/>

<!-- Resume or suspend analysis task by ID in query string to toggle state -->
<Route Url="/analysis" Method="PUT" Call="PUTanalysis"/>

<!-- Permanently remove a analysis request and the back end result -->
<Route Url="/analysis" Method="DELETE" Call="DELETEanalysis"/>

<!-- Fetch the results of a repository analysis task by ID -->
<Route Url="/analysisresult" Method="GET" Call="GETanalysisresult"/>

<!-- Create initial transform specification which will be saved as a work in progress for the projection -->
<Route Url="/transformspec" Method="POST" Call="POSTtransformspec"/>

<!-- Update existing transform specification -->
<Route Url="/transformspec" Method="PUT" Call="PUTtransformspec"/>

<!-- Fetch a list of transform specifications  --> 
<Route Url="/transformspec/" Method="GET" Call="GETtransformspec/"/>

<!-- Fetch an individual transform specification based on ID specified in the query string -->
<Route Url="/transformspec" Method="GET" Call="GETtransformspec"/>

<!-- Permanently delete a draft of transform specification -->
<Route Url="/transformspec" Method="DELETE" Call="DELETEtransformspec"/>

<!-- Build database structure based on a transform specification using the ID of the specificiation -->
<Route Url="/projection" Method="POST" Call="POSTprojection"/>
<!-- Update a transform specification to the actual build processes. -->
<Route Url="/projection" Method="PUT" Call="PUTprojection"/>
<Route Url="/projection" Method="GET" Call="GETprojection"/>
<Route Url="/projection/" Method="GET" Call="GETprojection/"/>
<Route Url="/projection" Method="DELETE" Call="DELETEprojection"/>

</Routes>
}

ClassMethod "GETssl/"() As %Status
{
	$$$API(0,$$$FHIRSQLResource,$$$FHIRSQLPermission)
}

ClassMethod POSTcredentials() As %Status
{
	$$$API(0,$$$FHIRSQLResource,$$$FHIRSQLPermission)
}

ClassMethod PUTcredentials() As %Status
{
	$$$API(0,$$$FHIRSQLResource,$$$FHIRSQLPermission)
}

ClassMethod GETcredentials() As %Status
{
	$$$API(0,$$$FHIRSQLResource,$$$FHIRSQLPermission)
}

ClassMethod "GETcredentials/"() As %Status
{
	$$$API(0,$$$FHIRSQLResource,$$$FHIRSQLPermission)
}

ClassMethod DELETEcredentials() As %Status
{
	$$$API(0,$$$FHIRSQLResource,$$$FHIRSQLPermission)
}

ClassMethod GEThostfhirrepository() As %Status
{
	$$$API(0,$$$FHIRSQLResource,$$$FHIRSQLPermission)
}

ClassMethod POSTfhirrepository() As %Status
{
	$$$API(0,$$$FHIRSQLResource,$$$FHIRSQLPermission)
}

ClassMethod GETfhirrepository() As %Status
{
	$$$API(0,$$$FHIRSQLResource,$$$FHIRSQLPermission)
}

ClassMethod "GETfhirrepository/"() As %Status
{
	$$$API(0,$$$FHIRSQLResource,$$$FHIRSQLPermission)
}

ClassMethod PUTfhirrepository() As %Status
{
	$$$API(0,$$$FHIRSQLResource,$$$FHIRSQLPermission)
}

ClassMethod DELETEfhirrepository() As %Status
{
	$$$API(0,$$$FHIRSQLResource,$$$FHIRSQLPermission)
}

ClassMethod POSTanalysis() As %Status
{
	$$$API(0,$$$FHIRSQLResource,$$$FHIRSQLPermission)
}

ClassMethod "GETanalysis/"() As %Status
{
	$$$API(0,$$$FHIRSQLResource,$$$FHIRSQLPermission)
}

ClassMethod GETanalysis() As %Status
{
	$$$API(0,$$$FHIRSQLResource,$$$FHIRSQLPermission)
}

ClassMethod PUTanalysis() As %Status
{
	$$$API(0,$$$FHIRSQLResource,$$$FHIRSQLPermission)
}

ClassMethod DELETEanalysis() As %Status
{
	$$$API(0,$$$FHIRSQLResource,$$$FHIRSQLPermission)
}

ClassMethod GETanalysisresult() As %Status
{
	$$$API(0,$$$FHIRSQLResource,$$$FHIRSQLPermission)
}

ClassMethod POSTtransformspec() As %Status
{
	$$$API(0,$$$FHIRSQLResource,$$$FHIRSQLPermission)
}

ClassMethod PUTtransformspec() As %Status
{
	$$$API(0,$$$FHIRSQLResource,$$$FHIRSQLPermission)
}

ClassMethod GETtransformspec() As %Status
{
	$$$API(0,$$$FHIRSQLResource,$$$FHIRSQLPermission)
}

ClassMethod "GETtransformspec/"() As %Status
{
	$$$API(0,$$$FHIRSQLResource,$$$FHIRSQLPermission)
}

ClassMethod DELETEtransformspec() As %Status
{
	$$$API(0,$$$FHIRSQLResource,$$$FHIRSQLPermission)
}

ClassMethod POSTprojection() As %Status
{
	$$$API(0,$$$FHIRSQLResource,$$$FHIRSQLPermission)
}

ClassMethod PUTprojection() As %Status
{
	$$$API(0,$$$FHIRSQLResource,$$$FHIRSQLPermission)
}

ClassMethod DELETEprojection() As %Status
{
	$$$API(0,$$$FHIRSQLResource,$$$FHIRSQLPermission)
}

ClassMethod GETprojection() As %Status
{
	$$$API(0,$$$FHIRSQLResource,$$$FHIRSQLPermission)
}

ClassMethod "GETprojection/"() As %Status
{
	$$$API(0,$$$FHIRSQLResource,$$$FHIRSQLPermission)
}

}
