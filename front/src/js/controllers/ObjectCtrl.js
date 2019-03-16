function ObjectCtrl($s, $q, $params, FormSrvc, $state, $timeout, UtilSrvc) {
    'use strict';

/*===============================================================
                       VARIABLES INITIALIZATION
===============================================================*/

    // initialization block
    $s.ctrl = {};

    var main = $s.main;
    var ctrl = $s.ctrl;

    // if main.busy set to true, the page dimmer will be shown
    main.page = 'object';

    $s.catalogs = {};
    $s.catalogsMeta = {};
    $s.obj = {};
    ctrl.form = {};
    ctrl.params = $params;
    ctrl.fields = [];
    ctrl.fieldsDisplayNames = {};
    ctrl.state = $state.$current.name;

    // semantic ui init
    $('.ui.checkbox').checkbox();

/*===============================================================
                        PRIVATE FUNCTIONS
===============================================================*/

    function checkPermission(permission) {
        if (!ctrl.form || !ctrl.form.objpermissions) { return false; }

        return ~ctrl.form.objpermissions.indexOf(permission);
    }

    function loadCatalog(catalog, name) {
        return FormSrvc.getCatalog(catalog, main.authToken)
            .then(function(data) {
                if (!data || !data.children) {
                    throw {summary: 'The server response is empty.'};
                }

                if ($s.catalogs[catalog] && ($s.catalogs[catalog].length > 0)) { return }

                $s.catalogs[catalog] = data.children;

            })
            .catch(function(err) {
                var errorText = $s.getErrorText(err);
                alert('An error occurred while receiving the list of directory values: ' + name + '. \nPlease, contact your administrator.\n' + errorText);
            });
    }


    function loadCatalogMeta(catalog, name) {
        return FormSrvc.getCatalogMeta(catalog, main.authToken)
            .then(function(data) {
                if (!data) {
                    throw {summary: 'The server response is empty.'};
                }

                if ($s.catalogsMeta[catalog] && ($s.catalogsMeta[catalog].length > 0)) { return }

                $s.catalogsMeta[catalog] = data;

            })
            .catch(function(err) {
                var errorText = $s.getErrorText(err);
                alert('An error occurred while receiving the list of directory values: ' + name + '. \nPlease, contact your administrator.\n' + errorText);
            });
    }

    function getFormMetadata(formType) {
        return FormSrvc.getFormMetadata(formType, main.authToken);
    }

    function logout() {
        main.doExit()
            .then(function() {
                $.obj = {};
                ctrl.form = {};
            });
    }

    function goMain() {
        $state.go('forms', { reload: true, inherit: false, notify: true });
    }

    function leavePage (source) {
         if ($s.clientForm.$pristine) {
            if      (source == 'logout') {logout();}
            else if (source == 'goMain') {goMain();}
            return;
        }

        main.confirmationText = 'Are you sure you want to logout without saving changes?';

        $('#confirmation')
            .modal({
                closable: false,

                onApprove : function() {
                    if      (source == 'logout') {logout();}
                    else if (source == 'goMain') {goMain();}
                }
            })
            .modal('show');
    }
/*===============================================================
                        EVENT HANDLERS
===============================================================*/

    $s.$on('closeObject', function (event, data) {
        ctrl.closeForm();
    });

    $s.$on('logout', function (event, data) {
        leavePage('logout');
    });

    $s.$on('goMain', function (event, data) {
        leavePage('goMain');
    });

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

    $s.loadCatalog = loadCatalog;
    $s.loadCatalogMeta = loadCatalogMeta;

    /// Submits form object to the server
    ctrl.submit = function(action) {
        if (action == 'save') {
            if (!$s.obj._id) {
                main.showBusyDimmer();
                return FormSrvc.newForm($s.obj, $params.form, main.authToken)
                    .then(function(data) {

                        if (data.Id) {
                            $('#success-dimmer').dimmer('show');

                            $timeout(function() {
                                $s.obj = {};
                                $state.go('form', {form: $params.form}, { reload: true, inherit: false, notify: true });
                                $('#success-dimmer').dimmer('hide');
                            }, 1100);
                        } else {
                            throw {summary: 'Couldn\'t save the form. Id: ' + data.Id};
                        }
                     })
                    .catch(function(err) {
                        var errorText = $s.getErrorText(err);
                        alert('An unexpected error occurred, contact your administrator \n' + errorText);
                    })
                    .finally(function() {
                        main.hideBusyDimmer();
                    });
            } else {
                main.showBusyDimmer();
                return FormSrvc.updateForm($s.obj._id, $s.obj, $params.form, main.authToken)
                    .then(function() {
                        $('#success-dimmer').dimmer('show');

                        $timeout(function() {
                            $s.obj = {};
                            $state.go('form', {form: $params.form}, { reload: true, inherit: false, notify: true });
                            $('#success-dimmer').dimmer('hide');
                        }, 1100);
                     })
                    .catch(function(err) {
                        var errorText = $s.getErrorText(err);
                        alert('An unexpected error occurred, contact your administrator \n' + errorText);
                    })
                    .finally(function() {
                        main.hideBusyDimmer();
                    });
            }
        }
    };

    /// Closes form (returns to the tasks page)
    ctrl.closeForm = function() {
        if ($s.clientForm.$pristine) {
            $state.go('form', {form: $params.form}, {reload: true, inherit: false, notify: true});
            return;
        }

        main.confirmationText = 'Are you sure you want to logout without saving changes?';

        $('#confirmation')
            .modal({
                closable: false,

                onApprove : function() {
                    $s.ctrl = {};
                    $state.go('form', {form: $params.form}, {reload: true, inherit: false, notify: true});
                }
            })
            .modal('show');
    };

/*===============================================================
                     CONTROLLER INITIALIZATION
===============================================================*/

    // data initialization for Task
    ctrl.init = function() {

        if (!main.loginState) {
            return
        }
        main.showBusyDimmer();

        getFormMetadata($params.form)
            .then(function(data) {
                ctrl.form = data;
                $s.obj._class = ctrl.form.class;
                ctrl.fields = data.fields;

                var ro = ($state.$current.name == 'object.open');

                ctrl.fields.forEach(function(field) {
                    ctrl.fieldsDisplayNames[field.name] = field.displayName;

                    if (ro) {
                        field.readonly = true;
                    }
                });

                if ($params.id) {
                    return FormSrvc.getFormObject($params.form, $params.id, main.authToken);
                }
            })
            .then(function(data) {
                if (data && data._id) {
                    UtilSrvc.convertDateStringsToDates(data);
                    $s.obj = data;

                    if ($s.clientForm) {
                        $s.clientForm.$setPristine();
                    }
                }
            })
            .catch(function(err) {
                var errorText = $s.getErrorText(err);
                alert('An unexpected error occurred, contact your administrator \n' + errorText);
            })
            .finally(function() {
                main.hideBusyDimmer();
            });
    };

    ctrl.init();
}

// resolving minification problems
ObjectCtrl.$inject = ['$scope', '$q', '$stateParams', 'FormSrvc', '$state', '$timeout', 'UtilSrvc'];
controllersModule.controller('ObjectCtrl', ObjectCtrl);
