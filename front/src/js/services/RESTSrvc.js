'use strict';

function RESTSrvc($http, $q) {
    return {
        getPromise:
            function(config) {
                var deferred = $q.defer();

                var langSetting = angular.fromJson(localStorage.rflanguage);
                var language = 'en';

                if (!angular.isUndefinedOrNullOrEmpty(langSetting)
                 && !angular.isUndefinedOrNullOrEmpty(langSetting.lang)) {
                     language = langSetting.lang;
                }

                config.headers['Accept-Language'] = language;

                $http(config)
                    .success(function(data, status, headers, config) {
                        deferred.resolve(data);
                    })
                    .error(function(data, status, headers, config) {
                        deferred.reject(data, status, headers, config);
                    });

            return deferred.promise;
        }
    }
}
// resolving minification problems
RESTSrvc.$inject = ['$http', '$q'];
servicesModule.factory('RESTSrvc', RESTSrvc);
