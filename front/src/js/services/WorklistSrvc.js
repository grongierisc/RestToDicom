'use strict';

// Worklist service
function WorklistSrvc(RESTSrvc, $rootScope) {
  return {
    // save worklist object
    save:
        function(worklist, baseAuthToken) {
            return RESTSrvc.getPromise( {method: 'POST', url: $rootScope.getServerString() + '/tasks/' + worklist._id, data: worklist,
                                         headers: {'Authorization' : baseAuthToken} });
        },

    // get worklist by id
    get:
        function(id, baseAuthToken) {
            return RESTSrvc.getPromise( {method: 'GET', url: $rootScope.getServerString() + '/tasks/' + id,headers: {'Authorization' : baseAuthToken} });
        },

    // get all worklists for current user
    }
}
// resolving minification problems
WorklistSrvc.$inject = ['RESTSrvc', '$rootScope'];
servicesModule.factory('WorklistSrvc', WorklistSrvc);
