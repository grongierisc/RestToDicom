'use strict';

// Utils service
function UtilSrvc($cookies, $filter) {

    function stringToDate(_date, _format, _delimiter) {
        var formatLowerCase = _format.toLowerCase();
        var formatItems = formatLowerCase.split(_delimiter);
        var dateItems = _date.split(_delimiter);
        var monthIndex = formatItems.indexOf("mm");
        var dayIndex = formatItems.indexOf("dd");
        var yearIndex = formatItems.indexOf("yyyy");
        var month = parseInt(dateItems[monthIndex]);
        month -= 1;
        var formatedDate = new Date(dateItems[yearIndex], month, dateItems[dayIndex]);
        return formatedDate;
    }

    function toJSONLocal(date) {
        if (!(date instanceof Date)) return "";
        date.setMinutes(date.getMinutes() - date.getTimezoneOffset());
        return new Date(date.toJSON().slice(0, 10));
    }

    return {
        // get cookie by name
        readCookie:
        function (name) {
            return $cookies[name];
        },
        // Function to get value of property of the object by name
        // Example:
        // var obj = {car: {body: {company: {name: 'Mazda'}}}};
        // getPropertyValue(obj, 'car.body.company.name')
        getPropertyValue:
        function (item, propertyStr, propertyType) {
            var value = item;

            try {
                var properties = propertyStr.split('.');

                for (var i = 0; i < properties.length; i++) {
                    value = value[properties[i]];

                    if (value !== Object(value))
                        break;
                }
            }
            catch (ex) {
                console.log('An unexpected error happened.');
            }

            switch (propertyType) {
                case 'datetime':
                    value = value.slice(0, 16);
                    break;
                case 'message':
                    value += (value.length > 25) ? '..' : '';
                    break;
                default:
                    break;
            }

            if (propertyType == 'datetime') {
                value = value.slice(0, 16);
            } else if (propertyType == 'message') {

            }

            return (value == undefined) ? '' : value;
        },
        convertDateStringsToDates:
        function (input) {
            var regexIso8601 = /^(\d{4}|\+\d{6})(?:-(\d{2})(?:-(\d{2})(?:T(\d{2}):(\d{2}):(\d{2})\.(\d{1,})(Z|([\-+])(\d{2}):(\d{2}))?)?)?)?$/;
            var sqlDM = /^\d{2}\/\d{2}\/\d{4}$/;
            // Ignore things that aren't objects.
            if (typeof input !== "object") return input;

            for (var key in input) {
                if (!input.hasOwnProperty(key)) continue;

                var value = input[key];
                var match;
                // Check for string properties which look like dates.
                if (typeof value === "string" && (match = value.match(regexIso8601))) {
                    var milliseconds = Date.parse(match[0]);
                    if (!isNaN(milliseconds)) {
                        input[key] = new Date(milliseconds);
                    }
                } else if (typeof value === "string" && (match = value.match(sqlDM))) {
                    input[key] = stringToDate(value, "mm/dd/yyyy", "/")
                } else if (typeof value === "object") {
                    // Recurse into object
                    this.convertDateStringsToDates(value);
                }
            }
        },
        toJSONLocal: toJSONLocal,
        convertDatestoJSONLocal:
        function (input) {
            if (typeof input !== "object") return input;

            for (var key in input) {
                if (!input.hasOwnProperty(key)) continue;

                var value = input[key];
                // Check for string properties which look like dates.
                if (value instanceof Date) {
                    input[key] = toJSONLocal(value);
                } else if (typeof value == 'undefined') {
                    input[key] = '';
                } else if ((typeof value === "object") && !(value instanceof Date)) {
                    // Recurse into object
                    this.convertDatestoJSONLocal(value);
                }
            }
        },
        getCalendarLocalization:
        function () {
            return {
                days: ['Sun', 'Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat'],
                months: ['January', 'February', 'March', 'April', 'May', 'June', 'July', 'August', 'September', 'October', 'November', 'December'],
                monthsShort: ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'],
                today: 'Today',
                now: 'Now',
                am: 'AM',
                pm: 'PM'
            };
        },

        getLanguageName:
        function (domain) {
            var languageList = {
                sq: "Albanian",
                ar: "Arabian",
                hy: "Armenian",
                az: "Azeri",
                be: "Belarusian",
                bs: "Bosnian",
                eu: "Basque",
                bg: "Bulgarian",
                ca: "Catalan",
                hr: "Croatian",
                cs: "Czech",
                zh: "Chinese",
                da: "Danish",
                nl: "Dutch",
                en: "English",
                et: "Estonian",
                eo: "Esperanto",
                fi: "Finnish",
                fr: "French",
                ka: "Georgian",
                de: "German",
                el: "Greek",
                he: "Hebrew",
                hu: "Hungarian",
                is: "Icelandic",
                id: "Indonesian",
                it: "Italian",
                ja: "Japanese",
                kk: "Kazakh",
                ko: "Korean",
                la: "Latin",
                lv: "Latvian",
                lt: "Lithuanian",
                mk: "Macedonian",
                ms: "Malay",
                mt: "Maltese",
                no: "Norwegian",
                pl: "Polish",
                pt: "Portuguese Brazil",
                ro: "Romanian",
                ru: "Russian",
                es: "Spanish",
                sr: "Serbian",
                sk: "Slovak",
                sl: "Slovenian",
                sv: "Swedish",
                th: "Thai",
                tr: "Turkish",
                uk: "Ukrainian",
                vi: "Vietnamese"
            }

            return languageList[domain];
        }
    }
}
// resolving minification problems
UtilSrvc.$inject = ['$cookies', '$filter'];
servicesModule.factory('UtilSrvc', UtilSrvc);
