function FormCtrl($s, $params, $state, FormSrvc) {
    'use strict';

/*===============================================================
                       VARIABLES INITIALIZATION
===============================================================*/

    $s.ctrl = {};

    var main = $s.main;
    var ctrl = $s.ctrl;

    main.page = 'form';

    ctrl.objects = [];
    ctrl.form = {};

    ctrl.grid = {
        caption: 'The list of tasks',
        itemsByPage: 25
    };

    // Semantic UI init
    $('.dimmer.modals').dimmer('hide');

/*===============================================================
                        PRIVATE FUNCTIONS
===============================================================*/

    function checkPermission(permission) {
        if (!ctrl.form || !ctrl.form.objpermissions) { return false; }

        return ~ctrl.form.objpermissions.indexOf(permission);
    }


/*===============================================================
                        EVENT HANDLERS
===============================================================*/

    $s.$on('login', function (event, data) {
        ctrl.forms = data;
    });

    $s.$on('logout', function (data) {
        main.doExit()
            .then(function() {
                ctrl.forms = [];
            });
    });

    $s.$on('goMain', function (data) {
        $state.go('forms', { reload: true, inherit: false, notify: true });
    });

    ctrl.formRowClick = function(row) {
        if (ctrl.isUpdate()) {
            ctrl.editObject(row._id);

        } else if (ctrl.isRead()) {
            ctrl.openObject(row._id);
        }
    };

/*===============================================================
                        EXPORTED FUNCTIONS
===============================================================*/

    ctrl.isRead = function() {
        return checkPermission('R');
    };

    ctrl.isUpdate = function() {
        return checkPermission('U');
    };

    ctrl.isDelete = function() {
        return checkPermission('D');
    };

    ctrl.isCreate = function() {
        return checkPermission('C');
    };

    ctrl.addNewObject = function() {
        $state.go('object.create', {form: $params.form}, { reload: true, inherit: false, notify: true });
    };

    ctrl.editObject = function(id) {
        $state.go('object.edit', {form: $params.form, id: id}, { reload: true, inherit: false, notify: true });
    };

    ctrl.openObject = function(id) {
        $state.go('object.open', {form: $params.form, id: id}, { reload: true, inherit: false, notify: true });
    };

    ctrl.deleteObject = function(obj) {
        main.confirmationText = 'Are you sure you want to delete the object?';

        $('#confirmation')
            .modal({
                closable: false,

                onApprove : function() {
                    FormSrvc.deleteObject($params.form, obj._id, main.authToken)
                        .then(function() {
                            ctrl.objects = ctrl.objects.filter(function(currObj) {
                                return currObj._id !== obj._id;
                            });
                        })
                }
            })
            .modal('show');
    };

/*===============================================================
                     CONTROLLER INITIALIZATION
===============================================================*/

    ctrl.init = function() {

        if (!main.loginState) {
            return
        }
        if (!$params.form) {
            $state.go('forms', {}, { reload: true, inherit: false, notify: true });
        }

        FormSrvc.getFormMetadata($params.form, main.authToken)
            .then(function(data) {
                if (data) {
                    ctrl.form = data;

                    if (ctrl.isRead()) {
                        return FormSrvc.getFormObjectsInfo($params.form, main.authToken);
                    }
                }
            })
            .then(function(data) {
                if (data && data.children) {
                    ctrl.objects = data.children;
                }
            })
            .catch(function(err) {
                var errorText =  $s.getErrorText(err);
                alert('An unexpected error occurred, contact your administrator \n' + errorText);
            });
    };

    ctrl.init();
}

// resolving minification problems
FormCtrl.$inject = ['$scope', '$stateParams', '$state', 'FormSrvc', '$filter'];
controllersModule.controller('FormCtrl', FormCtrl);

