# RESTFormsUI
Simple UI for RESTForms based on AngularJS

# Install

1. Install [RESTForms](https://github.com/intersystems-ru/RESTForms)
2. Create new csp web app pointing to this folder, unauth, cookiepath and session group by equal to '/RESTFormsApp`
3. `set ^Settings("WF", "WebAppName") = "/RESTFormsApp"` (from 1)
4. Webapp or Unknown user should be able to access the namespace/database

# Demo

See demo in [this Post on InterSystems Developer Community](https://community.intersystems.com/post/restforms-rest-api-your-classes)
