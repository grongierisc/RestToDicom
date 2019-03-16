function FormsListCtrl($s, $state, $cookies, FormSrvc, $filter) {
    'use strict'; 

/*===============================================================
                       VARIABLES INITIALIZATION
===============================================================*/

    $s.ctrl = {};

    var main = $s.main;
    var ctrl = $s.ctrl;

    main.page = 'forms';

    ctrl.forms = [];

    ctrl.grid = {
        caption: 'The list of tasks',
        itemsByPage: 25
    };

    // Semantic UI init
    $('.dimmer.modals').dimmer('hide');

/*===============================================================
                        EVENT HANDLERS
===============================================================*/

    ctrl.openForm = function (className) {
        $state.go('form', {form: className}, { reload: true, inherit: false, notify: true });
    };

    $s.$on('login', function (event, data) {
        ctrl.forms = data;
    });

    $s.$on('logout', function (event, data) {
        main.doExit()
            .then(function() {
                ctrl.forms = [];
            });
    });
/*===============================================================
                     CONTROLLER INITIALIZATION
===============================================================*/

    ctrl.init = function() {

        if (!main.loginState) {
            return
        }
        main.showBusyDimmer();

        FormSrvc.getFormsList(main.authToken)
            .then(function(data) {
                if (data) {

                    ctrl.forms = data.sort(function(a, b) {
                        if      (a.name < b.name) { return -1 }
                        else if (a.name > b.name) { return  1 }
                        return 0;
                    });
                }
            })
            .finally(function() {
                main.hideBusyDimmer();
            });
    };

    ctrl.init();
}

// resolving minification problems
FormsListCtrl.$inject = ['$scope', '$state', '$cookies', 'FormSrvc', '$filter'];
controllersModule.controller('FormsListCtrl', FormsListCtrl);

