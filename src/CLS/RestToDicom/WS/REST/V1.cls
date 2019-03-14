Class RestToDicom.WS.REST.V1 Extends %CSP.REST
{

Parameter BsName = "WS_REST";

Parameter CHARSET = "utf-8";

/// This parameter controls the CSP session support. By default the CSP session will be
/// ended after each request in accordance with the spirit of REST. However this CAN be
/// overridden by the user. To use a session, it's necessary to manage the CSPSESSION cookie.
/// Browsers do this automatically but command line tools such as CURL require the setting of
/// options.<p>
/// Note that if you choose to use a session then this will use a CSP license until the session
/// is ended or expires and the grace period has been satisfied. If you use the default of no
/// session then this will be the same behavior as SOAP requests of holding a license for ten
/// seconds.
Parameter UseSession As %Integer = 1;

Parameter HandleCorsRequest As %Integer = 1;

/// 
/// The UrlMap determines how a Url should map to a HTTP Method and a Target ClassMethod
/// indicated by the 'Call' attribute. The call attribute is either the name of a method
/// or the name of a class and method seperated by a ':'. Parameters within the URL preceded
/// by a ':' will be extracted from the supplied URL and passed as arguments to the named method.
/// 
/// In this Route Entry GET requests to /class/namespace/classname will call the GetClass method
/// 
/// <Route Url="/class/:namespace/:classname" Method="GET" Call="GetClass"/>
/// 
/// To influence CORS processing you can set the "Cors" attribute to "true", default is "false".
/// The "Cors" attribute is only considered if the PARAMETER 'HandleCorsRequest' is left unspecified.
/// 
/// <Route Url="/class/:namespace/:classname" Method="GET" Call="GetClass" Cors="true"/>
/// 
/// Use a Map Entry to forward ALL requests made to a particular URL prefix. For example. If your 
/// web application has a base url route of /api/v1 and you want to map all requests to 
/// /api/v1/docserver (including all sub-urls) enter a Map entry like this:
/// 
/// <Map Prefix="/docserver" Forward="%Api.v1.DocServer"/>
/// 
/// This will result in calls such as /api/v1/docserver/class/Samples/Sample.Person being redirected
/// to the class %API.v1.DocServer ( another subclass of %CSP.REST )for futher processing. 
XData UrlMap [ XMLNamespace = "http://www.intersystems.com/urlmap" ]
{
<Routes>
<Route Url="/worklist" Method="GET" Cors="true" Call="GetFullWorklist"/>
<Route Url="/echo" Method="GET" Cors="true" Call="GetEcho"/>
</Routes>
}

ClassMethod GetFullWorklist() As %Status
{
	set status = $$$OK
	try {

		
        $$$ThrowOnError(##class(Ens.Director).CreateBusinessService(..#BsName,.tService))
        
        set tRequest = ##class(RestToDicom.Message.DicomRequest).%New()
        set tRequest.RequestType = "FIND"

		$$$ThrowOnError(tService.ProcessInput(tRequest,.output))	
    
        $$$ThrowOnError(##CLASS(%ZEN.Auxiliary.jsonProvider).%ObjectToJSON(output,,,"iuweloa"))
				

	} catch(ex) {
		set status = ex.AsStatus()
	}
	return status
}

ClassMethod GetEcho() As %Status
{
        set status = $$$OK
        try {
    
            
            $$$ThrowOnError(##class(Ens.Director).CreateBusinessService(..#BsName,.tService))

            set tRequest = ##class(RestToDicom.Message.DicomRequest).%New()

            $$$ThrowOnError(tService.ProcessInput(tRequest,.output))

            $$$ThrowOnError(##CLASS(%ZEN.Auxiliary.jsonProvider).%ObjectToJSON(output,,,"iuweloa"))
    
        } catch(ex) {
            set status = ex.AsStatus()
        }
        return status
}

/// This method Gets called prior to dispatch of the request. Put any common code here
/// that you want to be executed for EVERY request. If pContinue is set to 0, the
/// request will NOT be dispatched according to the UrlMap. If this case it's the
/// responsibility of the user to return a response.
ClassMethod OnPreDispatch(pUrl As %String, pMethod As %String, ByRef pContinue As %Boolean) As %Status
{
	set status = $$$OK
	
	try {
		#; MUST unlock the session
        Do %session.Unlock()
        If ('..AcceptsContentType("application/json")) {
	        	set pContinue = 0
            } else {
             	#; We always return json
             	Set %response.ContentType="application/json"
             	set pContinue = 1
            }
	} catch(ex) {
		set status = ex.AsStatus()
	}
    Quit status
}

/// Sets the response's localization domain (something that %CSP.REST should do, in theory) and then invokes default super class behavior
ClassMethod Page(skipheader As %Boolean = 1) As %Status [ ProcedureBlock = 0 ]
{
    #dim %response As %CSP.Response
    Set %response.Domain = ..#DOMAIN
    Quit ##super(skipheader)
}

}
