/*
    http://www.JSON.org/json2.js
    2008-11-19

    Public Domain.

    NO WARRANTY EXPRESSED OR IMPLIED. USE AT YOUR OWN RISK.

    See http://www.JSON.org/js.html

    This file creates a global JSON object containing two methods: stringify
    and parse.

        JSON.stringify(value, replacer, space)
            value       any JavaScript value, usually an object or array.

            replacer    an optional parameter that determines how object
                        values are stringified for objects. It can be a
                        function or an array of strings.

            space       an optional parameter that specifies the indentation
                        of nested structures. If it is omitted, the text will
                        be packed without extra whitespace. If it is a number,
                        it will specify the number of spaces to indent at each
                        level. If it is a string (such as '\t' or '&nbsp;'),
                        it contains the characters used to indent at each level.

            This method produces a JSON text from a JavaScript value.

            When an object value is found, if the object contains a toJSON
            method, its toJSON method will be called and the result will be
            stringified. A toJSON method does not serialize: it returns the
            value represented by the name/value pair that should be serialized,
            or undefined if nothing should be serialized. The toJSON method
            will be passed the key associated with the value, and this will be
            bound to the object holding the key.

            For example, this would serialize Dates as ISO strings.

                Date.prototype.toJSON = function (key) {
                    function f(n) {
                        // Format integers to have at least two digits.
                        return n < 10 ? '0' + n : n;
                    }

                    return this.getUTCFullYear()   + '-' +
                         f(this.getUTCMonth() + 1) + '-' +
                         f(this.getUTCDate())      + 'T' +
                         f(this.getUTCHours())     + ':' +
                         f(this.getUTCMinutes())   + ':' +
                         f(this.getUTCSeconds())   + 'Z';
                };

            You can provide an optional replacer method. It will be passed the
            key and value of each member, with this bound to the containing
            object. The value that is returned from your method will be
            serialized. If your method returns undefined, then the member will
            be excluded from the serialization.

            If the replacer parameter is an array of strings, then it will be
            used to select the members to be serialized. It filters the results
            such that only members with keys listed in the replacer array are
            stringified.

            Values that do not have JSON representations, such as undefined or
            functions, will not be serialized. Such values in objects will be
            dropped; in arrays they will be replaced with null. You can use
            a replacer function to replace those with JSON values.
            JSON.stringify(undefined) returns undefined.

            The optional space parameter produces a stringification of the
            value that is filled with line breaks and indentation to make it
            easier to read.

            If the space parameter is a non-empty string, then that string will
            be used for indentation. If the space parameter is a number, then
            the indentation will be that many spaces.

            Example:

            text = JSON.stringify(['e', {pluribus: 'unum'}]);
            // text is '["e",{"pluribus":"unum"}]'


            text = JSON.stringify(['e', {pluribus: 'unum'}], null, '\t');
            // text is '[\n\t"e",\n\t{\n\t\t"pluribus": "unum"\n\t}\n]'

            text = JSON.stringify([new Date()], function (key, value) {
                return this[key] instanceof Date ?
                    'Date(' + this[key] + ')' : value;
            });
            // text is '["Date(---current time---)"]'


        JSON.parse(text, reviver)
            This method parses a JSON text to produce an object or array.
            It can throw a SyntaxError exception.

            The optional reviver parameter is a function that can filter and
            transform the results. It receives each of the keys and values,
            and its return value is used instead of the original value.
            If it returns what it received, then the structure is not modified.
            If it returns undefined then the member is deleted.

            Example:

            // Parse the text. Values that look like ISO date strings will
            // be converted to Date objects.

            myData = JSON.parse(text, function (key, value) {
                var a;
                if (typeof value === 'string') {
                    a =
/^(\d{4})-(\d{2})-(\d{2})T(\d{2}):(\d{2}):(\d{2}(?:\.\d*)?)Z$/.exec(value);
                    if (a) {
                        return new Date(Date.UTC(+a[1], +a[2] - 1, +a[3], +a[4],
                            +a[5], +a[6]));
                    }
                }
                return value;
            });

            myData = JSON.parse('["Date(09/09/2001)"]', function (key, value) {
                var d;
                if (typeof value === 'string' &&
                        value.slice(0, 5) === 'Date(' &&
                        value.slice(-1) === ')') {
                    d = new Date(value.slice(5, -1));
                    if (d) {
                        return d;
                    }
                }
                return value;
            });


    This is a reference implementation. You are free to copy, modify, or
    redistribute.

    This code should be minified before deployment.
    See http://javascript.crockford.com/jsmin.html

    USE YOUR OWN COPY. IT IS EXTREMELY UNWISE TO LOAD CODE FROM SERVERS YOU DO
    NOT CONTROL.
*/

/*jslint evil: true */

/*global JSON */

/*members "", "\b", "\t", "\n", "\f", "\r", "\"", JSON, "\\", apply,
    call, charCodeAt, getUTCDate, getUTCFullYear, getUTCHours,
    getUTCMinutes, getUTCMonth, getUTCSeconds, hasOwnProperty, join,
    lastIndex, length, parse, prototype, push, replace, slice, stringify,
    test, toJSON, toString, valueOf
*/

// Create a JSON object only if one does not already exist. We create the
// methods in a closure to avoid creating global variables.

if (!this.JSON) {
    JSON = {};
}
(function () {

    function f(n) {
        // Format integers to have at least two digits.
        return n < 10 ? '0' + n : n;
    }

    if (typeof Date.prototype.toJSON !== 'function') {

        Date.prototype.toJSON = function (key) {

            return this.getUTCFullYear()   + '-' +
                 f(this.getUTCMonth() + 1) + '-' +
                 f(this.getUTCDate())      + 'T' +
                 f(this.getUTCHours())     + ':' +
                 f(this.getUTCMinutes())   + ':' +
                 f(this.getUTCSeconds())   + 'Z';
        };

        String.prototype.toJSON =
        Number.prototype.toJSON =
        Boolean.prototype.toJSON = function (key) {
            return this.valueOf();
        };
    }

    var cx = /[\u0000\u00ad\u0600-\u0604\u070f\u17b4\u17b5\u200c-\u200f\u2028-\u202f\u2060-\u206f\ufeff\ufff0-\uffff]/g,
        escapable = /[\\\"\x00-\x1f\x7f-\x9f\u00ad\u0600-\u0604\u070f\u17b4\u17b5\u200c-\u200f\u2028-\u202f\u2060-\u206f\ufeff\ufff0-\uffff]/g,
        gap,
        indent,
        meta = {    // table of character substitutions
            '\b': '\\b',
            '\t': '\\t',
            '\n': '\\n',
            '\f': '\\f',
            '\r': '\\r',
            '"' : '\\"',
            '\\': '\\\\'
        },
        rep;


    function quote(string) {

// If the string contains no control characters, no quote characters, and no
// backslash characters, then we can safely slap some quotes around it.
// Otherwise we must also replace the offending characters with safe escape
// sequences.

        escapable.lastIndex = 0;
        return escapable.test(string) ?
            '"' + string.replace(escapable, function (a) {
                var c = meta[a];
                return typeof c === 'string' ? c :
                    '\\u' + ('0000' + a.charCodeAt(0).toString(16)).slice(-4);
            }) + '"' :
            '"' + string + '"';
    }


    function str(key, holder) {

// Produce a string from holder[key].

        var i,          // The loop counter.
            k,          // The member key.
            v,          // The member value.
            length,
            mind = gap,
            partial,
            value = holder[key];

// If the value has a toJSON method, call it to obtain a replacement value.

        if (value && typeof value === 'object' &&
                typeof value.toJSON === 'function') {
            value = value.toJSON(key);
        }

// If we were called with a replacer function, then call the replacer to
// obtain a replacement value.

        if (typeof rep === 'function') {
            value = rep.call(holder, key, value);
        }

// What happens next depends on the value's type.

        switch (typeof value) {
        case 'string':
            return quote(value);

        case 'number':

// JSON numbers must be finite. Encode non-finite numbers as null.

            return isFinite(value) ? String(value) : 'null';

        case 'boolean':
        case 'null':

// If the value is a boolean or null, convert it to a string. Note:
// typeof null does not produce 'null'. The case is included here in
// the remote chance that this gets fixed someday.

            return String(value);

// If the type is 'object', we might be dealing with an object or an array or
// null.

        case 'object':

// Due to a specification blunder in ECMAScript, typeof null is 'object',
// so watch out for that case.

            if (!value) {
                return 'null';
            }

// Make an array to hold the partial results of stringifying this object value.

            gap += indent;
            partial = [];

// Is the value an array?

            if (Object.prototype.toString.apply(value) === '[object Array]') {

// The value is an array. Stringify every element. Use null as a placeholder
// for non-JSON values.

                length = value.length;
                for (i = 0; i < length; i += 1) {
                    partial[i] = str(i, value) || 'null';
                }

// Join all of the elements together, separated with commas, and wrap them in
// brackets.

                v = partial.length === 0 ? '[]' :
                    gap ? '[\n' + gap +
                            partial.join(',\n' + gap) + '\n' +
                                mind + ']' :
                          '[' + partial.join(',') + ']';
                gap = mind;
                return v;
            }

// If the replacer is an array, use it to select the members to be stringified.

            if (rep && typeof rep === 'object') {
                length = rep.length;
                for (i = 0; i < length; i += 1) {
                    k = rep[i];
                    if (typeof k === 'string') {
                        v = str(k, value);
                        if (v) {
                            partial.push(quote(k) + (gap ? ': ' : ':') + v);
                        }
                    }
                }
            } else {

// Otherwise, iterate through all of the keys in the object.

                for (k in value) {
                    if (Object.hasOwnProperty.call(value, k)) {
                        v = str(k, value);
                        if (v) {
                            partial.push(quote(k) + (gap ? ': ' : ':') + v);
                        }
                    }
                }
            }

// Join all of the member texts together, separated with commas,
// and wrap them in braces.

            v = partial.length === 0 ? '{}' :
                gap ? '{\n' + gap + partial.join(',\n' + gap) + '\n' +
                        mind + '}' : '{' + partial.join(',') + '}';
            gap = mind;
            return v;
        }
    }

// If the JSON object does not yet have a stringify method, give it one.

    if (typeof JSON.stringify !== 'function') {
        JSON.stringify = function (value, replacer, space) {

// The stringify method takes a value and an optional replacer, and an optional
// space parameter, and returns a JSON text. The replacer can be a function
// that can replace values, or an array of strings that will select the keys.
// A default replacer method can be provided. Use of the space parameter can
// produce text that is more easily readable.

            var i;
            gap = '';
            indent = '';

// If the space parameter is a number, make an indent string containing that
// many spaces.

            if (typeof space === 'number') {
                for (i = 0; i < space; i += 1) {
                    indent += ' ';
                }

// If the space parameter is a string, it will be used as the indent string.

            } else if (typeof space === 'string') {
                indent = space;
            }

// If there is a replacer, it must be a function or an array.
// Otherwise, throw an error.

            rep = replacer;
            if (replacer && typeof replacer !== 'function' &&
                    (typeof replacer !== 'object' ||
                     typeof replacer.length !== 'number')) {
                throw new Error('JSON.stringify');
            }

// Make a fake root object containing our value under the key of ''.
// Return the result of stringifying the value.

            return str('', {'': value});
        };
    }


// If the JSON object does not yet have a parse method, give it one.

    if (typeof JSON.parse !== 'function') {
        JSON.parse = function (text, reviver) {

// The parse method takes a text and an optional reviver function, and returns
// a JavaScript value if the text is a valid JSON text.

            var j;

            function walk(holder, key) {

// The walk method is used to recursively walk the resulting structure so
// that modifications can be made.

                var k, v, value = holder[key];
                if (value && typeof value === 'object') {
                    for (k in value) {
                        if (Object.hasOwnProperty.call(value, k)) {
                            v = walk(value, k);
                            if (v !== undefined) {
                                value[k] = v;
                            } else {
                                delete value[k];
                            }
                        }
                    }
                }
                return reviver.call(holder, key, value);
            }


// Parsing happens in four stages. In the first stage, we replace certain
// Unicode characters with escape sequences. JavaScript handles many characters
// incorrectly, either silently deleting them, or treating them as line endings.

            cx.lastIndex = 0;
            if (cx.test(text)) {
                text = text.replace(cx, function (a) {
                    return '\\u' +
                        ('0000' + a.charCodeAt(0).toString(16)).slice(-4);
                });
            }

// In the second stage, we run the text against regular expressions that look
// for non-JSON patterns. We are especially concerned with '()' and 'new'
// because they can cause invocation, and '=' because it can cause mutation.
// But just to be safe, we want to reject all unexpected forms.

// We split the second stage into 4 regexp operations in order to work around
// crippling inefficiencies in IE's and Safari's regexp engines. First we
// replace the JSON backslash pairs with '@' (a non-JSON character). Second, we
// replace all simple value tokens with ']' characters. Third, we delete all
// open brackets that follow a colon or comma or that begin the text. Finally,
// we look to see that the remaining characters are only whitespace or ']' or
// ',' or ':' or '{' or '}'. If that is so, then the text is safe for eval.

            if (/^[\],:{}\s]*$/.
test(text.replace(/\\(?:["\\\/bfnrt]|u[0-9a-fA-F]{4})/g, '@').
replace(/"[^"\\\n\r]*"|true|false|null|-?\d+(?:\.\d*)?(?:[eE][+\-]?\d+)?/g, ']').
replace(/(?:^|:|,)(?:\s*\[)+/g, ''))) {

// In the third stage we use the eval function to compile the text into a
// JavaScript structure. The '{' operator is subject to a syntactic ambiguity
// in JavaScript: it can begin a block or an object literal. We wrap the text
// in parens to eliminate the ambiguity.

                j = eval('(' + text + ')');

// In the optional fourth stage, we recursively walk the new structure, passing
// each name/value pair to a reviver function for possible transformation.

                return typeof reviver === 'function' ?
                    walk({'': j}, '') : j;
            }

// If the text is not JSON parseable, then a SyntaxError is thrown.

            throw new SyntaxError('JSON.parse');
        };
    }
})();
/**
 * @autor vutreras
 */

//@jsfn R121.SectionMgr.params2json(parray)
//Converts parameter array received from serializing the form into JSON

//agrego esto para extender la libreria json2.js y agregarle la funcion "params2json"
if (!this.JSON) {
  JSON = {};
}

/**
* transforma un array a objeto.
* @param {array} - d - array de valores
* @return objeto
*/
JSON.params2json = function(d) {
	if (d.constructor != Array) {
	    return d;
	}
	var data={};
	for(var i=0;i<d.length;i++) {
		     if (typeof data[d[i].name] != 'undefined') {
		         if (data[d[i].name].constructor!= Array) {
		             data[d[i].name]=[data[d[i].name],d[i].value];
		         } else {
		             data[d[i].name].push(d[i].value);
		         }
		     } else {
		         data[d[i].name]=d[i].value;
		     }
	}
	return data;
};

/**
* transforma un form a un objeto
* @param {object} - form - formulario
* @return objeto
*/
JSON.form2json = function(form) {
	return JSON.params2json(form.serializeArray());
};

/**
* transforma un form a json
* @param {object} - form - formulario
* @return formulario en json
*/
JSON.form2json_stringify = function(form) {
	return JSON.stringify(JSON.params2json(form.serializeArray()));
};

/**
 * JSON.stringify simplificado
 * @param obj
 * @return
 */
function toJson(obj) {
	return (obj != undefined) ? JSON.stringify(obj) : undefined;
}

/**
 * realiza un eval de un json
 * @param json
 * @return
 */
function jsonToObject(json) {
	return eval('(' + json + ')');
}

/*
 * Clona todos los atributos de un objeto ademas de las funciones miembros del objeto
 */
JSON.clone = function clone(o) {
	function OneShotConstructor(){}
	OneShotConstructor.prototype = o;
	return new OneShotConstructor();
};
if( window.console && window.console.firebug ) {
	$('body').append("<div onclick=\"this.style.display = 'none'\" style='position:absolute; top:0; width:100%; padding: 5px 0; background: #ff7; border-bottom: 1px solid #770; font-weight: bold; text-align: center; cursor: pointer;'>"+
	"Firebug puede hacer que esta p\u00e1gina web funcione lenta, le sugerimos que lo desactive para esta p\u00e1gina web. Haga clic aqu\u00ed para cerrar esta advertencia.</div>");
}
var REGX_NUMERO_TELEFONICO = /^[0-9+-]$/;

/**
* Definicion de las funciones de log.
*/
if (!this.console) {
  var console = {
  	info: function(s){
			var text = '';
			for( var i = 0; i < arguments.length; i++ ) {
				var arg = arguments[i];
				if(typeof(arg) != "object"){
					text+= arg + ', ';
				}else{
					text+= JSON.stringify(arg) + ', ';
				}
			}
			if (window['log']){ log.info(text); } //else { alert('INFO: ' + text); }
		},	
  	debug: function(s){
			var text = '';
			for( var i = 0; i < arguments.length; i++ ) {
				var arg = arguments[i];
				if(typeof(arg) != "object"){
					text+= arg + ', ';
				}else{
					text+= JSON.stringify(arg) + ', ';
				}
			}
			if (window['log']) { log.debug(text); } //else { alert('DEBUG: ' + text); }
		},	
  	warn: function(s){
			var text = '';
			for( var i = 0; i < arguments.length; i++ ) {
				var arg = arguments[i];
				if(typeof(arg) != "object"){
					text+= arg + ', ';
				}else{
					text+= JSON.stringify(arg) + ', ';
				}
			}
			if (window['log']) { log.warn(text); } //else { alert('WARN: ' + text); }
		},	
  	error: function(s){
			var text = '';
			for( var i = 0; i < arguments.length; i++ ) {
				var arg = arguments[i];
				if(typeof(arg) != "object"){
					text+= arg + ', ';
				}else{
					text+= JSON.stringify(arg) + ', ';
				}
			}
			if (window['log']) { log.error(text); } //else { alert('ERROR: ' + text); }
		}
  }
}

/**
 * Clona un objeto
 * @param {Object} o
 */
function clone(o) {
	return eval(uneval(o));
}

/**
 * Clona un objeto
 * @param {Object} from
 */
function clone2(from) {
	
	if(from == null || typeof from != "object") return from;
	
	if(from.constructor != Object && from.constructor != Array) return from;
	
	if(from.constructor == Date ||
		from.constructor == RegExp ||
		from.constructor == Function ||
		from.constructor == String ||
		from.constructor == Number ||
		from.constructor == Boolean)
	return new from.constructor(from);
	
	var to = {};
	to = to || new from.constructor();
	
	for (var name in from) {
		to[name] = typeof to[name] == "undefined" ? this.clone(from[name]) : to[name];
	}
	
	return to;
}
/**
 * @autor vutreras
 */

/**
 * retorna true si el numero es par
 */
Number.prototype.isPair = function()  { 
   return this % 2 == 0; 
}
/**
 * @autor vutreras
 */


/**
 * Elimina un elemento de un array.
 * @see Array Remove - By John Resig (MIT Licensed)
 * @author John Resig (MIT Licensed) 
 */
Array.prototype.removeElement = function(from, to) {
	try {
		var rest = this.slice((to || from) + 1 || this.length);
		this.length = from < 0 ? this.length + from : from;
		return this.push.apply(this, rest);
	} catch(err) {
	}
};

/**
 * 	retorna el indice del elemento. Realiza diferentes tipos de comparaciones de acuerdo al tipo de dato
 	@param {object} - element - objeto que se desea buscar en el array
 	@param {function} - fcomparacion - funcion de comparacion
 	@example
	 	-- uso normal
	 	var arr = ['a', 'b', '4', 'h', 'l', 'm'];
	
		console.info(arr.indexOfElement('4'));
	 
	 	-- uso con objetos que tienen el atributo id
	 	var arr = [{id:'a'},{id:'b'},{id:'4'},{id:'h'},{id:'l'},{id:'m'}];
	
		console.info(arr.indexOfElement( {id: '4'} ));
		
		--uso con una funcion de comparacion
		var arr = [{id:'a'},{id:'b'},{id:'4'},{id:'h'},{id:'l'},{id:'m'}];
	
		var comp = function(element, el) {
			return element === el.id;
		}
		
		console.info(arr.indexOfElement('4'));
		
	@return indice del elemento en el array, si no encuentra se retorna -1.	
 * 
 */
Array.prototype.indexOfElement = function(element, fcomparacion) {
	var result = -1;
	if (this.length) {
		$.each(this, function (index, el) {
			
			if (fcomparacion) {
				if (fcomparacion(element, el)) {
					result = index;
					return;
				}
			} else {
				if (element.id && Number(element.id) === Number(el.id)) {
					result = index;
					return;
				} else if (element === el) {
					result = index;
					return;
				}
			}
		})
	}
	return result;
};

/**
 * Reemplaza un elemento en un array
 * @param {object} - element - elemento que se desea poner en el array
 * @param {number} - i - indice donde se desea reemplazar el elemento.
 */
Array.prototype.replaceElement = function(element, i) {
	
	if (!i) {
		i = this.indexOfElement(element);
	}
	
	if (i >= 0) {
		this[i] = element;
	}
};

/**
 * refresca un elemento en un array - si no existe lo agrega, si existe lo reeplaza
 * @param {object} - element - elemento que se desea poner en el array
 * @param {number} - i - indice donde se desea reemplazar el elemento.
 */
Array.prototype.refreshElement = function(element, i) {
	
	if (!i) {
		i = this.indexOfElement(element);
	}
	
	if (i >= 0) {
		this[i] = element;
	}else{
		this.push(element);
	}
};

/**
 * 
 * Clase de utilidades de arrays
 */
ArrayUtils = {
	
	/**
	 * comprueba si un array es vacio
	 * @param {Object} arr
	 */
	isEmpty: function(arr) {
		return arr == undefined || arr.length == 0;
	},
	
	/**
	 * comprueba si un array no es vacio
	 * @param {Object} arr
	 */
	isNotEmpty: function(arr) {
		return arr && arr.length && arr.length > 0;
	}
};
/**
 * @autor vutreras
 */

/**
 * retorna true si el string es un boolean 'true'
 */
String.prototype.bool = function() {
    return (/^true$/i).test(this);
};

/**
 * retorna true si el string esta vacio
 */
String.prototype.blank = function() {
	return /^\s*$/.test(this);
}

/**
 * retorna true si un string comiensa con un patron
 * @param {string} - str - patron de busqueda
 * @return true o false
 */
String.prototype.startsWith = function(str) {
	return (this.match("^"+str)==str);
}

/**
 * retorna true si un string termina con un patron
 * @param {string} - str - patron de busqueda
 * @return true o false
 */
String.prototype.endsWith = function(str) {
	return (this.match(str+"$")==str);
}

/**
 * elimina los espacios de los extremos de un string.
 * @return objeto string sin espacios
 */
String.prototype.trim = function() {
	return (this.replace(/^[\s\xA0]+/, "").replace(/[\s\xA0]+$/, ""));
}

/**
 * 
 */
String.prototype.reverse = function(){
	var splitext = this.split("");
	var revertext = splitext.reverse();
	return revertext.join("");
}

/**
 * elimina los espacios de los extremos de un string.
 * @return objeto string sin espacios
 */
String.prototype.scapeTagsHTML = function() {
	return (this.replace(/</gi, "&lt;").replace(/>/gi, "&gt;"));
}

/**
 * Realiza una busqueda de string - utiliza el estandar sql que permite utilizar el caracter %
 * @param {string} - str - string que se desea buscar
 * @param {boolean} - casesve - true: case-sensitive
 * @example
 *  	var criterio = '%tinuum%';
 *  	
 *  	console.info( criterio.inStr('Hola continuum') ); 	//resultado true
 *  
 *  	var criterio = '%tinuu';
 *  	
 *  	console.info( criterio.inStr('Hola continuum') ); 	//resultado false
 *  @return true: se encontro el valor, false: no se encontro el valor
 */
String.prototype.inStr = function(str, casesve){
	
	if (str) {
	
		str = (!casesve) ? str.toString().toLowerCase() : str.toString();
		var this_ = this.toString();
		
		if (this_.startsWith('%') && this_.endsWith("%")) { //start and end
			var s = this_.substring(1,this_.length-1);
			var ok = str.search((!casesve) ? s.toLowerCase() : s) != -1;
			return ok;
		}else if (this_.startsWith('%')) {	//start
			var s = this_.substring(1);
			var ok = str.endsWith((!casesve) ? s.toLowerCase() : s);
			return ok;
		} else if (this_.endsWith('%')) { //end
			var s = this_.substring(0,this_.length-1);
			var ok = (str.startsWith((!casesve) ? s.toLowerCase() : s));
			return ok;
		} else {
			var s = this_;
			var ok = str.search((!casesve) ? s.toLowerCase() : s) != -1;
			return ok;
		}
		
	} else {
		return false;
	}
}

/**
 * escapa el string a HTML
 */
String.prototype.scapeToHTML = function() {
	/*
	var stmp = ''; 	
	var s = this;

	for(var i = 0; i < s.length; i++) {

		var c = s.charAt(i);

		if (c == '\u00F1') {
			stmp+='&ntilde;';
		} else if (c == '\u00D1') {
			stmp+='&Ntilde;';	
		} else if (c === 'á') {
			stmp+='&aacute;';
		} else if (c === 'Á') {
			stmp+='&Aacute;';		
		} else if (c === 'é') {
			stmp+='&eacute;';
		} else if (c === 'É') {
			stmp+='&Eacute;';			
		} else if (c === 'í') {
			stmp+='&iacute;';
		} else if (c === 'Í') {
			stmp+='&Iacute;';
		} else if (c === 'ó') {
			stmp+='&oacute;';
		} else if (c === 'Ó') {
			stmp+='&Oacute;';
		} else if (c === 'ú') {
			stmp+='&uacute;';
		} else if (c === 'Ú') {
			stmp+='&Uacute;';			
		} else {
			stmp+=c;
		}
	}
	return stmp;*/
	/*
	Á 	&Aacute; 	\u00C1
	á 	&aacute; 	\u00E1
	É 	&Eacute; 	\u00C9
	é 	&eacute; 	\u00E9
	Í 	&Iacute; 	\u00CD
	í 	&iacute; 	\u00ED
	Ó 	&Oacute; 	\u00D3
	ó 	&oacute; 	\u00F3
	Ú 	&Uacute; 	\u00DA
	ú 	&uacute; 	\u00FA
	Ü 	&Uuml; 		\u00DC
	ü 	&uuml; 		\u00FC
	Ñ 	&Ntilde; 	\u00D1
	ñ 	&ntilde; 	\u00F1
	*/
	return this
	.replace(/\u00E1/gi,'&aacute;')
	.replace(/\u00E9/gi,'&eacute;')
	.replace(/\u00ED/gi,'&iacute;')
	.replace(/\u00F3/gi,'&oacute;')
	.replace(/\u00FA/gi,'&uacute;')
	.replace(/\u00C1/gi,'&Aacute;')
	.replace(/\u00C9/gi,'&Eacute;')
	.replace(/\u00CD/gi,'&Iacute;')
	.replace(/\u00D3/gi,'&Oacute;')
	.replace(/\u00DA/gi,'&Uacute;')
	.replace(/\u00F1/gi,'&ntilde;')
	.replace(/\u00D1/gi,'&Ntilde;')
	.replace(/\u00FC/gi,'&uacute;')
	.replace(/\u00DC/gi,'&Uacute;');
}

/**
 * 
 * @param {Object} obj
 */
String.prototype.populate = function(obj) {
	var str = this;
	for(var property in obj) {
	    var v = '#' + property + '#';
	    str = eval('str.replace(/' + v + '/g,obj[property])');
	}
	return str;
}

/**
 * 
 * @param {Object} str
 * @param {Object} casesve
 */
Number.prototype.inStr = function(str, casesve){
	return this.toString().inStr(str, casesve);
}

 /**
  * Clase de utilidades de strings
  */
StringUtils = {
	
		/**
		 * StringUtils.isEmpty(undefined) = true
	     * StringUtils.isEmpty("") = true
      	 * StringUtils.isEmpty(" ") = false
      	 * StringUtils.isEmpty("bob") = false
      	 * StringUtils.isEmpty(" bob ") = false
		 * @param {Object} s
		 */
		isEmpty: function(s) {
			return s == undefined || s.length == 0;
		},
		
		/**
		 * StringUtils.isNotEmpty(undefined) = false
	     * StringUtils.isNotEmpty("") = false
      	 * StringUtils.isNotEmpty(" ") = true
      	 * StringUtils.isNotEmpty("bob") = true
      	 * StringUtils.isNotEmpty(" bob ") = true
		 * @param {Object} s
		 */
		isNotEmpty: function(s) {
			return s != undefined && s.length > 0;
		},
		
		/**
		 * StringUtils.isBlank(undefined) = true
	     * StringUtils.isBlank("") = true
      	 * StringUtils.isBlank(" ") = true
      	 * StringUtils.isBlank("bob") = false
      	 * StringUtils.isBlank(" bob ") = false
		 * @param {Object} s
		 */
		isBlank: function(s) {
			if (s == undefined) {
				return true;
			} else {	
				return s.blank();
			}
		},
		
		/**
		 * StringUtils.isNotBlank(undefined) = false
	     * StringUtils.isNotBlank("") = false
      	 * StringUtils.isNotBlank(" ") = false
      	 * StringUtils.isNotBlank("bob") = true
      	 * StringUtils.isNotBlank(" bob ") = true
		 * @param {Object} s
		 */
		isNotBlank: function(s) {
			return !StringUtils.isBlank(s);
		},
		
		/**
		 * retorna true si un string comienza con un patron
		 * @param {object} - obj - objeto string
		 * @param {string} - str - patron de busqueda
		 * @return true o false
		 */
		startsWith: function(obj, str) {
			return (obj.toString().match("^"+str)==str);
		},

		/**
		 * retorna true si un string termina con un patron
		 * @param {object} - obj - objeto string
		 * @param {string} - str - patron de busqueda
		 * @return true o false
		 */
		endsWith: function(obj, str) {
			return (obj.toString().match(str+"$")==str);
		},

		/**
		 * elimina los espacios de los extremos de un string.
		 * @param {object} - obj - objeto string
		 * @return objeto string sin espacios
		 */
		trim: function(obj) {
			if (obj == undefined){
				return undefined;
			} else {
				var s = obj.toString();
				return (s.replace(/^[\s\xA0]+/, "").replace(/[\s\xA0]+$/, ""));
			}
		},
		
		/**
		 * escapa los tags html de un string.
		 * @param {object} - obj - objeto string
		 * @return objeto string sin espacios
		 */
		scapeTagsHTML: function(obj) {
			if (obj == undefined) {
				return undefined;
			} else {
				if (StringUtils.isNotBlank(obj)){
					var s = obj.toString();
					return (s.replace(/</gi, "&lt;").replace(/>/gi, "&gt;"));
				} else {
					return obj;
				}
			}
		}
		
		
};
/**
 * @autor vutreras
 */

/**
 * transforma un date a int en el formato (yyyyMMdd) ej: 20090526
 */
Date.prototype.toIntDate = function() {
	var d = this.getDate().toString();
	if (d.length == 1) {
		d = '0' + d;
	}
	var m = this.getMonth() + 1;
	m = m.toString();
	if (m.length == 1) {
		m = '0' + m;
	}
	return Number(this.getFullYear() + '' + m + '' + d);
}

/**
 * transforma un date a String en el formato (dd/mm/yyyy) ej: 20090526
 */
String.prototype.toFormatDate = function() {
	var fecha = this;
	var anio = fecha.substring(0,4);
	var mes = fecha.substring(4,6);
	var dia = fecha.substring(6);	
	
	return dia + '/' + mes + '/'+ anio;
}

/**
 * transforma un numero en el formato yyyymmdd ej: (20090526) en un objeto Date.
 * @param {Object} format
 */
Number.prototype.toDate = function(format) {
	var fecha = this.toString();
	return fecha.toDate(format);
}


/**
 * transforma un string en el formato yyyymmdd ej: (20090526) en un objeto Date.
 * @param {Object} format
 */
String.prototype.toDate = function(format) {
	var fecha = this.toString();
	if (!format) {
		var anio = parseInt(fecha.substring(0,4), 10);
		var mes = parseInt(fecha.substring(4,6), 10) - 1;
		var dia = parseInt(fecha.substring(6), 10);	
		var d = new Date();
		d.setFullYear(anio, mes, dia);
		return d;
	} else { 
		format = format.toLowerCase();
		if (format === 'yyyymmdd'){
			var anio = parseInt(fecha.substring(0,4), 10);
			var mes = parseInt(fecha.substring(4,6), 10) - 1;
			var dia = parseInt(fecha.substring(6), 10);	
			var d = new Date();
			d.setFullYear(anio, mes, dia);
			return d;
		} else if (format === 'dd/mm/yyyy'){
			var partes = fecha.split('/');
			var dia = parseInt(partes[0], 10);
			var mes = parseInt(partes[1], 10) - 1;
			var anio = parseInt(partes[2], 10);	
			var d = new Date();
			d.setFullYear(anio, mes, dia);
			return d;
		}  else {
			return undefined;
		}
	}
}

/**
 * 
 * Clase de utilidades de fechas
 */
DateUtils = {
	
	/**
	 * transforma un date a int en el formato (yyyyMMdd) ej: 20090526
	 * @param {Object} fecha
	 */
	toIntDate: function(fecha) {
		return fecha.toIntDate();
	},

	/**
	 * transforma un date a String en el formato (dd/mm/yyyy) ej: 20090526
	 * @param {Object} fecha
	 */
	toFormatDate: function(fecha) {
		return fecha.toString().toFormatDate();
	},

	/**
	 * transforma un string en el formato yyyymmdd ej: (20090526) en un objeto Date.
	 * @param {Object} fecha
	 * @param {Object} format
	 */
	toDate: function(fecha, format) {
		return fecha.toString().toDate();
	},
	
	/**
	 * calcula la diferencia en dias y segundos entre la fecha 1 y fecha2, NOTA: si la fecha1 es mayor a la fecha2 la diferencia es positiva pero si la fecha1 es menor a la fecha2 la diferencia es negativa
	 * @param {Object} fecha1
	 * @param {Object} fecha2
	 */
	diferencia: function(fecha1, fecha2) {
		var diferencia = fecha1.toString().toDate().getTime() - fecha2.toString().toDate().getTime();
		var dias = Math.floor(diferencia / (1000 * 60 * 60 * 24));  
		var segundos = Math.floor(diferencia / 1000);
		return {dias: dias, segundos: segundos};
	}
};
var parametrosRequestBin;
var winBin;
var confBin;

/**
 * retorna los parametros
 * @return
 */
function getParametrosRequestBin() {
	return parametrosRequestBin;
}

/**
 * cierra la ventana
 * @return
 */
function closePerformXLS() {
	 try {
		if(winBin) winBin.close(); 
		winBin = undefined;
	 } catch(e) {
		 
	 }
}

/**
 * Solicita un request POST para archivos binarios.
 * @param html
 * @return
 */
function requestBinDoc(conf) {
	parametrosRequestBin = conf;
	winBin = window.open("bin.html","","width=100,height=100,scrollbars=NO");
	if (conf.success) {
		if (!conf.timeOutSuccess) {
			conf.timeOutSuccess = 3000;
		}	
		setTimeout('getParametrosRequestBin().success();', conf.timeOutSuccess);
	}
	if (!conf.timeOutClose) {
		conf.timeOutClose = 60000;
	}	
	setTimeout('closePerformXLS();', conf.timeOutClose);
}
var textPrint_;
var winPrint_;

/**
 * retorna el texto HTML para impresion
 * @return
 */
function getTextPrint() {
	return textPrint_;
}

/**
 * cierra la ventana con el contenido de impresion.
 * @return
 */
function closeWinPrint() {
	if (winPrint_) winPrint_.close(); 
	winPrint_ = undefined;
}

/**
 * Solicita la impresion del contenido HTML pasado como parametro.
 * @param html
 * @return
 */
function printHTML(html, tpl) {
	
	textPrint_ = html;
	if (tpl) {
		winPrint_ = window.open(tpl,"","top=0,left=0,toolbar=no,location=no,status=no,menubar=no,scrollbars=yes,resizable=no,width=640,height=600");
	} else {
		winPrint_ = window.open("print.html","","top=0,left=0,toolbar=no,location=no,status=no,menubar=no,scrollbars=no,resizable=no,width=640,height=480");
	}
	//winPrint_.resizeTo(1,1);
	//winPrint_.moveTo(screen.width, screen.height);
	// setTimeout('closeWinPrint();',3000);
}
