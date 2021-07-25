(function(scope){
'use strict';

function F(arity, fun, wrapper) {
  wrapper.a = arity;
  wrapper.f = fun;
  return wrapper;
}

function F2(fun) {
  return F(2, fun, function(a) { return function(b) { return fun(a,b); }; })
}
function F3(fun) {
  return F(3, fun, function(a) {
    return function(b) { return function(c) { return fun(a, b, c); }; };
  });
}
function F4(fun) {
  return F(4, fun, function(a) { return function(b) { return function(c) {
    return function(d) { return fun(a, b, c, d); }; }; };
  });
}
function F5(fun) {
  return F(5, fun, function(a) { return function(b) { return function(c) {
    return function(d) { return function(e) { return fun(a, b, c, d, e); }; }; }; };
  });
}
function F6(fun) {
  return F(6, fun, function(a) { return function(b) { return function(c) {
    return function(d) { return function(e) { return function(f) {
    return fun(a, b, c, d, e, f); }; }; }; }; };
  });
}
function F7(fun) {
  return F(7, fun, function(a) { return function(b) { return function(c) {
    return function(d) { return function(e) { return function(f) {
    return function(g) { return fun(a, b, c, d, e, f, g); }; }; }; }; }; };
  });
}
function F8(fun) {
  return F(8, fun, function(a) { return function(b) { return function(c) {
    return function(d) { return function(e) { return function(f) {
    return function(g) { return function(h) {
    return fun(a, b, c, d, e, f, g, h); }; }; }; }; }; }; };
  });
}
function F9(fun) {
  return F(9, fun, function(a) { return function(b) { return function(c) {
    return function(d) { return function(e) { return function(f) {
    return function(g) { return function(h) { return function(i) {
    return fun(a, b, c, d, e, f, g, h, i); }; }; }; }; }; }; }; };
  });
}

function A2(fun, a, b) {
  return fun.a === 2 ? fun.f(a, b) : fun(a)(b);
}
function A3(fun, a, b, c) {
  return fun.a === 3 ? fun.f(a, b, c) : fun(a)(b)(c);
}
function A4(fun, a, b, c, d) {
  return fun.a === 4 ? fun.f(a, b, c, d) : fun(a)(b)(c)(d);
}
function A5(fun, a, b, c, d, e) {
  return fun.a === 5 ? fun.f(a, b, c, d, e) : fun(a)(b)(c)(d)(e);
}
function A6(fun, a, b, c, d, e, f) {
  return fun.a === 6 ? fun.f(a, b, c, d, e, f) : fun(a)(b)(c)(d)(e)(f);
}
function A7(fun, a, b, c, d, e, f, g) {
  return fun.a === 7 ? fun.f(a, b, c, d, e, f, g) : fun(a)(b)(c)(d)(e)(f)(g);
}
function A8(fun, a, b, c, d, e, f, g, h) {
  return fun.a === 8 ? fun.f(a, b, c, d, e, f, g, h) : fun(a)(b)(c)(d)(e)(f)(g)(h);
}
function A9(fun, a, b, c, d, e, f, g, h, i) {
  return fun.a === 9 ? fun.f(a, b, c, d, e, f, g, h, i) : fun(a)(b)(c)(d)(e)(f)(g)(h)(i);
}

console.warn('Compiled in DEV mode. Follow the advice at https://elm-lang.org/0.19.1/optimize for better performance and smaller assets.');


// EQUALITY

function _Utils_eq(x, y)
{
	for (
		var pair, stack = [], isEqual = _Utils_eqHelp(x, y, 0, stack);
		isEqual && (pair = stack.pop());
		isEqual = _Utils_eqHelp(pair.a, pair.b, 0, stack)
		)
	{}

	return isEqual;
}

function _Utils_eqHelp(x, y, depth, stack)
{
	if (x === y)
	{
		return true;
	}

	if (typeof x !== 'object' || x === null || y === null)
	{
		typeof x === 'function' && _Debug_crash(5);
		return false;
	}

	if (depth > 100)
	{
		stack.push(_Utils_Tuple2(x,y));
		return true;
	}

	/**/
	if (x.$ === 'Set_elm_builtin')
	{
		x = $elm$core$Set$toList(x);
		y = $elm$core$Set$toList(y);
	}
	if (x.$ === 'RBNode_elm_builtin' || x.$ === 'RBEmpty_elm_builtin')
	{
		x = $elm$core$Dict$toList(x);
		y = $elm$core$Dict$toList(y);
	}
	//*/

	/**_UNUSED/
	if (x.$ < 0)
	{
		x = $elm$core$Dict$toList(x);
		y = $elm$core$Dict$toList(y);
	}
	//*/

	for (var key in x)
	{
		if (!_Utils_eqHelp(x[key], y[key], depth + 1, stack))
		{
			return false;
		}
	}
	return true;
}

var _Utils_equal = F2(_Utils_eq);
var _Utils_notEqual = F2(function(a, b) { return !_Utils_eq(a,b); });



// COMPARISONS

// Code in Generate/JavaScript.hs, Basics.js, and List.js depends on
// the particular integer values assigned to LT, EQ, and GT.

function _Utils_cmp(x, y, ord)
{
	if (typeof x !== 'object')
	{
		return x === y ? /*EQ*/ 0 : x < y ? /*LT*/ -1 : /*GT*/ 1;
	}

	/**/
	if (x instanceof String)
	{
		var a = x.valueOf();
		var b = y.valueOf();
		return a === b ? 0 : a < b ? -1 : 1;
	}
	//*/

	/**_UNUSED/
	if (typeof x.$ === 'undefined')
	//*/
	/**/
	if (x.$[0] === '#')
	//*/
	{
		return (ord = _Utils_cmp(x.a, y.a))
			? ord
			: (ord = _Utils_cmp(x.b, y.b))
				? ord
				: _Utils_cmp(x.c, y.c);
	}

	// traverse conses until end of a list or a mismatch
	for (; x.b && y.b && !(ord = _Utils_cmp(x.a, y.a)); x = x.b, y = y.b) {} // WHILE_CONSES
	return ord || (x.b ? /*GT*/ 1 : y.b ? /*LT*/ -1 : /*EQ*/ 0);
}

var _Utils_lt = F2(function(a, b) { return _Utils_cmp(a, b) < 0; });
var _Utils_le = F2(function(a, b) { return _Utils_cmp(a, b) < 1; });
var _Utils_gt = F2(function(a, b) { return _Utils_cmp(a, b) > 0; });
var _Utils_ge = F2(function(a, b) { return _Utils_cmp(a, b) >= 0; });

var _Utils_compare = F2(function(x, y)
{
	var n = _Utils_cmp(x, y);
	return n < 0 ? $elm$core$Basics$LT : n ? $elm$core$Basics$GT : $elm$core$Basics$EQ;
});


// COMMON VALUES

var _Utils_Tuple0_UNUSED = 0;
var _Utils_Tuple0 = { $: '#0' };

function _Utils_Tuple2_UNUSED(a, b) { return { a: a, b: b }; }
function _Utils_Tuple2(a, b) { return { $: '#2', a: a, b: b }; }

function _Utils_Tuple3_UNUSED(a, b, c) { return { a: a, b: b, c: c }; }
function _Utils_Tuple3(a, b, c) { return { $: '#3', a: a, b: b, c: c }; }

function _Utils_chr_UNUSED(c) { return c; }
function _Utils_chr(c) { return new String(c); }


// RECORDS

function _Utils_update(oldRecord, updatedFields)
{
	var newRecord = {};

	for (var key in oldRecord)
	{
		newRecord[key] = oldRecord[key];
	}

	for (var key in updatedFields)
	{
		newRecord[key] = updatedFields[key];
	}

	return newRecord;
}


// APPEND

var _Utils_append = F2(_Utils_ap);

function _Utils_ap(xs, ys)
{
	// append Strings
	if (typeof xs === 'string')
	{
		return xs + ys;
	}

	// append Lists
	if (!xs.b)
	{
		return ys;
	}
	var root = _List_Cons(xs.a, ys);
	xs = xs.b
	for (var curr = root; xs.b; xs = xs.b) // WHILE_CONS
	{
		curr = curr.b = _List_Cons(xs.a, ys);
	}
	return root;
}



var _List_Nil_UNUSED = { $: 0 };
var _List_Nil = { $: '[]' };

function _List_Cons_UNUSED(hd, tl) { return { $: 1, a: hd, b: tl }; }
function _List_Cons(hd, tl) { return { $: '::', a: hd, b: tl }; }


var _List_cons = F2(_List_Cons);

function _List_fromArray(arr)
{
	var out = _List_Nil;
	for (var i = arr.length; i--; )
	{
		out = _List_Cons(arr[i], out);
	}
	return out;
}

function _List_toArray(xs)
{
	for (var out = []; xs.b; xs = xs.b) // WHILE_CONS
	{
		out.push(xs.a);
	}
	return out;
}

var _List_map2 = F3(function(f, xs, ys)
{
	for (var arr = []; xs.b && ys.b; xs = xs.b, ys = ys.b) // WHILE_CONSES
	{
		arr.push(A2(f, xs.a, ys.a));
	}
	return _List_fromArray(arr);
});

var _List_map3 = F4(function(f, xs, ys, zs)
{
	for (var arr = []; xs.b && ys.b && zs.b; xs = xs.b, ys = ys.b, zs = zs.b) // WHILE_CONSES
	{
		arr.push(A3(f, xs.a, ys.a, zs.a));
	}
	return _List_fromArray(arr);
});

var _List_map4 = F5(function(f, ws, xs, ys, zs)
{
	for (var arr = []; ws.b && xs.b && ys.b && zs.b; ws = ws.b, xs = xs.b, ys = ys.b, zs = zs.b) // WHILE_CONSES
	{
		arr.push(A4(f, ws.a, xs.a, ys.a, zs.a));
	}
	return _List_fromArray(arr);
});

var _List_map5 = F6(function(f, vs, ws, xs, ys, zs)
{
	for (var arr = []; vs.b && ws.b && xs.b && ys.b && zs.b; vs = vs.b, ws = ws.b, xs = xs.b, ys = ys.b, zs = zs.b) // WHILE_CONSES
	{
		arr.push(A5(f, vs.a, ws.a, xs.a, ys.a, zs.a));
	}
	return _List_fromArray(arr);
});

var _List_sortBy = F2(function(f, xs)
{
	return _List_fromArray(_List_toArray(xs).sort(function(a, b) {
		return _Utils_cmp(f(a), f(b));
	}));
});

var _List_sortWith = F2(function(f, xs)
{
	return _List_fromArray(_List_toArray(xs).sort(function(a, b) {
		var ord = A2(f, a, b);
		return ord === $elm$core$Basics$EQ ? 0 : ord === $elm$core$Basics$LT ? -1 : 1;
	}));
});



var _JsArray_empty = [];

function _JsArray_singleton(value)
{
    return [value];
}

function _JsArray_length(array)
{
    return array.length;
}

var _JsArray_initialize = F3(function(size, offset, func)
{
    var result = new Array(size);

    for (var i = 0; i < size; i++)
    {
        result[i] = func(offset + i);
    }

    return result;
});

var _JsArray_initializeFromList = F2(function (max, ls)
{
    var result = new Array(max);

    for (var i = 0; i < max && ls.b; i++)
    {
        result[i] = ls.a;
        ls = ls.b;
    }

    result.length = i;
    return _Utils_Tuple2(result, ls);
});

var _JsArray_unsafeGet = F2(function(index, array)
{
    return array[index];
});

var _JsArray_unsafeSet = F3(function(index, value, array)
{
    var length = array.length;
    var result = new Array(length);

    for (var i = 0; i < length; i++)
    {
        result[i] = array[i];
    }

    result[index] = value;
    return result;
});

var _JsArray_push = F2(function(value, array)
{
    var length = array.length;
    var result = new Array(length + 1);

    for (var i = 0; i < length; i++)
    {
        result[i] = array[i];
    }

    result[length] = value;
    return result;
});

var _JsArray_foldl = F3(function(func, acc, array)
{
    var length = array.length;

    for (var i = 0; i < length; i++)
    {
        acc = A2(func, array[i], acc);
    }

    return acc;
});

var _JsArray_foldr = F3(function(func, acc, array)
{
    for (var i = array.length - 1; i >= 0; i--)
    {
        acc = A2(func, array[i], acc);
    }

    return acc;
});

var _JsArray_map = F2(function(func, array)
{
    var length = array.length;
    var result = new Array(length);

    for (var i = 0; i < length; i++)
    {
        result[i] = func(array[i]);
    }

    return result;
});

var _JsArray_indexedMap = F3(function(func, offset, array)
{
    var length = array.length;
    var result = new Array(length);

    for (var i = 0; i < length; i++)
    {
        result[i] = A2(func, offset + i, array[i]);
    }

    return result;
});

var _JsArray_slice = F3(function(from, to, array)
{
    return array.slice(from, to);
});

var _JsArray_appendN = F3(function(n, dest, source)
{
    var destLen = dest.length;
    var itemsToCopy = n - destLen;

    if (itemsToCopy > source.length)
    {
        itemsToCopy = source.length;
    }

    var size = destLen + itemsToCopy;
    var result = new Array(size);

    for (var i = 0; i < destLen; i++)
    {
        result[i] = dest[i];
    }

    for (var i = 0; i < itemsToCopy; i++)
    {
        result[i + destLen] = source[i];
    }

    return result;
});



// LOG

var _Debug_log_UNUSED = F2(function(tag, value)
{
	return value;
});

var _Debug_log = F2(function(tag, value)
{
	console.log(tag + ': ' + _Debug_toString(value));
	return value;
});


// TODOS

function _Debug_todo(moduleName, region)
{
	return function(message) {
		_Debug_crash(8, moduleName, region, message);
	};
}

function _Debug_todoCase(moduleName, region, value)
{
	return function(message) {
		_Debug_crash(9, moduleName, region, value, message);
	};
}


// TO STRING

function _Debug_toString_UNUSED(value)
{
	return '<internals>';
}

function _Debug_toString(value)
{
	return _Debug_toAnsiString(false, value);
}

function _Debug_toAnsiString(ansi, value)
{
	if (typeof value === 'function')
	{
		return _Debug_internalColor(ansi, '<function>');
	}

	if (typeof value === 'boolean')
	{
		return _Debug_ctorColor(ansi, value ? 'True' : 'False');
	}

	if (typeof value === 'number')
	{
		return _Debug_numberColor(ansi, value + '');
	}

	if (value instanceof String)
	{
		return _Debug_charColor(ansi, "'" + _Debug_addSlashes(value, true) + "'");
	}

	if (typeof value === 'string')
	{
		return _Debug_stringColor(ansi, '"' + _Debug_addSlashes(value, false) + '"');
	}

	if (typeof value === 'object' && '$' in value)
	{
		var tag = value.$;

		if (typeof tag === 'number')
		{
			return _Debug_internalColor(ansi, '<internals>');
		}

		if (tag[0] === '#')
		{
			var output = [];
			for (var k in value)
			{
				if (k === '$') continue;
				output.push(_Debug_toAnsiString(ansi, value[k]));
			}
			return '(' + output.join(',') + ')';
		}

		if (tag === 'Set_elm_builtin')
		{
			return _Debug_ctorColor(ansi, 'Set')
				+ _Debug_fadeColor(ansi, '.fromList') + ' '
				+ _Debug_toAnsiString(ansi, $elm$core$Set$toList(value));
		}

		if (tag === 'RBNode_elm_builtin' || tag === 'RBEmpty_elm_builtin')
		{
			return _Debug_ctorColor(ansi, 'Dict')
				+ _Debug_fadeColor(ansi, '.fromList') + ' '
				+ _Debug_toAnsiString(ansi, $elm$core$Dict$toList(value));
		}

		if (tag === 'Array_elm_builtin')
		{
			return _Debug_ctorColor(ansi, 'Array')
				+ _Debug_fadeColor(ansi, '.fromList') + ' '
				+ _Debug_toAnsiString(ansi, $elm$core$Array$toList(value));
		}

		if (tag === '::' || tag === '[]')
		{
			var output = '[';

			value.b && (output += _Debug_toAnsiString(ansi, value.a), value = value.b)

			for (; value.b; value = value.b) // WHILE_CONS
			{
				output += ',' + _Debug_toAnsiString(ansi, value.a);
			}
			return output + ']';
		}

		var output = '';
		for (var i in value)
		{
			if (i === '$') continue;
			var str = _Debug_toAnsiString(ansi, value[i]);
			var c0 = str[0];
			var parenless = c0 === '{' || c0 === '(' || c0 === '[' || c0 === '<' || c0 === '"' || str.indexOf(' ') < 0;
			output += ' ' + (parenless ? str : '(' + str + ')');
		}
		return _Debug_ctorColor(ansi, tag) + output;
	}

	if (typeof DataView === 'function' && value instanceof DataView)
	{
		return _Debug_stringColor(ansi, '<' + value.byteLength + ' bytes>');
	}

	if (typeof File !== 'undefined' && value instanceof File)
	{
		return _Debug_internalColor(ansi, '<' + value.name + '>');
	}

	if (typeof value === 'object')
	{
		var output = [];
		for (var key in value)
		{
			var field = key[0] === '_' ? key.slice(1) : key;
			output.push(_Debug_fadeColor(ansi, field) + ' = ' + _Debug_toAnsiString(ansi, value[key]));
		}
		if (output.length === 0)
		{
			return '{}';
		}
		return '{ ' + output.join(', ') + ' }';
	}

	return _Debug_internalColor(ansi, '<internals>');
}

function _Debug_addSlashes(str, isChar)
{
	var s = str
		.replace(/\\/g, '\\\\')
		.replace(/\n/g, '\\n')
		.replace(/\t/g, '\\t')
		.replace(/\r/g, '\\r')
		.replace(/\v/g, '\\v')
		.replace(/\0/g, '\\0');

	if (isChar)
	{
		return s.replace(/\'/g, '\\\'');
	}
	else
	{
		return s.replace(/\"/g, '\\"');
	}
}

function _Debug_ctorColor(ansi, string)
{
	return ansi ? '\x1b[96m' + string + '\x1b[0m' : string;
}

function _Debug_numberColor(ansi, string)
{
	return ansi ? '\x1b[95m' + string + '\x1b[0m' : string;
}

function _Debug_stringColor(ansi, string)
{
	return ansi ? '\x1b[93m' + string + '\x1b[0m' : string;
}

function _Debug_charColor(ansi, string)
{
	return ansi ? '\x1b[92m' + string + '\x1b[0m' : string;
}

function _Debug_fadeColor(ansi, string)
{
	return ansi ? '\x1b[37m' + string + '\x1b[0m' : string;
}

function _Debug_internalColor(ansi, string)
{
	return ansi ? '\x1b[36m' + string + '\x1b[0m' : string;
}

function _Debug_toHexDigit(n)
{
	return String.fromCharCode(n < 10 ? 48 + n : 55 + n);
}


// CRASH


function _Debug_crash_UNUSED(identifier)
{
	throw new Error('https://github.com/elm/core/blob/1.0.0/hints/' + identifier + '.md');
}


function _Debug_crash(identifier, fact1, fact2, fact3, fact4)
{
	switch(identifier)
	{
		case 0:
			throw new Error('What node should I take over? In JavaScript I need something like:\n\n    Elm.Main.init({\n        node: document.getElementById("elm-node")\n    })\n\nYou need to do this with any Browser.sandbox or Browser.element program.');

		case 1:
			throw new Error('Browser.application programs cannot handle URLs like this:\n\n    ' + document.location.href + '\n\nWhat is the root? The root of your file system? Try looking at this program with `elm reactor` or some other server.');

		case 2:
			var jsonErrorString = fact1;
			throw new Error('Problem with the flags given to your Elm program on initialization.\n\n' + jsonErrorString);

		case 3:
			var portName = fact1;
			throw new Error('There can only be one port named `' + portName + '`, but your program has multiple.');

		case 4:
			var portName = fact1;
			var problem = fact2;
			throw new Error('Trying to send an unexpected type of value through port `' + portName + '`:\n' + problem);

		case 5:
			throw new Error('Trying to use `(==)` on functions.\nThere is no way to know if functions are "the same" in the Elm sense.\nRead more about this at https://package.elm-lang.org/packages/elm/core/latest/Basics#== which describes why it is this way and what the better version will look like.');

		case 6:
			var moduleName = fact1;
			throw new Error('Your page is loading multiple Elm scripts with a module named ' + moduleName + '. Maybe a duplicate script is getting loaded accidentally? If not, rename one of them so I know which is which!');

		case 8:
			var moduleName = fact1;
			var region = fact2;
			var message = fact3;
			throw new Error('TODO in module `' + moduleName + '` ' + _Debug_regionToString(region) + '\n\n' + message);

		case 9:
			var moduleName = fact1;
			var region = fact2;
			var value = fact3;
			var message = fact4;
			throw new Error(
				'TODO in module `' + moduleName + '` from the `case` expression '
				+ _Debug_regionToString(region) + '\n\nIt received the following value:\n\n    '
				+ _Debug_toString(value).replace('\n', '\n    ')
				+ '\n\nBut the branch that handles it says:\n\n    ' + message.replace('\n', '\n    ')
			);

		case 10:
			throw new Error('Bug in https://github.com/elm/virtual-dom/issues');

		case 11:
			throw new Error('Cannot perform mod 0. Division by zero error.');
	}
}

function _Debug_regionToString(region)
{
	if (region.start.line === region.end.line)
	{
		return 'on line ' + region.start.line;
	}
	return 'on lines ' + region.start.line + ' through ' + region.end.line;
}



// MATH

var _Basics_add = F2(function(a, b) { return a + b; });
var _Basics_sub = F2(function(a, b) { return a - b; });
var _Basics_mul = F2(function(a, b) { return a * b; });
var _Basics_fdiv = F2(function(a, b) { return a / b; });
var _Basics_idiv = F2(function(a, b) { return (a / b) | 0; });
var _Basics_pow = F2(Math.pow);

var _Basics_remainderBy = F2(function(b, a) { return a % b; });

// https://www.microsoft.com/en-us/research/wp-content/uploads/2016/02/divmodnote-letter.pdf
var _Basics_modBy = F2(function(modulus, x)
{
	var answer = x % modulus;
	return modulus === 0
		? _Debug_crash(11)
		:
	((answer > 0 && modulus < 0) || (answer < 0 && modulus > 0))
		? answer + modulus
		: answer;
});


// TRIGONOMETRY

var _Basics_pi = Math.PI;
var _Basics_e = Math.E;
var _Basics_cos = Math.cos;
var _Basics_sin = Math.sin;
var _Basics_tan = Math.tan;
var _Basics_acos = Math.acos;
var _Basics_asin = Math.asin;
var _Basics_atan = Math.atan;
var _Basics_atan2 = F2(Math.atan2);


// MORE MATH

function _Basics_toFloat(x) { return x; }
function _Basics_truncate(n) { return n | 0; }
function _Basics_isInfinite(n) { return n === Infinity || n === -Infinity; }

var _Basics_ceiling = Math.ceil;
var _Basics_floor = Math.floor;
var _Basics_round = Math.round;
var _Basics_sqrt = Math.sqrt;
var _Basics_log = Math.log;
var _Basics_isNaN = isNaN;


// BOOLEANS

function _Basics_not(bool) { return !bool; }
var _Basics_and = F2(function(a, b) { return a && b; });
var _Basics_or  = F2(function(a, b) { return a || b; });
var _Basics_xor = F2(function(a, b) { return a !== b; });



var _String_cons = F2(function(chr, str)
{
	return chr + str;
});

function _String_uncons(string)
{
	var word = string.charCodeAt(0);
	return !isNaN(word)
		? $elm$core$Maybe$Just(
			0xD800 <= word && word <= 0xDBFF
				? _Utils_Tuple2(_Utils_chr(string[0] + string[1]), string.slice(2))
				: _Utils_Tuple2(_Utils_chr(string[0]), string.slice(1))
		)
		: $elm$core$Maybe$Nothing;
}

var _String_append = F2(function(a, b)
{
	return a + b;
});

function _String_length(str)
{
	return str.length;
}

var _String_map = F2(function(func, string)
{
	var len = string.length;
	var array = new Array(len);
	var i = 0;
	while (i < len)
	{
		var word = string.charCodeAt(i);
		if (0xD800 <= word && word <= 0xDBFF)
		{
			array[i] = func(_Utils_chr(string[i] + string[i+1]));
			i += 2;
			continue;
		}
		array[i] = func(_Utils_chr(string[i]));
		i++;
	}
	return array.join('');
});

var _String_filter = F2(function(isGood, str)
{
	var arr = [];
	var len = str.length;
	var i = 0;
	while (i < len)
	{
		var char = str[i];
		var word = str.charCodeAt(i);
		i++;
		if (0xD800 <= word && word <= 0xDBFF)
		{
			char += str[i];
			i++;
		}

		if (isGood(_Utils_chr(char)))
		{
			arr.push(char);
		}
	}
	return arr.join('');
});

function _String_reverse(str)
{
	var len = str.length;
	var arr = new Array(len);
	var i = 0;
	while (i < len)
	{
		var word = str.charCodeAt(i);
		if (0xD800 <= word && word <= 0xDBFF)
		{
			arr[len - i] = str[i + 1];
			i++;
			arr[len - i] = str[i - 1];
			i++;
		}
		else
		{
			arr[len - i] = str[i];
			i++;
		}
	}
	return arr.join('');
}

var _String_foldl = F3(function(func, state, string)
{
	var len = string.length;
	var i = 0;
	while (i < len)
	{
		var char = string[i];
		var word = string.charCodeAt(i);
		i++;
		if (0xD800 <= word && word <= 0xDBFF)
		{
			char += string[i];
			i++;
		}
		state = A2(func, _Utils_chr(char), state);
	}
	return state;
});

var _String_foldr = F3(function(func, state, string)
{
	var i = string.length;
	while (i--)
	{
		var char = string[i];
		var word = string.charCodeAt(i);
		if (0xDC00 <= word && word <= 0xDFFF)
		{
			i--;
			char = string[i] + char;
		}
		state = A2(func, _Utils_chr(char), state);
	}
	return state;
});

var _String_split = F2(function(sep, str)
{
	return str.split(sep);
});

var _String_join = F2(function(sep, strs)
{
	return strs.join(sep);
});

var _String_slice = F3(function(start, end, str) {
	return str.slice(start, end);
});

function _String_trim(str)
{
	return str.trim();
}

function _String_trimLeft(str)
{
	return str.replace(/^\s+/, '');
}

function _String_trimRight(str)
{
	return str.replace(/\s+$/, '');
}

function _String_words(str)
{
	return _List_fromArray(str.trim().split(/\s+/g));
}

function _String_lines(str)
{
	return _List_fromArray(str.split(/\r\n|\r|\n/g));
}

function _String_toUpper(str)
{
	return str.toUpperCase();
}

function _String_toLower(str)
{
	return str.toLowerCase();
}

var _String_any = F2(function(isGood, string)
{
	var i = string.length;
	while (i--)
	{
		var char = string[i];
		var word = string.charCodeAt(i);
		if (0xDC00 <= word && word <= 0xDFFF)
		{
			i--;
			char = string[i] + char;
		}
		if (isGood(_Utils_chr(char)))
		{
			return true;
		}
	}
	return false;
});

var _String_all = F2(function(isGood, string)
{
	var i = string.length;
	while (i--)
	{
		var char = string[i];
		var word = string.charCodeAt(i);
		if (0xDC00 <= word && word <= 0xDFFF)
		{
			i--;
			char = string[i] + char;
		}
		if (!isGood(_Utils_chr(char)))
		{
			return false;
		}
	}
	return true;
});

var _String_contains = F2(function(sub, str)
{
	return str.indexOf(sub) > -1;
});

var _String_startsWith = F2(function(sub, str)
{
	return str.indexOf(sub) === 0;
});

var _String_endsWith = F2(function(sub, str)
{
	return str.length >= sub.length &&
		str.lastIndexOf(sub) === str.length - sub.length;
});

var _String_indexes = F2(function(sub, str)
{
	var subLen = sub.length;

	if (subLen < 1)
	{
		return _List_Nil;
	}

	var i = 0;
	var is = [];

	while ((i = str.indexOf(sub, i)) > -1)
	{
		is.push(i);
		i = i + subLen;
	}

	return _List_fromArray(is);
});


// TO STRING

function _String_fromNumber(number)
{
	return number + '';
}


// INT CONVERSIONS

function _String_toInt(str)
{
	var total = 0;
	var code0 = str.charCodeAt(0);
	var start = code0 == 0x2B /* + */ || code0 == 0x2D /* - */ ? 1 : 0;

	for (var i = start; i < str.length; ++i)
	{
		var code = str.charCodeAt(i);
		if (code < 0x30 || 0x39 < code)
		{
			return $elm$core$Maybe$Nothing;
		}
		total = 10 * total + code - 0x30;
	}

	return i == start
		? $elm$core$Maybe$Nothing
		: $elm$core$Maybe$Just(code0 == 0x2D ? -total : total);
}


// FLOAT CONVERSIONS

function _String_toFloat(s)
{
	// check if it is a hex, octal, or binary number
	if (s.length === 0 || /[\sxbo]/.test(s))
	{
		return $elm$core$Maybe$Nothing;
	}
	var n = +s;
	// faster isNaN check
	return n === n ? $elm$core$Maybe$Just(n) : $elm$core$Maybe$Nothing;
}

function _String_fromList(chars)
{
	return _List_toArray(chars).join('');
}




function _Char_toCode(char)
{
	var code = char.charCodeAt(0);
	if (0xD800 <= code && code <= 0xDBFF)
	{
		return (code - 0xD800) * 0x400 + char.charCodeAt(1) - 0xDC00 + 0x10000
	}
	return code;
}

function _Char_fromCode(code)
{
	return _Utils_chr(
		(code < 0 || 0x10FFFF < code)
			? '\uFFFD'
			:
		(code <= 0xFFFF)
			? String.fromCharCode(code)
			:
		(code -= 0x10000,
			String.fromCharCode(Math.floor(code / 0x400) + 0xD800, code % 0x400 + 0xDC00)
		)
	);
}

function _Char_toUpper(char)
{
	return _Utils_chr(char.toUpperCase());
}

function _Char_toLower(char)
{
	return _Utils_chr(char.toLowerCase());
}

function _Char_toLocaleUpper(char)
{
	return _Utils_chr(char.toLocaleUpperCase());
}

function _Char_toLocaleLower(char)
{
	return _Utils_chr(char.toLocaleLowerCase());
}



/**/
function _Json_errorToString(error)
{
	return $elm$json$Json$Decode$errorToString(error);
}
//*/


// CORE DECODERS

function _Json_succeed(msg)
{
	return {
		$: 0,
		a: msg
	};
}

function _Json_fail(msg)
{
	return {
		$: 1,
		a: msg
	};
}

function _Json_decodePrim(decoder)
{
	return { $: 2, b: decoder };
}

var _Json_decodeInt = _Json_decodePrim(function(value) {
	return (typeof value !== 'number')
		? _Json_expecting('an INT', value)
		:
	(-2147483647 < value && value < 2147483647 && (value | 0) === value)
		? $elm$core$Result$Ok(value)
		:
	(isFinite(value) && !(value % 1))
		? $elm$core$Result$Ok(value)
		: _Json_expecting('an INT', value);
});

var _Json_decodeBool = _Json_decodePrim(function(value) {
	return (typeof value === 'boolean')
		? $elm$core$Result$Ok(value)
		: _Json_expecting('a BOOL', value);
});

var _Json_decodeFloat = _Json_decodePrim(function(value) {
	return (typeof value === 'number')
		? $elm$core$Result$Ok(value)
		: _Json_expecting('a FLOAT', value);
});

var _Json_decodeValue = _Json_decodePrim(function(value) {
	return $elm$core$Result$Ok(_Json_wrap(value));
});

var _Json_decodeString = _Json_decodePrim(function(value) {
	return (typeof value === 'string')
		? $elm$core$Result$Ok(value)
		: (value instanceof String)
			? $elm$core$Result$Ok(value + '')
			: _Json_expecting('a STRING', value);
});

function _Json_decodeList(decoder) { return { $: 3, b: decoder }; }
function _Json_decodeArray(decoder) { return { $: 4, b: decoder }; }

function _Json_decodeNull(value) { return { $: 5, c: value }; }

var _Json_decodeField = F2(function(field, decoder)
{
	return {
		$: 6,
		d: field,
		b: decoder
	};
});

var _Json_decodeIndex = F2(function(index, decoder)
{
	return {
		$: 7,
		e: index,
		b: decoder
	};
});

function _Json_decodeKeyValuePairs(decoder)
{
	return {
		$: 8,
		b: decoder
	};
}

function _Json_mapMany(f, decoders)
{
	return {
		$: 9,
		f: f,
		g: decoders
	};
}

var _Json_andThen = F2(function(callback, decoder)
{
	return {
		$: 10,
		b: decoder,
		h: callback
	};
});

function _Json_oneOf(decoders)
{
	return {
		$: 11,
		g: decoders
	};
}


// DECODING OBJECTS

var _Json_map1 = F2(function(f, d1)
{
	return _Json_mapMany(f, [d1]);
});

var _Json_map2 = F3(function(f, d1, d2)
{
	return _Json_mapMany(f, [d1, d2]);
});

var _Json_map3 = F4(function(f, d1, d2, d3)
{
	return _Json_mapMany(f, [d1, d2, d3]);
});

var _Json_map4 = F5(function(f, d1, d2, d3, d4)
{
	return _Json_mapMany(f, [d1, d2, d3, d4]);
});

var _Json_map5 = F6(function(f, d1, d2, d3, d4, d5)
{
	return _Json_mapMany(f, [d1, d2, d3, d4, d5]);
});

var _Json_map6 = F7(function(f, d1, d2, d3, d4, d5, d6)
{
	return _Json_mapMany(f, [d1, d2, d3, d4, d5, d6]);
});

var _Json_map7 = F8(function(f, d1, d2, d3, d4, d5, d6, d7)
{
	return _Json_mapMany(f, [d1, d2, d3, d4, d5, d6, d7]);
});

var _Json_map8 = F9(function(f, d1, d2, d3, d4, d5, d6, d7, d8)
{
	return _Json_mapMany(f, [d1, d2, d3, d4, d5, d6, d7, d8]);
});


// DECODE

var _Json_runOnString = F2(function(decoder, string)
{
	try
	{
		var value = JSON.parse(string);
		return _Json_runHelp(decoder, value);
	}
	catch (e)
	{
		return $elm$core$Result$Err(A2($elm$json$Json$Decode$Failure, 'This is not valid JSON! ' + e.message, _Json_wrap(string)));
	}
});

var _Json_run = F2(function(decoder, value)
{
	return _Json_runHelp(decoder, _Json_unwrap(value));
});

function _Json_runHelp(decoder, value)
{
	switch (decoder.$)
	{
		case 2:
			return decoder.b(value);

		case 5:
			return (value === null)
				? $elm$core$Result$Ok(decoder.c)
				: _Json_expecting('null', value);

		case 3:
			if (!_Json_isArray(value))
			{
				return _Json_expecting('a LIST', value);
			}
			return _Json_runArrayDecoder(decoder.b, value, _List_fromArray);

		case 4:
			if (!_Json_isArray(value))
			{
				return _Json_expecting('an ARRAY', value);
			}
			return _Json_runArrayDecoder(decoder.b, value, _Json_toElmArray);

		case 6:
			var field = decoder.d;
			if (typeof value !== 'object' || value === null || !(field in value))
			{
				return _Json_expecting('an OBJECT with a field named `' + field + '`', value);
			}
			var result = _Json_runHelp(decoder.b, value[field]);
			return ($elm$core$Result$isOk(result)) ? result : $elm$core$Result$Err(A2($elm$json$Json$Decode$Field, field, result.a));

		case 7:
			var index = decoder.e;
			if (!_Json_isArray(value))
			{
				return _Json_expecting('an ARRAY', value);
			}
			if (index >= value.length)
			{
				return _Json_expecting('a LONGER array. Need index ' + index + ' but only see ' + value.length + ' entries', value);
			}
			var result = _Json_runHelp(decoder.b, value[index]);
			return ($elm$core$Result$isOk(result)) ? result : $elm$core$Result$Err(A2($elm$json$Json$Decode$Index, index, result.a));

		case 8:
			if (typeof value !== 'object' || value === null || _Json_isArray(value))
			{
				return _Json_expecting('an OBJECT', value);
			}

			var keyValuePairs = _List_Nil;
			// TODO test perf of Object.keys and switch when support is good enough
			for (var key in value)
			{
				if (value.hasOwnProperty(key))
				{
					var result = _Json_runHelp(decoder.b, value[key]);
					if (!$elm$core$Result$isOk(result))
					{
						return $elm$core$Result$Err(A2($elm$json$Json$Decode$Field, key, result.a));
					}
					keyValuePairs = _List_Cons(_Utils_Tuple2(key, result.a), keyValuePairs);
				}
			}
			return $elm$core$Result$Ok($elm$core$List$reverse(keyValuePairs));

		case 9:
			var answer = decoder.f;
			var decoders = decoder.g;
			for (var i = 0; i < decoders.length; i++)
			{
				var result = _Json_runHelp(decoders[i], value);
				if (!$elm$core$Result$isOk(result))
				{
					return result;
				}
				answer = answer(result.a);
			}
			return $elm$core$Result$Ok(answer);

		case 10:
			var result = _Json_runHelp(decoder.b, value);
			return (!$elm$core$Result$isOk(result))
				? result
				: _Json_runHelp(decoder.h(result.a), value);

		case 11:
			var errors = _List_Nil;
			for (var temp = decoder.g; temp.b; temp = temp.b) // WHILE_CONS
			{
				var result = _Json_runHelp(temp.a, value);
				if ($elm$core$Result$isOk(result))
				{
					return result;
				}
				errors = _List_Cons(result.a, errors);
			}
			return $elm$core$Result$Err($elm$json$Json$Decode$OneOf($elm$core$List$reverse(errors)));

		case 1:
			return $elm$core$Result$Err(A2($elm$json$Json$Decode$Failure, decoder.a, _Json_wrap(value)));

		case 0:
			return $elm$core$Result$Ok(decoder.a);
	}
}

function _Json_runArrayDecoder(decoder, value, toElmValue)
{
	var len = value.length;
	var array = new Array(len);
	for (var i = 0; i < len; i++)
	{
		var result = _Json_runHelp(decoder, value[i]);
		if (!$elm$core$Result$isOk(result))
		{
			return $elm$core$Result$Err(A2($elm$json$Json$Decode$Index, i, result.a));
		}
		array[i] = result.a;
	}
	return $elm$core$Result$Ok(toElmValue(array));
}

function _Json_isArray(value)
{
	return Array.isArray(value) || (typeof FileList !== 'undefined' && value instanceof FileList);
}

function _Json_toElmArray(array)
{
	return A2($elm$core$Array$initialize, array.length, function(i) { return array[i]; });
}

function _Json_expecting(type, value)
{
	return $elm$core$Result$Err(A2($elm$json$Json$Decode$Failure, 'Expecting ' + type, _Json_wrap(value)));
}


// EQUALITY

function _Json_equality(x, y)
{
	if (x === y)
	{
		return true;
	}

	if (x.$ !== y.$)
	{
		return false;
	}

	switch (x.$)
	{
		case 0:
		case 1:
			return x.a === y.a;

		case 2:
			return x.b === y.b;

		case 5:
			return x.c === y.c;

		case 3:
		case 4:
		case 8:
			return _Json_equality(x.b, y.b);

		case 6:
			return x.d === y.d && _Json_equality(x.b, y.b);

		case 7:
			return x.e === y.e && _Json_equality(x.b, y.b);

		case 9:
			return x.f === y.f && _Json_listEquality(x.g, y.g);

		case 10:
			return x.h === y.h && _Json_equality(x.b, y.b);

		case 11:
			return _Json_listEquality(x.g, y.g);
	}
}

function _Json_listEquality(aDecoders, bDecoders)
{
	var len = aDecoders.length;
	if (len !== bDecoders.length)
	{
		return false;
	}
	for (var i = 0; i < len; i++)
	{
		if (!_Json_equality(aDecoders[i], bDecoders[i]))
		{
			return false;
		}
	}
	return true;
}


// ENCODE

var _Json_encode = F2(function(indentLevel, value)
{
	return JSON.stringify(_Json_unwrap(value), null, indentLevel) + '';
});

function _Json_wrap(value) { return { $: 0, a: value }; }
function _Json_unwrap(value) { return value.a; }

function _Json_wrap_UNUSED(value) { return value; }
function _Json_unwrap_UNUSED(value) { return value; }

function _Json_emptyArray() { return []; }
function _Json_emptyObject() { return {}; }

var _Json_addField = F3(function(key, value, object)
{
	object[key] = _Json_unwrap(value);
	return object;
});

function _Json_addEntry(func)
{
	return F2(function(entry, array)
	{
		array.push(_Json_unwrap(func(entry)));
		return array;
	});
}

var _Json_encodeNull = _Json_wrap(null);



// TASKS

function _Scheduler_succeed(value)
{
	return {
		$: 0,
		a: value
	};
}

function _Scheduler_fail(error)
{
	return {
		$: 1,
		a: error
	};
}

function _Scheduler_binding(callback)
{
	return {
		$: 2,
		b: callback,
		c: null
	};
}

var _Scheduler_andThen = F2(function(callback, task)
{
	return {
		$: 3,
		b: callback,
		d: task
	};
});

var _Scheduler_onError = F2(function(callback, task)
{
	return {
		$: 4,
		b: callback,
		d: task
	};
});

function _Scheduler_receive(callback)
{
	return {
		$: 5,
		b: callback
	};
}


// PROCESSES

var _Scheduler_guid = 0;

function _Scheduler_rawSpawn(task)
{
	var proc = {
		$: 0,
		e: _Scheduler_guid++,
		f: task,
		g: null,
		h: []
	};

	_Scheduler_enqueue(proc);

	return proc;
}

function _Scheduler_spawn(task)
{
	return _Scheduler_binding(function(callback) {
		callback(_Scheduler_succeed(_Scheduler_rawSpawn(task)));
	});
}

function _Scheduler_rawSend(proc, msg)
{
	proc.h.push(msg);
	_Scheduler_enqueue(proc);
}

var _Scheduler_send = F2(function(proc, msg)
{
	return _Scheduler_binding(function(callback) {
		_Scheduler_rawSend(proc, msg);
		callback(_Scheduler_succeed(_Utils_Tuple0));
	});
});

function _Scheduler_kill(proc)
{
	return _Scheduler_binding(function(callback) {
		var task = proc.f;
		if (task.$ === 2 && task.c)
		{
			task.c();
		}

		proc.f = null;

		callback(_Scheduler_succeed(_Utils_Tuple0));
	});
}


/* STEP PROCESSES

type alias Process =
  { $ : tag
  , id : unique_id
  , root : Task
  , stack : null | { $: SUCCEED | FAIL, a: callback, b: stack }
  , mailbox : [msg]
  }

*/


var _Scheduler_working = false;
var _Scheduler_queue = [];


function _Scheduler_enqueue(proc)
{
	_Scheduler_queue.push(proc);
	if (_Scheduler_working)
	{
		return;
	}
	_Scheduler_working = true;
	while (proc = _Scheduler_queue.shift())
	{
		_Scheduler_step(proc);
	}
	_Scheduler_working = false;
}


function _Scheduler_step(proc)
{
	while (proc.f)
	{
		var rootTag = proc.f.$;
		if (rootTag === 0 || rootTag === 1)
		{
			while (proc.g && proc.g.$ !== rootTag)
			{
				proc.g = proc.g.i;
			}
			if (!proc.g)
			{
				return;
			}
			proc.f = proc.g.b(proc.f.a);
			proc.g = proc.g.i;
		}
		else if (rootTag === 2)
		{
			proc.f.c = proc.f.b(function(newRoot) {
				proc.f = newRoot;
				_Scheduler_enqueue(proc);
			});
			return;
		}
		else if (rootTag === 5)
		{
			if (proc.h.length === 0)
			{
				return;
			}
			proc.f = proc.f.b(proc.h.shift());
		}
		else // if (rootTag === 3 || rootTag === 4)
		{
			proc.g = {
				$: rootTag === 3 ? 0 : 1,
				b: proc.f.b,
				i: proc.g
			};
			proc.f = proc.f.d;
		}
	}
}



function _Process_sleep(time)
{
	return _Scheduler_binding(function(callback) {
		var id = setTimeout(function() {
			callback(_Scheduler_succeed(_Utils_Tuple0));
		}, time);

		return function() { clearTimeout(id); };
	});
}




// PROGRAMS


var _Platform_worker = F4(function(impl, flagDecoder, debugMetadata, args)
{
	return _Platform_initialize(
		flagDecoder,
		args,
		impl.init,
		impl.update,
		impl.subscriptions,
		function() { return function() {} }
	);
});



// INITIALIZE A PROGRAM


function _Platform_initialize(flagDecoder, args, init, update, subscriptions, stepperBuilder)
{
	var result = A2(_Json_run, flagDecoder, _Json_wrap(args ? args['flags'] : undefined));
	$elm$core$Result$isOk(result) || _Debug_crash(2 /**/, _Json_errorToString(result.a) /**/);
	var managers = {};
	var initPair = init(result.a);
	var model = initPair.a;
	var stepper = stepperBuilder(sendToApp, model);
	var ports = _Platform_setupEffects(managers, sendToApp);

	function sendToApp(msg, viewMetadata)
	{
		var pair = A2(update, msg, model);
		stepper(model = pair.a, viewMetadata);
		_Platform_enqueueEffects(managers, pair.b, subscriptions(model));
	}

	_Platform_enqueueEffects(managers, initPair.b, subscriptions(model));

	return ports ? { ports: ports } : {};
}



// TRACK PRELOADS
//
// This is used by code in elm/browser and elm/http
// to register any HTTP requests that are triggered by init.
//


var _Platform_preload;


function _Platform_registerPreload(url)
{
	_Platform_preload.add(url);
}



// EFFECT MANAGERS


var _Platform_effectManagers = {};


function _Platform_setupEffects(managers, sendToApp)
{
	var ports;

	// setup all necessary effect managers
	for (var key in _Platform_effectManagers)
	{
		var manager = _Platform_effectManagers[key];

		if (manager.a)
		{
			ports = ports || {};
			ports[key] = manager.a(key, sendToApp);
		}

		managers[key] = _Platform_instantiateManager(manager, sendToApp);
	}

	return ports;
}


function _Platform_createManager(init, onEffects, onSelfMsg, cmdMap, subMap)
{
	return {
		b: init,
		c: onEffects,
		d: onSelfMsg,
		e: cmdMap,
		f: subMap
	};
}


function _Platform_instantiateManager(info, sendToApp)
{
	var router = {
		g: sendToApp,
		h: undefined
	};

	var onEffects = info.c;
	var onSelfMsg = info.d;
	var cmdMap = info.e;
	var subMap = info.f;

	function loop(state)
	{
		return A2(_Scheduler_andThen, loop, _Scheduler_receive(function(msg)
		{
			var value = msg.a;

			if (msg.$ === 0)
			{
				return A3(onSelfMsg, router, value, state);
			}

			return cmdMap && subMap
				? A4(onEffects, router, value.i, value.j, state)
				: A3(onEffects, router, cmdMap ? value.i : value.j, state);
		}));
	}

	return router.h = _Scheduler_rawSpawn(A2(_Scheduler_andThen, loop, info.b));
}



// ROUTING


var _Platform_sendToApp = F2(function(router, msg)
{
	return _Scheduler_binding(function(callback)
	{
		router.g(msg);
		callback(_Scheduler_succeed(_Utils_Tuple0));
	});
});


var _Platform_sendToSelf = F2(function(router, msg)
{
	return A2(_Scheduler_send, router.h, {
		$: 0,
		a: msg
	});
});



// BAGS


function _Platform_leaf(home)
{
	return function(value)
	{
		return {
			$: 1,
			k: home,
			l: value
		};
	};
}


function _Platform_batch(list)
{
	return {
		$: 2,
		m: list
	};
}


var _Platform_map = F2(function(tagger, bag)
{
	return {
		$: 3,
		n: tagger,
		o: bag
	}
});



// PIPE BAGS INTO EFFECT MANAGERS
//
// Effects must be queued!
//
// Say your init contains a synchronous command, like Time.now or Time.here
//
//   - This will produce a batch of effects (FX_1)
//   - The synchronous task triggers the subsequent `update` call
//   - This will produce a batch of effects (FX_2)
//
// If we just start dispatching FX_2, subscriptions from FX_2 can be processed
// before subscriptions from FX_1. No good! Earlier versions of this code had
// this problem, leading to these reports:
//
//   https://github.com/elm/core/issues/980
//   https://github.com/elm/core/pull/981
//   https://github.com/elm/compiler/issues/1776
//
// The queue is necessary to avoid ordering issues for synchronous commands.


// Why use true/false here? Why not just check the length of the queue?
// The goal is to detect "are we currently dispatching effects?" If we
// are, we need to bail and let the ongoing while loop handle things.
//
// Now say the queue has 1 element. When we dequeue the final element,
// the queue will be empty, but we are still actively dispatching effects.
// So you could get queue jumping in a really tricky category of cases.
//
var _Platform_effectsQueue = [];
var _Platform_effectsActive = false;


function _Platform_enqueueEffects(managers, cmdBag, subBag)
{
	_Platform_effectsQueue.push({ p: managers, q: cmdBag, r: subBag });

	if (_Platform_effectsActive) return;

	_Platform_effectsActive = true;
	for (var fx; fx = _Platform_effectsQueue.shift(); )
	{
		_Platform_dispatchEffects(fx.p, fx.q, fx.r);
	}
	_Platform_effectsActive = false;
}


function _Platform_dispatchEffects(managers, cmdBag, subBag)
{
	var effectsDict = {};
	_Platform_gatherEffects(true, cmdBag, effectsDict, null);
	_Platform_gatherEffects(false, subBag, effectsDict, null);

	for (var home in managers)
	{
		_Scheduler_rawSend(managers[home], {
			$: 'fx',
			a: effectsDict[home] || { i: _List_Nil, j: _List_Nil }
		});
	}
}


function _Platform_gatherEffects(isCmd, bag, effectsDict, taggers)
{
	switch (bag.$)
	{
		case 1:
			var home = bag.k;
			var effect = _Platform_toEffect(isCmd, home, taggers, bag.l);
			effectsDict[home] = _Platform_insert(isCmd, effect, effectsDict[home]);
			return;

		case 2:
			for (var list = bag.m; list.b; list = list.b) // WHILE_CONS
			{
				_Platform_gatherEffects(isCmd, list.a, effectsDict, taggers);
			}
			return;

		case 3:
			_Platform_gatherEffects(isCmd, bag.o, effectsDict, {
				s: bag.n,
				t: taggers
			});
			return;
	}
}


function _Platform_toEffect(isCmd, home, taggers, value)
{
	function applyTaggers(x)
	{
		for (var temp = taggers; temp; temp = temp.t)
		{
			x = temp.s(x);
		}
		return x;
	}

	var map = isCmd
		? _Platform_effectManagers[home].e
		: _Platform_effectManagers[home].f;

	return A2(map, applyTaggers, value)
}


function _Platform_insert(isCmd, newEffect, effects)
{
	effects = effects || { i: _List_Nil, j: _List_Nil };

	isCmd
		? (effects.i = _List_Cons(newEffect, effects.i))
		: (effects.j = _List_Cons(newEffect, effects.j));

	return effects;
}



// PORTS


function _Platform_checkPortName(name)
{
	if (_Platform_effectManagers[name])
	{
		_Debug_crash(3, name)
	}
}



// OUTGOING PORTS


function _Platform_outgoingPort(name, converter)
{
	_Platform_checkPortName(name);
	_Platform_effectManagers[name] = {
		e: _Platform_outgoingPortMap,
		u: converter,
		a: _Platform_setupOutgoingPort
	};
	return _Platform_leaf(name);
}


var _Platform_outgoingPortMap = F2(function(tagger, value) { return value; });


function _Platform_setupOutgoingPort(name)
{
	var subs = [];
	var converter = _Platform_effectManagers[name].u;

	// CREATE MANAGER

	var init = _Process_sleep(0);

	_Platform_effectManagers[name].b = init;
	_Platform_effectManagers[name].c = F3(function(router, cmdList, state)
	{
		for ( ; cmdList.b; cmdList = cmdList.b) // WHILE_CONS
		{
			// grab a separate reference to subs in case unsubscribe is called
			var currentSubs = subs;
			var value = _Json_unwrap(converter(cmdList.a));
			for (var i = 0; i < currentSubs.length; i++)
			{
				currentSubs[i](value);
			}
		}
		return init;
	});

	// PUBLIC API

	function subscribe(callback)
	{
		subs.push(callback);
	}

	function unsubscribe(callback)
	{
		// copy subs into a new array in case unsubscribe is called within a
		// subscribed callback
		subs = subs.slice();
		var index = subs.indexOf(callback);
		if (index >= 0)
		{
			subs.splice(index, 1);
		}
	}

	return {
		subscribe: subscribe,
		unsubscribe: unsubscribe
	};
}



// INCOMING PORTS


function _Platform_incomingPort(name, converter)
{
	_Platform_checkPortName(name);
	_Platform_effectManagers[name] = {
		f: _Platform_incomingPortMap,
		u: converter,
		a: _Platform_setupIncomingPort
	};
	return _Platform_leaf(name);
}


var _Platform_incomingPortMap = F2(function(tagger, finalTagger)
{
	return function(value)
	{
		return tagger(finalTagger(value));
	};
});


function _Platform_setupIncomingPort(name, sendToApp)
{
	var subs = _List_Nil;
	var converter = _Platform_effectManagers[name].u;

	// CREATE MANAGER

	var init = _Scheduler_succeed(null);

	_Platform_effectManagers[name].b = init;
	_Platform_effectManagers[name].c = F3(function(router, subList, state)
	{
		subs = subList;
		return init;
	});

	// PUBLIC API

	function send(incomingValue)
	{
		var result = A2(_Json_run, converter, _Json_wrap(incomingValue));

		$elm$core$Result$isOk(result) || _Debug_crash(4, name, result.a);

		var value = result.a;
		for (var temp = subs; temp.b; temp = temp.b) // WHILE_CONS
		{
			sendToApp(temp.a(value));
		}
	}

	return { send: send };
}



// EXPORT ELM MODULES
//
// Have DEBUG and PROD versions so that we can (1) give nicer errors in
// debug mode and (2) not pay for the bits needed for that in prod mode.
//


function _Platform_export_UNUSED(exports)
{
	scope['Elm']
		? _Platform_mergeExportsProd(scope['Elm'], exports)
		: scope['Elm'] = exports;
}


function _Platform_mergeExportsProd(obj, exports)
{
	for (var name in exports)
	{
		(name in obj)
			? (name == 'init')
				? _Debug_crash(6)
				: _Platform_mergeExportsProd(obj[name], exports[name])
			: (obj[name] = exports[name]);
	}
}


function _Platform_export(exports)
{
	scope['Elm']
		? _Platform_mergeExportsDebug('Elm', scope['Elm'], exports)
		: scope['Elm'] = exports;
}


function _Platform_mergeExportsDebug(moduleName, obj, exports)
{
	for (var name in exports)
	{
		(name in obj)
			? (name == 'init')
				? _Debug_crash(6, moduleName)
				: _Platform_mergeExportsDebug(moduleName + '.' + name, obj[name], exports[name])
			: (obj[name] = exports[name]);
	}
}




// HELPERS


var _VirtualDom_divertHrefToApp;

var _VirtualDom_doc = typeof document !== 'undefined' ? document : {};


function _VirtualDom_appendChild(parent, child)
{
	parent.appendChild(child);
}

var _VirtualDom_init = F4(function(virtualNode, flagDecoder, debugMetadata, args)
{
	// NOTE: this function needs _Platform_export available to work

	/**_UNUSED/
	var node = args['node'];
	//*/
	/**/
	var node = args && args['node'] ? args['node'] : _Debug_crash(0);
	//*/

	node.parentNode.replaceChild(
		_VirtualDom_render(virtualNode, function() {}),
		node
	);

	return {};
});



// TEXT


function _VirtualDom_text(string)
{
	return {
		$: 0,
		a: string
	};
}



// NODE


var _VirtualDom_nodeNS = F2(function(namespace, tag)
{
	return F2(function(factList, kidList)
	{
		for (var kids = [], descendantsCount = 0; kidList.b; kidList = kidList.b) // WHILE_CONS
		{
			var kid = kidList.a;
			descendantsCount += (kid.b || 0);
			kids.push(kid);
		}
		descendantsCount += kids.length;

		return {
			$: 1,
			c: tag,
			d: _VirtualDom_organizeFacts(factList),
			e: kids,
			f: namespace,
			b: descendantsCount
		};
	});
});


var _VirtualDom_node = _VirtualDom_nodeNS(undefined);



// KEYED NODE


var _VirtualDom_keyedNodeNS = F2(function(namespace, tag)
{
	return F2(function(factList, kidList)
	{
		for (var kids = [], descendantsCount = 0; kidList.b; kidList = kidList.b) // WHILE_CONS
		{
			var kid = kidList.a;
			descendantsCount += (kid.b.b || 0);
			kids.push(kid);
		}
		descendantsCount += kids.length;

		return {
			$: 2,
			c: tag,
			d: _VirtualDom_organizeFacts(factList),
			e: kids,
			f: namespace,
			b: descendantsCount
		};
	});
});


var _VirtualDom_keyedNode = _VirtualDom_keyedNodeNS(undefined);



// CUSTOM


function _VirtualDom_custom(factList, model, render, diff)
{
	return {
		$: 3,
		d: _VirtualDom_organizeFacts(factList),
		g: model,
		h: render,
		i: diff
	};
}



// MAP


var _VirtualDom_map = F2(function(tagger, node)
{
	return {
		$: 4,
		j: tagger,
		k: node,
		b: 1 + (node.b || 0)
	};
});



// LAZY


function _VirtualDom_thunk(refs, thunk)
{
	return {
		$: 5,
		l: refs,
		m: thunk,
		k: undefined
	};
}

var _VirtualDom_lazy = F2(function(func, a)
{
	return _VirtualDom_thunk([func, a], function() {
		return func(a);
	});
});

var _VirtualDom_lazy2 = F3(function(func, a, b)
{
	return _VirtualDom_thunk([func, a, b], function() {
		return A2(func, a, b);
	});
});

var _VirtualDom_lazy3 = F4(function(func, a, b, c)
{
	return _VirtualDom_thunk([func, a, b, c], function() {
		return A3(func, a, b, c);
	});
});

var _VirtualDom_lazy4 = F5(function(func, a, b, c, d)
{
	return _VirtualDom_thunk([func, a, b, c, d], function() {
		return A4(func, a, b, c, d);
	});
});

var _VirtualDom_lazy5 = F6(function(func, a, b, c, d, e)
{
	return _VirtualDom_thunk([func, a, b, c, d, e], function() {
		return A5(func, a, b, c, d, e);
	});
});

var _VirtualDom_lazy6 = F7(function(func, a, b, c, d, e, f)
{
	return _VirtualDom_thunk([func, a, b, c, d, e, f], function() {
		return A6(func, a, b, c, d, e, f);
	});
});

var _VirtualDom_lazy7 = F8(function(func, a, b, c, d, e, f, g)
{
	return _VirtualDom_thunk([func, a, b, c, d, e, f, g], function() {
		return A7(func, a, b, c, d, e, f, g);
	});
});

var _VirtualDom_lazy8 = F9(function(func, a, b, c, d, e, f, g, h)
{
	return _VirtualDom_thunk([func, a, b, c, d, e, f, g, h], function() {
		return A8(func, a, b, c, d, e, f, g, h);
	});
});



// FACTS


var _VirtualDom_on = F2(function(key, handler)
{
	return {
		$: 'a0',
		n: key,
		o: handler
	};
});
var _VirtualDom_style = F2(function(key, value)
{
	return {
		$: 'a1',
		n: key,
		o: value
	};
});
var _VirtualDom_property = F2(function(key, value)
{
	return {
		$: 'a2',
		n: key,
		o: value
	};
});
var _VirtualDom_attribute = F2(function(key, value)
{
	return {
		$: 'a3',
		n: key,
		o: value
	};
});
var _VirtualDom_attributeNS = F3(function(namespace, key, value)
{
	return {
		$: 'a4',
		n: key,
		o: { f: namespace, o: value }
	};
});



// XSS ATTACK VECTOR CHECKS


function _VirtualDom_noScript(tag)
{
	return tag == 'script' ? 'p' : tag;
}

function _VirtualDom_noOnOrFormAction(key)
{
	return /^(on|formAction$)/i.test(key) ? 'data-' + key : key;
}

function _VirtualDom_noInnerHtmlOrFormAction(key)
{
	return key == 'innerHTML' || key == 'formAction' ? 'data-' + key : key;
}

function _VirtualDom_noJavaScriptUri_UNUSED(value)
{
	return /^javascript:/i.test(value.replace(/\s/g,'')) ? '' : value;
}

function _VirtualDom_noJavaScriptUri(value)
{
	return /^javascript:/i.test(value.replace(/\s/g,''))
		? 'javascript:alert("This is an XSS vector. Please use ports or web components instead.")'
		: value;
}

function _VirtualDom_noJavaScriptOrHtmlUri_UNUSED(value)
{
	return /^\s*(javascript:|data:text\/html)/i.test(value) ? '' : value;
}

function _VirtualDom_noJavaScriptOrHtmlUri(value)
{
	return /^\s*(javascript:|data:text\/html)/i.test(value)
		? 'javascript:alert("This is an XSS vector. Please use ports or web components instead.")'
		: value;
}



// MAP FACTS


var _VirtualDom_mapAttribute = F2(function(func, attr)
{
	return (attr.$ === 'a0')
		? A2(_VirtualDom_on, attr.n, _VirtualDom_mapHandler(func, attr.o))
		: attr;
});

function _VirtualDom_mapHandler(func, handler)
{
	var tag = $elm$virtual_dom$VirtualDom$toHandlerInt(handler);

	// 0 = Normal
	// 1 = MayStopPropagation
	// 2 = MayPreventDefault
	// 3 = Custom

	return {
		$: handler.$,
		a:
			!tag
				? A2($elm$json$Json$Decode$map, func, handler.a)
				:
			A3($elm$json$Json$Decode$map2,
				tag < 3
					? _VirtualDom_mapEventTuple
					: _VirtualDom_mapEventRecord,
				$elm$json$Json$Decode$succeed(func),
				handler.a
			)
	};
}

var _VirtualDom_mapEventTuple = F2(function(func, tuple)
{
	return _Utils_Tuple2(func(tuple.a), tuple.b);
});

var _VirtualDom_mapEventRecord = F2(function(func, record)
{
	return {
		message: func(record.message),
		stopPropagation: record.stopPropagation,
		preventDefault: record.preventDefault
	}
});



// ORGANIZE FACTS


function _VirtualDom_organizeFacts(factList)
{
	for (var facts = {}; factList.b; factList = factList.b) // WHILE_CONS
	{
		var entry = factList.a;

		var tag = entry.$;
		var key = entry.n;
		var value = entry.o;

		if (tag === 'a2')
		{
			(key === 'className')
				? _VirtualDom_addClass(facts, key, _Json_unwrap(value))
				: facts[key] = _Json_unwrap(value);

			continue;
		}

		var subFacts = facts[tag] || (facts[tag] = {});
		(tag === 'a3' && key === 'class')
			? _VirtualDom_addClass(subFacts, key, value)
			: subFacts[key] = value;
	}

	return facts;
}

function _VirtualDom_addClass(object, key, newClass)
{
	var classes = object[key];
	object[key] = classes ? classes + ' ' + newClass : newClass;
}



// RENDER


function _VirtualDom_render(vNode, eventNode)
{
	var tag = vNode.$;

	if (tag === 5)
	{
		return _VirtualDom_render(vNode.k || (vNode.k = vNode.m()), eventNode);
	}

	if (tag === 0)
	{
		return _VirtualDom_doc.createTextNode(vNode.a);
	}

	if (tag === 4)
	{
		var subNode = vNode.k;
		var tagger = vNode.j;

		while (subNode.$ === 4)
		{
			typeof tagger !== 'object'
				? tagger = [tagger, subNode.j]
				: tagger.push(subNode.j);

			subNode = subNode.k;
		}

		var subEventRoot = { j: tagger, p: eventNode };
		var domNode = _VirtualDom_render(subNode, subEventRoot);
		domNode.elm_event_node_ref = subEventRoot;
		return domNode;
	}

	if (tag === 3)
	{
		var domNode = vNode.h(vNode.g);
		_VirtualDom_applyFacts(domNode, eventNode, vNode.d);
		return domNode;
	}

	// at this point `tag` must be 1 or 2

	var domNode = vNode.f
		? _VirtualDom_doc.createElementNS(vNode.f, vNode.c)
		: _VirtualDom_doc.createElement(vNode.c);

	if (_VirtualDom_divertHrefToApp && vNode.c == 'a')
	{
		domNode.addEventListener('click', _VirtualDom_divertHrefToApp(domNode));
	}

	_VirtualDom_applyFacts(domNode, eventNode, vNode.d);

	for (var kids = vNode.e, i = 0; i < kids.length; i++)
	{
		_VirtualDom_appendChild(domNode, _VirtualDom_render(tag === 1 ? kids[i] : kids[i].b, eventNode));
	}

	return domNode;
}



// APPLY FACTS


function _VirtualDom_applyFacts(domNode, eventNode, facts)
{
	for (var key in facts)
	{
		var value = facts[key];

		key === 'a1'
			? _VirtualDom_applyStyles(domNode, value)
			:
		key === 'a0'
			? _VirtualDom_applyEvents(domNode, eventNode, value)
			:
		key === 'a3'
			? _VirtualDom_applyAttrs(domNode, value)
			:
		key === 'a4'
			? _VirtualDom_applyAttrsNS(domNode, value)
			:
		((key !== 'value' && key !== 'checked') || domNode[key] !== value) && (domNode[key] = value);
	}
}



// APPLY STYLES


function _VirtualDom_applyStyles(domNode, styles)
{
	var domNodeStyle = domNode.style;

	for (var key in styles)
	{
		domNodeStyle[key] = styles[key];
	}
}



// APPLY ATTRS


function _VirtualDom_applyAttrs(domNode, attrs)
{
	for (var key in attrs)
	{
		var value = attrs[key];
		typeof value !== 'undefined'
			? domNode.setAttribute(key, value)
			: domNode.removeAttribute(key);
	}
}



// APPLY NAMESPACED ATTRS


function _VirtualDom_applyAttrsNS(domNode, nsAttrs)
{
	for (var key in nsAttrs)
	{
		var pair = nsAttrs[key];
		var namespace = pair.f;
		var value = pair.o;

		typeof value !== 'undefined'
			? domNode.setAttributeNS(namespace, key, value)
			: domNode.removeAttributeNS(namespace, key);
	}
}



// APPLY EVENTS


function _VirtualDom_applyEvents(domNode, eventNode, events)
{
	var allCallbacks = domNode.elmFs || (domNode.elmFs = {});

	for (var key in events)
	{
		var newHandler = events[key];
		var oldCallback = allCallbacks[key];

		if (!newHandler)
		{
			domNode.removeEventListener(key, oldCallback);
			allCallbacks[key] = undefined;
			continue;
		}

		if (oldCallback)
		{
			var oldHandler = oldCallback.q;
			if (oldHandler.$ === newHandler.$)
			{
				oldCallback.q = newHandler;
				continue;
			}
			domNode.removeEventListener(key, oldCallback);
		}

		oldCallback = _VirtualDom_makeCallback(eventNode, newHandler);
		domNode.addEventListener(key, oldCallback,
			_VirtualDom_passiveSupported
			&& { passive: $elm$virtual_dom$VirtualDom$toHandlerInt(newHandler) < 2 }
		);
		allCallbacks[key] = oldCallback;
	}
}



// PASSIVE EVENTS


var _VirtualDom_passiveSupported;

try
{
	window.addEventListener('t', null, Object.defineProperty({}, 'passive', {
		get: function() { _VirtualDom_passiveSupported = true; }
	}));
}
catch(e) {}



// EVENT HANDLERS


function _VirtualDom_makeCallback(eventNode, initialHandler)
{
	function callback(event)
	{
		var handler = callback.q;
		var result = _Json_runHelp(handler.a, event);

		if (!$elm$core$Result$isOk(result))
		{
			return;
		}

		var tag = $elm$virtual_dom$VirtualDom$toHandlerInt(handler);

		// 0 = Normal
		// 1 = MayStopPropagation
		// 2 = MayPreventDefault
		// 3 = Custom

		var value = result.a;
		var message = !tag ? value : tag < 3 ? value.a : value.message;
		var stopPropagation = tag == 1 ? value.b : tag == 3 && value.stopPropagation;
		var currentEventNode = (
			stopPropagation && event.stopPropagation(),
			(tag == 2 ? value.b : tag == 3 && value.preventDefault) && event.preventDefault(),
			eventNode
		);
		var tagger;
		var i;
		while (tagger = currentEventNode.j)
		{
			if (typeof tagger == 'function')
			{
				message = tagger(message);
			}
			else
			{
				for (var i = tagger.length; i--; )
				{
					message = tagger[i](message);
				}
			}
			currentEventNode = currentEventNode.p;
		}
		currentEventNode(message, stopPropagation); // stopPropagation implies isSync
	}

	callback.q = initialHandler;

	return callback;
}

function _VirtualDom_equalEvents(x, y)
{
	return x.$ == y.$ && _Json_equality(x.a, y.a);
}



// DIFF


// TODO: Should we do patches like in iOS?
//
// type Patch
//   = At Int Patch
//   | Batch (List Patch)
//   | Change ...
//
// How could it not be better?
//
function _VirtualDom_diff(x, y)
{
	var patches = [];
	_VirtualDom_diffHelp(x, y, patches, 0);
	return patches;
}


function _VirtualDom_pushPatch(patches, type, index, data)
{
	var patch = {
		$: type,
		r: index,
		s: data,
		t: undefined,
		u: undefined
	};
	patches.push(patch);
	return patch;
}


function _VirtualDom_diffHelp(x, y, patches, index)
{
	if (x === y)
	{
		return;
	}

	var xType = x.$;
	var yType = y.$;

	// Bail if you run into different types of nodes. Implies that the
	// structure has changed significantly and it's not worth a diff.
	if (xType !== yType)
	{
		if (xType === 1 && yType === 2)
		{
			y = _VirtualDom_dekey(y);
			yType = 1;
		}
		else
		{
			_VirtualDom_pushPatch(patches, 0, index, y);
			return;
		}
	}

	// Now we know that both nodes are the same $.
	switch (yType)
	{
		case 5:
			var xRefs = x.l;
			var yRefs = y.l;
			var i = xRefs.length;
			var same = i === yRefs.length;
			while (same && i--)
			{
				same = xRefs[i] === yRefs[i];
			}
			if (same)
			{
				y.k = x.k;
				return;
			}
			y.k = y.m();
			var subPatches = [];
			_VirtualDom_diffHelp(x.k, y.k, subPatches, 0);
			subPatches.length > 0 && _VirtualDom_pushPatch(patches, 1, index, subPatches);
			return;

		case 4:
			// gather nested taggers
			var xTaggers = x.j;
			var yTaggers = y.j;
			var nesting = false;

			var xSubNode = x.k;
			while (xSubNode.$ === 4)
			{
				nesting = true;

				typeof xTaggers !== 'object'
					? xTaggers = [xTaggers, xSubNode.j]
					: xTaggers.push(xSubNode.j);

				xSubNode = xSubNode.k;
			}

			var ySubNode = y.k;
			while (ySubNode.$ === 4)
			{
				nesting = true;

				typeof yTaggers !== 'object'
					? yTaggers = [yTaggers, ySubNode.j]
					: yTaggers.push(ySubNode.j);

				ySubNode = ySubNode.k;
			}

			// Just bail if different numbers of taggers. This implies the
			// structure of the virtual DOM has changed.
			if (nesting && xTaggers.length !== yTaggers.length)
			{
				_VirtualDom_pushPatch(patches, 0, index, y);
				return;
			}

			// check if taggers are "the same"
			if (nesting ? !_VirtualDom_pairwiseRefEqual(xTaggers, yTaggers) : xTaggers !== yTaggers)
			{
				_VirtualDom_pushPatch(patches, 2, index, yTaggers);
			}

			// diff everything below the taggers
			_VirtualDom_diffHelp(xSubNode, ySubNode, patches, index + 1);
			return;

		case 0:
			if (x.a !== y.a)
			{
				_VirtualDom_pushPatch(patches, 3, index, y.a);
			}
			return;

		case 1:
			_VirtualDom_diffNodes(x, y, patches, index, _VirtualDom_diffKids);
			return;

		case 2:
			_VirtualDom_diffNodes(x, y, patches, index, _VirtualDom_diffKeyedKids);
			return;

		case 3:
			if (x.h !== y.h)
			{
				_VirtualDom_pushPatch(patches, 0, index, y);
				return;
			}

			var factsDiff = _VirtualDom_diffFacts(x.d, y.d);
			factsDiff && _VirtualDom_pushPatch(patches, 4, index, factsDiff);

			var patch = y.i(x.g, y.g);
			patch && _VirtualDom_pushPatch(patches, 5, index, patch);

			return;
	}
}

// assumes the incoming arrays are the same length
function _VirtualDom_pairwiseRefEqual(as, bs)
{
	for (var i = 0; i < as.length; i++)
	{
		if (as[i] !== bs[i])
		{
			return false;
		}
	}

	return true;
}

function _VirtualDom_diffNodes(x, y, patches, index, diffKids)
{
	// Bail if obvious indicators have changed. Implies more serious
	// structural changes such that it's not worth it to diff.
	if (x.c !== y.c || x.f !== y.f)
	{
		_VirtualDom_pushPatch(patches, 0, index, y);
		return;
	}

	var factsDiff = _VirtualDom_diffFacts(x.d, y.d);
	factsDiff && _VirtualDom_pushPatch(patches, 4, index, factsDiff);

	diffKids(x, y, patches, index);
}



// DIFF FACTS


// TODO Instead of creating a new diff object, it's possible to just test if
// there *is* a diff. During the actual patch, do the diff again and make the
// modifications directly. This way, there's no new allocations. Worth it?
function _VirtualDom_diffFacts(x, y, category)
{
	var diff;

	// look for changes and removals
	for (var xKey in x)
	{
		if (xKey === 'a1' || xKey === 'a0' || xKey === 'a3' || xKey === 'a4')
		{
			var subDiff = _VirtualDom_diffFacts(x[xKey], y[xKey] || {}, xKey);
			if (subDiff)
			{
				diff = diff || {};
				diff[xKey] = subDiff;
			}
			continue;
		}

		// remove if not in the new facts
		if (!(xKey in y))
		{
			diff = diff || {};
			diff[xKey] =
				!category
					? (typeof x[xKey] === 'string' ? '' : null)
					:
				(category === 'a1')
					? ''
					:
				(category === 'a0' || category === 'a3')
					? undefined
					:
				{ f: x[xKey].f, o: undefined };

			continue;
		}

		var xValue = x[xKey];
		var yValue = y[xKey];

		// reference equal, so don't worry about it
		if (xValue === yValue && xKey !== 'value' && xKey !== 'checked'
			|| category === 'a0' && _VirtualDom_equalEvents(xValue, yValue))
		{
			continue;
		}

		diff = diff || {};
		diff[xKey] = yValue;
	}

	// add new stuff
	for (var yKey in y)
	{
		if (!(yKey in x))
		{
			diff = diff || {};
			diff[yKey] = y[yKey];
		}
	}

	return diff;
}



// DIFF KIDS


function _VirtualDom_diffKids(xParent, yParent, patches, index)
{
	var xKids = xParent.e;
	var yKids = yParent.e;

	var xLen = xKids.length;
	var yLen = yKids.length;

	// FIGURE OUT IF THERE ARE INSERTS OR REMOVALS

	if (xLen > yLen)
	{
		_VirtualDom_pushPatch(patches, 6, index, {
			v: yLen,
			i: xLen - yLen
		});
	}
	else if (xLen < yLen)
	{
		_VirtualDom_pushPatch(patches, 7, index, {
			v: xLen,
			e: yKids
		});
	}

	// PAIRWISE DIFF EVERYTHING ELSE

	for (var minLen = xLen < yLen ? xLen : yLen, i = 0; i < minLen; i++)
	{
		var xKid = xKids[i];
		_VirtualDom_diffHelp(xKid, yKids[i], patches, ++index);
		index += xKid.b || 0;
	}
}



// KEYED DIFF


function _VirtualDom_diffKeyedKids(xParent, yParent, patches, rootIndex)
{
	var localPatches = [];

	var changes = {}; // Dict String Entry
	var inserts = []; // Array { index : Int, entry : Entry }
	// type Entry = { tag : String, vnode : VNode, index : Int, data : _ }

	var xKids = xParent.e;
	var yKids = yParent.e;
	var xLen = xKids.length;
	var yLen = yKids.length;
	var xIndex = 0;
	var yIndex = 0;

	var index = rootIndex;

	while (xIndex < xLen && yIndex < yLen)
	{
		var x = xKids[xIndex];
		var y = yKids[yIndex];

		var xKey = x.a;
		var yKey = y.a;
		var xNode = x.b;
		var yNode = y.b;

		var newMatch = undefined;
		var oldMatch = undefined;

		// check if keys match

		if (xKey === yKey)
		{
			index++;
			_VirtualDom_diffHelp(xNode, yNode, localPatches, index);
			index += xNode.b || 0;

			xIndex++;
			yIndex++;
			continue;
		}

		// look ahead 1 to detect insertions and removals.

		var xNext = xKids[xIndex + 1];
		var yNext = yKids[yIndex + 1];

		if (xNext)
		{
			var xNextKey = xNext.a;
			var xNextNode = xNext.b;
			oldMatch = yKey === xNextKey;
		}

		if (yNext)
		{
			var yNextKey = yNext.a;
			var yNextNode = yNext.b;
			newMatch = xKey === yNextKey;
		}


		// swap x and y
		if (newMatch && oldMatch)
		{
			index++;
			_VirtualDom_diffHelp(xNode, yNextNode, localPatches, index);
			_VirtualDom_insertNode(changes, localPatches, xKey, yNode, yIndex, inserts);
			index += xNode.b || 0;

			index++;
			_VirtualDom_removeNode(changes, localPatches, xKey, xNextNode, index);
			index += xNextNode.b || 0;

			xIndex += 2;
			yIndex += 2;
			continue;
		}

		// insert y
		if (newMatch)
		{
			index++;
			_VirtualDom_insertNode(changes, localPatches, yKey, yNode, yIndex, inserts);
			_VirtualDom_diffHelp(xNode, yNextNode, localPatches, index);
			index += xNode.b || 0;

			xIndex += 1;
			yIndex += 2;
			continue;
		}

		// remove x
		if (oldMatch)
		{
			index++;
			_VirtualDom_removeNode(changes, localPatches, xKey, xNode, index);
			index += xNode.b || 0;

			index++;
			_VirtualDom_diffHelp(xNextNode, yNode, localPatches, index);
			index += xNextNode.b || 0;

			xIndex += 2;
			yIndex += 1;
			continue;
		}

		// remove x, insert y
		if (xNext && xNextKey === yNextKey)
		{
			index++;
			_VirtualDom_removeNode(changes, localPatches, xKey, xNode, index);
			_VirtualDom_insertNode(changes, localPatches, yKey, yNode, yIndex, inserts);
			index += xNode.b || 0;

			index++;
			_VirtualDom_diffHelp(xNextNode, yNextNode, localPatches, index);
			index += xNextNode.b || 0;

			xIndex += 2;
			yIndex += 2;
			continue;
		}

		break;
	}

	// eat up any remaining nodes with removeNode and insertNode

	while (xIndex < xLen)
	{
		index++;
		var x = xKids[xIndex];
		var xNode = x.b;
		_VirtualDom_removeNode(changes, localPatches, x.a, xNode, index);
		index += xNode.b || 0;
		xIndex++;
	}

	while (yIndex < yLen)
	{
		var endInserts = endInserts || [];
		var y = yKids[yIndex];
		_VirtualDom_insertNode(changes, localPatches, y.a, y.b, undefined, endInserts);
		yIndex++;
	}

	if (localPatches.length > 0 || inserts.length > 0 || endInserts)
	{
		_VirtualDom_pushPatch(patches, 8, rootIndex, {
			w: localPatches,
			x: inserts,
			y: endInserts
		});
	}
}



// CHANGES FROM KEYED DIFF


var _VirtualDom_POSTFIX = '_elmW6BL';


function _VirtualDom_insertNode(changes, localPatches, key, vnode, yIndex, inserts)
{
	var entry = changes[key];

	// never seen this key before
	if (!entry)
	{
		entry = {
			c: 0,
			z: vnode,
			r: yIndex,
			s: undefined
		};

		inserts.push({ r: yIndex, A: entry });
		changes[key] = entry;

		return;
	}

	// this key was removed earlier, a match!
	if (entry.c === 1)
	{
		inserts.push({ r: yIndex, A: entry });

		entry.c = 2;
		var subPatches = [];
		_VirtualDom_diffHelp(entry.z, vnode, subPatches, entry.r);
		entry.r = yIndex;
		entry.s.s = {
			w: subPatches,
			A: entry
		};

		return;
	}

	// this key has already been inserted or moved, a duplicate!
	_VirtualDom_insertNode(changes, localPatches, key + _VirtualDom_POSTFIX, vnode, yIndex, inserts);
}


function _VirtualDom_removeNode(changes, localPatches, key, vnode, index)
{
	var entry = changes[key];

	// never seen this key before
	if (!entry)
	{
		var patch = _VirtualDom_pushPatch(localPatches, 9, index, undefined);

		changes[key] = {
			c: 1,
			z: vnode,
			r: index,
			s: patch
		};

		return;
	}

	// this key was inserted earlier, a match!
	if (entry.c === 0)
	{
		entry.c = 2;
		var subPatches = [];
		_VirtualDom_diffHelp(vnode, entry.z, subPatches, index);

		_VirtualDom_pushPatch(localPatches, 9, index, {
			w: subPatches,
			A: entry
		});

		return;
	}

	// this key has already been removed or moved, a duplicate!
	_VirtualDom_removeNode(changes, localPatches, key + _VirtualDom_POSTFIX, vnode, index);
}



// ADD DOM NODES
//
// Each DOM node has an "index" assigned in order of traversal. It is important
// to minimize our crawl over the actual DOM, so these indexes (along with the
// descendantsCount of virtual nodes) let us skip touching entire subtrees of
// the DOM if we know there are no patches there.


function _VirtualDom_addDomNodes(domNode, vNode, patches, eventNode)
{
	_VirtualDom_addDomNodesHelp(domNode, vNode, patches, 0, 0, vNode.b, eventNode);
}


// assumes `patches` is non-empty and indexes increase monotonically.
function _VirtualDom_addDomNodesHelp(domNode, vNode, patches, i, low, high, eventNode)
{
	var patch = patches[i];
	var index = patch.r;

	while (index === low)
	{
		var patchType = patch.$;

		if (patchType === 1)
		{
			_VirtualDom_addDomNodes(domNode, vNode.k, patch.s, eventNode);
		}
		else if (patchType === 8)
		{
			patch.t = domNode;
			patch.u = eventNode;

			var subPatches = patch.s.w;
			if (subPatches.length > 0)
			{
				_VirtualDom_addDomNodesHelp(domNode, vNode, subPatches, 0, low, high, eventNode);
			}
		}
		else if (patchType === 9)
		{
			patch.t = domNode;
			patch.u = eventNode;

			var data = patch.s;
			if (data)
			{
				data.A.s = domNode;
				var subPatches = data.w;
				if (subPatches.length > 0)
				{
					_VirtualDom_addDomNodesHelp(domNode, vNode, subPatches, 0, low, high, eventNode);
				}
			}
		}
		else
		{
			patch.t = domNode;
			patch.u = eventNode;
		}

		i++;

		if (!(patch = patches[i]) || (index = patch.r) > high)
		{
			return i;
		}
	}

	var tag = vNode.$;

	if (tag === 4)
	{
		var subNode = vNode.k;

		while (subNode.$ === 4)
		{
			subNode = subNode.k;
		}

		return _VirtualDom_addDomNodesHelp(domNode, subNode, patches, i, low + 1, high, domNode.elm_event_node_ref);
	}

	// tag must be 1 or 2 at this point

	var vKids = vNode.e;
	var childNodes = domNode.childNodes;
	for (var j = 0; j < vKids.length; j++)
	{
		low++;
		var vKid = tag === 1 ? vKids[j] : vKids[j].b;
		var nextLow = low + (vKid.b || 0);
		if (low <= index && index <= nextLow)
		{
			i = _VirtualDom_addDomNodesHelp(childNodes[j], vKid, patches, i, low, nextLow, eventNode);
			if (!(patch = patches[i]) || (index = patch.r) > high)
			{
				return i;
			}
		}
		low = nextLow;
	}
	return i;
}



// APPLY PATCHES


function _VirtualDom_applyPatches(rootDomNode, oldVirtualNode, patches, eventNode)
{
	if (patches.length === 0)
	{
		return rootDomNode;
	}

	_VirtualDom_addDomNodes(rootDomNode, oldVirtualNode, patches, eventNode);
	return _VirtualDom_applyPatchesHelp(rootDomNode, patches);
}

function _VirtualDom_applyPatchesHelp(rootDomNode, patches)
{
	for (var i = 0; i < patches.length; i++)
	{
		var patch = patches[i];
		var localDomNode = patch.t
		var newNode = _VirtualDom_applyPatch(localDomNode, patch);
		if (localDomNode === rootDomNode)
		{
			rootDomNode = newNode;
		}
	}
	return rootDomNode;
}

function _VirtualDom_applyPatch(domNode, patch)
{
	switch (patch.$)
	{
		case 0:
			return _VirtualDom_applyPatchRedraw(domNode, patch.s, patch.u);

		case 4:
			_VirtualDom_applyFacts(domNode, patch.u, patch.s);
			return domNode;

		case 3:
			domNode.replaceData(0, domNode.length, patch.s);
			return domNode;

		case 1:
			return _VirtualDom_applyPatchesHelp(domNode, patch.s);

		case 2:
			if (domNode.elm_event_node_ref)
			{
				domNode.elm_event_node_ref.j = patch.s;
			}
			else
			{
				domNode.elm_event_node_ref = { j: patch.s, p: patch.u };
			}
			return domNode;

		case 6:
			var data = patch.s;
			for (var i = 0; i < data.i; i++)
			{
				domNode.removeChild(domNode.childNodes[data.v]);
			}
			return domNode;

		case 7:
			var data = patch.s;
			var kids = data.e;
			var i = data.v;
			var theEnd = domNode.childNodes[i];
			for (; i < kids.length; i++)
			{
				domNode.insertBefore(_VirtualDom_render(kids[i], patch.u), theEnd);
			}
			return domNode;

		case 9:
			var data = patch.s;
			if (!data)
			{
				domNode.parentNode.removeChild(domNode);
				return domNode;
			}
			var entry = data.A;
			if (typeof entry.r !== 'undefined')
			{
				domNode.parentNode.removeChild(domNode);
			}
			entry.s = _VirtualDom_applyPatchesHelp(domNode, data.w);
			return domNode;

		case 8:
			return _VirtualDom_applyPatchReorder(domNode, patch);

		case 5:
			return patch.s(domNode);

		default:
			_Debug_crash(10); // 'Ran into an unknown patch!'
	}
}


function _VirtualDom_applyPatchRedraw(domNode, vNode, eventNode)
{
	var parentNode = domNode.parentNode;
	var newNode = _VirtualDom_render(vNode, eventNode);

	if (!newNode.elm_event_node_ref)
	{
		newNode.elm_event_node_ref = domNode.elm_event_node_ref;
	}

	if (parentNode && newNode !== domNode)
	{
		parentNode.replaceChild(newNode, domNode);
	}
	return newNode;
}


function _VirtualDom_applyPatchReorder(domNode, patch)
{
	var data = patch.s;

	// remove end inserts
	var frag = _VirtualDom_applyPatchReorderEndInsertsHelp(data.y, patch);

	// removals
	domNode = _VirtualDom_applyPatchesHelp(domNode, data.w);

	// inserts
	var inserts = data.x;
	for (var i = 0; i < inserts.length; i++)
	{
		var insert = inserts[i];
		var entry = insert.A;
		var node = entry.c === 2
			? entry.s
			: _VirtualDom_render(entry.z, patch.u);
		domNode.insertBefore(node, domNode.childNodes[insert.r]);
	}

	// add end inserts
	if (frag)
	{
		_VirtualDom_appendChild(domNode, frag);
	}

	return domNode;
}


function _VirtualDom_applyPatchReorderEndInsertsHelp(endInserts, patch)
{
	if (!endInserts)
	{
		return;
	}

	var frag = _VirtualDom_doc.createDocumentFragment();
	for (var i = 0; i < endInserts.length; i++)
	{
		var insert = endInserts[i];
		var entry = insert.A;
		_VirtualDom_appendChild(frag, entry.c === 2
			? entry.s
			: _VirtualDom_render(entry.z, patch.u)
		);
	}
	return frag;
}


function _VirtualDom_virtualize(node)
{
	// TEXT NODES

	if (node.nodeType === 3)
	{
		return _VirtualDom_text(node.textContent);
	}


	// WEIRD NODES

	if (node.nodeType !== 1)
	{
		return _VirtualDom_text('');
	}


	// ELEMENT NODES

	var attrList = _List_Nil;
	var attrs = node.attributes;
	for (var i = attrs.length; i--; )
	{
		var attr = attrs[i];
		var name = attr.name;
		var value = attr.value;
		attrList = _List_Cons( A2(_VirtualDom_attribute, name, value), attrList );
	}

	var tag = node.tagName.toLowerCase();
	var kidList = _List_Nil;
	var kids = node.childNodes;

	for (var i = kids.length; i--; )
	{
		kidList = _List_Cons(_VirtualDom_virtualize(kids[i]), kidList);
	}
	return A3(_VirtualDom_node, tag, attrList, kidList);
}

function _VirtualDom_dekey(keyedNode)
{
	var keyedKids = keyedNode.e;
	var len = keyedKids.length;
	var kids = new Array(len);
	for (var i = 0; i < len; i++)
	{
		kids[i] = keyedKids[i].b;
	}

	return {
		$: 1,
		c: keyedNode.c,
		d: keyedNode.d,
		e: kids,
		f: keyedNode.f,
		b: keyedNode.b
	};
}




// ELEMENT


var _Debugger_element;

var _Browser_element = _Debugger_element || F4(function(impl, flagDecoder, debugMetadata, args)
{
	return _Platform_initialize(
		flagDecoder,
		args,
		impl.init,
		impl.update,
		impl.subscriptions,
		function(sendToApp, initialModel) {
			var view = impl.view;
			/**_UNUSED/
			var domNode = args['node'];
			//*/
			/**/
			var domNode = args && args['node'] ? args['node'] : _Debug_crash(0);
			//*/
			var currNode = _VirtualDom_virtualize(domNode);

			return _Browser_makeAnimator(initialModel, function(model)
			{
				var nextNode = view(model);
				var patches = _VirtualDom_diff(currNode, nextNode);
				domNode = _VirtualDom_applyPatches(domNode, currNode, patches, sendToApp);
				currNode = nextNode;
			});
		}
	);
});



// DOCUMENT


var _Debugger_document;

var _Browser_document = _Debugger_document || F4(function(impl, flagDecoder, debugMetadata, args)
{
	return _Platform_initialize(
		flagDecoder,
		args,
		impl.init,
		impl.update,
		impl.subscriptions,
		function(sendToApp, initialModel) {
			var divertHrefToApp = impl.setup && impl.setup(sendToApp)
			var view = impl.view;
			var title = _VirtualDom_doc.title;
			var bodyNode = _VirtualDom_doc.body;
			var currNode = _VirtualDom_virtualize(bodyNode);
			return _Browser_makeAnimator(initialModel, function(model)
			{
				_VirtualDom_divertHrefToApp = divertHrefToApp;
				var doc = view(model);
				var nextNode = _VirtualDom_node('body')(_List_Nil)(doc.body);
				var patches = _VirtualDom_diff(currNode, nextNode);
				bodyNode = _VirtualDom_applyPatches(bodyNode, currNode, patches, sendToApp);
				currNode = nextNode;
				_VirtualDom_divertHrefToApp = 0;
				(title !== doc.title) && (_VirtualDom_doc.title = title = doc.title);
			});
		}
	);
});



// ANIMATION


var _Browser_cancelAnimationFrame =
	typeof cancelAnimationFrame !== 'undefined'
		? cancelAnimationFrame
		: function(id) { clearTimeout(id); };

var _Browser_requestAnimationFrame =
	typeof requestAnimationFrame !== 'undefined'
		? requestAnimationFrame
		: function(callback) { return setTimeout(callback, 1000 / 60); };


function _Browser_makeAnimator(model, draw)
{
	draw(model);

	var state = 0;

	function updateIfNeeded()
	{
		state = state === 1
			? 0
			: ( _Browser_requestAnimationFrame(updateIfNeeded), draw(model), 1 );
	}

	return function(nextModel, isSync)
	{
		model = nextModel;

		isSync
			? ( draw(model),
				state === 2 && (state = 1)
				)
			: ( state === 0 && _Browser_requestAnimationFrame(updateIfNeeded),
				state = 2
				);
	};
}



// APPLICATION


function _Browser_application(impl)
{
	var onUrlChange = impl.onUrlChange;
	var onUrlRequest = impl.onUrlRequest;
	var key = function() { key.a(onUrlChange(_Browser_getUrl())); };

	return _Browser_document({
		setup: function(sendToApp)
		{
			key.a = sendToApp;
			_Browser_window.addEventListener('popstate', key);
			_Browser_window.navigator.userAgent.indexOf('Trident') < 0 || _Browser_window.addEventListener('hashchange', key);

			return F2(function(domNode, event)
			{
				if (!event.ctrlKey && !event.metaKey && !event.shiftKey && event.button < 1 && !domNode.target && !domNode.hasAttribute('download'))
				{
					event.preventDefault();
					var href = domNode.href;
					var curr = _Browser_getUrl();
					var next = $elm$url$Url$fromString(href).a;
					sendToApp(onUrlRequest(
						(next
							&& curr.protocol === next.protocol
							&& curr.host === next.host
							&& curr.port_.a === next.port_.a
						)
							? $elm$browser$Browser$Internal(next)
							: $elm$browser$Browser$External(href)
					));
				}
			});
		},
		init: function(flags)
		{
			return A3(impl.init, flags, _Browser_getUrl(), key);
		},
		view: impl.view,
		update: impl.update,
		subscriptions: impl.subscriptions
	});
}

function _Browser_getUrl()
{
	return $elm$url$Url$fromString(_VirtualDom_doc.location.href).a || _Debug_crash(1);
}

var _Browser_go = F2(function(key, n)
{
	return A2($elm$core$Task$perform, $elm$core$Basics$never, _Scheduler_binding(function() {
		n && history.go(n);
		key();
	}));
});

var _Browser_pushUrl = F2(function(key, url)
{
	return A2($elm$core$Task$perform, $elm$core$Basics$never, _Scheduler_binding(function() {
		history.pushState({}, '', url);
		key();
	}));
});

var _Browser_replaceUrl = F2(function(key, url)
{
	return A2($elm$core$Task$perform, $elm$core$Basics$never, _Scheduler_binding(function() {
		history.replaceState({}, '', url);
		key();
	}));
});



// GLOBAL EVENTS


var _Browser_fakeNode = { addEventListener: function() {}, removeEventListener: function() {} };
var _Browser_doc = typeof document !== 'undefined' ? document : _Browser_fakeNode;
var _Browser_window = typeof window !== 'undefined' ? window : _Browser_fakeNode;

var _Browser_on = F3(function(node, eventName, sendToSelf)
{
	return _Scheduler_spawn(_Scheduler_binding(function(callback)
	{
		function handler(event)	{ _Scheduler_rawSpawn(sendToSelf(event)); }
		node.addEventListener(eventName, handler, _VirtualDom_passiveSupported && { passive: true });
		return function() { node.removeEventListener(eventName, handler); };
	}));
});

var _Browser_decodeEvent = F2(function(decoder, event)
{
	var result = _Json_runHelp(decoder, event);
	return $elm$core$Result$isOk(result) ? $elm$core$Maybe$Just(result.a) : $elm$core$Maybe$Nothing;
});



// PAGE VISIBILITY


function _Browser_visibilityInfo()
{
	return (typeof _VirtualDom_doc.hidden !== 'undefined')
		? { hidden: 'hidden', change: 'visibilitychange' }
		:
	(typeof _VirtualDom_doc.mozHidden !== 'undefined')
		? { hidden: 'mozHidden', change: 'mozvisibilitychange' }
		:
	(typeof _VirtualDom_doc.msHidden !== 'undefined')
		? { hidden: 'msHidden', change: 'msvisibilitychange' }
		:
	(typeof _VirtualDom_doc.webkitHidden !== 'undefined')
		? { hidden: 'webkitHidden', change: 'webkitvisibilitychange' }
		: { hidden: 'hidden', change: 'visibilitychange' };
}



// ANIMATION FRAMES


function _Browser_rAF()
{
	return _Scheduler_binding(function(callback)
	{
		var id = _Browser_requestAnimationFrame(function() {
			callback(_Scheduler_succeed(Date.now()));
		});

		return function() {
			_Browser_cancelAnimationFrame(id);
		};
	});
}


function _Browser_now()
{
	return _Scheduler_binding(function(callback)
	{
		callback(_Scheduler_succeed(Date.now()));
	});
}



// DOM STUFF


function _Browser_withNode(id, doStuff)
{
	return _Scheduler_binding(function(callback)
	{
		_Browser_requestAnimationFrame(function() {
			var node = document.getElementById(id);
			callback(node
				? _Scheduler_succeed(doStuff(node))
				: _Scheduler_fail($elm$browser$Browser$Dom$NotFound(id))
			);
		});
	});
}


function _Browser_withWindow(doStuff)
{
	return _Scheduler_binding(function(callback)
	{
		_Browser_requestAnimationFrame(function() {
			callback(_Scheduler_succeed(doStuff()));
		});
	});
}


// FOCUS and BLUR


var _Browser_call = F2(function(functionName, id)
{
	return _Browser_withNode(id, function(node) {
		node[functionName]();
		return _Utils_Tuple0;
	});
});



// WINDOW VIEWPORT


function _Browser_getViewport()
{
	return {
		scene: _Browser_getScene(),
		viewport: {
			x: _Browser_window.pageXOffset,
			y: _Browser_window.pageYOffset,
			width: _Browser_doc.documentElement.clientWidth,
			height: _Browser_doc.documentElement.clientHeight
		}
	};
}

function _Browser_getScene()
{
	var body = _Browser_doc.body;
	var elem = _Browser_doc.documentElement;
	return {
		width: Math.max(body.scrollWidth, body.offsetWidth, elem.scrollWidth, elem.offsetWidth, elem.clientWidth),
		height: Math.max(body.scrollHeight, body.offsetHeight, elem.scrollHeight, elem.offsetHeight, elem.clientHeight)
	};
}

var _Browser_setViewport = F2(function(x, y)
{
	return _Browser_withWindow(function()
	{
		_Browser_window.scroll(x, y);
		return _Utils_Tuple0;
	});
});



// ELEMENT VIEWPORT


function _Browser_getViewportOf(id)
{
	return _Browser_withNode(id, function(node)
	{
		return {
			scene: {
				width: node.scrollWidth,
				height: node.scrollHeight
			},
			viewport: {
				x: node.scrollLeft,
				y: node.scrollTop,
				width: node.clientWidth,
				height: node.clientHeight
			}
		};
	});
}


var _Browser_setViewportOf = F3(function(id, x, y)
{
	return _Browser_withNode(id, function(node)
	{
		node.scrollLeft = x;
		node.scrollTop = y;
		return _Utils_Tuple0;
	});
});



// ELEMENT


function _Browser_getElement(id)
{
	return _Browser_withNode(id, function(node)
	{
		var rect = node.getBoundingClientRect();
		var x = _Browser_window.pageXOffset;
		var y = _Browser_window.pageYOffset;
		return {
			scene: _Browser_getScene(),
			viewport: {
				x: x,
				y: y,
				width: _Browser_doc.documentElement.clientWidth,
				height: _Browser_doc.documentElement.clientHeight
			},
			element: {
				x: x + rect.left,
				y: y + rect.top,
				width: rect.width,
				height: rect.height
			}
		};
	});
}



// LOAD and RELOAD


function _Browser_reload(skipCache)
{
	return A2($elm$core$Task$perform, $elm$core$Basics$never, _Scheduler_binding(function(callback)
	{
		_VirtualDom_doc.location.reload(skipCache);
	}));
}

function _Browser_load(url)
{
	return A2($elm$core$Task$perform, $elm$core$Basics$never, _Scheduler_binding(function(callback)
	{
		try
		{
			_Browser_window.location = url;
		}
		catch(err)
		{
			// Only Firefox can throw a NS_ERROR_MALFORMED_URI exception here.
			// Other browsers reload the page, so let's be consistent about that.
			_VirtualDom_doc.location.reload(false);
		}
	}));
}
var $elm$core$Basics$EQ = {$: 'EQ'};
var $elm$core$Basics$GT = {$: 'GT'};
var $elm$core$Basics$LT = {$: 'LT'};
var $elm$core$List$cons = _List_cons;
var $elm$core$Dict$foldr = F3(
	function (func, acc, t) {
		foldr:
		while (true) {
			if (t.$ === 'RBEmpty_elm_builtin') {
				return acc;
			} else {
				var key = t.b;
				var value = t.c;
				var left = t.d;
				var right = t.e;
				var $temp$func = func,
					$temp$acc = A3(
					func,
					key,
					value,
					A3($elm$core$Dict$foldr, func, acc, right)),
					$temp$t = left;
				func = $temp$func;
				acc = $temp$acc;
				t = $temp$t;
				continue foldr;
			}
		}
	});
var $elm$core$Dict$toList = function (dict) {
	return A3(
		$elm$core$Dict$foldr,
		F3(
			function (key, value, list) {
				return A2(
					$elm$core$List$cons,
					_Utils_Tuple2(key, value),
					list);
			}),
		_List_Nil,
		dict);
};
var $elm$core$Dict$keys = function (dict) {
	return A3(
		$elm$core$Dict$foldr,
		F3(
			function (key, value, keyList) {
				return A2($elm$core$List$cons, key, keyList);
			}),
		_List_Nil,
		dict);
};
var $elm$core$Set$toList = function (_v0) {
	var dict = _v0.a;
	return $elm$core$Dict$keys(dict);
};
var $elm$core$Elm$JsArray$foldr = _JsArray_foldr;
var $elm$core$Array$foldr = F3(
	function (func, baseCase, _v0) {
		var tree = _v0.c;
		var tail = _v0.d;
		var helper = F2(
			function (node, acc) {
				if (node.$ === 'SubTree') {
					var subTree = node.a;
					return A3($elm$core$Elm$JsArray$foldr, helper, acc, subTree);
				} else {
					var values = node.a;
					return A3($elm$core$Elm$JsArray$foldr, func, acc, values);
				}
			});
		return A3(
			$elm$core$Elm$JsArray$foldr,
			helper,
			A3($elm$core$Elm$JsArray$foldr, func, baseCase, tail),
			tree);
	});
var $elm$core$Array$toList = function (array) {
	return A3($elm$core$Array$foldr, $elm$core$List$cons, _List_Nil, array);
};
var $elm$core$Result$Err = function (a) {
	return {$: 'Err', a: a};
};
var $elm$json$Json$Decode$Failure = F2(
	function (a, b) {
		return {$: 'Failure', a: a, b: b};
	});
var $elm$json$Json$Decode$Field = F2(
	function (a, b) {
		return {$: 'Field', a: a, b: b};
	});
var $elm$json$Json$Decode$Index = F2(
	function (a, b) {
		return {$: 'Index', a: a, b: b};
	});
var $elm$core$Result$Ok = function (a) {
	return {$: 'Ok', a: a};
};
var $elm$json$Json$Decode$OneOf = function (a) {
	return {$: 'OneOf', a: a};
};
var $elm$core$Basics$False = {$: 'False'};
var $elm$core$Basics$add = _Basics_add;
var $elm$core$Maybe$Just = function (a) {
	return {$: 'Just', a: a};
};
var $elm$core$Maybe$Nothing = {$: 'Nothing'};
var $elm$core$String$all = _String_all;
var $elm$core$Basics$and = _Basics_and;
var $elm$core$Basics$append = _Utils_append;
var $elm$json$Json$Encode$encode = _Json_encode;
var $elm$core$String$fromInt = _String_fromNumber;
var $elm$core$String$join = F2(
	function (sep, chunks) {
		return A2(
			_String_join,
			sep,
			_List_toArray(chunks));
	});
var $elm$core$String$split = F2(
	function (sep, string) {
		return _List_fromArray(
			A2(_String_split, sep, string));
	});
var $elm$json$Json$Decode$indent = function (str) {
	return A2(
		$elm$core$String$join,
		'\n    ',
		A2($elm$core$String$split, '\n', str));
};
var $elm$core$List$foldl = F3(
	function (func, acc, list) {
		foldl:
		while (true) {
			if (!list.b) {
				return acc;
			} else {
				var x = list.a;
				var xs = list.b;
				var $temp$func = func,
					$temp$acc = A2(func, x, acc),
					$temp$list = xs;
				func = $temp$func;
				acc = $temp$acc;
				list = $temp$list;
				continue foldl;
			}
		}
	});
var $elm$core$List$length = function (xs) {
	return A3(
		$elm$core$List$foldl,
		F2(
			function (_v0, i) {
				return i + 1;
			}),
		0,
		xs);
};
var $elm$core$List$map2 = _List_map2;
var $elm$core$Basics$le = _Utils_le;
var $elm$core$Basics$sub = _Basics_sub;
var $elm$core$List$rangeHelp = F3(
	function (lo, hi, list) {
		rangeHelp:
		while (true) {
			if (_Utils_cmp(lo, hi) < 1) {
				var $temp$lo = lo,
					$temp$hi = hi - 1,
					$temp$list = A2($elm$core$List$cons, hi, list);
				lo = $temp$lo;
				hi = $temp$hi;
				list = $temp$list;
				continue rangeHelp;
			} else {
				return list;
			}
		}
	});
var $elm$core$List$range = F2(
	function (lo, hi) {
		return A3($elm$core$List$rangeHelp, lo, hi, _List_Nil);
	});
var $elm$core$List$indexedMap = F2(
	function (f, xs) {
		return A3(
			$elm$core$List$map2,
			f,
			A2(
				$elm$core$List$range,
				0,
				$elm$core$List$length(xs) - 1),
			xs);
	});
var $elm$core$Char$toCode = _Char_toCode;
var $elm$core$Char$isLower = function (_char) {
	var code = $elm$core$Char$toCode(_char);
	return (97 <= code) && (code <= 122);
};
var $elm$core$Char$isUpper = function (_char) {
	var code = $elm$core$Char$toCode(_char);
	return (code <= 90) && (65 <= code);
};
var $elm$core$Basics$or = _Basics_or;
var $elm$core$Char$isAlpha = function (_char) {
	return $elm$core$Char$isLower(_char) || $elm$core$Char$isUpper(_char);
};
var $elm$core$Char$isDigit = function (_char) {
	var code = $elm$core$Char$toCode(_char);
	return (code <= 57) && (48 <= code);
};
var $elm$core$Char$isAlphaNum = function (_char) {
	return $elm$core$Char$isLower(_char) || ($elm$core$Char$isUpper(_char) || $elm$core$Char$isDigit(_char));
};
var $elm$core$List$reverse = function (list) {
	return A3($elm$core$List$foldl, $elm$core$List$cons, _List_Nil, list);
};
var $elm$core$String$uncons = _String_uncons;
var $elm$json$Json$Decode$errorOneOf = F2(
	function (i, error) {
		return '\n\n(' + ($elm$core$String$fromInt(i + 1) + (') ' + $elm$json$Json$Decode$indent(
			$elm$json$Json$Decode$errorToString(error))));
	});
var $elm$json$Json$Decode$errorToString = function (error) {
	return A2($elm$json$Json$Decode$errorToStringHelp, error, _List_Nil);
};
var $elm$json$Json$Decode$errorToStringHelp = F2(
	function (error, context) {
		errorToStringHelp:
		while (true) {
			switch (error.$) {
				case 'Field':
					var f = error.a;
					var err = error.b;
					var isSimple = function () {
						var _v1 = $elm$core$String$uncons(f);
						if (_v1.$ === 'Nothing') {
							return false;
						} else {
							var _v2 = _v1.a;
							var _char = _v2.a;
							var rest = _v2.b;
							return $elm$core$Char$isAlpha(_char) && A2($elm$core$String$all, $elm$core$Char$isAlphaNum, rest);
						}
					}();
					var fieldName = isSimple ? ('.' + f) : ('[\'' + (f + '\']'));
					var $temp$error = err,
						$temp$context = A2($elm$core$List$cons, fieldName, context);
					error = $temp$error;
					context = $temp$context;
					continue errorToStringHelp;
				case 'Index':
					var i = error.a;
					var err = error.b;
					var indexName = '[' + ($elm$core$String$fromInt(i) + ']');
					var $temp$error = err,
						$temp$context = A2($elm$core$List$cons, indexName, context);
					error = $temp$error;
					context = $temp$context;
					continue errorToStringHelp;
				case 'OneOf':
					var errors = error.a;
					if (!errors.b) {
						return 'Ran into a Json.Decode.oneOf with no possibilities' + function () {
							if (!context.b) {
								return '!';
							} else {
								return ' at json' + A2(
									$elm$core$String$join,
									'',
									$elm$core$List$reverse(context));
							}
						}();
					} else {
						if (!errors.b.b) {
							var err = errors.a;
							var $temp$error = err,
								$temp$context = context;
							error = $temp$error;
							context = $temp$context;
							continue errorToStringHelp;
						} else {
							var starter = function () {
								if (!context.b) {
									return 'Json.Decode.oneOf';
								} else {
									return 'The Json.Decode.oneOf at json' + A2(
										$elm$core$String$join,
										'',
										$elm$core$List$reverse(context));
								}
							}();
							var introduction = starter + (' failed in the following ' + ($elm$core$String$fromInt(
								$elm$core$List$length(errors)) + ' ways:'));
							return A2(
								$elm$core$String$join,
								'\n\n',
								A2(
									$elm$core$List$cons,
									introduction,
									A2($elm$core$List$indexedMap, $elm$json$Json$Decode$errorOneOf, errors)));
						}
					}
				default:
					var msg = error.a;
					var json = error.b;
					var introduction = function () {
						if (!context.b) {
							return 'Problem with the given value:\n\n';
						} else {
							return 'Problem with the value at json' + (A2(
								$elm$core$String$join,
								'',
								$elm$core$List$reverse(context)) + ':\n\n    ');
						}
					}();
					return introduction + ($elm$json$Json$Decode$indent(
						A2($elm$json$Json$Encode$encode, 4, json)) + ('\n\n' + msg));
			}
		}
	});
var $elm$core$Array$branchFactor = 32;
var $elm$core$Array$Array_elm_builtin = F4(
	function (a, b, c, d) {
		return {$: 'Array_elm_builtin', a: a, b: b, c: c, d: d};
	});
var $elm$core$Elm$JsArray$empty = _JsArray_empty;
var $elm$core$Basics$ceiling = _Basics_ceiling;
var $elm$core$Basics$fdiv = _Basics_fdiv;
var $elm$core$Basics$logBase = F2(
	function (base, number) {
		return _Basics_log(number) / _Basics_log(base);
	});
var $elm$core$Basics$toFloat = _Basics_toFloat;
var $elm$core$Array$shiftStep = $elm$core$Basics$ceiling(
	A2($elm$core$Basics$logBase, 2, $elm$core$Array$branchFactor));
var $elm$core$Array$empty = A4($elm$core$Array$Array_elm_builtin, 0, $elm$core$Array$shiftStep, $elm$core$Elm$JsArray$empty, $elm$core$Elm$JsArray$empty);
var $elm$core$Elm$JsArray$initialize = _JsArray_initialize;
var $elm$core$Array$Leaf = function (a) {
	return {$: 'Leaf', a: a};
};
var $elm$core$Basics$apL = F2(
	function (f, x) {
		return f(x);
	});
var $elm$core$Basics$apR = F2(
	function (x, f) {
		return f(x);
	});
var $elm$core$Basics$eq = _Utils_equal;
var $elm$core$Basics$floor = _Basics_floor;
var $elm$core$Elm$JsArray$length = _JsArray_length;
var $elm$core$Basics$gt = _Utils_gt;
var $elm$core$Basics$max = F2(
	function (x, y) {
		return (_Utils_cmp(x, y) > 0) ? x : y;
	});
var $elm$core$Basics$mul = _Basics_mul;
var $elm$core$Array$SubTree = function (a) {
	return {$: 'SubTree', a: a};
};
var $elm$core$Elm$JsArray$initializeFromList = _JsArray_initializeFromList;
var $elm$core$Array$compressNodes = F2(
	function (nodes, acc) {
		compressNodes:
		while (true) {
			var _v0 = A2($elm$core$Elm$JsArray$initializeFromList, $elm$core$Array$branchFactor, nodes);
			var node = _v0.a;
			var remainingNodes = _v0.b;
			var newAcc = A2(
				$elm$core$List$cons,
				$elm$core$Array$SubTree(node),
				acc);
			if (!remainingNodes.b) {
				return $elm$core$List$reverse(newAcc);
			} else {
				var $temp$nodes = remainingNodes,
					$temp$acc = newAcc;
				nodes = $temp$nodes;
				acc = $temp$acc;
				continue compressNodes;
			}
		}
	});
var $elm$core$Tuple$first = function (_v0) {
	var x = _v0.a;
	return x;
};
var $elm$core$Array$treeFromBuilder = F2(
	function (nodeList, nodeListSize) {
		treeFromBuilder:
		while (true) {
			var newNodeSize = $elm$core$Basics$ceiling(nodeListSize / $elm$core$Array$branchFactor);
			if (newNodeSize === 1) {
				return A2($elm$core$Elm$JsArray$initializeFromList, $elm$core$Array$branchFactor, nodeList).a;
			} else {
				var $temp$nodeList = A2($elm$core$Array$compressNodes, nodeList, _List_Nil),
					$temp$nodeListSize = newNodeSize;
				nodeList = $temp$nodeList;
				nodeListSize = $temp$nodeListSize;
				continue treeFromBuilder;
			}
		}
	});
var $elm$core$Array$builderToArray = F2(
	function (reverseNodeList, builder) {
		if (!builder.nodeListSize) {
			return A4(
				$elm$core$Array$Array_elm_builtin,
				$elm$core$Elm$JsArray$length(builder.tail),
				$elm$core$Array$shiftStep,
				$elm$core$Elm$JsArray$empty,
				builder.tail);
		} else {
			var treeLen = builder.nodeListSize * $elm$core$Array$branchFactor;
			var depth = $elm$core$Basics$floor(
				A2($elm$core$Basics$logBase, $elm$core$Array$branchFactor, treeLen - 1));
			var correctNodeList = reverseNodeList ? $elm$core$List$reverse(builder.nodeList) : builder.nodeList;
			var tree = A2($elm$core$Array$treeFromBuilder, correctNodeList, builder.nodeListSize);
			return A4(
				$elm$core$Array$Array_elm_builtin,
				$elm$core$Elm$JsArray$length(builder.tail) + treeLen,
				A2($elm$core$Basics$max, 5, depth * $elm$core$Array$shiftStep),
				tree,
				builder.tail);
		}
	});
var $elm$core$Basics$idiv = _Basics_idiv;
var $elm$core$Basics$lt = _Utils_lt;
var $elm$core$Array$initializeHelp = F5(
	function (fn, fromIndex, len, nodeList, tail) {
		initializeHelp:
		while (true) {
			if (fromIndex < 0) {
				return A2(
					$elm$core$Array$builderToArray,
					false,
					{nodeList: nodeList, nodeListSize: (len / $elm$core$Array$branchFactor) | 0, tail: tail});
			} else {
				var leaf = $elm$core$Array$Leaf(
					A3($elm$core$Elm$JsArray$initialize, $elm$core$Array$branchFactor, fromIndex, fn));
				var $temp$fn = fn,
					$temp$fromIndex = fromIndex - $elm$core$Array$branchFactor,
					$temp$len = len,
					$temp$nodeList = A2($elm$core$List$cons, leaf, nodeList),
					$temp$tail = tail;
				fn = $temp$fn;
				fromIndex = $temp$fromIndex;
				len = $temp$len;
				nodeList = $temp$nodeList;
				tail = $temp$tail;
				continue initializeHelp;
			}
		}
	});
var $elm$core$Basics$remainderBy = _Basics_remainderBy;
var $elm$core$Array$initialize = F2(
	function (len, fn) {
		if (len <= 0) {
			return $elm$core$Array$empty;
		} else {
			var tailLen = len % $elm$core$Array$branchFactor;
			var tail = A3($elm$core$Elm$JsArray$initialize, tailLen, len - tailLen, fn);
			var initialFromIndex = (len - tailLen) - $elm$core$Array$branchFactor;
			return A5($elm$core$Array$initializeHelp, fn, initialFromIndex, len, _List_Nil, tail);
		}
	});
var $elm$core$Basics$True = {$: 'True'};
var $elm$core$Result$isOk = function (result) {
	if (result.$ === 'Ok') {
		return true;
	} else {
		return false;
	}
};
var $elm$json$Json$Decode$map = _Json_map1;
var $elm$json$Json$Decode$map2 = _Json_map2;
var $elm$json$Json$Decode$succeed = _Json_succeed;
var $elm$virtual_dom$VirtualDom$toHandlerInt = function (handler) {
	switch (handler.$) {
		case 'Normal':
			return 0;
		case 'MayStopPropagation':
			return 1;
		case 'MayPreventDefault':
			return 2;
		default:
			return 3;
	}
};
var $elm$browser$Browser$External = function (a) {
	return {$: 'External', a: a};
};
var $elm$browser$Browser$Internal = function (a) {
	return {$: 'Internal', a: a};
};
var $elm$core$Basics$identity = function (x) {
	return x;
};
var $elm$browser$Browser$Dom$NotFound = function (a) {
	return {$: 'NotFound', a: a};
};
var $elm$url$Url$Http = {$: 'Http'};
var $elm$url$Url$Https = {$: 'Https'};
var $elm$url$Url$Url = F6(
	function (protocol, host, port_, path, query, fragment) {
		return {fragment: fragment, host: host, path: path, port_: port_, protocol: protocol, query: query};
	});
var $elm$core$String$contains = _String_contains;
var $elm$core$String$length = _String_length;
var $elm$core$String$slice = _String_slice;
var $elm$core$String$dropLeft = F2(
	function (n, string) {
		return (n < 1) ? string : A3(
			$elm$core$String$slice,
			n,
			$elm$core$String$length(string),
			string);
	});
var $elm$core$String$indexes = _String_indexes;
var $elm$core$String$isEmpty = function (string) {
	return string === '';
};
var $elm$core$String$left = F2(
	function (n, string) {
		return (n < 1) ? '' : A3($elm$core$String$slice, 0, n, string);
	});
var $elm$core$String$toInt = _String_toInt;
var $elm$url$Url$chompBeforePath = F5(
	function (protocol, path, params, frag, str) {
		if ($elm$core$String$isEmpty(str) || A2($elm$core$String$contains, '@', str)) {
			return $elm$core$Maybe$Nothing;
		} else {
			var _v0 = A2($elm$core$String$indexes, ':', str);
			if (!_v0.b) {
				return $elm$core$Maybe$Just(
					A6($elm$url$Url$Url, protocol, str, $elm$core$Maybe$Nothing, path, params, frag));
			} else {
				if (!_v0.b.b) {
					var i = _v0.a;
					var _v1 = $elm$core$String$toInt(
						A2($elm$core$String$dropLeft, i + 1, str));
					if (_v1.$ === 'Nothing') {
						return $elm$core$Maybe$Nothing;
					} else {
						var port_ = _v1;
						return $elm$core$Maybe$Just(
							A6(
								$elm$url$Url$Url,
								protocol,
								A2($elm$core$String$left, i, str),
								port_,
								path,
								params,
								frag));
					}
				} else {
					return $elm$core$Maybe$Nothing;
				}
			}
		}
	});
var $elm$url$Url$chompBeforeQuery = F4(
	function (protocol, params, frag, str) {
		if ($elm$core$String$isEmpty(str)) {
			return $elm$core$Maybe$Nothing;
		} else {
			var _v0 = A2($elm$core$String$indexes, '/', str);
			if (!_v0.b) {
				return A5($elm$url$Url$chompBeforePath, protocol, '/', params, frag, str);
			} else {
				var i = _v0.a;
				return A5(
					$elm$url$Url$chompBeforePath,
					protocol,
					A2($elm$core$String$dropLeft, i, str),
					params,
					frag,
					A2($elm$core$String$left, i, str));
			}
		}
	});
var $elm$url$Url$chompBeforeFragment = F3(
	function (protocol, frag, str) {
		if ($elm$core$String$isEmpty(str)) {
			return $elm$core$Maybe$Nothing;
		} else {
			var _v0 = A2($elm$core$String$indexes, '?', str);
			if (!_v0.b) {
				return A4($elm$url$Url$chompBeforeQuery, protocol, $elm$core$Maybe$Nothing, frag, str);
			} else {
				var i = _v0.a;
				return A4(
					$elm$url$Url$chompBeforeQuery,
					protocol,
					$elm$core$Maybe$Just(
						A2($elm$core$String$dropLeft, i + 1, str)),
					frag,
					A2($elm$core$String$left, i, str));
			}
		}
	});
var $elm$url$Url$chompAfterProtocol = F2(
	function (protocol, str) {
		if ($elm$core$String$isEmpty(str)) {
			return $elm$core$Maybe$Nothing;
		} else {
			var _v0 = A2($elm$core$String$indexes, '#', str);
			if (!_v0.b) {
				return A3($elm$url$Url$chompBeforeFragment, protocol, $elm$core$Maybe$Nothing, str);
			} else {
				var i = _v0.a;
				return A3(
					$elm$url$Url$chompBeforeFragment,
					protocol,
					$elm$core$Maybe$Just(
						A2($elm$core$String$dropLeft, i + 1, str)),
					A2($elm$core$String$left, i, str));
			}
		}
	});
var $elm$core$String$startsWith = _String_startsWith;
var $elm$url$Url$fromString = function (str) {
	return A2($elm$core$String$startsWith, 'http://', str) ? A2(
		$elm$url$Url$chompAfterProtocol,
		$elm$url$Url$Http,
		A2($elm$core$String$dropLeft, 7, str)) : (A2($elm$core$String$startsWith, 'https://', str) ? A2(
		$elm$url$Url$chompAfterProtocol,
		$elm$url$Url$Https,
		A2($elm$core$String$dropLeft, 8, str)) : $elm$core$Maybe$Nothing);
};
var $elm$core$Basics$never = function (_v0) {
	never:
	while (true) {
		var nvr = _v0.a;
		var $temp$_v0 = nvr;
		_v0 = $temp$_v0;
		continue never;
	}
};
var $elm$core$Task$Perform = function (a) {
	return {$: 'Perform', a: a};
};
var $elm$core$Task$succeed = _Scheduler_succeed;
var $elm$core$Task$init = $elm$core$Task$succeed(_Utils_Tuple0);
var $elm$core$List$foldrHelper = F4(
	function (fn, acc, ctr, ls) {
		if (!ls.b) {
			return acc;
		} else {
			var a = ls.a;
			var r1 = ls.b;
			if (!r1.b) {
				return A2(fn, a, acc);
			} else {
				var b = r1.a;
				var r2 = r1.b;
				if (!r2.b) {
					return A2(
						fn,
						a,
						A2(fn, b, acc));
				} else {
					var c = r2.a;
					var r3 = r2.b;
					if (!r3.b) {
						return A2(
							fn,
							a,
							A2(
								fn,
								b,
								A2(fn, c, acc)));
					} else {
						var d = r3.a;
						var r4 = r3.b;
						var res = (ctr > 500) ? A3(
							$elm$core$List$foldl,
							fn,
							acc,
							$elm$core$List$reverse(r4)) : A4($elm$core$List$foldrHelper, fn, acc, ctr + 1, r4);
						return A2(
							fn,
							a,
							A2(
								fn,
								b,
								A2(
									fn,
									c,
									A2(fn, d, res))));
					}
				}
			}
		}
	});
var $elm$core$List$foldr = F3(
	function (fn, acc, ls) {
		return A4($elm$core$List$foldrHelper, fn, acc, 0, ls);
	});
var $elm$core$List$map = F2(
	function (f, xs) {
		return A3(
			$elm$core$List$foldr,
			F2(
				function (x, acc) {
					return A2(
						$elm$core$List$cons,
						f(x),
						acc);
				}),
			_List_Nil,
			xs);
	});
var $elm$core$Task$andThen = _Scheduler_andThen;
var $elm$core$Task$map = F2(
	function (func, taskA) {
		return A2(
			$elm$core$Task$andThen,
			function (a) {
				return $elm$core$Task$succeed(
					func(a));
			},
			taskA);
	});
var $elm$core$Task$map2 = F3(
	function (func, taskA, taskB) {
		return A2(
			$elm$core$Task$andThen,
			function (a) {
				return A2(
					$elm$core$Task$andThen,
					function (b) {
						return $elm$core$Task$succeed(
							A2(func, a, b));
					},
					taskB);
			},
			taskA);
	});
var $elm$core$Task$sequence = function (tasks) {
	return A3(
		$elm$core$List$foldr,
		$elm$core$Task$map2($elm$core$List$cons),
		$elm$core$Task$succeed(_List_Nil),
		tasks);
};
var $elm$core$Platform$sendToApp = _Platform_sendToApp;
var $elm$core$Task$spawnCmd = F2(
	function (router, _v0) {
		var task = _v0.a;
		return _Scheduler_spawn(
			A2(
				$elm$core$Task$andThen,
				$elm$core$Platform$sendToApp(router),
				task));
	});
var $elm$core$Task$onEffects = F3(
	function (router, commands, state) {
		return A2(
			$elm$core$Task$map,
			function (_v0) {
				return _Utils_Tuple0;
			},
			$elm$core$Task$sequence(
				A2(
					$elm$core$List$map,
					$elm$core$Task$spawnCmd(router),
					commands)));
	});
var $elm$core$Task$onSelfMsg = F3(
	function (_v0, _v1, _v2) {
		return $elm$core$Task$succeed(_Utils_Tuple0);
	});
var $elm$core$Task$cmdMap = F2(
	function (tagger, _v0) {
		var task = _v0.a;
		return $elm$core$Task$Perform(
			A2($elm$core$Task$map, tagger, task));
	});
_Platform_effectManagers['Task'] = _Platform_createManager($elm$core$Task$init, $elm$core$Task$onEffects, $elm$core$Task$onSelfMsg, $elm$core$Task$cmdMap);
var $elm$core$Task$command = _Platform_leaf('Task');
var $elm$core$Task$perform = F2(
	function (toMessage, task) {
		return $elm$core$Task$command(
			$elm$core$Task$Perform(
				A2($elm$core$Task$map, toMessage, task)));
	});
var $elm$browser$Browser$element = _Browser_element;
var $author$project$Messages$GetViewport = function (a) {
	return {$: 'GetViewport', a: a};
};
var $elm$core$Platform$Cmd$batch = _Platform_batch;
var $elm$json$Json$Encode$float = _Json_wrap;
var $elm$json$Json$Encode$list = F2(
	function (func, entries) {
		return _Json_wrap(
			A3(
				$elm$core$List$foldl,
				_Json_addEntry(func),
				_Json_emptyArray(_Utils_Tuple0),
				entries));
	});
var $elm$json$Json$Encode$string = _Json_wrap;
var $author$project$Music$changeVolume = _Platform_outgoingPort(
	'changeVolume',
	function ($) {
		var a = $.a;
		var b = $.b;
		return A2(
			$elm$json$Json$Encode$list,
			$elm$core$Basics$identity,
			_List_fromArray(
				[
					$elm$json$Json$Encode$string(a),
					$elm$json$Json$Encode$float(b)
				]));
	});
var $elm$browser$Browser$Dom$getViewport = _Browser_withWindow(_Browser_getViewport);
var $author$project$Inventory$Blank = {$: 'Blank'};
var $author$project$Model$Model = function (cscreen) {
	return function (tscreen) {
		return function (gradient) {
			return function (objects) {
				return function (scenes) {
					return function (size) {
						return function (spcPosition) {
							return function (drag) {
								return function (pictures) {
									return function (inventory) {
										return function (underUse) {
											return function (memory) {
												return function (docu) {
													return function (move_timer) {
														return function (opac) {
															return function (intro) {
																return function (volume) {
																	return {cscreen: cscreen, docu: docu, drag: drag, gradient: gradient, intro: intro, inventory: inventory, memory: memory, move_timer: move_timer, objects: objects, opac: opac, pictures: pictures, scenes: scenes, size: size, spcPosition: spcPosition, tscreen: tscreen, underUse: underUse, volume: volume};
																};
															};
														};
													};
												};
											};
										};
									};
								};
							};
						};
					};
				};
			};
		};
	};
};
var $author$project$Gradient$Normal = {$: 'Normal'};
var $zaboco$elm_draggable$Internal$NotDragging = {$: 'NotDragging'};
var $zaboco$elm_draggable$Draggable$State = function (a) {
	return {$: 'State', a: a};
};
var $zaboco$elm_draggable$Draggable$init = $zaboco$elm_draggable$Draggable$State($zaboco$elm_draggable$Internal$NotDragging);
var $author$project$Document$Document = F4(
	function (showState, lockState, index, belong) {
		return {belong: belong, index: index, lockState: lockState, showState: showState};
	});
var $author$project$Memory$Locked = {$: 'Locked'};
var $author$project$Picture$Show = {$: 'Show'};
var $author$project$Document$initial_docu = _List_fromArray(
	[
		A4($author$project$Document$Document, $author$project$Picture$Show, $author$project$Memory$Locked, 0, 0)
	]);
var $author$project$Intro$IntroPage = F3(
	function (sec, tran_sec, sit) {
		return {sec: sec, sit: sit, tran_sec: tran_sec};
	});
var $author$project$Intro$UnderGoing = function (a) {
	return {$: 'UnderGoing', a: a};
};
var $author$project$Intro$initial_intro = A3(
	$author$project$Intro$IntroPage,
	0,
	1,
	$author$project$Intro$UnderGoing(0));
var $author$project$Inventory$Inventory = F3(
	function (own, locaLeft, num) {
		return {locaLeft: locaLeft, num: num, own: own};
	});
var $elm$core$List$repeatHelp = F3(
	function (result, n, value) {
		repeatHelp:
		while (true) {
			if (n <= 0) {
				return result;
			} else {
				var $temp$result = A2($elm$core$List$cons, value, result),
					$temp$n = n - 1,
					$temp$value = value;
				result = $temp$result;
				n = $temp$n;
				value = $temp$value;
				continue repeatHelp;
			}
		}
	});
var $elm$core$List$repeat = F2(
	function (n, value) {
		return A3($elm$core$List$repeatHelp, _List_Nil, n, value);
	});
var $author$project$Inventory$initial_inventory = A3(
	$author$project$Inventory$Inventory,
	A2($elm$core$List$repeat, 8, $author$project$Inventory$Blank),
	_List_fromArray(
		[210, 370, 520, 673, 826, 979, 1135, 1291]),
	0);
var $author$project$Memory$Memory = F4(
	function (index, state, frag, need) {
		return {frag: frag, index: index, need: need, state: state};
	});
var $author$project$Memory$initial_memory = _List_fromArray(
	[
		A4(
		$author$project$Memory$Memory,
		0,
		$author$project$Memory$Locked,
		_List_fromArray(
			[$author$project$Memory$Locked, $author$project$Memory$Locked]),
		_List_fromArray(
			[0, 1]))
	]);
var $author$project$Object$Bul = function (a) {
	return {$: 'Bul', a: a};
};
var $author$project$Object$Clock = function (a) {
	return {$: 'Clock', a: a};
};
var $author$project$Object$ClockModel = F2(
	function (hour, minute) {
		return {hour: hour, minute: minute};
	});
var $author$project$Object$Computer = function (a) {
	return {$: 'Computer', a: a};
};
var $author$project$Object$Frame = function (a) {
	return {$: 'Frame', a: a};
};
var $author$project$Object$FrameModel = function (index) {
	return {index: index};
};
var $author$project$Object$Mirror = function (a) {
	return {$: 'Mirror', a: a};
};
var $author$project$Object$Piano = function (a) {
	return {$: 'Piano', a: a};
};
var $author$project$Object$Power = function (a) {
	return {$: 'Power', a: a};
};
var $author$project$Object$Table = function (a) {
	return {$: 'Table', a: a};
};
var $author$project$Ppower$Low = {$: 'Low'};
var $author$project$Ppower$PowerModel = F3(
	function (key, state, subscene) {
		return {key: key, state: state, subscene: subscene};
	});
var $author$project$Ppower$initPowerModel = A3($author$project$Ppower$PowerModel, 1, $author$project$Ppower$Low, 1);
var $author$project$Ppiano$PianoModel = F3(
	function (pianoKeySet, playedKey, currentMusic) {
		return {currentMusic: currentMusic, pianoKeySet: pianoKeySet, playedKey: playedKey};
	});
var $author$project$Geometry$Location = F2(
	function (x, y) {
		return {x: x, y: y};
	});
var $author$project$Ppiano$PianoKey = F4(
	function (anchor, index, keyState, press_time) {
		return {anchor: anchor, index: index, keyState: keyState, press_time: press_time};
	});
var $author$project$Ppiano$Up = {$: 'Up'};
var $author$project$Ppiano$keyLength = 30.0;
var $author$project$Ppiano$generate_key_set_help = function (number) {
	var fl = number;
	var x = fl * $author$project$Ppiano$keyLength;
	return A4(
		$author$project$Ppiano$PianoKey,
		A2($author$project$Geometry$Location, x, 400.0),
		number,
		$author$project$Ppiano$Up,
		0);
};
var $author$project$Ppiano$generate_key_set = function () {
	var indexSet = A2($elm$core$List$range, 1, 14);
	return A2($elm$core$List$map, $author$project$Ppiano$generate_key_set_help, indexSet);
}();
var $author$project$Ppiano$initial = A3($author$project$Ppiano$PianoModel, $author$project$Ppiano$generate_key_set, _List_Nil, 0);
var $author$project$Geometry$Line = F2(
	function (firstPoint, secondPoint) {
		return {firstPoint: firstPoint, secondPoint: secondPoint};
	});
var $author$project$Geometry$Mirror = F2(
	function (body, index) {
		return {body: body, index: index};
	});
var $author$project$Pmirror$MirrorModel = F3(
	function (frame, lightSet, mirrorSet) {
		return {frame: frame, lightSet: lightSet, mirrorSet: mirrorSet};
	});
var $elm$core$List$append = F2(
	function (xs, ys) {
		if (!ys.b) {
			return xs;
		} else {
			return A3($elm$core$List$foldr, $elm$core$List$cons, ys, xs);
		}
	});
var $elm$core$List$concat = function (lists) {
	return A3($elm$core$List$foldr, $elm$core$List$append, _List_Nil, lists);
};
var $author$project$Pmirror$frameHeight = 100.0;
var $author$project$Pmirror$frameWidth = 100.0;
var $elm$core$Tuple$second = function (_v0) {
	var y = _v0.b;
	return y;
};
var $author$project$Pmirror$generate_one_frame = function (position) {
	return A2($author$project$Geometry$Location, ($author$project$Pmirror$frameWidth * position.a) + 1, ($author$project$Pmirror$frameHeight * position.b) - 1);
};
var $elm$core$Tuple$pair = F2(
	function (a, b) {
		return _Utils_Tuple2(a, b);
	});
var $author$project$Pmirror$toFloatPoint = function (_v0) {
	var x = _v0.a;
	var y = _v0.b;
	return _Utils_Tuple2(x, y);
};
var $author$project$Pmirror$generate_frames = function (size) {
	var rangey = A2($elm$core$List$range, 0, size.b - 1);
	var rangex = A2($elm$core$List$range, 0, size.a - 1);
	var line = function (y) {
		return A2(
			$elm$core$List$map,
			function (x) {
				return A2($elm$core$Tuple$pair, x, y);
			},
			rangex);
	};
	return A2(
		$elm$core$List$map,
		$author$project$Pmirror$generate_one_frame,
		A2(
			$elm$core$List$map,
			$author$project$Pmirror$toFloatPoint,
			$elm$core$List$concat(
				A2($elm$core$List$map, line, rangey))));
};
var $elm$core$List$singleton = function (value) {
	return _List_fromArray(
		[value]);
};
var $author$project$Pmirror$initialMirror = A3(
	$author$project$Pmirror$MirrorModel,
	$author$project$Pmirror$generate_frames(
		_Utils_Tuple2(4, 4)),
	$elm$core$List$singleton(
		A2(
			$author$project$Geometry$Line,
			A2($author$project$Geometry$Location, 400, 350),
			A2($author$project$Geometry$Location, 0, 350))),
	_List_fromArray(
		[
			A2(
			$author$project$Geometry$Mirror,
			A2(
				$author$project$Geometry$Line,
				A2($author$project$Geometry$Location, 300, 350),
				A2($author$project$Geometry$Location, 400, 350)),
			1),
			A2(
			$author$project$Geometry$Mirror,
			A2(
				$author$project$Geometry$Line,
				A2($author$project$Geometry$Location, 350, 100),
				A2($author$project$Geometry$Location, 350, 0)),
			2),
			A2(
			$author$project$Geometry$Mirror,
			A2(
				$author$project$Geometry$Line,
				A2($author$project$Geometry$Location, 50, 100),
				A2($author$project$Geometry$Location, 50, 0)),
			3)
		]));
var $author$project$Pbulb$BulbModel = F2(
	function (state, bulb) {
		return {bulb: bulb, state: state};
	});
var $author$project$Pbulb$Puzzling = {$: 'Puzzling'};
var $author$project$Pbulb$Bulb = F2(
	function (position, color) {
		return {color: color, position: position};
	});
var $author$project$Pbulb$None = {$: 'None'};
var $author$project$Pbulb$Red = {$: 'Red'};
var $author$project$Pbulb$initbulb = _List_fromArray(
	[
		A2(
		$author$project$Pbulb$Bulb,
		_Utils_Tuple2(1, 1),
		$author$project$Pbulb$None),
		A2(
		$author$project$Pbulb$Bulb,
		_Utils_Tuple2(1, 2),
		$author$project$Pbulb$None),
		A2(
		$author$project$Pbulb$Bulb,
		_Utils_Tuple2(1, 3),
		$author$project$Pbulb$None),
		A2(
		$author$project$Pbulb$Bulb,
		_Utils_Tuple2(2, 1),
		$author$project$Pbulb$None),
		A2(
		$author$project$Pbulb$Bulb,
		_Utils_Tuple2(2, 2),
		$author$project$Pbulb$Red),
		A2(
		$author$project$Pbulb$Bulb,
		_Utils_Tuple2(2, 3),
		$author$project$Pbulb$None),
		A2(
		$author$project$Pbulb$Bulb,
		_Utils_Tuple2(3, 1),
		$author$project$Pbulb$None),
		A2(
		$author$project$Pbulb$Bulb,
		_Utils_Tuple2(3, 2),
		$author$project$Pbulb$None),
		A2(
		$author$project$Pbulb$Bulb,
		_Utils_Tuple2(3, 3),
		$author$project$Pbulb$None)
	]);
var $author$project$Pbulb$initial_bulb = A2($author$project$Pbulb$BulbModel, $author$project$Pbulb$Puzzling, $author$project$Pbulb$initbulb);
var $author$project$Pcomputer$ComputerModel = F3(
	function (state, scene, word) {
		return {scene: scene, state: state, word: word};
	});
var $author$project$Pcomputer$Lowpower = {$: 'Lowpower'};
var $author$project$Pcomputer$initial_computer = A3($author$project$Pcomputer$ComputerModel, $author$project$Pcomputer$Lowpower, 0, _List_Nil);
var $author$project$Ptable$TableModel = F3(
	function (blockSet, lastLocation, size) {
		return {blockSet: blockSet, lastLocation: lastLocation, size: size};
	});
var $author$project$Ptable$blockLength = 40.0;
var $elm$core$Basics$sqrt = _Basics_sqrt;
var $author$project$Ptable$Block = F2(
	function (anchor, state) {
		return {anchor: anchor, state: state};
	});
var $author$project$Ptable$NonActive = {$: 'NonActive'};
var $author$project$Ptable$three_block_set = function (center) {
	return _List_fromArray(
		[
			A2($author$project$Ptable$Block, center, $author$project$Ptable$NonActive),
			A2(
			$author$project$Ptable$Block,
			_Utils_update(
				center,
				{
					y: center.y - ($author$project$Ptable$blockLength * $elm$core$Basics$sqrt(3))
				}),
			$author$project$Ptable$NonActive),
			A2(
			$author$project$Ptable$Block,
			_Utils_update(
				center,
				{
					y: center.y + ($author$project$Ptable$blockLength * $elm$core$Basics$sqrt(3))
				}),
			$author$project$Ptable$NonActive)
		]);
};
var $author$project$Ptable$twoOfSquare3 = $elm$core$Basics$sqrt(3) / 2.0;
var $author$project$Ptable$ushape_block_set = function (center) {
	return _List_fromArray(
		[
			A2($author$project$Ptable$Block, center, $author$project$Ptable$NonActive),
			A2(
			$author$project$Ptable$Block,
			_Utils_update(
				center,
				{x: center.x + ($author$project$Ptable$blockLength * 1.5), y: center.y - ($author$project$Ptable$twoOfSquare3 * $author$project$Ptable$blockLength)}),
			$author$project$Ptable$NonActive),
			A2(
			$author$project$Ptable$Block,
			_Utils_update(
				center,
				{x: center.x - ($author$project$Ptable$blockLength * 1.5), y: center.y - ($author$project$Ptable$twoOfSquare3 * $author$project$Ptable$blockLength)}),
			$author$project$Ptable$NonActive)
		]);
};
var $author$project$Ptable$initial_block = _Utils_ap(
	$author$project$Ptable$three_block_set(
		A2($author$project$Geometry$Location, 500.0, 500.0)),
	_Utils_ap(
		$author$project$Ptable$three_block_set(
			A2($author$project$Geometry$Location, 500.0 - (3 * $author$project$Ptable$blockLength), 500.0)),
		_Utils_ap(
			$author$project$Ptable$three_block_set(
				A2($author$project$Geometry$Location, 500.0 + (3 * $author$project$Ptable$blockLength), 500.0)),
			_Utils_ap(
				$author$project$Ptable$ushape_block_set(
					A2(
						$author$project$Geometry$Location,
						500.0,
						500.0 + ((2 * $author$project$Ptable$blockLength) * $elm$core$Basics$sqrt(3)))),
				$author$project$Ptable$ushape_block_set(
					A2(
						$author$project$Geometry$Location,
						500.0,
						500.0 - ($author$project$Ptable$blockLength * $elm$core$Basics$sqrt(3))))))));
var $author$project$Ptable$twoOfSquare3_help = $elm$core$Basics$sqrt(3) / 2.0;
var $author$project$Ptable$initial_table = A3(
	$author$project$Ptable$TableModel,
	$author$project$Ptable$initial_block,
	A2($author$project$Geometry$Location, 500.0 + (($author$project$Ptable$twoOfSquare3_help * 3) / 2), 500.0 - (1.5 * $author$project$Ptable$blockLength)),
	_Utils_Tuple2(0, 0));
var $author$project$Object$initial_objects = _List_fromArray(
	[
		$author$project$Object$Clock(
		A2($author$project$Object$ClockModel, 1, 30)),
		$author$project$Object$Table($author$project$Ptable$initial_table),
		$author$project$Object$Frame(
		$author$project$Object$FrameModel(
			_List_fromArray(
				[0]))),
		$author$project$Object$Mirror($author$project$Pmirror$initialMirror),
		$author$project$Object$Computer($author$project$Pcomputer$initial_computer),
		$author$project$Object$Power($author$project$Ppower$initPowerModel),
		$author$project$Object$Piano($author$project$Ppiano$initial),
		$author$project$Object$Bul($author$project$Pbulb$initial_bulb)
	]);
var $author$project$Picture$NotShow = {$: 'NotShow'};
var $author$project$Picture$Picture = F2(
	function (state, index) {
		return {index: index, state: state};
	});
var $author$project$Picture$initial_pictures = _List_fromArray(
	[
		A2($author$project$Picture$Picture, $author$project$Picture$NotShow, 0),
		A2($author$project$Picture$Picture, $author$project$Picture$NotShow, 1),
		A2($author$project$Picture$Picture, $author$project$Picture$NotShow, 2),
		A2($author$project$Picture$Picture, $author$project$Picture$NotShow, 3)
	]);
var $author$project$Scene$Scene = F2(
	function (objectOrder, pictureSrc) {
		return {objectOrder: objectOrder, pictureSrc: pictureSrc};
	});
var $author$project$Scene$initial_scene = function () {
	var scene2 = A2($author$project$Scene$Scene, _List_Nil, 'assets/2f.png');
	var scene1 = A2(
		$author$project$Scene$Scene,
		_List_fromArray(
			[1, 2]),
		'assets/mvp.png');
	var scene0 = A2($author$project$Scene$Scene, _List_Nil, 'assets/basement.png');
	return _List_fromArray(
		[scene0, scene1, scene2]);
}();
var $author$project$Gradient$Screen = F6(
	function (cstate, clevel, cscene, cmemory, cpage, cdocu) {
		return {cdocu: cdocu, clevel: clevel, cmemory: cmemory, cpage: cpage, cscene: cscene, cstate: cstate};
	});
var $elm$core$Basics$negate = function (n) {
	return -n;
};
var $author$project$Model$initial_screen = A6($author$project$Gradient$Screen, 98, 1, 0, -1, -1, -1);
var $author$project$Model$initial_target = A6($author$project$Gradient$Screen, 98, 1, 0, -1, -1, -1);
var $author$project$Model$initial = $author$project$Model$Model($author$project$Model$initial_screen)($author$project$Model$initial_target)($author$project$Gradient$Normal)($author$project$Object$initial_objects)($author$project$Scene$initial_scene)(
	_Utils_Tuple2(0, 0))(
	_Utils_Tuple2(0, 0))($zaboco$elm_draggable$Draggable$init)($author$project$Picture$initial_pictures)($author$project$Inventory$initial_inventory)($author$project$Inventory$Blank)($author$project$Memory$initial_memory)($author$project$Document$initial_docu)(0)(1)($author$project$Intro$initial_intro)(1);
var $author$project$Main$init = function (a) {
	return _Utils_Tuple2(
		$author$project$Model$initial,
		$elm$core$Platform$Cmd$batch(
			_List_fromArray(
				[
					$author$project$Music$changeVolume(
					_Utils_Tuple2('bgm', 1)),
					A2($elm$core$Task$perform, $author$project$Messages$GetViewport, $elm$browser$Browser$Dom$getViewport)
				])));
};
var $author$project$Messages$Decrease = {$: 'Decrease'};
var $author$project$Messages$DragMsg = function (a) {
	return {$: 'DragMsg', a: a};
};
var $author$project$Messages$Increase = {$: 'Increase'};
var $author$project$Messages$Resize = F2(
	function (a, b) {
		return {$: 'Resize', a: a, b: b};
	});
var $author$project$Messages$Tick = function (a) {
	return {$: 'Tick', a: a};
};
var $elm$core$Platform$Sub$batch = _Platform_batch;
var $elm$browser$Browser$AnimationManager$Delta = function (a) {
	return {$: 'Delta', a: a};
};
var $elm$browser$Browser$AnimationManager$State = F3(
	function (subs, request, oldTime) {
		return {oldTime: oldTime, request: request, subs: subs};
	});
var $elm$browser$Browser$AnimationManager$init = $elm$core$Task$succeed(
	A3($elm$browser$Browser$AnimationManager$State, _List_Nil, $elm$core$Maybe$Nothing, 0));
var $elm$core$Process$kill = _Scheduler_kill;
var $elm$browser$Browser$AnimationManager$now = _Browser_now(_Utils_Tuple0);
var $elm$browser$Browser$AnimationManager$rAF = _Browser_rAF(_Utils_Tuple0);
var $elm$core$Platform$sendToSelf = _Platform_sendToSelf;
var $elm$core$Process$spawn = _Scheduler_spawn;
var $elm$browser$Browser$AnimationManager$onEffects = F3(
	function (router, subs, _v0) {
		var request = _v0.request;
		var oldTime = _v0.oldTime;
		var _v1 = _Utils_Tuple2(request, subs);
		if (_v1.a.$ === 'Nothing') {
			if (!_v1.b.b) {
				var _v2 = _v1.a;
				return $elm$browser$Browser$AnimationManager$init;
			} else {
				var _v4 = _v1.a;
				return A2(
					$elm$core$Task$andThen,
					function (pid) {
						return A2(
							$elm$core$Task$andThen,
							function (time) {
								return $elm$core$Task$succeed(
									A3(
										$elm$browser$Browser$AnimationManager$State,
										subs,
										$elm$core$Maybe$Just(pid),
										time));
							},
							$elm$browser$Browser$AnimationManager$now);
					},
					$elm$core$Process$spawn(
						A2(
							$elm$core$Task$andThen,
							$elm$core$Platform$sendToSelf(router),
							$elm$browser$Browser$AnimationManager$rAF)));
			}
		} else {
			if (!_v1.b.b) {
				var pid = _v1.a.a;
				return A2(
					$elm$core$Task$andThen,
					function (_v3) {
						return $elm$browser$Browser$AnimationManager$init;
					},
					$elm$core$Process$kill(pid));
			} else {
				return $elm$core$Task$succeed(
					A3($elm$browser$Browser$AnimationManager$State, subs, request, oldTime));
			}
		}
	});
var $elm$time$Time$Posix = function (a) {
	return {$: 'Posix', a: a};
};
var $elm$time$Time$millisToPosix = $elm$time$Time$Posix;
var $elm$browser$Browser$AnimationManager$onSelfMsg = F3(
	function (router, newTime, _v0) {
		var subs = _v0.subs;
		var oldTime = _v0.oldTime;
		var send = function (sub) {
			if (sub.$ === 'Time') {
				var tagger = sub.a;
				return A2(
					$elm$core$Platform$sendToApp,
					router,
					tagger(
						$elm$time$Time$millisToPosix(newTime)));
			} else {
				var tagger = sub.a;
				return A2(
					$elm$core$Platform$sendToApp,
					router,
					tagger(newTime - oldTime));
			}
		};
		return A2(
			$elm$core$Task$andThen,
			function (pid) {
				return A2(
					$elm$core$Task$andThen,
					function (_v1) {
						return $elm$core$Task$succeed(
							A3(
								$elm$browser$Browser$AnimationManager$State,
								subs,
								$elm$core$Maybe$Just(pid),
								newTime));
					},
					$elm$core$Task$sequence(
						A2($elm$core$List$map, send, subs)));
			},
			$elm$core$Process$spawn(
				A2(
					$elm$core$Task$andThen,
					$elm$core$Platform$sendToSelf(router),
					$elm$browser$Browser$AnimationManager$rAF)));
	});
var $elm$browser$Browser$AnimationManager$Time = function (a) {
	return {$: 'Time', a: a};
};
var $elm$core$Basics$composeL = F3(
	function (g, f, x) {
		return g(
			f(x));
	});
var $elm$browser$Browser$AnimationManager$subMap = F2(
	function (func, sub) {
		if (sub.$ === 'Time') {
			var tagger = sub.a;
			return $elm$browser$Browser$AnimationManager$Time(
				A2($elm$core$Basics$composeL, func, tagger));
		} else {
			var tagger = sub.a;
			return $elm$browser$Browser$AnimationManager$Delta(
				A2($elm$core$Basics$composeL, func, tagger));
		}
	});
_Platform_effectManagers['Browser.AnimationManager'] = _Platform_createManager($elm$browser$Browser$AnimationManager$init, $elm$browser$Browser$AnimationManager$onEffects, $elm$browser$Browser$AnimationManager$onSelfMsg, 0, $elm$browser$Browser$AnimationManager$subMap);
var $elm$browser$Browser$AnimationManager$subscription = _Platform_leaf('Browser.AnimationManager');
var $elm$browser$Browser$AnimationManager$onAnimationFrameDelta = function (tagger) {
	return $elm$browser$Browser$AnimationManager$subscription(
		$elm$browser$Browser$AnimationManager$Delta(tagger));
};
var $elm$browser$Browser$Events$onAnimationFrameDelta = $elm$browser$Browser$AnimationManager$onAnimationFrameDelta;
var $elm$browser$Browser$Events$Document = {$: 'Document'};
var $elm$browser$Browser$Events$MySub = F3(
	function (a, b, c) {
		return {$: 'MySub', a: a, b: b, c: c};
	});
var $elm$browser$Browser$Events$State = F2(
	function (subs, pids) {
		return {pids: pids, subs: subs};
	});
var $elm$core$Dict$RBEmpty_elm_builtin = {$: 'RBEmpty_elm_builtin'};
var $elm$core$Dict$empty = $elm$core$Dict$RBEmpty_elm_builtin;
var $elm$browser$Browser$Events$init = $elm$core$Task$succeed(
	A2($elm$browser$Browser$Events$State, _List_Nil, $elm$core$Dict$empty));
var $elm$browser$Browser$Events$nodeToKey = function (node) {
	if (node.$ === 'Document') {
		return 'd_';
	} else {
		return 'w_';
	}
};
var $elm$browser$Browser$Events$addKey = function (sub) {
	var node = sub.a;
	var name = sub.b;
	return _Utils_Tuple2(
		_Utils_ap(
			$elm$browser$Browser$Events$nodeToKey(node),
			name),
		sub);
};
var $elm$core$Dict$Black = {$: 'Black'};
var $elm$core$Dict$RBNode_elm_builtin = F5(
	function (a, b, c, d, e) {
		return {$: 'RBNode_elm_builtin', a: a, b: b, c: c, d: d, e: e};
	});
var $elm$core$Dict$Red = {$: 'Red'};
var $elm$core$Dict$balance = F5(
	function (color, key, value, left, right) {
		if ((right.$ === 'RBNode_elm_builtin') && (right.a.$ === 'Red')) {
			var _v1 = right.a;
			var rK = right.b;
			var rV = right.c;
			var rLeft = right.d;
			var rRight = right.e;
			if ((left.$ === 'RBNode_elm_builtin') && (left.a.$ === 'Red')) {
				var _v3 = left.a;
				var lK = left.b;
				var lV = left.c;
				var lLeft = left.d;
				var lRight = left.e;
				return A5(
					$elm$core$Dict$RBNode_elm_builtin,
					$elm$core$Dict$Red,
					key,
					value,
					A5($elm$core$Dict$RBNode_elm_builtin, $elm$core$Dict$Black, lK, lV, lLeft, lRight),
					A5($elm$core$Dict$RBNode_elm_builtin, $elm$core$Dict$Black, rK, rV, rLeft, rRight));
			} else {
				return A5(
					$elm$core$Dict$RBNode_elm_builtin,
					color,
					rK,
					rV,
					A5($elm$core$Dict$RBNode_elm_builtin, $elm$core$Dict$Red, key, value, left, rLeft),
					rRight);
			}
		} else {
			if ((((left.$ === 'RBNode_elm_builtin') && (left.a.$ === 'Red')) && (left.d.$ === 'RBNode_elm_builtin')) && (left.d.a.$ === 'Red')) {
				var _v5 = left.a;
				var lK = left.b;
				var lV = left.c;
				var _v6 = left.d;
				var _v7 = _v6.a;
				var llK = _v6.b;
				var llV = _v6.c;
				var llLeft = _v6.d;
				var llRight = _v6.e;
				var lRight = left.e;
				return A5(
					$elm$core$Dict$RBNode_elm_builtin,
					$elm$core$Dict$Red,
					lK,
					lV,
					A5($elm$core$Dict$RBNode_elm_builtin, $elm$core$Dict$Black, llK, llV, llLeft, llRight),
					A5($elm$core$Dict$RBNode_elm_builtin, $elm$core$Dict$Black, key, value, lRight, right));
			} else {
				return A5($elm$core$Dict$RBNode_elm_builtin, color, key, value, left, right);
			}
		}
	});
var $elm$core$Basics$compare = _Utils_compare;
var $elm$core$Dict$insertHelp = F3(
	function (key, value, dict) {
		if (dict.$ === 'RBEmpty_elm_builtin') {
			return A5($elm$core$Dict$RBNode_elm_builtin, $elm$core$Dict$Red, key, value, $elm$core$Dict$RBEmpty_elm_builtin, $elm$core$Dict$RBEmpty_elm_builtin);
		} else {
			var nColor = dict.a;
			var nKey = dict.b;
			var nValue = dict.c;
			var nLeft = dict.d;
			var nRight = dict.e;
			var _v1 = A2($elm$core$Basics$compare, key, nKey);
			switch (_v1.$) {
				case 'LT':
					return A5(
						$elm$core$Dict$balance,
						nColor,
						nKey,
						nValue,
						A3($elm$core$Dict$insertHelp, key, value, nLeft),
						nRight);
				case 'EQ':
					return A5($elm$core$Dict$RBNode_elm_builtin, nColor, nKey, value, nLeft, nRight);
				default:
					return A5(
						$elm$core$Dict$balance,
						nColor,
						nKey,
						nValue,
						nLeft,
						A3($elm$core$Dict$insertHelp, key, value, nRight));
			}
		}
	});
var $elm$core$Dict$insert = F3(
	function (key, value, dict) {
		var _v0 = A3($elm$core$Dict$insertHelp, key, value, dict);
		if ((_v0.$ === 'RBNode_elm_builtin') && (_v0.a.$ === 'Red')) {
			var _v1 = _v0.a;
			var k = _v0.b;
			var v = _v0.c;
			var l = _v0.d;
			var r = _v0.e;
			return A5($elm$core$Dict$RBNode_elm_builtin, $elm$core$Dict$Black, k, v, l, r);
		} else {
			var x = _v0;
			return x;
		}
	});
var $elm$core$Dict$fromList = function (assocs) {
	return A3(
		$elm$core$List$foldl,
		F2(
			function (_v0, dict) {
				var key = _v0.a;
				var value = _v0.b;
				return A3($elm$core$Dict$insert, key, value, dict);
			}),
		$elm$core$Dict$empty,
		assocs);
};
var $elm$core$Dict$foldl = F3(
	function (func, acc, dict) {
		foldl:
		while (true) {
			if (dict.$ === 'RBEmpty_elm_builtin') {
				return acc;
			} else {
				var key = dict.b;
				var value = dict.c;
				var left = dict.d;
				var right = dict.e;
				var $temp$func = func,
					$temp$acc = A3(
					func,
					key,
					value,
					A3($elm$core$Dict$foldl, func, acc, left)),
					$temp$dict = right;
				func = $temp$func;
				acc = $temp$acc;
				dict = $temp$dict;
				continue foldl;
			}
		}
	});
var $elm$core$Dict$merge = F6(
	function (leftStep, bothStep, rightStep, leftDict, rightDict, initialResult) {
		var stepState = F3(
			function (rKey, rValue, _v0) {
				stepState:
				while (true) {
					var list = _v0.a;
					var result = _v0.b;
					if (!list.b) {
						return _Utils_Tuple2(
							list,
							A3(rightStep, rKey, rValue, result));
					} else {
						var _v2 = list.a;
						var lKey = _v2.a;
						var lValue = _v2.b;
						var rest = list.b;
						if (_Utils_cmp(lKey, rKey) < 0) {
							var $temp$rKey = rKey,
								$temp$rValue = rValue,
								$temp$_v0 = _Utils_Tuple2(
								rest,
								A3(leftStep, lKey, lValue, result));
							rKey = $temp$rKey;
							rValue = $temp$rValue;
							_v0 = $temp$_v0;
							continue stepState;
						} else {
							if (_Utils_cmp(lKey, rKey) > 0) {
								return _Utils_Tuple2(
									list,
									A3(rightStep, rKey, rValue, result));
							} else {
								return _Utils_Tuple2(
									rest,
									A4(bothStep, lKey, lValue, rValue, result));
							}
						}
					}
				}
			});
		var _v3 = A3(
			$elm$core$Dict$foldl,
			stepState,
			_Utils_Tuple2(
				$elm$core$Dict$toList(leftDict),
				initialResult),
			rightDict);
		var leftovers = _v3.a;
		var intermediateResult = _v3.b;
		return A3(
			$elm$core$List$foldl,
			F2(
				function (_v4, result) {
					var k = _v4.a;
					var v = _v4.b;
					return A3(leftStep, k, v, result);
				}),
			intermediateResult,
			leftovers);
	});
var $elm$browser$Browser$Events$Event = F2(
	function (key, event) {
		return {event: event, key: key};
	});
var $elm$browser$Browser$Events$spawn = F3(
	function (router, key, _v0) {
		var node = _v0.a;
		var name = _v0.b;
		var actualNode = function () {
			if (node.$ === 'Document') {
				return _Browser_doc;
			} else {
				return _Browser_window;
			}
		}();
		return A2(
			$elm$core$Task$map,
			function (value) {
				return _Utils_Tuple2(key, value);
			},
			A3(
				_Browser_on,
				actualNode,
				name,
				function (event) {
					return A2(
						$elm$core$Platform$sendToSelf,
						router,
						A2($elm$browser$Browser$Events$Event, key, event));
				}));
	});
var $elm$core$Dict$union = F2(
	function (t1, t2) {
		return A3($elm$core$Dict$foldl, $elm$core$Dict$insert, t2, t1);
	});
var $elm$browser$Browser$Events$onEffects = F3(
	function (router, subs, state) {
		var stepRight = F3(
			function (key, sub, _v6) {
				var deads = _v6.a;
				var lives = _v6.b;
				var news = _v6.c;
				return _Utils_Tuple3(
					deads,
					lives,
					A2(
						$elm$core$List$cons,
						A3($elm$browser$Browser$Events$spawn, router, key, sub),
						news));
			});
		var stepLeft = F3(
			function (_v4, pid, _v5) {
				var deads = _v5.a;
				var lives = _v5.b;
				var news = _v5.c;
				return _Utils_Tuple3(
					A2($elm$core$List$cons, pid, deads),
					lives,
					news);
			});
		var stepBoth = F4(
			function (key, pid, _v2, _v3) {
				var deads = _v3.a;
				var lives = _v3.b;
				var news = _v3.c;
				return _Utils_Tuple3(
					deads,
					A3($elm$core$Dict$insert, key, pid, lives),
					news);
			});
		var newSubs = A2($elm$core$List$map, $elm$browser$Browser$Events$addKey, subs);
		var _v0 = A6(
			$elm$core$Dict$merge,
			stepLeft,
			stepBoth,
			stepRight,
			state.pids,
			$elm$core$Dict$fromList(newSubs),
			_Utils_Tuple3(_List_Nil, $elm$core$Dict$empty, _List_Nil));
		var deadPids = _v0.a;
		var livePids = _v0.b;
		var makeNewPids = _v0.c;
		return A2(
			$elm$core$Task$andThen,
			function (pids) {
				return $elm$core$Task$succeed(
					A2(
						$elm$browser$Browser$Events$State,
						newSubs,
						A2(
							$elm$core$Dict$union,
							livePids,
							$elm$core$Dict$fromList(pids))));
			},
			A2(
				$elm$core$Task$andThen,
				function (_v1) {
					return $elm$core$Task$sequence(makeNewPids);
				},
				$elm$core$Task$sequence(
					A2($elm$core$List$map, $elm$core$Process$kill, deadPids))));
	});
var $elm$core$List$maybeCons = F3(
	function (f, mx, xs) {
		var _v0 = f(mx);
		if (_v0.$ === 'Just') {
			var x = _v0.a;
			return A2($elm$core$List$cons, x, xs);
		} else {
			return xs;
		}
	});
var $elm$core$List$filterMap = F2(
	function (f, xs) {
		return A3(
			$elm$core$List$foldr,
			$elm$core$List$maybeCons(f),
			_List_Nil,
			xs);
	});
var $elm$browser$Browser$Events$onSelfMsg = F3(
	function (router, _v0, state) {
		var key = _v0.key;
		var event = _v0.event;
		var toMessage = function (_v2) {
			var subKey = _v2.a;
			var _v3 = _v2.b;
			var node = _v3.a;
			var name = _v3.b;
			var decoder = _v3.c;
			return _Utils_eq(subKey, key) ? A2(_Browser_decodeEvent, decoder, event) : $elm$core$Maybe$Nothing;
		};
		var messages = A2($elm$core$List$filterMap, toMessage, state.subs);
		return A2(
			$elm$core$Task$andThen,
			function (_v1) {
				return $elm$core$Task$succeed(state);
			},
			$elm$core$Task$sequence(
				A2(
					$elm$core$List$map,
					$elm$core$Platform$sendToApp(router),
					messages)));
	});
var $elm$browser$Browser$Events$subMap = F2(
	function (func, _v0) {
		var node = _v0.a;
		var name = _v0.b;
		var decoder = _v0.c;
		return A3(
			$elm$browser$Browser$Events$MySub,
			node,
			name,
			A2($elm$json$Json$Decode$map, func, decoder));
	});
_Platform_effectManagers['Browser.Events'] = _Platform_createManager($elm$browser$Browser$Events$init, $elm$browser$Browser$Events$onEffects, $elm$browser$Browser$Events$onSelfMsg, 0, $elm$browser$Browser$Events$subMap);
var $elm$browser$Browser$Events$subscription = _Platform_leaf('Browser.Events');
var $elm$browser$Browser$Events$on = F3(
	function (node, name, decoder) {
		return $elm$browser$Browser$Events$subscription(
			A3($elm$browser$Browser$Events$MySub, node, name, decoder));
	});
var $elm$browser$Browser$Events$onClick = A2($elm$browser$Browser$Events$on, $elm$browser$Browser$Events$Document, 'click');
var $elm$browser$Browser$Events$Window = {$: 'Window'};
var $elm$json$Json$Decode$field = _Json_decodeField;
var $elm$json$Json$Decode$int = _Json_decodeInt;
var $elm$browser$Browser$Events$onResize = function (func) {
	return A3(
		$elm$browser$Browser$Events$on,
		$elm$browser$Browser$Events$Window,
		'resize',
		A2(
			$elm$json$Json$Decode$field,
			'target',
			A3(
				$elm$json$Json$Decode$map2,
				func,
				A2($elm$json$Json$Decode$field, 'innerWidth', $elm$json$Json$Decode$int),
				A2($elm$json$Json$Decode$field, 'innerHeight', $elm$json$Json$Decode$int))));
};
var $zaboco$elm_draggable$Internal$DragAt = function (a) {
	return {$: 'DragAt', a: a};
};
var $zaboco$elm_draggable$Draggable$Msg = function (a) {
	return {$: 'Msg', a: a};
};
var $zaboco$elm_draggable$Internal$StopDragging = {$: 'StopDragging'};
var $elm$core$Platform$Sub$map = _Platform_map;
var $elm$core$Platform$Sub$none = $elm$core$Platform$Sub$batch(_List_Nil);
var $elm$browser$Browser$Events$onMouseMove = A2($elm$browser$Browser$Events$on, $elm$browser$Browser$Events$Document, 'mousemove');
var $elm$browser$Browser$Events$onMouseUp = A2($elm$browser$Browser$Events$on, $elm$browser$Browser$Events$Document, 'mouseup');
var $zaboco$elm_draggable$Internal$Position = F2(
	function (x, y) {
		return {x: x, y: y};
	});
var $elm$json$Json$Decode$float = _Json_decodeFloat;
var $elm$core$Basics$truncate = _Basics_truncate;
var $zaboco$elm_draggable$Draggable$positionDecoder = A3(
	$elm$json$Json$Decode$map2,
	$zaboco$elm_draggable$Internal$Position,
	A2(
		$elm$json$Json$Decode$map,
		$elm$core$Basics$truncate,
		A2($elm$json$Json$Decode$field, 'pageX', $elm$json$Json$Decode$float)),
	A2(
		$elm$json$Json$Decode$map,
		$elm$core$Basics$truncate,
		A2($elm$json$Json$Decode$field, 'pageY', $elm$json$Json$Decode$float)));
var $zaboco$elm_draggable$Draggable$subscriptions = F2(
	function (envelope, _v0) {
		var drag = _v0.a;
		if (drag.$ === 'NotDragging') {
			return $elm$core$Platform$Sub$none;
		} else {
			return A2(
				$elm$core$Platform$Sub$map,
				A2($elm$core$Basics$composeL, envelope, $zaboco$elm_draggable$Draggable$Msg),
				$elm$core$Platform$Sub$batch(
					_List_fromArray(
						[
							$elm$browser$Browser$Events$onMouseMove(
							A2($elm$json$Json$Decode$map, $zaboco$elm_draggable$Internal$DragAt, $zaboco$elm_draggable$Draggable$positionDecoder)),
							$elm$browser$Browser$Events$onMouseUp(
							$elm$json$Json$Decode$succeed($zaboco$elm_draggable$Internal$StopDragging))
						])));
		}
	});
var $author$project$Main$subscriptions = function (model) {
	return $elm$core$Platform$Sub$batch(
		_List_fromArray(
			[
				$elm$browser$Browser$Events$onAnimationFrameDelta($author$project$Messages$Tick),
				$elm$browser$Browser$Events$onResize($author$project$Messages$Resize),
				A2($zaboco$elm_draggable$Draggable$subscriptions, $author$project$Messages$DragMsg, model.drag),
				$elm$browser$Browser$Events$onClick(
				$elm$json$Json$Decode$succeed($author$project$Messages$Increase)),
				$elm$browser$Browser$Events$onClick(
				$elm$json$Json$Decode$succeed($author$project$Messages$Decrease))
			]));
};
var $author$project$Ptable$Active = {$: 'Active'};
var $elm$core$List$any = F2(
	function (isOkay, list) {
		any:
		while (true) {
			if (!list.b) {
				return false;
			} else {
				var x = list.a;
				var xs = list.b;
				if (isOkay(x)) {
					return true;
				} else {
					var $temp$isOkay = isOkay,
						$temp$list = xs;
					isOkay = $temp$isOkay;
					list = $temp$list;
					continue any;
				}
			}
		}
	});
var $elm$core$Basics$not = _Basics_not;
var $elm$core$List$all = F2(
	function (isOkay, list) {
		return !A2(
			$elm$core$List$any,
			A2($elm$core$Basics$composeL, $elm$core$Basics$not, isOkay),
			list);
	});
var $author$project$Gradient$Appear = function (a) {
	return {$: 'Appear', a: a};
};
var $author$project$Gradient$KeepSame = {$: 'KeepSame'};
var $author$project$Gradient$NoUse = {$: 'NoUse'};
var $author$project$Gradient$Process = F3(
	function (a, b, c) {
		return {$: 'Process', a: a, b: b, c: c};
	});
var $author$project$Gradient$Useless = {$: 'Useless'};
var $author$project$Ppiano$Down = {$: 'Down'};
var $author$project$Ppiano$bounce_key = F2(
	function (time, keySet) {
		var bounce_key_help = F2(
			function (currentTime, key) {
				return (((currentTime - key.press_time) > 900) && _Utils_eq(key.keyState, $author$project$Ppiano$Down)) ? _Utils_update(
					key,
					{keyState: $author$project$Ppiano$Up, press_time: 0}) : key;
			});
		return A2(
			$elm$core$List$map,
			bounce_key_help(time),
			keySet);
	});
var $author$project$Update$bounce_key_help = F2(
	function (time, object) {
		if (object.$ === 'Piano') {
			var a = object.a;
			return $author$project$Object$Piano(
				_Utils_update(
					a,
					{
						pianoKeySet: A2($author$project$Ppiano$bounce_key, time, a.pianoKeySet)
					}));
		} else {
			return object;
		}
	});
var $author$project$Update$bounce_key_top = F2(
	function (time, objectSet) {
		return A2(
			$elm$core$List$map,
			$author$project$Update$bounce_key_help(time),
			objectSet);
	});
var $author$project$Intro$Finished = {$: 'Finished'};
var $author$project$Intro$Transition = function (a) {
	return {$: 'Transition', a: a};
};
var $elm$core$Basics$abs = function (n) {
	return (n < 0) ? (-n) : n;
};
var $author$project$Intro$get_new_intro = F2(
	function (old, cstate) {
		var newTran = (_Utils_eq(
			old.sit,
			$author$project$Intro$Transition(0)) || _Utils_eq(
			old.sit,
			$author$project$Intro$Transition(1))) ? (old.tran_sec - 0.05) : 1;
		var newSec = (cstate === 99) ? (_Utils_eq(
			old.sit,
			$author$project$Intro$Transition(0)) ? 60 : (_Utils_eq(
			old.sit,
			$author$project$Intro$Transition(1)) ? 210 : (old.sec + 0.5))) : 0;
		var newSit = function () {
			var _v0 = old.sit;
			switch (_v0.$) {
				case 'Transition':
					var a = _v0.a;
					return (newTran <= 0) ? $author$project$Intro$UnderGoing(a + 1) : old.sit;
				case 'UnderGoing':
					var a = _v0.a;
					return (($elm$core$Basics$abs(newSec - 60) <= 0.001) || ($elm$core$Basics$abs(newSec - 210) <= 0.001)) ? $author$project$Intro$Transition(a) : (($elm$core$Basics$abs(newSec - 375) <= 0.001) ? $author$project$Intro$Finished : old.sit);
				default:
					return old.sit;
			}
		}();
		return A3($author$project$Intro$IntroPage, newSec, newTran, newSit);
	});
var $author$project$Update$animate = F2(
	function (model, elapsed) {
		var new_intro = A2($author$project$Intro$get_new_intro, model.intro, model.cscreen.cstate);
		var _v0 = function () {
			var _v1 = model.gradient;
			if (_v1.$ === 'Normal') {
				return _Utils_Tuple3(0.0, $author$project$Gradient$Useless, $author$project$Gradient$KeepSame);
			} else {
				var aa = _v1.a;
				var b = _v1.b;
				var c = _v1.c;
				return _Utils_Tuple3(aa, b, c);
			}
		}();
		var spe = _v0.a;
		var col = _v0.b;
		var pro = _v0.c;
		var type_ = function () {
			switch (pro.$) {
				case 'KeepSame':
					return $author$project$Gradient$NoUse;
				case 'Disappear':
					var a = pro.a;
					return a;
				default:
					var b = pro.a;
					return b;
			}
		}();
		var new_opacity = function () {
			switch (pro.$) {
				case 'Disappear':
					var a = pro.a;
					return model.opac - spe;
				case 'Appear':
					var a = pro.a;
					return model.opac + spe;
				default:
					return model.opac;
			}
		}();
		var _v2 = (new_opacity < 0) ? _Utils_Tuple3(
			A3(
				$author$project$Gradient$Process,
				spe,
				col,
				$author$project$Gradient$Appear(type_)),
			model.tscreen,
			$author$project$Model$initial_target) : ((new_opacity > 1) ? _Utils_Tuple3($author$project$Gradient$Normal, model.cscreen, $author$project$Model$initial_target) : _Utils_Tuple3(model.gradient, model.cscreen, model.tscreen));
		var new_gradient = _v2.a;
		var new_cscreen = _v2.b;
		var new_tscreen = _v2.c;
		var stage_1 = _Utils_update(
			model,
			{
				cscreen: new_cscreen,
				gradient: new_gradient,
				move_timer: model.move_timer + elapsed,
				objects: A2($author$project$Update$bounce_key_top, model.move_timer, model.objects),
				opac: new_opacity,
				tscreen: new_tscreen
			});
		return _Utils_update(
			stage_1,
			{intro: new_intro});
	});
var $author$project$Pcomputer$Charged = function (a) {
	return {$: 'Charged', a: a};
};
var $author$project$Update$charge_computer = F2(
	function (model, number) {
		var toggle = function (computer) {
			if (computer.$ === 'Computer') {
				var cpt = computer.a;
				return $author$project$Object$Computer(
					_Utils_update(
						cpt,
						{
							state: $author$project$Pcomputer$Charged(number)
						}));
			} else {
				return computer;
			}
		};
		return _Utils_update(
			model,
			{
				objects: A2($elm$core$List$map, toggle, model.objects)
			});
	});
var $author$project$Ppower$High = {$: 'High'};
var $author$project$Update$charge_power = function (model) {
	var toggle = function (power) {
		if (power.$ === 'Power') {
			var a = power.a;
			return $author$project$Object$Power(
				_Utils_update(
					a,
					{state: $author$project$Ppower$High}));
		} else {
			return power;
		}
	};
	return _Utils_update(
		model,
		{
			objects: A2($elm$core$List$map, toggle, model.objects)
		});
};
var $author$project$Picture$UnderUse = {$: 'UnderUse'};
var $author$project$Picture$Picked = {$: 'Picked'};
var $author$project$Inventory$Pict = function (a) {
	return {$: 'Pict', a: a};
};
var $author$project$Picture$Stored = {$: 'Stored'};
var $elm$core$List$drop = F2(
	function (n, list) {
		drop:
		while (true) {
			if (n <= 0) {
				return list;
			} else {
				if (!list.b) {
					return list;
				} else {
					var x = list.a;
					var xs = list.b;
					var $temp$n = n - 1,
						$temp$list = xs;
					n = $temp$n;
					list = $temp$list;
					continue drop;
				}
			}
		}
	});
var $elm$core$List$takeReverse = F3(
	function (n, list, kept) {
		takeReverse:
		while (true) {
			if (n <= 0) {
				return kept;
			} else {
				if (!list.b) {
					return kept;
				} else {
					var x = list.a;
					var xs = list.b;
					var $temp$n = n - 1,
						$temp$list = xs,
						$temp$kept = A2($elm$core$List$cons, x, kept);
					n = $temp$n;
					list = $temp$list;
					kept = $temp$kept;
					continue takeReverse;
				}
			}
		}
	});
var $elm$core$List$takeTailRec = F2(
	function (n, list) {
		return $elm$core$List$reverse(
			A3($elm$core$List$takeReverse, n, list, _List_Nil));
	});
var $elm$core$List$takeFast = F3(
	function (ctr, n, list) {
		if (n <= 0) {
			return _List_Nil;
		} else {
			var _v0 = _Utils_Tuple2(n, list);
			_v0$1:
			while (true) {
				_v0$5:
				while (true) {
					if (!_v0.b.b) {
						return list;
					} else {
						if (_v0.b.b.b) {
							switch (_v0.a) {
								case 1:
									break _v0$1;
								case 2:
									var _v2 = _v0.b;
									var x = _v2.a;
									var _v3 = _v2.b;
									var y = _v3.a;
									return _List_fromArray(
										[x, y]);
								case 3:
									if (_v0.b.b.b.b) {
										var _v4 = _v0.b;
										var x = _v4.a;
										var _v5 = _v4.b;
										var y = _v5.a;
										var _v6 = _v5.b;
										var z = _v6.a;
										return _List_fromArray(
											[x, y, z]);
									} else {
										break _v0$5;
									}
								default:
									if (_v0.b.b.b.b && _v0.b.b.b.b.b) {
										var _v7 = _v0.b;
										var x = _v7.a;
										var _v8 = _v7.b;
										var y = _v8.a;
										var _v9 = _v8.b;
										var z = _v9.a;
										var _v10 = _v9.b;
										var w = _v10.a;
										var tl = _v10.b;
										return (ctr > 1000) ? A2(
											$elm$core$List$cons,
											x,
											A2(
												$elm$core$List$cons,
												y,
												A2(
													$elm$core$List$cons,
													z,
													A2(
														$elm$core$List$cons,
														w,
														A2($elm$core$List$takeTailRec, n - 4, tl))))) : A2(
											$elm$core$List$cons,
											x,
											A2(
												$elm$core$List$cons,
												y,
												A2(
													$elm$core$List$cons,
													z,
													A2(
														$elm$core$List$cons,
														w,
														A3($elm$core$List$takeFast, ctr + 1, n - 4, tl)))));
									} else {
										break _v0$5;
									}
							}
						} else {
							if (_v0.a === 1) {
								break _v0$1;
							} else {
								break _v0$5;
							}
						}
					}
				}
				return list;
			}
			var _v1 = _v0.b;
			var x = _v1.a;
			return _List_fromArray(
				[x]);
		}
	});
var $elm$core$List$take = F2(
	function (n, list) {
		return A3($elm$core$List$takeFast, 0, n, list);
	});
var $author$project$Inventory$insert_new_item = F2(
	function (grid, old) {
		var pre = (!old.num) ? _List_Nil : A2($elm$core$List$take, old.num, old.own);
		var now = _List_fromArray(
			[grid]);
		var new_num = old.num + 1;
		var nex = (old.num === 7) ? _List_Nil : A2($elm$core$List$drop, new_num, old.own);
		return A3(
			$author$project$Inventory$Inventory,
			_Utils_ap(
				pre,
				_Utils_ap(now, nex)),
			old.locaLeft,
			new_num);
	});
var $author$project$Update$check_use_picture = F2(
	function (pict, model) {
		var from_picked_to_stored = F2(
			function (index, pic) {
				return _Utils_eq(pic.index, index) ? _Utils_update(
					pic,
					{state: $author$project$Picture$Stored}) : pic;
			});
		return (_Utils_eq(pict.state, $author$project$Picture$UnderUse) && _Utils_eq(model.underUse, $author$project$Inventory$Blank)) ? _Utils_update(
			model,
			{
				underUse: $author$project$Inventory$Pict(
					A2($author$project$Picture$Picture, pict.state, pict.index))
			}) : (_Utils_eq(pict.state, $author$project$Picture$Picked) ? _Utils_update(
			model,
			{
				inventory: A2(
					$author$project$Inventory$insert_new_item,
					$author$project$Inventory$Pict(
						A2($author$project$Picture$Picture, $author$project$Picture$Stored, pict.index)),
					model.inventory),
				pictures: A2(
					$elm$core$List$map,
					from_picked_to_stored(pict.index),
					model.pictures)
			}) : model);
	});
var $elm$core$Basics$neq = _Utils_notEqual;
var $author$project$Update$check_pict_state = function (model) {
	var refresh_underuse = function (mod) {
		return A2(
			$elm$core$List$all,
			function (x) {
				return !_Utils_eq(x.state, $author$project$Picture$UnderUse);
			},
			model.pictures) ? _Utils_update(
			mod,
			{underUse: $author$project$Inventory$Blank}) : mod;
	};
	return refresh_underuse(
		A3($elm$core$List$foldr, $author$project$Update$check_use_picture, model, model.pictures));
};
var $author$project$Messages$OnDragBy = function (a) {
	return {$: 'OnDragBy', a: a};
};
var $zaboco$elm_draggable$Draggable$Config = function (a) {
	return {$: 'Config', a: a};
};
var $zaboco$elm_draggable$Internal$defaultConfig = {
	onClick: function (_v0) {
		return $elm$core$Maybe$Nothing;
	},
	onDragBy: function (_v1) {
		return $elm$core$Maybe$Nothing;
	},
	onDragEnd: $elm$core$Maybe$Nothing,
	onDragStart: function (_v2) {
		return $elm$core$Maybe$Nothing;
	},
	onMouseDown: function (_v3) {
		return $elm$core$Maybe$Nothing;
	}
};
var $zaboco$elm_draggable$Draggable$basicConfig = function (onDragByListener) {
	var defaultConfig = $zaboco$elm_draggable$Internal$defaultConfig;
	return $zaboco$elm_draggable$Draggable$Config(
		_Utils_update(
			defaultConfig,
			{
				onDragBy: A2($elm$core$Basics$composeL, $elm$core$Maybe$Just, onDragByListener)
			}));
};
var $author$project$Update$dragConfig = $zaboco$elm_draggable$Draggable$basicConfig($author$project$Messages$OnDragBy);
var $author$project$Object$default_object = $author$project$Object$Clock(
	A2($author$project$Object$ClockModel, 0, 0));
var $author$project$Model$list_index_object = F2(
	function (index, list) {
		list_index_object:
		while (true) {
			if (_Utils_cmp(
				index,
				$elm$core$List$length(list)) > 0) {
				return $author$project$Object$default_object;
			} else {
				if (list.b) {
					var x = list.a;
					var xs = list.b;
					if (!index) {
						return x;
					} else {
						var $temp$index = index - 1,
							$temp$list = xs;
						index = $temp$index;
						list = $temp$list;
						continue list_index_object;
					}
				} else {
					return $author$project$Object$default_object;
				}
			}
		}
	});
var $elm$core$Basics$min = F2(
	function (x, y) {
		return (_Utils_cmp(x, y) < 0) ? x : y;
	});
var $elm$core$Platform$Cmd$none = $elm$core$Platform$Cmd$batch(_List_Nil);
var $author$project$Update$pickup_picture = F2(
	function (index, model) {
		var f = function (x) {
			return _Utils_eq(x.index, index) ? (_Utils_eq(x.state, $author$project$Picture$Show) ? _Utils_update(
				x,
				{state: $author$project$Picture$Picked}) : ((_Utils_eq(x.state, $author$project$Picture$Stored) && _Utils_eq(model.underUse, $author$project$Inventory$Blank)) ? _Utils_update(
				x,
				{state: $author$project$Picture$UnderUse}) : (_Utils_eq(x.state, $author$project$Picture$UnderUse) ? _Utils_update(
				x,
				{state: $author$project$Picture$Stored}) : x))) : x;
		};
		return _Utils_update(
			model,
			{
				pictures: A2($elm$core$List$map, f, model.pictures)
			});
	});
var $elm$core$Basics$modBy = _Basics_modBy;
var $elm$core$Debug$todo = _Debug_todo;
var $author$project$Object$get_time = function (obj) {
	var _v0 = function () {
		if (obj.$ === 'Clock') {
			var a = obj.a;
			return _Utils_Tuple2(a.hour, a.minute);
		} else {
			return _Debug_todo(
				'Object',
				{
					start: {line: 54, column: 21},
					end: {line: 54, column: 31}
				})('abab');
		}
	}();
	var orihour = _v0.a;
	var oriminute = _v0.b;
	return _Utils_Tuple2(
		A2($elm$core$Basics$modBy, 12, orihour),
		A2($elm$core$Basics$modBy, 60, oriminute));
};
var $author$project$Picture$show_index_picture = F2(
	function (index, list) {
		var f = function (x) {
			return _Utils_eq(x.index, index) ? _Utils_update(
				x,
				{state: $author$project$Picture$Show}) : x;
		};
		return A2($elm$core$List$map, f, list);
	});
var $author$project$Update$test_clock_win = function (model) {
	var cloc = A2($author$project$Model$list_index_object, 0, model.objects);
	var _v0 = $author$project$Object$get_time(cloc);
	var hour = _v0.a;
	var min = _v0.b;
	return ((hour === 2) && (min === 30)) ? _Utils_update(
		model,
		{
			pictures: A2($author$project$Picture$show_index_picture, 1, model.pictures)
		}) : model;
};
var $elm$core$List$head = function (list) {
	if (list.b) {
		var x = list.a;
		var xs = list.b;
		return $elm$core$Maybe$Just(x);
	} else {
		return $elm$core$Maybe$Nothing;
	}
};
var $elm$core$Maybe$withDefault = F2(
	function (_default, maybe) {
		if (maybe.$ === 'Just') {
			var value = maybe.a;
			return value;
		} else {
			return _default;
		}
	});
var $author$project$Update$test_mirror_win_help = function (object) {
	if (object.$ === 'Mirror') {
		var a = object.a;
		var tail = A2(
			$elm$core$Maybe$withDefault,
			A2(
				$author$project$Geometry$Line,
				A2($author$project$Geometry$Location, 100, 100),
				A2($author$project$Geometry$Location, 0, 100)),
			$elm$core$List$head(
				$elm$core$List$reverse(a.lightSet)));
		return ((tail.secondPoint.x > 49) && ((tail.secondPoint.x < 51) && (tail.secondPoint.y > 350))) ? true : false;
	} else {
		return false;
	}
};
var $author$project$Update$test_mirror_win = function (model) {
	var flag = A2($elm$core$List$any, $author$project$Update$test_mirror_win_help, model.objects);
	return flag ? _Utils_update(
		model,
		{
			pictures: A2($author$project$Picture$show_index_picture, 2, model.pictures)
		}) : model;
};
var $author$project$Ptable$change_block_state = F2(
	function (location, block) {
		return _Utils_eq(block.anchor, location) ? _Utils_update(
			block,
			{state: $author$project$Ptable$Active}) : block;
	});
var $elm$core$Basics$pow = _Basics_pow;
var $author$project$Ptable$distance = F2(
	function (pa, pb) {
		var by = pb.y;
		var bx = pb.x;
		var ay = pa.y;
		var ax = pa.x;
		return $elm$core$Basics$sqrt(
			A2($elm$core$Basics$pow, ax - bx, 2) + A2($elm$core$Basics$pow, ay - by, 2));
	});
var $author$project$Object$test_table = F2(
	function (loca, pre) {
		if (pre.$ === 'Table') {
			var tm = pre.a;
			return (_Utils_cmp(
				A2($author$project$Ptable$distance, loca, tm.lastLocation),
				($author$project$Ptable$blockLength * 1.1) * $elm$core$Basics$sqrt(3)) > 0) ? $author$project$Object$Table($author$project$Ptable$initial_table) : $author$project$Object$Table(
				_Utils_update(
					tm,
					{
						blockSet: A2(
							$elm$core$List$map,
							$author$project$Ptable$change_block_state(loca),
							tm.blockSet),
						lastLocation: loca
					}));
		} else {
			return pre;
		}
	});
var $author$project$Update$test_table_win = F2(
	function (obj, model) {
		if (obj.$ === 'Table') {
			var a = obj.a;
			return A2(
				$elm$core$List$all,
				function (x) {
					return _Utils_eq(x.state, $author$project$Ptable$Active);
				},
				a.blockSet) ? _Utils_update(
				model,
				{
					pictures: A2($author$project$Picture$show_index_picture, 0, model.pictures)
				}) : model;
		} else {
			return model;
		}
	});
var $elm$core$Maybe$map = F2(
	function (f, maybe) {
		if (maybe.$ === 'Just') {
			var value = maybe.a;
			return $elm$core$Maybe$Just(
				f(value));
		} else {
			return $elm$core$Maybe$Nothing;
		}
	});
var $zaboco$elm_draggable$Cmd$Extra$message = function (x) {
	return A2(
		$elm$core$Task$perform,
		$elm$core$Basics$identity,
		$elm$core$Task$succeed(x));
};
var $zaboco$elm_draggable$Cmd$Extra$optionalMessage = function (msgMaybe) {
	return A2(
		$elm$core$Maybe$withDefault,
		$elm$core$Platform$Cmd$none,
		A2($elm$core$Maybe$map, $zaboco$elm_draggable$Cmd$Extra$message, msgMaybe));
};
var $zaboco$elm_draggable$Internal$Dragging = function (a) {
	return {$: 'Dragging', a: a};
};
var $zaboco$elm_draggable$Internal$DraggingTentative = F2(
	function (a, b) {
		return {$: 'DraggingTentative', a: a, b: b};
	});
var $zaboco$elm_draggable$Internal$distanceTo = F2(
	function (end, start) {
		return _Utils_Tuple2(end.x - start.x, end.y - start.y);
	});
var $zaboco$elm_draggable$Internal$updateAndEmit = F3(
	function (config, msg, drag) {
		var _v0 = _Utils_Tuple2(drag, msg);
		_v0$5:
		while (true) {
			switch (_v0.a.$) {
				case 'NotDragging':
					if (_v0.b.$ === 'StartDragging') {
						var _v1 = _v0.a;
						var _v2 = _v0.b;
						var key = _v2.a;
						var initialPosition = _v2.b;
						return _Utils_Tuple2(
							A2($zaboco$elm_draggable$Internal$DraggingTentative, key, initialPosition),
							config.onMouseDown(key));
					} else {
						break _v0$5;
					}
				case 'DraggingTentative':
					switch (_v0.b.$) {
						case 'DragAt':
							var _v3 = _v0.a;
							var key = _v3.a;
							var oldPosition = _v3.b;
							return _Utils_Tuple2(
								$zaboco$elm_draggable$Internal$Dragging(oldPosition),
								config.onDragStart(key));
						case 'StopDragging':
							var _v4 = _v0.a;
							var key = _v4.a;
							var _v5 = _v0.b;
							return _Utils_Tuple2(
								$zaboco$elm_draggable$Internal$NotDragging,
								config.onClick(key));
						default:
							break _v0$5;
					}
				default:
					switch (_v0.b.$) {
						case 'DragAt':
							var oldPosition = _v0.a.a;
							var newPosition = _v0.b.a;
							return _Utils_Tuple2(
								$zaboco$elm_draggable$Internal$Dragging(newPosition),
								config.onDragBy(
									A2($zaboco$elm_draggable$Internal$distanceTo, newPosition, oldPosition)));
						case 'StopDragging':
							var _v6 = _v0.b;
							return _Utils_Tuple2($zaboco$elm_draggable$Internal$NotDragging, config.onDragEnd);
						default:
							break _v0$5;
					}
			}
		}
		return _Utils_Tuple2(drag, $elm$core$Maybe$Nothing);
	});
var $zaboco$elm_draggable$Draggable$updateDraggable = F3(
	function (_v0, _v1, _v2) {
		var config = _v0.a;
		var msg = _v1.a;
		var drag = _v2.a;
		var _v3 = A3($zaboco$elm_draggable$Internal$updateAndEmit, config, msg, drag);
		var newDrag = _v3.a;
		var newMsgMaybe = _v3.b;
		return _Utils_Tuple2(
			$zaboco$elm_draggable$Draggable$State(newDrag),
			$zaboco$elm_draggable$Cmd$Extra$optionalMessage(newMsgMaybe));
	});
var $zaboco$elm_draggable$Draggable$update = F3(
	function (config, msg, model) {
		var _v0 = A3($zaboco$elm_draggable$Draggable$updateDraggable, config, msg, model.drag);
		var dragState = _v0.a;
		var dragCmd = _v0.b;
		return _Utils_Tuple2(
			_Utils_update(
				model,
				{drag: dragState}),
			dragCmd);
	});
var $author$project$Gradient$Black = {$: 'Black'};
var $author$project$Gradient$Disappear = function (a) {
	return {$: 'Disappear', a: a};
};
var $author$project$Gradient$Whole = {$: 'Whole'};
var $author$project$Gradient$default_process = A3(
	$author$project$Gradient$Process,
	0.05,
	$author$project$Gradient$Black,
	$author$project$Gradient$Disappear($author$project$Gradient$Whole));
var $author$project$Gradient$OnlyWord = {$: 'OnlyWord'};
var $author$project$Gradient$White = {$: 'White'};
var $author$project$Gradient$default_word_change = A3(
	$author$project$Gradient$Process,
	0.1,
	$author$project$Gradient$White,
	$author$project$Gradient$Disappear($author$project$Gradient$OnlyWord));
var $author$project$Update$get_gra_state = function (submsg) {
	if (submsg.$ === 'Forward') {
		return $author$project$Gradient$default_word_change;
	} else {
		return $author$project$Gradient$default_process;
	}
};
var $author$project$Memory$Unlocked = {$: 'Unlocked'};
var $author$project$Document$unlock_cor_docu = F2(
	function (index, old) {
		var fin = F2(
			function (ind, docu) {
				return (_Utils_eq(docu.index, ind) && _Utils_eq(docu.lockState, $author$project$Memory$Locked)) ? _Utils_update(
					docu,
					{lockState: $author$project$Memory$Unlocked}) : docu;
			});
		return A2(
			$elm$core$List$map,
			fin(index),
			old);
	});
var $author$project$Update$renew_other_thing = F2(
	function (model, submsg) {
		if (submsg.$ === 'OnClickDocu') {
			var index = submsg.a;
			return _Utils_update(
				model,
				{
					docu: A2($author$project$Document$unlock_cor_docu, index, model.docu)
				});
		} else {
			return model;
		}
	});
var $author$project$Update$renew_screen_info = F2(
	function (submsg, old) {
		switch (submsg.$) {
			case 'Pause':
				return _Utils_update(
					old,
					{cstate: 1});
			case 'RecallMemory':
				return _Utils_update(
					old,
					{cstate: 2});
			case 'Back':
				var _new = (old.cstate === 11) ? 0 : (old.cstate - 1);
				return _Utils_update(
					old,
					{cstate: _new});
			case 'MovePage':
				var dir = submsg.a;
				return _Utils_update(
					old,
					{cstate: old.cstate + dir});
			case 'Achievement':
				return _Utils_update(
					old,
					{cstate: 10});
			case 'BackfromAch':
				return _Utils_update(
					old,
					{cstate: 1});
			case 'EnterState':
				var _new = function () {
					var _v1 = old.cstate;
					switch (_v1) {
						case 99:
							return 0;
						case 98:
							return 99;
						default:
							return old.cstate + 1;
					}
				}();
				return _Utils_update(
					old,
					{cstate: _new});
			case 'ChangeLevel':
				var a = submsg.a;
				return _Utils_update(
					old,
					{clevel: a});
			case 'ChangeScene':
				var a = submsg.a;
				return _Utils_update(
					old,
					{cscene: a});
			case 'BeginMemory':
				var a = submsg.a;
				return _Utils_update(
					old,
					{cmemory: a, cpage: 0, cscene: a, cstate: 20});
			case 'EndMemory':
				return _Utils_update(
					old,
					{cpage: -1, cstate: 0});
			case 'Forward':
				return _Utils_update(
					old,
					{cpage: old.cpage + 1});
			case 'Choice':
				var a = submsg.a;
				var b = submsg.b;
				var new_page = function () {
					var _v2 = _Utils_Tuple2(a, b);
					if ((!_v2.a) && (!_v2.b)) {
						return 5;
					} else {
						return 11;
					}
				}();
				return _Utils_update(
					old,
					{cpage: new_page});
			case 'OnClickDocu':
				var a = submsg.a;
				return _Utils_update(
					old,
					{cdocu: a, cstate: 11});
			default:
				return old;
		}
	});
var $author$project$Update$update_gra_part = F2(
	function (model, submsg) {
		var targetScreen = A2($author$project$Update$renew_screen_info, submsg, model.cscreen);
		var other_new = A2($author$project$Update$renew_other_thing, model, submsg);
		var graState = $author$project$Update$get_gra_state(submsg);
		return _Utils_update(
			other_new,
			{gradient: graState, tscreen: targetScreen});
	});
var $author$project$Picture$Consumed = {$: 'Consumed'};
var $author$project$Update$consume_picture = F3(
	function (list, index, whe) {
		if (!whe) {
			return list;
		} else {
			var consume = F2(
				function (id, pic) {
					return _Utils_eq(pic.index, id) ? _Utils_update(
						pic,
						{state: $author$project$Picture$Consumed}) : pic;
				});
			return A2(
				$elm$core$List$map,
				consume(index),
				list);
		}
	});
var $author$project$Inventory$eliminate_old_item = F2(
	function (index, old) {
		var pre = (!old.num) ? _List_Nil : A2($elm$core$List$take, index, old.own);
		var now = _List_fromArray(
			[$author$project$Inventory$Blank]);
		var new_num = old.num - 1;
		var latter = (index === 7) ? _List_Nil : A2($elm$core$List$drop, index + 1, old.own);
		return A3(
			$author$project$Inventory$Inventory,
			_Utils_ap(
				pre,
				_Utils_ap(now, latter)),
			old.locaLeft,
			new_num);
	});
var $author$project$Memory$find_cor_pict = function (index) {
	if (!index) {
		return _List_fromArray(
			[0, 1]);
	} else {
		return _List_Nil;
	}
};
var $elm$core$List$filter = F2(
	function (isGood, list) {
		return A3(
			$elm$core$List$foldr,
			F2(
				function (x, xs) {
					return isGood(x) ? A2($elm$core$List$cons, x, xs) : xs;
				}),
			_List_Nil,
			list);
	});
var $author$project$Inventory$find_the_grid = F2(
	function (list, ud) {
		if (ud.$ === 'Blank') {
			return -1;
		} else {
			var tmpList = A2($elm$core$List$indexedMap, $elm$core$Tuple$pair, list);
			return A2(
				$elm$core$Maybe$withDefault,
				_Utils_Tuple2(999, $author$project$Inventory$Blank),
				$elm$core$List$head(
					A2(
						$elm$core$List$filter,
						function (x) {
							return _Utils_eq(x.b, ud);
						},
						tmpList))).a;
		}
	});
var $elm$core$List$unzip = function (pairs) {
	var step = F2(
		function (_v0, _v1) {
			var x = _v0.a;
			var y = _v0.b;
			var xs = _v1.a;
			var ys = _v1.b;
			return _Utils_Tuple2(
				A2($elm$core$List$cons, x, xs),
				A2($elm$core$List$cons, y, ys));
		});
	return A3(
		$elm$core$List$foldr,
		step,
		_Utils_Tuple2(_List_Nil, _List_Nil),
		pairs);
};
var $author$project$Memory$unlock_cor_memory = F3(
	function (index, pict_index, old) {
		var unlock_pict = F3(
			function (need_id, p_id, mestate) {
				return (_Utils_eq(p_id, need_id) && _Utils_eq(mestate, $author$project$Memory$Locked)) ? _Utils_Tuple2($author$project$Memory$Unlocked, true) : _Utils_Tuple2(mestate, false);
			});
		var unlock_memory_final = function (pi) {
			return (A2(
				$elm$core$List$all,
				function (x) {
					return _Utils_eq(x, $author$project$Memory$Unlocked);
				},
				pi.frag) && _Utils_eq(pi.state, $author$project$Memory$Locked)) ? _Utils_update(
				pi,
				{state: $author$project$Memory$Unlocked}) : pi;
		};
		var unlock_memory_2 = F3(
			function (id, pict_id, memory) {
				var _v1 = $elm$core$List$unzip(
					A3(
						$elm$core$List$map2,
						unlock_pict(pict_id),
						memory.need,
						memory.frag));
				var curFrag = _v1.a;
				var curBool = _v1.b;
				return _Utils_eq(memory.index, id) ? _Utils_Tuple2(
					_Utils_update(
						memory,
						{frag: curFrag}),
					A2(
						$elm$core$List$any,
						function (x) {
							return x;
						},
						curBool)) : _Utils_Tuple2(memory, false);
			});
		var _v0 = $elm$core$List$unzip(
			A2(
				$elm$core$List$map,
				A2(unlock_memory_2, index, pict_index),
				old));
		var outMe = _v0.a;
		var outBool = _v0.b;
		var otb = A2(
			$elm$core$List$any,
			function (x) {
				return x;
			},
			outBool);
		return _Utils_Tuple2(
			A2($elm$core$List$map, unlock_memory_final, outMe),
			otb);
	});
var $author$project$Update$try_to_unlock_picture = F2(
	function (model, number) {
		var target_invent = A2($author$project$Inventory$find_the_grid, model.inventory.own, model.underUse);
		var pict_num = function () {
			var _v0 = model.underUse;
			if (_v0.$ === 'Blank') {
				return -1;
			} else {
				var a = _v0.a;
				return a.index;
			}
		}();
		var _new = A3($author$project$Memory$unlock_cor_memory, number, pict_num, model.memory);
		var need = $author$project$Memory$find_cor_pict(number);
		return _Utils_eq(pict_num, -1) ? model : (A2(
			$elm$core$List$any,
			function (x) {
				return _Utils_eq(x, pict_num);
			},
			need) ? _Utils_update(
			model,
			{
				inventory: A2($author$project$Inventory$eliminate_old_item, target_invent, model.inventory),
				memory: _new.a,
				pictures: A3($author$project$Update$consume_picture, model.pictures, pict_num, _new.b),
				underUse: _new.b ? $author$project$Inventory$Blank : model.underUse
			}) : model);
	});
var $author$project$Pcomputer$updatebackspace = function (word) {
	return A2($elm$core$List$drop, 1, word);
};
var $author$project$Pcomputer$updatecorrectpw = function (model) {
	return _Utils_eq(
		model.word,
		_List_fromArray(
			[1, 2, 3, 4])) ? _Utils_update(
		model,
		{
			state: $author$project$Pcomputer$Charged(1)
		}) : model;
};
var $author$project$Pcomputer$updateword = F2(
	function (number, word) {
		return A2($elm$core$List$cons, number, word);
	});
var $author$project$Pcomputer$updatetrigger = F2(
	function (a, model) {
		switch (a) {
			case 10:
				return _Utils_update(
					model,
					{
						word: $author$project$Pcomputer$updatebackspace(model.word)
					});
			case 11:
				return $author$project$Pcomputer$updatecorrectpw(model);
			default:
				return ($elm$core$List$length(model.word) < 4) ? _Utils_update(
					model,
					{
						word: A2($author$project$Pcomputer$updateword, a, model.word)
					}) : model;
		}
	});
var $author$project$Update$try_to_update_computer = F2(
	function (model, number) {
		var toggle = function (computer) {
			if (computer.$ === 'Computer') {
				var cpt = computer.a;
				return $author$project$Object$Computer(
					A2($author$project$Pcomputer$updatetrigger, number, cpt));
			} else {
				return computer;
			}
		};
		return _Utils_update(
			model,
			{
				objects: A2($elm$core$List$map, toggle, model.objects)
			});
	});
var $author$project$Ppiano$press_key = F3(
	function (index, time, keySet) {
		var press_key_help = F2(
			function (num, key) {
				return _Utils_eq(num, key.index) ? _Utils_update(
					key,
					{keyState: $author$project$Ppiano$Down, press_time: time}) : key;
			});
		return A2(
			$elm$core$List$map,
			press_key_help(index),
			keySet);
	});
var $author$project$Update$try_to_update_piano_help = F3(
	function (index, time, object) {
		if (object.$ === 'Piano') {
			var a = object.a;
			return $author$project$Object$Piano(
				_Utils_update(
					a,
					{
						currentMusic: index,
						pianoKeySet: A3($author$project$Ppiano$press_key, index, time, a.pianoKeySet)
					}));
		} else {
			return object;
		}
	});
var $author$project$Update$try_to_update_piano = F3(
	function (index, time, objectSet) {
		return A2(
			$elm$core$List$map,
			A2($author$project$Update$try_to_update_piano_help, index, time),
			objectSet);
	});
var $author$project$Ppower$updatekey = function (model) {
	return (model.key === 1) ? _Utils_update(
		model,
		{subscene: 2}) : model;
};
var $author$project$Ppower$updatetrigger = F2(
	function (index, model) {
		switch (index) {
			case 0:
				return $author$project$Ppower$updatekey(model);
			case 1:
				return _Utils_update(
					model,
					{state: $author$project$Ppower$High});
			default:
				return _Debug_todo(
					'Ppower',
					{
						start: {line: 42, column: 13},
						end: {line: 42, column: 23}
					})('branch \'_\' not implemented');
		}
	});
var $author$project$Update$try_to_update_power = F2(
	function (model, index) {
		var toggle = function (power) {
			if (power.$ === 'Power') {
				var a = power.a;
				return $author$project$Object$Power(
					A2($author$project$Ppower$updatetrigger, index, a));
			} else {
				return power;
			}
		};
		return _Utils_update(
			model,
			{
				objects: A2($elm$core$List$map, toggle, model.objects)
			});
	});
var $author$project$Pbulb$changecolor = function (cl) {
	if (cl.$ === 'None') {
		return $author$project$Pbulb$Red;
	} else {
		return $author$project$Pbulb$None;
	}
};
var $author$project$Pbulb$changebulbpos = F2(
	function (_v0, lb) {
		var a = _v0.a;
		var b = _v0.b;
		var toggle = function (bulb) {
			return _Utils_eq(
				bulb.position,
				_Utils_Tuple2(a, b)) ? _Utils_update(
				bulb,
				{
					color: $author$project$Pbulb$changecolor(bulb.color)
				}) : _Utils_update(
				bulb,
				{color: bulb.color});
		};
		return A2($elm$core$List$map, toggle, lb);
	});
var $author$project$Pbulb$nm2po = function (number) {
	var b = A2($elm$core$Basics$modBy, 3, number);
	var a = ((number + 3) / 3) | 0;
	return (!b) ? _Utils_Tuple2(a - 1, 3) : _Utils_Tuple2(a, b);
};
var $author$project$Pbulb$changebulb = F2(
	function (number, lb) {
		var _v0 = $author$project$Pbulb$nm2po(number);
		var a = _v0.a;
		var b = _v0.b;
		return A2(
			$author$project$Pbulb$changebulbpos,
			_Utils_Tuple2(a, b - 1),
			A2(
				$author$project$Pbulb$changebulbpos,
				_Utils_Tuple2(a, b + 1),
				A2(
					$author$project$Pbulb$changebulbpos,
					_Utils_Tuple2(a - 1, b),
					A2(
						$author$project$Pbulb$changebulbpos,
						_Utils_Tuple2(a + 1, b),
						lb))));
	});
var $author$project$Pbulb$update_bulb_inside = F2(
	function (number, model) {
		var newbulb = A2($author$project$Pbulb$changebulb, number, model.bulb);
		return _Utils_update(
			model,
			{bulb: newbulb});
	});
var $author$project$Update$update_bulb = F2(
	function (model, number) {
		var fin = F2(
			function (num, obj) {
				if (obj.$ === 'Bul') {
					var a = obj.a;
					return $author$project$Object$Bul(
						A2($author$project$Pbulb$update_bulb_inside, num, a));
				} else {
					return obj;
				}
			});
		return _Utils_update(
			model,
			{
				objects: A2(
					$elm$core$List$map,
					fin(number),
					model.objects)
			});
	});
var $elm$core$List$member = F2(
	function (x, xs) {
		return A2(
			$elm$core$List$any,
			function (a) {
				return _Utils_eq(a, x);
			},
			xs);
	});
var $elm$core$Basics$cos = _Basics_cos;
var $elm$core$Basics$atan = _Basics_atan;
var $elm$core$Basics$pi = _Basics_pi;
var $author$project$Geometry$get_angle_from_line = function (line) {
	return _Utils_eq(line.firstPoint.x, line.secondPoint.x) ? ((_Utils_cmp(line.firstPoint.y, line.secondPoint.y) > 0) ? ($elm$core$Basics$pi / 2) : ((3 * $elm$core$Basics$pi) / 2)) : (_Utils_eq(line.firstPoint.y, line.secondPoint.y) ? ((_Utils_cmp(line.firstPoint.x, line.secondPoint.x) > 0) ? 0.0 : $elm$core$Basics$pi) : ((line.firstPoint.y !== 100000) ? ((_Utils_cmp(line.firstPoint.x, line.secondPoint.x) > 0) ? $elm$core$Basics$atan((line.firstPoint.y - line.secondPoint.y) / (line.firstPoint.x - line.secondPoint.x)) : ($elm$core$Basics$pi + $elm$core$Basics$atan((line.firstPoint.y - line.secondPoint.y) / (line.firstPoint.x - line.secondPoint.x)))) : 0.2));
};
var $author$project$Geometry$get_coefficient = function (line) {
	if (_Utils_eq(line.firstPoint.y, line.secondPoint.y)) {
		return _Utils_Tuple3(0, 1, -line.firstPoint.y);
	} else {
		if (_Utils_eq(line.firstPoint.x, line.secondPoint.x)) {
			return _Utils_Tuple3(1, 0, -line.firstPoint.x);
		} else {
			var a = (line.secondPoint.y - line.firstPoint.y) / (line.secondPoint.x - line.firstPoint.x);
			var c = ((-a) * line.firstPoint.x) + line.firstPoint.y;
			return _Utils_Tuple3(a, -1, c);
		}
	}
};
var $elm$core$Basics$sin = _Basics_sin;
var $author$project$Geometry$reflect_light = F2(
	function (mirror, light) {
		var normalAngle = ($elm$core$Basics$pi / 2) + $author$project$Geometry$get_angle_from_line(mirror.body);
		var newLineAngle = (2 * (normalAngle - $author$project$Geometry$get_angle_from_line(light))) + $author$project$Geometry$get_angle_from_line(light);
		var newFirstPoint = A2($author$project$Geometry$Location, 0.5 * (mirror.body.firstPoint.x + mirror.body.secondPoint.x), (mirror.body.secondPoint.y + mirror.body.firstPoint.y) * 0.5);
		var newSecondPoint = A2(
			$author$project$Geometry$Location,
			newFirstPoint.x + (500 * $elm$core$Basics$cos(newLineAngle)),
			newFirstPoint.y + (500 * $elm$core$Basics$sin(newLineAngle)));
		var _v0 = $author$project$Geometry$get_coefficient(light);
		var a = _v0.a;
		var b = _v0.b;
		var c = _v0.c;
		var d1 = ((a * mirror.body.firstPoint.x) + (b * mirror.body.firstPoint.y)) + c;
		var d2 = ((a * mirror.body.secondPoint.x) + (b * mirror.body.secondPoint.y)) + c;
		return (((d1 * d2) < 0) && (!_Utils_eq(light.firstPoint, newFirstPoint))) ? A2($author$project$Geometry$Line, newFirstPoint, newSecondPoint) : light;
	});
var $author$project$Geometry$get_new_light_help = F2(
	function (lightSet, mirrorSet) {
		var shortenedLightSet = A2(
			$elm$core$List$take,
			$elm$core$List$length(lightSet) - 1,
			lightSet);
		var light_tail = A2(
			$elm$core$Maybe$withDefault,
			A2(
				$author$project$Geometry$Line,
				A2($author$project$Geometry$Location, 100, 100),
				A2($author$project$Geometry$Location, 0, 100)),
			$elm$core$List$head(
				$elm$core$List$reverse(lightSet)));
		var new_light = A3($elm$core$List$foldr, $author$project$Geometry$reflect_light, light_tail, mirrorSet);
		var new_lightset_before_append = A2(
			$elm$core$List$append,
			shortenedLightSet,
			$elm$core$List$singleton(
				A2($author$project$Geometry$Line, light_tail.firstPoint, new_light.firstPoint)));
		return A2($elm$core$List$member, new_light, lightSet) ? lightSet : A2(
			$elm$core$List$append,
			new_lightset_before_append,
			$elm$core$List$singleton(new_light));
	});
var $author$project$Geometry$refresh_lightSet = F2(
	function (lightSet, mirrorSet) {
		refresh_lightSet:
		while (true) {
			var len = $elm$core$List$length(lightSet);
			if (_Utils_eq(
				$elm$core$List$length(
					A2($author$project$Geometry$get_new_light_help, lightSet, mirrorSet)),
				len)) {
				return A2($author$project$Geometry$get_new_light_help, lightSet, mirrorSet);
			} else {
				var $temp$lightSet = A2($author$project$Geometry$get_new_light_help, lightSet, mirrorSet),
					$temp$mirrorSet = mirrorSet;
				lightSet = $temp$lightSet;
				mirrorSet = $temp$mirrorSet;
				continue refresh_lightSet;
			}
		}
	});
var $author$project$Geometry$distance = F2(
	function (pa, pb) {
		var by = pb.y;
		var bx = pb.x;
		var ay = pa.y;
		var ax = pa.x;
		return $elm$core$Basics$sqrt(
			A2($elm$core$Basics$pow, ax - bx, 2) + A2($elm$core$Basics$pow, ay - by, 2));
	});
var $author$project$Geometry$rotate_single_mirror = F2(
	function (index, mirror) {
		if (_Utils_eq(mirror.index, index)) {
			var halfLength = A2($author$project$Geometry$distance, mirror.body.secondPoint, mirror.body.firstPoint) * 0.5;
			var centerPoint = A2($author$project$Geometry$Location, 0.5 * (mirror.body.firstPoint.x + mirror.body.secondPoint.x), (mirror.body.secondPoint.y + mirror.body.firstPoint.y) * 0.5);
			var angle = $author$project$Geometry$get_angle_from_line(mirror.body);
			var x1 = centerPoint.x - (halfLength * $elm$core$Basics$cos(($elm$core$Basics$pi / 4) + angle));
			var x2 = centerPoint.x + (halfLength * $elm$core$Basics$cos(($elm$core$Basics$pi / 4) + angle));
			var y1 = centerPoint.y - (halfLength * $elm$core$Basics$sin(($elm$core$Basics$pi / 4) + angle));
			var y2 = centerPoint.y + (halfLength * $elm$core$Basics$sin(($elm$core$Basics$pi / 4) + angle));
			return _Utils_update(
				mirror,
				{
					body: A2(
						$author$project$Geometry$Line,
						A2($author$project$Geometry$Location, x1, y1),
						A2($author$project$Geometry$Location, x2, y2))
				});
		} else {
			return mirror;
		}
	});
var $author$project$Geometry$rotate_mirror = F2(
	function (mirrorSet, index) {
		return A2(
			$elm$core$List$map,
			$author$project$Geometry$rotate_single_mirror(index),
			mirrorSet);
	});
var $author$project$Update$update_light_mirror = F2(
	function (index, object) {
		if (object.$ === 'Mirror') {
			var a = object.a;
			var newMirrorSet = A2($author$project$Geometry$rotate_mirror, a.mirrorSet, index);
			var newLightSet = A2(
				$author$project$Geometry$refresh_lightSet,
				$elm$core$List$singleton(
					A2(
						$author$project$Geometry$Line,
						A2($author$project$Geometry$Location, 400, 350),
						A2($author$project$Geometry$Location, 0, 350))),
				newMirrorSet);
			return $author$project$Object$Mirror(
				_Utils_update(
					a,
					{lightSet: newLightSet, mirrorSet: newMirrorSet}));
		} else {
			return object;
		}
	});
var $author$project$Update$update_light_mirror_set = F2(
	function (index, objectSet) {
		return A2(
			$elm$core$List$map,
			$author$project$Update$update_light_mirror(index),
			objectSet);
	});
var $author$project$Update$updatetime = F2(
	function (number, clock) {
		switch (number) {
			case 0:
				return (clock.minute < 55) ? $author$project$Object$Clock(
					A2($author$project$Object$ClockModel, clock.hour, clock.minute + 5)) : $author$project$Object$Clock(
					A2($author$project$Object$ClockModel, clock.hour + 1, clock.minute - 55));
			case 1:
				return $author$project$Object$Clock(
					A2($author$project$Object$ClockModel, clock.hour + 1, clock.minute));
			default:
				return _Debug_todo(
					'Update',
					{
						start: {line: 710, column: 13},
						end: {line: 710, column: 23}
					})('branch \'_\' not implemented');
		}
	});
var $author$project$Update$updateclock = F2(
	function (model, number) {
		var toggle = function (clock) {
			if (clock.$ === 'Clock') {
				var clk = clock.a;
				return A2($author$project$Update$updatetime, number, clk);
			} else {
				return clock;
			}
		};
		return _Utils_update(
			model,
			{
				objects: A2($elm$core$List$map, toggle, model.objects)
			});
	});
var $author$project$Update$update_onclicktrigger = F2(
	function (model, number) {
		var _v0 = model.cscreen.cscene;
		switch (_v0) {
			case 1:
				return A2($author$project$Update$updateclock, model, number);
			case 3:
				return A2($author$project$Update$try_to_unlock_picture, model, number);
			case 4:
				return _Utils_update(
					model,
					{
						objects: A2($author$project$Update$update_light_mirror_set, number, model.objects)
					});
			case 5:
				return A2($author$project$Update$try_to_update_computer, model, number);
			case 6:
				return A2($author$project$Update$try_to_update_power, model, number);
			case 7:
				return _Utils_update(
					model,
					{
						objects: A3($author$project$Update$try_to_update_piano, number, model.move_timer, model.objects)
					});
			case 8:
				return A2($author$project$Update$update_bulb, model, number);
			case 0:
				var _v1 = model.cscreen.clevel;
				if (!_v1) {
					return A2($author$project$Update$charge_computer, model, number);
				} else {
					return model;
				}
			default:
				return model;
		}
	});
var $author$project$Update$update = F2(
	function (msg, model) {
		var up = _Utils_update(
			model,
			{
				volume: A2($elm$core$Basics$min, 1, model.volume + 0.05)
			});
		var down = _Utils_update(
			model,
			{
				volume: A2($elm$core$Basics$max, 0, model.volume - 0.05)
			});
		switch (msg.$) {
			case 'StartChange':
				var submsg = msg.a;
				return _Utils_Tuple2(
					A2($author$project$Update$update_gra_part, model, submsg),
					$elm$core$Platform$Cmd$none);
			case 'Resize':
				var width = msg.a;
				var height = msg.b;
				return _Utils_Tuple2(
					_Utils_update(
						model,
						{
							size: _Utils_Tuple2(width, height)
						}),
					$elm$core$Platform$Cmd$none);
			case 'GetViewport':
				var viewport = msg.a.viewport;
				return _Utils_Tuple2(
					_Utils_update(
						model,
						{
							size: _Utils_Tuple2(viewport.width, viewport.height)
						}),
					$elm$core$Platform$Cmd$none);
			case 'Reset':
				return _Utils_Tuple2(
					$author$project$Model$initial,
					A2($elm$core$Task$perform, $author$project$Messages$GetViewport, $elm$browser$Browser$Dom$getViewport));
			case 'DecideLegal':
				var location = msg.a;
				var cur = A2($author$project$Model$list_index_object, 1, model.objects);
				var mod = function () {
					if (cur.$ === 'Table') {
						var a = cur.a;
						return a;
					} else {
						return A3(
							$author$project$Ptable$TableModel,
							_List_Nil,
							A2($author$project$Geometry$Location, 0, 0),
							_Utils_Tuple2(0, 0));
					}
				}();
				var sta = A2(
					$elm$core$List$all,
					function (x) {
						return _Utils_eq(x.state, $author$project$Ptable$Active);
					},
					mod.blockSet);
				return (!sta) ? _Utils_Tuple2(
					function (x) {
						return A3($elm$core$List$foldr, $author$project$Update$test_table_win, x, x.objects);
					}(
						_Utils_update(
							model,
							{
								objects: A2(
									$elm$core$List$map,
									$author$project$Object$test_table(location),
									model.objects)
							})),
					$elm$core$Platform$Cmd$none) : _Utils_Tuple2(model, $elm$core$Platform$Cmd$none);
			case 'OnDragBy':
				var _v2 = msg.a;
				var dx = _v2.a;
				var dy = _v2.b;
				var _v3 = model.spcPosition;
				var x = _v3.a;
				var y = _v3.b;
				return _Utils_Tuple2(
					_Utils_update(
						model,
						{
							spcPosition: _Utils_Tuple2(x + dx, y + dy)
						}),
					$elm$core$Platform$Cmd$none);
			case 'DragMsg':
				var dragMsg = msg.a;
				return A3($zaboco$elm_draggable$Draggable$update, $author$project$Update$dragConfig, dragMsg, model);
			case 'OnClickTriggers':
				var number = msg.a;
				return _Utils_Tuple2(
					$author$project$Update$test_mirror_win(
						$author$project$Update$test_clock_win(
							A2($author$project$Update$update_onclicktrigger, model, number))),
					$elm$core$Platform$Cmd$none);
			case 'OnClickItem':
				var index = msg.a;
				var kind = msg.b;
				if (!kind) {
					return _Utils_Tuple2(
						$author$project$Update$check_pict_state(
							A2($author$project$Update$pickup_picture, index, model)),
						$elm$core$Platform$Cmd$none);
				} else {
					return _Utils_Tuple2(model, $elm$core$Platform$Cmd$none);
				}
			case 'Charge':
				var a = msg.a;
				return _Utils_Tuple2(
					$author$project$Update$charge_power(
						A2($author$project$Update$charge_computer, model, a)),
					$elm$core$Platform$Cmd$none);
			case 'Tick':
				var elapsed = msg.a;
				return _Utils_Tuple2(
					A2($author$project$Update$animate, model, elapsed),
					$elm$core$Platform$Cmd$none);
			case 'Increase':
				return _Utils_Tuple2(
					up,
					$author$project$Music$changeVolume(
						_Utils_Tuple2('bgm', up.volume)));
			case 'Decrease':
				return _Utils_Tuple2(
					down,
					$author$project$Music$changeVolume(
						_Utils_Tuple2('bgm', down.volume)));
			default:
				return _Utils_Tuple2(model, $elm$core$Platform$Cmd$none);
		}
	});
var $author$project$Messages$EnterState = {$: 'EnterState'};
var $author$project$Messages$StartChange = function (a) {
	return {$: 'StartChange', a: a};
};
var $elm$html$Html$audio = _VirtualDom_node('audio');
var $elm$json$Json$Encode$bool = _Json_wrap;
var $elm$html$Html$Attributes$boolProperty = F2(
	function (key, bool) {
		return A2(
			_VirtualDom_property,
			key,
			$elm$json$Json$Encode$bool(bool));
	});
var $elm$html$Html$Attributes$autoplay = $elm$html$Html$Attributes$boolProperty('autoplay');
var $elm$html$Html$button = _VirtualDom_node('button');
var $elm$html$Html$div = _VirtualDom_node('div');
var $elm$html$Html$embed = _VirtualDom_node('embed');
var $elm$core$String$fromFloat = _String_fromNumber;
var $elm$core$Basics$ge = _Utils_ge;
var $author$project$Gradient$get_Gcontent = function (gstate) {
	var pState = function () {
		if (gstate.$ === 'Normal') {
			return $author$project$Gradient$KeepSame;
		} else {
			var aa = gstate.a;
			var bb = gstate.b;
			var cc = gstate.c;
			return cc;
		}
	}();
	var gcontent = function () {
		switch (pState.$) {
			case 'KeepSame':
				return $author$project$Gradient$NoUse;
			case 'Disappear':
				var aa = pState.a;
				return aa;
			default:
				var aa = pState.a;
				return aa;
		}
	}();
	return gcontent;
};
var $elm$html$Html$Attributes$stringProperty = F2(
	function (key, string) {
		return A2(
			_VirtualDom_property,
			key,
			$elm$json$Json$Encode$string(string));
	});
var $elm$html$Html$Attributes$id = $elm$html$Html$Attributes$stringProperty('id');
var $elm$html$Html$img = _VirtualDom_node('img');
var $elm$virtual_dom$VirtualDom$Normal = function (a) {
	return {$: 'Normal', a: a};
};
var $elm$virtual_dom$VirtualDom$on = _VirtualDom_on;
var $elm$html$Html$Events$on = F2(
	function (event, decoder) {
		return A2(
			$elm$virtual_dom$VirtualDom$on,
			event,
			$elm$virtual_dom$VirtualDom$Normal(decoder));
	});
var $elm$html$Html$Events$onClick = function (msg) {
	return A2(
		$elm$html$Html$Events$on,
		'click',
		$elm$json$Json$Decode$succeed(msg));
};
var $elm$html$Html$Attributes$loop = $elm$html$Html$Attributes$boolProperty('loop');
var $elm$html$Html$Attributes$src = function (url) {
	return A2(
		$elm$html$Html$Attributes$stringProperty,
		'src',
		_VirtualDom_noJavaScriptOrHtmlUri(url));
};
var $elm$virtual_dom$VirtualDom$text = _VirtualDom_text;
var $elm$html$Html$text = $elm$virtual_dom$VirtualDom$text;
var $author$project$Ppiano$play_audio = function (index) {
	return A2(
		$elm$html$Html$audio,
		_List_fromArray(
			[
				$elm$html$Html$Attributes$src(
				'assets/piano/' + ($elm$core$String$fromInt(index) + '.ogg')),
				$elm$html$Html$Attributes$autoplay(true),
				$elm$html$Html$Attributes$loop(false)
			]),
		_List_fromArray(
			[
				$elm$html$Html$text('error')
			]));
};
var $author$project$View$play_piano_audio = F2(
	function (currentScene, objectSet) {
		var play_piano_audio_help = F2(
			function (cscene, object) {
				if (cscene === 7) {
					if (object.$ === 'Piano') {
						var a = object.a;
						return $author$project$Ppiano$play_audio(a.currentMusic);
					} else {
						return A2($elm$html$Html$div, _List_Nil, _List_Nil);
					}
				} else {
					return A2($elm$html$Html$div, _List_Nil, _List_Nil);
				}
			});
		return A2(
			$elm$core$List$map,
			play_piano_audio_help(currentScene),
			objectSet);
	});
var $author$project$Messages$ChangeScene = function (a) {
	return {$: 'ChangeScene', a: a};
};
var $elm$virtual_dom$VirtualDom$style = _VirtualDom_style;
var $elm$html$Html$Attributes$style = $elm$virtual_dom$VirtualDom$style;
var $author$project$Pclock$drawbackbutton = A2(
	$elm$html$Html$button,
	_List_fromArray(
		[
			A2($elm$html$Html$Attributes$style, 'position', 'absolute'),
			A2($elm$html$Html$Attributes$style, 'top', '75%'),
			A2($elm$html$Html$Attributes$style, 'left', '3%'),
			A2($elm$html$Html$Attributes$style, 'height', '5%'),
			A2($elm$html$Html$Attributes$style, 'width', '10%'),
			A2($elm$html$Html$Attributes$style, 'background', 'red'),
			$elm$html$Html$Events$onClick(
			$author$project$Messages$StartChange(
				$author$project$Messages$ChangeScene(0)))
		]),
	_List_Nil);
var $author$project$View$render_button_inside = F2(
	function (cs, objs) {
		return _List_fromArray(
			[$author$project$Pclock$drawbackbutton]);
	});
var $author$project$Messages$OnClickItem = F2(
	function (a, b) {
		return {$: 'OnClickItem', a: a, b: b};
	});
var $elm$html$Html$Attributes$type_ = $elm$html$Html$Attributes$stringProperty('type');
var $author$project$Document$draw_list = F2(
	function (id, lck) {
		if (!id) {
			return _Utils_eq(lck, $author$project$Memory$Locked) ? _List_fromArray(
				[
					A2(
					$elm$html$Html$embed,
					_List_fromArray(
						[
							$elm$html$Html$Attributes$type_('image/png'),
							$elm$html$Html$Attributes$src('assets/newspaper1.png'),
							A2($elm$html$Html$Attributes$style, 'top', '30%'),
							A2($elm$html$Html$Attributes$style, 'left', '10%'),
							A2($elm$html$Html$Attributes$style, 'width', '15%'),
							A2($elm$html$Html$Attributes$style, 'height', '20%'),
							A2($elm$html$Html$Attributes$style, 'position', 'absolute')
						]),
					_List_Nil)
				]) : _List_fromArray(
				[
					A2(
					$elm$html$Html$embed,
					_List_fromArray(
						[
							$elm$html$Html$Attributes$type_('image/svg+xml'),
							$elm$html$Html$Attributes$src('assets/newspaper1.svg'),
							A2($elm$html$Html$Attributes$style, 'top', '30%'),
							A2($elm$html$Html$Attributes$style, 'left', '10%'),
							A2($elm$html$Html$Attributes$style, 'width', '15%'),
							A2($elm$html$Html$Attributes$style, 'height', '20%'),
							A2($elm$html$Html$Attributes$style, 'position', 'absolute'),
							$elm$html$Html$Events$onClick(
							A2($author$project$Messages$OnClickItem, 0, 1))
						]),
					_List_Nil)
				]);
		} else {
			return _List_Nil;
		}
	});
var $author$project$Document$render_docu_list = F2(
	function (index, list) {
		var drawin = F2(
			function (id, docu) {
				return _Utils_eq(docu.belong, id) ? A2($author$project$Document$draw_list, docu.index, docu.lockState) : _List_Nil;
			});
		return $elm$core$List$concat(
			A2(
				$elm$core$List$map,
				drawin(index),
				list));
	});
var $author$project$Messages$Back = {$: 'Back'};
var $author$project$Button$Button = F7(
	function (lef, to, wid, hei, content, effect, display) {
		return {content: content, display: display, effect: effect, hei: hei, lef: lef, to: to, wid: wid};
	});
var $elm$core$Debug$toString = _Debug_toString;
var $author$project$Button$trans_button_sq = function (but) {
	return A2(
		$elm$html$Html$button,
		_List_fromArray(
			[
				A2(
				$elm$html$Html$Attributes$style,
				'top',
				$elm$core$Debug$toString(but.to) + '%'),
				A2(
				$elm$html$Html$Attributes$style,
				'left',
				$elm$core$Debug$toString(but.lef) + '%'),
				A2(
				$elm$html$Html$Attributes$style,
				'height',
				$elm$core$Debug$toString(but.hei) + '%'),
				A2(
				$elm$html$Html$Attributes$style,
				'width',
				$elm$core$Debug$toString(but.wid) + '%'),
				A2($elm$html$Html$Attributes$style, 'cursor', 'pointer'),
				A2($elm$html$Html$Attributes$style, 'border', '0'),
				A2($elm$html$Html$Attributes$style, 'outline', 'none'),
				A2($elm$html$Html$Attributes$style, 'padding', '0'),
				A2($elm$html$Html$Attributes$style, 'position', 'absolute'),
				A2($elm$html$Html$Attributes$style, 'background-color', 'Transparent'),
				$elm$html$Html$Events$onClick(but.effect)
			]),
		_List_Nil);
};
var $author$project$Document$render_document_detail = function (index) {
	if (!index) {
		return _List_fromArray(
			[
				A2(
				$elm$html$Html$embed,
				_List_fromArray(
					[
						$elm$html$Html$Attributes$type_('image/svg+xml'),
						$elm$html$Html$Attributes$src('assets/newspaper1.svg'),
						A2($elm$html$Html$Attributes$style, 'top', '10%'),
						A2($elm$html$Html$Attributes$style, 'left', '20%'),
						A2($elm$html$Html$Attributes$style, 'width', '60%'),
						A2($elm$html$Html$Attributes$style, 'height', '80%'),
						A2($elm$html$Html$Attributes$style, 'position', 'absolute')
					]),
				_List_Nil),
				$author$project$Button$trans_button_sq(
				A7(
					$author$project$Button$Button,
					20,
					10,
					60,
					80,
					'',
					$author$project$Messages$StartChange($author$project$Messages$Back),
					'block'))
			]);
	} else {
		return _List_Nil;
	}
};
var $author$project$Messages$OnClickDocu = function (a) {
	return {$: 'OnClickDocu', a: a};
};
var $author$project$Document$list_index_docu = F2(
	function (index, list) {
		list_index_docu:
		while (true) {
			if (_Utils_cmp(
				index,
				$elm$core$List$length(list)) > 0) {
				return A4($author$project$Document$Document, $author$project$Picture$Show, $author$project$Memory$Locked, 0, 0);
			} else {
				if (list.b) {
					var x = list.a;
					var xs = list.b;
					if (!index) {
						return x;
					} else {
						var $temp$index = index - 1,
							$temp$list = xs;
						index = $temp$index;
						list = $temp$list;
						continue list_index_docu;
					}
				} else {
					return A4($author$project$Document$Document, $author$project$Picture$Show, $author$project$Memory$Locked, 0, 0);
				}
			}
		}
	});
var $author$project$Document$render_newspaper_index = F2(
	function (index, list) {
		var tar = A2($author$project$Document$list_index_docu, index, list);
		if (_Utils_eq(tar.showState, $author$project$Picture$Show)) {
			var _v0 = tar.index;
			if (!_v0) {
				return A2(
					$elm$html$Html$embed,
					_List_fromArray(
						[
							$elm$html$Html$Attributes$type_('image/png'),
							$elm$html$Html$Attributes$src('assets/newspaper1.png'),
							A2($elm$html$Html$Attributes$style, 'top', '40%'),
							A2($elm$html$Html$Attributes$style, 'left', '70%'),
							A2($elm$html$Html$Attributes$style, 'width', '15%'),
							A2($elm$html$Html$Attributes$style, 'height', '20%'),
							A2($elm$html$Html$Attributes$style, 'position', 'absolute'),
							A2($elm$html$Html$Attributes$style, 'transform', 'rotate(-45deg)'),
							$elm$html$Html$Events$onClick(
							$author$project$Messages$StartChange(
								$author$project$Messages$OnClickDocu(0)))
						]),
					_List_Nil);
			} else {
				return A2($elm$html$Html$embed, _List_Nil, _List_Nil);
			}
		} else {
			return A2($elm$html$Html$embed, _List_Nil, _List_Nil);
		}
	});
var $author$project$View$render_documents = F2(
	function (docus, cs) {
		if (cs === 2) {
			return _List_fromArray(
				[
					A2($author$project$Document$render_newspaper_index, 0, docus)
				]);
		} else {
			return _List_Nil;
		}
	});
var $elm$html$Html$br = _VirtualDom_node('br');
var $author$project$Intro$intro_base = _List_fromArray(
	['My life stopped,', 'One year ago.', 'I lost my memory.', 'Now I have remembered lots of things,', 'Except Maria, my past lover.', 'I have heard about her from others many times,', 'But still can\'t remember her.', 'How is she?', 'Why we broke out?', 'Why she died?', 'This house, where we lived together, may give some help.', 'So, I come here, to find the lost memory for Maria.']);
var $author$project$Intro$list_index_intro = F2(
	function (list, index) {
		list_index_intro:
		while (true) {
			if (_Utils_cmp(
				index,
				$elm$core$List$length(list)) > 0) {
				return 'abab';
			} else {
				if (list.b) {
					var x = list.a;
					var xs = list.b;
					if (!index) {
						return x;
					} else {
						var $temp$list = xs,
							$temp$index = index - 1;
						list = $temp$list;
						index = $temp$index;
						continue list_index_intro;
					}
				} else {
					return 'abab';
				}
			}
		}
	});
var $author$project$Intro$text_attr = _List_fromArray(
	[
		A2($elm$html$Html$Attributes$style, 'top', '20%'),
		A2($elm$html$Html$Attributes$style, 'left', '25%'),
		A2($elm$html$Html$Attributes$style, 'width', '50%'),
		A2($elm$html$Html$Attributes$style, 'height', '40%'),
		A2($elm$html$Html$Attributes$style, 'text-align', 'center'),
		A2($elm$html$Html$Attributes$style, 'position', 'absolute')
	]);
var $author$project$Intro$render_intro = function (intro) {
	var lintro = $author$project$Intro$list_index_intro($author$project$Intro$intro_base);
	var _v0 = intro.sit;
	_v0$6:
	while (true) {
		switch (_v0.$) {
			case 'Transition':
				switch (_v0.a) {
					case 0:
						return _List_fromArray(
							[
								A2(
								$elm$html$Html$div,
								_Utils_ap(
									$author$project$Intro$text_attr,
									_List_fromArray(
										[
											A2(
											$elm$html$Html$Attributes$style,
											'opacity',
											$elm$core$Debug$toString(intro.tran_sec))
										])),
								_List_fromArray(
									[
										$elm$html$Html$text(
										lintro(0)),
										A2($elm$html$Html$br, _List_Nil, _List_Nil),
										$elm$html$Html$text(
										lintro(1)),
										A2($elm$html$Html$br, _List_Nil, _List_Nil),
										$elm$html$Html$text(
										lintro(2))
									]))
							]);
					case 1:
						return _List_fromArray(
							[
								A2(
								$elm$html$Html$div,
								_Utils_ap(
									$author$project$Intro$text_attr,
									_List_fromArray(
										[
											A2(
											$elm$html$Html$Attributes$style,
											'opacity',
											$elm$core$Debug$toString(intro.tran_sec))
										])),
								_List_fromArray(
									[
										$elm$html$Html$text(
										lintro(3)),
										A2($elm$html$Html$br, _List_Nil, _List_Nil),
										$elm$html$Html$text(
										lintro(4)),
										A2($elm$html$Html$br, _List_Nil, _List_Nil),
										$elm$html$Html$text(
										lintro(5)),
										A2($elm$html$Html$br, _List_Nil, _List_Nil),
										$elm$html$Html$text(
										lintro(6))
									]))
							]);
					default:
						break _v0$6;
				}
			case 'UnderGoing':
				switch (_v0.a) {
					case 0:
						return _List_fromArray(
							[
								A2(
								$elm$html$Html$div,
								$author$project$Intro$text_attr,
								_List_fromArray(
									[
										$elm$html$Html$text(
										lintro(0)),
										A2($elm$html$Html$br, _List_Nil, _List_Nil),
										$elm$html$Html$text(
										lintro(1)),
										A2($elm$html$Html$br, _List_Nil, _List_Nil),
										$elm$html$Html$text(
										lintro(2))
									]))
							]);
					case 1:
						return _List_fromArray(
							[
								A2(
								$elm$html$Html$div,
								$author$project$Intro$text_attr,
								_List_fromArray(
									[
										$elm$html$Html$text(
										lintro(3)),
										A2($elm$html$Html$br, _List_Nil, _List_Nil),
										$elm$html$Html$text(
										lintro(4)),
										A2($elm$html$Html$br, _List_Nil, _List_Nil),
										$elm$html$Html$text(
										lintro(5)),
										A2($elm$html$Html$br, _List_Nil, _List_Nil),
										$elm$html$Html$text(
										lintro(6))
									]))
							]);
					case 2:
						return _List_fromArray(
							[
								A2(
								$elm$html$Html$div,
								$author$project$Intro$text_attr,
								_List_fromArray(
									[
										$elm$html$Html$text(
										lintro(7)),
										A2($elm$html$Html$br, _List_Nil, _List_Nil),
										$elm$html$Html$text(
										lintro(8)),
										A2($elm$html$Html$br, _List_Nil, _List_Nil),
										$elm$html$Html$text(
										lintro(9)),
										A2($elm$html$Html$br, _List_Nil, _List_Nil),
										$elm$html$Html$text(
										lintro(10)),
										A2($elm$html$Html$br, _List_Nil, _List_Nil),
										$elm$html$Html$text(
										lintro(11))
									]))
							]);
					default:
						break _v0$6;
				}
			default:
				return _List_fromArray(
					[
						A2(
						$elm$html$Html$div,
						$author$project$Intro$text_attr,
						_List_fromArray(
							[
								$elm$html$Html$text(
								lintro(7)),
								A2($elm$html$Html$br, _List_Nil, _List_Nil),
								$elm$html$Html$text(
								lintro(8)),
								A2($elm$html$Html$br, _List_Nil, _List_Nil),
								$elm$html$Html$text(
								lintro(9)),
								A2($elm$html$Html$br, _List_Nil, _List_Nil),
								$elm$html$Html$text(
								lintro(10)),
								A2($elm$html$Html$br, _List_Nil, _List_Nil),
								$elm$html$Html$text(
								lintro(11)),
								A2($elm$html$Html$br, _List_Nil, _List_Nil),
								$elm$html$Html$text('Click Anywhere to Enter the game.')
							])),
						A2(
						$elm$html$Html$button,
						_List_fromArray(
							[
								A2($elm$html$Html$Attributes$style, 'top', '0'),
								A2($elm$html$Html$Attributes$style, 'left', '0'),
								A2($elm$html$Html$Attributes$style, 'width', '100%'),
								A2($elm$html$Html$Attributes$style, 'height', '100%'),
								A2($elm$html$Html$Attributes$style, 'cursor', 'pointer'),
								A2($elm$html$Html$Attributes$style, 'border', '0'),
								A2($elm$html$Html$Attributes$style, 'outline', 'none'),
								A2($elm$html$Html$Attributes$style, 'padding', '0'),
								A2($elm$html$Html$Attributes$style, 'position', 'absolute'),
								A2($elm$html$Html$Attributes$style, 'background-color', 'Transparent'),
								$elm$html$Html$Events$onClick(
								$author$project$Messages$StartChange($author$project$Messages$EnterState))
							]),
						_List_Nil)
					]);
		}
	}
	return _List_Nil;
};
var $author$project$Pclock$drawclockbutton = A2(
	$elm$html$Html$button,
	_List_fromArray(
		[
			A2($elm$html$Html$Attributes$style, 'position', 'absolute'),
			A2($elm$html$Html$Attributes$style, 'top', '7.78%'),
			A2($elm$html$Html$Attributes$style, 'left', '48.125%'),
			A2($elm$html$Html$Attributes$style, 'height', '60px'),
			A2($elm$html$Html$Attributes$style, 'width', '60px'),
			A2($elm$html$Html$Attributes$style, 'background', '#FFF'),
			A2($elm$html$Html$Attributes$style, 'border-radius', '50%'),
			A2($elm$html$Html$Attributes$style, 'opacity', '0.0'),
			$elm$html$Html$Events$onClick(
			$author$project$Messages$StartChange(
				$author$project$Messages$ChangeScene(1)))
		]),
	_List_Nil);
var $author$project$Button$test_button = function (but) {
	return A2(
		$elm$html$Html$button,
		_List_fromArray(
			[
				A2($elm$html$Html$Attributes$style, 'border', '0'),
				A2(
				$elm$html$Html$Attributes$style,
				'top',
				$elm$core$Debug$toString(but.to) + '%'),
				A2(
				$elm$html$Html$Attributes$style,
				'left',
				$elm$core$Debug$toString(but.lef) + '%'),
				A2(
				$elm$html$Html$Attributes$style,
				'height',
				$elm$core$Debug$toString(but.hei) + '%'),
				A2(
				$elm$html$Html$Attributes$style,
				'width',
				$elm$core$Debug$toString(but.wid) + '%'),
				A2($elm$html$Html$Attributes$style, 'cursor', 'pointer'),
				A2($elm$html$Html$Attributes$style, 'outline', 'none'),
				A2($elm$html$Html$Attributes$style, 'padding', '2'),
				A2($elm$html$Html$Attributes$style, 'position', 'absolute'),
				A2($elm$html$Html$Attributes$style, 'background-color', '#f3e4b0'),
				$elm$html$Html$Events$onClick(but.effect),
				A2($elm$html$Html$Attributes$style, 'font-size', '15px')
			]),
		_List_fromArray(
			[
				$elm$html$Html$text(but.content)
			]));
};
var $author$project$View$render_mirror_button = function () {
	var but = A7(
		$author$project$Button$Button,
		30,
		30,
		10,
		10,
		'',
		$author$project$Messages$StartChange(
			$author$project$Messages$ChangeScene(4)),
		'');
	return $elm$core$List$singleton(
		$author$project$Button$test_button(but));
}();
var $author$project$View$render_piano_button = function () {
	var but = A7(
		$author$project$Button$Button,
		10,
		10,
		10,
		10,
		'',
		$author$project$Messages$StartChange(
			$author$project$Messages$ChangeScene(7)),
		'');
	return $elm$core$List$singleton(
		$author$project$Button$test_button(but));
}();
var $author$project$Messages$ChangeLevel = function (a) {
	return {$: 'ChangeLevel', a: a};
};
var $author$project$Pstair$stair_button_level_0 = A7(
	$author$project$Button$Button,
	42,
	45.51,
	8,
	39.1,
	'',
	$author$project$Messages$StartChange(
		$author$project$Messages$ChangeLevel(1)),
	'block');
var $author$project$Pstair$stair_button_level_1l = A7(
	$author$project$Button$Button,
	42,
	45.51,
	8,
	39.1,
	'',
	$author$project$Messages$StartChange(
		$author$project$Messages$ChangeLevel(2)),
	'block');
var $author$project$Pstair$stair_button_level_1r = A7(
	$author$project$Button$Button,
	52,
	45.51,
	8,
	39.1,
	'',
	$author$project$Messages$StartChange(
		$author$project$Messages$ChangeLevel(0)),
	'block');
var $author$project$Pstair$stair_button_level_2 = A7(
	$author$project$Button$Button,
	52,
	45.51,
	8,
	39.1,
	'',
	$author$project$Messages$StartChange(
		$author$project$Messages$ChangeLevel(1)),
	'block');
var $author$project$Pstair$render_stair_level = function (cl) {
	switch (cl) {
		case 0:
			return _List_fromArray(
				[
					$author$project$Button$trans_button_sq($author$project$Pstair$stair_button_level_0)
				]);
		case 1:
			return _List_fromArray(
				[
					$author$project$Button$trans_button_sq($author$project$Pstair$stair_button_level_1l),
					$author$project$Button$trans_button_sq($author$project$Pstair$stair_button_level_1r)
				]);
		default:
			return _List_fromArray(
				[
					$author$project$Button$test_button($author$project$Pstair$stair_button_level_2)
				]);
	}
};
var $author$project$Ptable$render_table_button = function () {
	var enter = A7(
		$author$project$Button$Button,
		75,
		53.33,
		12.5,
		2.22,
		'',
		$author$project$Messages$StartChange(
			$author$project$Messages$ChangeScene(2)),
		'block');
	return $author$project$Button$test_button(enter);
}();
var $author$project$View$render_button_level = function (level) {
	switch (level) {
		case 0:
			return _Utils_ap(
				$author$project$Pstair$render_stair_level(level),
				$author$project$View$render_piano_button);
		case 1:
			return _Utils_ap(
				$author$project$Pstair$render_stair_level(level),
				_List_fromArray(
					[
						$author$project$Pclock$drawclockbutton,
						$author$project$Ptable$render_table_button,
						$author$project$Button$test_button(
						A7(
							$author$project$Button$Button,
							60,
							20,
							10,
							10,
							'',
							$author$project$Messages$StartChange(
								$author$project$Messages$ChangeScene(8)),
							'block'))
					]));
		case 2:
			return _Utils_ap(
				$author$project$Pstair$render_stair_level(level),
				$author$project$View$render_mirror_button);
		default:
			return $author$project$Pstair$render_stair_level(level);
	}
};
var $elm$svg$Svg$Attributes$height = _VirtualDom_attribute('height');
var $elm$svg$Svg$Attributes$fill = _VirtualDom_attribute('fill');
var $elm$svg$Svg$Attributes$points = _VirtualDom_attribute('points');
var $elm$svg$Svg$trustedNode = _VirtualDom_nodeNS('http://www.w3.org/2000/svg');
var $elm$svg$Svg$polygon = $elm$svg$Svg$trustedNode('polygon');
var $elm$svg$Svg$Attributes$stroke = _VirtualDom_attribute('stroke');
var $elm$svg$Svg$Attributes$strokeWidth = _VirtualDom_attribute('stroke-width');
var $author$project$Level0$drawCeiling = _List_fromArray(
	[
		A2(
		$elm$svg$Svg$polygon,
		_List_fromArray(
			[
				$elm$svg$Svg$Attributes$points('1000,0 975,0 975,750 1000,750'),
				$elm$svg$Svg$Attributes$fill('white'),
				$elm$svg$Svg$Attributes$stroke('black'),
				$elm$svg$Svg$Attributes$strokeWidth('1')
			]),
		_List_Nil),
		A2(
		$elm$svg$Svg$polygon,
		_List_fromArray(
			[
				$elm$svg$Svg$Attributes$points('975,350 975,375 675,375 675,350'),
				$elm$svg$Svg$Attributes$fill('white'),
				$elm$svg$Svg$Attributes$stroke('black'),
				$elm$svg$Svg$Attributes$strokeWidth('1')
			]),
		_List_Nil),
		A2(
		$elm$svg$Svg$polygon,
		_List_fromArray(
			[
				$elm$svg$Svg$Attributes$points('675,0 650,0 650,750 675,750'),
				$elm$svg$Svg$Attributes$fill('white'),
				$elm$svg$Svg$Attributes$stroke('black'),
				$elm$svg$Svg$Attributes$strokeWidth('1')
			]),
		_List_Nil),
		A2(
		$elm$svg$Svg$polygon,
		_List_fromArray(
			[
				$elm$svg$Svg$Attributes$points('815,375 835,375 835,750 815,750'),
				$elm$svg$Svg$Attributes$fill('white'),
				$elm$svg$Svg$Attributes$stroke('black'),
				$elm$svg$Svg$Attributes$strokeWidth('1')
			]),
		_List_Nil)
	]);
var $author$project$Level0$drawChair = _List_fromArray(
	[
		A2(
		$elm$svg$Svg$polygon,
		_List_fromArray(
			[
				$elm$svg$Svg$Attributes$points('1290,740 1280,750 1320,750 1310,740 1310,670 1290,670'),
				$elm$svg$Svg$Attributes$fill('white'),
				$elm$svg$Svg$Attributes$stroke('black'),
				$elm$svg$Svg$Attributes$strokeWidth('1')
			]),
		_List_Nil),
		A2(
		$elm$svg$Svg$polygon,
		_List_fromArray(
			[
				$elm$svg$Svg$Attributes$points('1250,670 1350,670 1350,650 1250,650'),
				$elm$svg$Svg$Attributes$fill('white'),
				$elm$svg$Svg$Attributes$stroke('black'),
				$elm$svg$Svg$Attributes$strokeWidth('1')
			]),
		_List_Nil),
		A2(
		$elm$svg$Svg$polygon,
		_List_fromArray(
			[
				$elm$svg$Svg$Attributes$points('1250,650 1350,650 1350,550 1250,550'),
				$elm$svg$Svg$Attributes$fill('white'),
				$elm$svg$Svg$Attributes$stroke('black'),
				$elm$svg$Svg$Attributes$strokeWidth('1')
			]),
		_List_Nil),
		A2(
		$elm$svg$Svg$polygon,
		_List_fromArray(
			[
				$elm$svg$Svg$Attributes$points('1270,550 1330,550 1330,530 1270,530'),
				$elm$svg$Svg$Attributes$fill('white'),
				$elm$svg$Svg$Attributes$stroke('black'),
				$elm$svg$Svg$Attributes$strokeWidth('1')
			]),
		_List_Nil),
		A2(
		$elm$svg$Svg$polygon,
		_List_fromArray(
			[
				$elm$svg$Svg$Attributes$points('1260,530 1340,530 1340,480 1260,480'),
				$elm$svg$Svg$Attributes$fill('white'),
				$elm$svg$Svg$Attributes$stroke('black'),
				$elm$svg$Svg$Attributes$strokeWidth('1')
			]),
		_List_Nil),
		A2(
		$elm$svg$Svg$polygon,
		_List_fromArray(
			[
				$elm$svg$Svg$Attributes$points('1250,670 1240,670 1240,600 1250,600'),
				$elm$svg$Svg$Attributes$fill('white'),
				$elm$svg$Svg$Attributes$stroke('black'),
				$elm$svg$Svg$Attributes$strokeWidth('1')
			]),
		_List_Nil),
		A2(
		$elm$svg$Svg$polygon,
		_List_fromArray(
			[
				$elm$svg$Svg$Attributes$points('1360,670 1350,670 1350,600 1360,600'),
				$elm$svg$Svg$Attributes$fill('white'),
				$elm$svg$Svg$Attributes$stroke('black'),
				$elm$svg$Svg$Attributes$strokeWidth('1')
			]),
		_List_Nil)
	]);
var $author$project$Level0$drawDesk = _List_fromArray(
	[
		A2(
		$elm$svg$Svg$polygon,
		_List_fromArray(
			[
				$elm$svg$Svg$Attributes$points('1100,600 1500,600 1500,585 1100,585'),
				$elm$svg$Svg$Attributes$fill('white'),
				$elm$svg$Svg$Attributes$stroke('black'),
				$elm$svg$Svg$Attributes$strokeWidth('1')
			]),
		_List_Nil),
		A2(
		$elm$svg$Svg$polygon,
		_List_fromArray(
			[
				$elm$svg$Svg$Attributes$points('1125,600 1140,600 1140,750 1125,750'),
				$elm$svg$Svg$Attributes$fill('white'),
				$elm$svg$Svg$Attributes$stroke('black'),
				$elm$svg$Svg$Attributes$strokeWidth('1')
			]),
		_List_Nil),
		A2(
		$elm$svg$Svg$polygon,
		_List_fromArray(
			[
				$elm$svg$Svg$Attributes$points('1460,600 1475,600 1475,750 1460,750'),
				$elm$svg$Svg$Attributes$fill('white'),
				$elm$svg$Svg$Attributes$stroke('black'),
				$elm$svg$Svg$Attributes$strokeWidth('1')
			]),
		_List_Nil)
	]);
var $elm$svg$Svg$circle = $elm$svg$Svg$trustedNode('circle');
var $elm$svg$Svg$Attributes$cx = _VirtualDom_attribute('cx');
var $elm$svg$Svg$Attributes$cy = _VirtualDom_attribute('cy');
var $elm$svg$Svg$Attributes$r = _VirtualDom_attribute('r');
var $author$project$Level0$drawDoor = _List_fromArray(
	[
		A2(
		$elm$svg$Svg$polygon,
		_List_fromArray(
			[
				$elm$svg$Svg$Attributes$points('975,375 835,375 835,750 975,750'),
				$elm$svg$Svg$Attributes$fill('white'),
				$elm$svg$Svg$Attributes$stroke('black'),
				$elm$svg$Svg$Attributes$strokeWidth('1')
			]),
		_List_Nil),
		A2(
		$elm$svg$Svg$circle,
		_List_fromArray(
			[
				$elm$svg$Svg$Attributes$cx('950'),
				$elm$svg$Svg$Attributes$cy('550'),
				$elm$svg$Svg$Attributes$r('10'),
				$elm$svg$Svg$Attributes$stroke('black'),
				$elm$svg$Svg$Attributes$strokeWidth('1'),
				$elm$svg$Svg$Attributes$fill('white')
			]),
		_List_Nil)
	]);
var $elm$svg$Svg$line = $elm$svg$Svg$trustedNode('line');
var $elm$svg$Svg$Attributes$x1 = _VirtualDom_attribute('x1');
var $elm$svg$Svg$Attributes$x2 = _VirtualDom_attribute('x2');
var $elm$svg$Svg$Attributes$y1 = _VirtualDom_attribute('y1');
var $elm$svg$Svg$Attributes$y2 = _VirtualDom_attribute('y2');
var $author$project$Level0$drawFloor = _List_fromArray(
	[
		A2(
		$elm$svg$Svg$line,
		_List_fromArray(
			[
				$elm$svg$Svg$Attributes$x1('0'),
				$elm$svg$Svg$Attributes$y1('750'),
				$elm$svg$Svg$Attributes$x2('1600'),
				$elm$svg$Svg$Attributes$y2('750'),
				$elm$svg$Svg$Attributes$stroke('black'),
				$elm$svg$Svg$Attributes$strokeWidth('1')
			]),
		_List_Nil)
	]);
var $author$project$Level0$drawLeftBox = _List_fromArray(
	[
		A2(
		$elm$svg$Svg$polygon,
		_List_fromArray(
			[
				$elm$svg$Svg$Attributes$points('1060,320 1190,320 1190,220 1060,220'),
				$elm$svg$Svg$Attributes$fill('white'),
				$elm$svg$Svg$Attributes$stroke('black'),
				$elm$svg$Svg$Attributes$strokeWidth('1')
			]),
		_List_Nil),
		A2(
		$elm$svg$Svg$polygon,
		_List_fromArray(
			[
				$elm$svg$Svg$Attributes$points('1140,310 1180,310 1180,285 1140,285'),
				$elm$svg$Svg$Attributes$fill('white'),
				$elm$svg$Svg$Attributes$stroke('black'),
				$elm$svg$Svg$Attributes$strokeWidth('1')
			]),
		_List_Nil)
	]);
var $author$project$Level0$drawMonitor = _List_fromArray(
	[
		A2(
		$elm$svg$Svg$polygon,
		_List_fromArray(
			[
				$elm$svg$Svg$Attributes$points('1310,585 1390,585 1390,575 1310,575'),
				$elm$svg$Svg$Attributes$fill('white'),
				$elm$svg$Svg$Attributes$stroke('black'),
				$elm$svg$Svg$Attributes$strokeWidth('1')
			]),
		_List_Nil),
		A2(
		$elm$svg$Svg$polygon,
		_List_fromArray(
			[
				$elm$svg$Svg$Attributes$points('1270,560 1430,560 1430,470 1270,470'),
				$elm$svg$Svg$Attributes$fill('white'),
				$elm$svg$Svg$Attributes$stroke('black'),
				$elm$svg$Svg$Attributes$strokeWidth('1')
			]),
		_List_Nil),
		A2(
		$elm$svg$Svg$polygon,
		_List_fromArray(
			[
				$elm$svg$Svg$Attributes$points('1330,575 1370,575 1370,520 1330,520'),
				$elm$svg$Svg$Attributes$fill('white'),
				$elm$svg$Svg$Attributes$stroke('black'),
				$elm$svg$Svg$Attributes$strokeWidth('1')
			]),
		_List_Nil)
	]);
var $author$project$Level0$drawPainting = _List_fromArray(
	[
		A2(
		$elm$svg$Svg$polygon,
		_List_fromArray(
			[
				$elm$svg$Svg$Attributes$points('75,325 575,325 575,50 75,50'),
				$elm$svg$Svg$Attributes$fill('white'),
				$elm$svg$Svg$Attributes$stroke('black'),
				$elm$svg$Svg$Attributes$strokeWidth('1')
			]),
		_List_Nil)
	]);
var $author$project$Level0$drawPiano = _List_fromArray(
	[
		A2(
		$elm$svg$Svg$polygon,
		_List_fromArray(
			[
				$elm$svg$Svg$Attributes$points('580,750 600,750 600,730 580,730'),
				$elm$svg$Svg$Attributes$fill('white'),
				$elm$svg$Svg$Attributes$stroke('black'),
				$elm$svg$Svg$Attributes$strokeWidth('1')
			]),
		_List_Nil),
		A2(
		$elm$svg$Svg$polygon,
		_List_fromArray(
			[
				$elm$svg$Svg$Attributes$points('580,730 595,730 595,630 580,630'),
				$elm$svg$Svg$Attributes$fill('white'),
				$elm$svg$Svg$Attributes$stroke('black'),
				$elm$svg$Svg$Attributes$strokeWidth('1')
			]),
		_List_Nil),
		A2(
		$elm$svg$Svg$polygon,
		_List_fromArray(
			[
				$elm$svg$Svg$Attributes$points('580,750 500,750 500,740 580,740'),
				$elm$svg$Svg$Attributes$fill('white'),
				$elm$svg$Svg$Attributes$stroke('black'),
				$elm$svg$Svg$Attributes$strokeWidth('1')
			]),
		_List_Nil),
		A2(
		$elm$svg$Svg$polygon,
		_List_fromArray(
			[
				$elm$svg$Svg$Attributes$points('500,750 485,750 485,670 500,670'),
				$elm$svg$Svg$Attributes$fill('white'),
				$elm$svg$Svg$Attributes$stroke('black'),
				$elm$svg$Svg$Attributes$strokeWidth('1')
			]),
		_List_Nil),
		A2(
		$elm$svg$Svg$polygon,
		_List_fromArray(
			[
				$elm$svg$Svg$Attributes$points('485,750 365,750 365,740 485,740'),
				$elm$svg$Svg$Attributes$fill('white'),
				$elm$svg$Svg$Attributes$stroke('black'),
				$elm$svg$Svg$Attributes$strokeWidth('1')
			]),
		_List_Nil),
		A2(
		$elm$svg$Svg$polygon,
		_List_fromArray(
			[
				$elm$svg$Svg$Attributes$points('365,750 350,750 350,670 365,670'),
				$elm$svg$Svg$Attributes$fill('white'),
				$elm$svg$Svg$Attributes$stroke('black'),
				$elm$svg$Svg$Attributes$strokeWidth('1')
			]),
		_List_Nil),
		A2(
		$elm$svg$Svg$polygon,
		_List_fromArray(
			[
				$elm$svg$Svg$Attributes$points('342.5,670 507.5,670 507.5,655 342.5,655'),
				$elm$svg$Svg$Attributes$fill('white'),
				$elm$svg$Svg$Attributes$stroke('black'),
				$elm$svg$Svg$Attributes$strokeWidth('1')
			]),
		_List_Nil),
		A2(
		$elm$svg$Svg$polygon,
		_List_fromArray(
			[
				$elm$svg$Svg$Attributes$points('365,670 485,670 485,690 365,690'),
				$elm$svg$Svg$Attributes$fill('white'),
				$elm$svg$Svg$Attributes$stroke('black'),
				$elm$svg$Svg$Attributes$strokeWidth('1')
			]),
		_List_Nil),
		A2(
		$elm$svg$Svg$polygon,
		_List_fromArray(
			[
				$elm$svg$Svg$Attributes$points('350,750 270,750 270,740 350,740'),
				$elm$svg$Svg$Attributes$fill('white'),
				$elm$svg$Svg$Attributes$stroke('black'),
				$elm$svg$Svg$Attributes$strokeWidth('1')
			]),
		_List_Nil),
		A2(
		$elm$svg$Svg$polygon,
		_List_fromArray(
			[
				$elm$svg$Svg$Attributes$points('270,750 250,750 250,730 270,730'),
				$elm$svg$Svg$Attributes$fill('white'),
				$elm$svg$Svg$Attributes$stroke('black'),
				$elm$svg$Svg$Attributes$strokeWidth('1')
			]),
		_List_Nil),
		A2(
		$elm$svg$Svg$polygon,
		_List_fromArray(
			[
				$elm$svg$Svg$Attributes$points('270,730 255,730 255,630 270,630'),
				$elm$svg$Svg$Attributes$fill('white'),
				$elm$svg$Svg$Attributes$stroke('black'),
				$elm$svg$Svg$Attributes$strokeWidth('1')
			]),
		_List_Nil),
		A2(
		$elm$svg$Svg$polygon,
		_List_fromArray(
			[
				$elm$svg$Svg$Attributes$points('595,630 255,630 255,620 595,620'),
				$elm$svg$Svg$Attributes$fill('white'),
				$elm$svg$Svg$Attributes$stroke('black'),
				$elm$svg$Svg$Attributes$strokeWidth('1')
			]),
		_List_Nil),
		A2(
		$elm$svg$Svg$polygon,
		_List_fromArray(
			[
				$elm$svg$Svg$Attributes$points('595,620 255,620 255,605 595,605'),
				$elm$svg$Svg$Attributes$fill('white'),
				$elm$svg$Svg$Attributes$stroke('black'),
				$elm$svg$Svg$Attributes$strokeWidth('1')
			]),
		_List_Nil),
		A2(
		$elm$svg$Svg$polygon,
		_List_fromArray(
			[
				$elm$svg$Svg$Attributes$points('595,605 255,605 255,595 595,595'),
				$elm$svg$Svg$Attributes$fill('white'),
				$elm$svg$Svg$Attributes$stroke('black'),
				$elm$svg$Svg$Attributes$strokeWidth('1')
			]),
		_List_Nil),
		A2(
		$elm$svg$Svg$polygon,
		_List_fromArray(
			[
				$elm$svg$Svg$Attributes$points('595,595 255,595 255,445 595,445'),
				$elm$svg$Svg$Attributes$fill('white'),
				$elm$svg$Svg$Attributes$stroke('black'),
				$elm$svg$Svg$Attributes$strokeWidth('1')
			]),
		_List_Nil),
		A2(
		$elm$svg$Svg$polygon,
		_List_fromArray(
			[
				$elm$svg$Svg$Attributes$points('602.5,635 587.5,635 587.5,575 602.5,575'),
				$elm$svg$Svg$Attributes$fill('white'),
				$elm$svg$Svg$Attributes$stroke('black'),
				$elm$svg$Svg$Attributes$strokeWidth('1')
			]),
		_List_Nil),
		A2(
		$elm$svg$Svg$polygon,
		_List_fromArray(
			[
				$elm$svg$Svg$Attributes$points('247.5,635 262.5,635 262.5,575 247.5,575'),
				$elm$svg$Svg$Attributes$fill('white'),
				$elm$svg$Svg$Attributes$stroke('black'),
				$elm$svg$Svg$Attributes$strokeWidth('1')
			]),
		_List_Nil),
		A2(
		$elm$svg$Svg$polygon,
		_List_fromArray(
			[
				$elm$svg$Svg$Attributes$points('587.5,595 262.5,595 262.5,545 587.5,545'),
				$elm$svg$Svg$Attributes$fill('white'),
				$elm$svg$Svg$Attributes$stroke('black'),
				$elm$svg$Svg$Attributes$strokeWidth('1')
			]),
		_List_Nil),
		A2(
		$elm$svg$Svg$polygon,
		_List_fromArray(
			[
				$elm$svg$Svg$Attributes$points('587.5,545 262.5,545 262.5,530 587.5,530'),
				$elm$svg$Svg$Attributes$fill('white'),
				$elm$svg$Svg$Attributes$stroke('black'),
				$elm$svg$Svg$Attributes$strokeWidth('1')
			]),
		_List_Nil),
		A2(
		$elm$svg$Svg$polygon,
		_List_fromArray(
			[
				$elm$svg$Svg$Attributes$points('602.5,445 247.5,445 247.5,435 602.5,435'),
				$elm$svg$Svg$Attributes$fill('blue'),
				$elm$svg$Svg$Attributes$stroke('black'),
				$elm$svg$Svg$Attributes$strokeWidth('1')
			]),
		_List_Nil),
		A2(
		$elm$svg$Svg$polygon,
		_List_fromArray(
			[
				$elm$svg$Svg$Attributes$points('487.5,575 362.5,575 362.5,565 487.5,565'),
				$elm$svg$Svg$Attributes$fill('white'),
				$elm$svg$Svg$Attributes$stroke('black'),
				$elm$svg$Svg$Attributes$strokeWidth('1')
			]),
		_List_Nil)
	]);
var $author$project$Level0$drawRack = _List_fromArray(
	[
		A2(
		$elm$svg$Svg$polygon,
		_List_fromArray(
			[
				$elm$svg$Svg$Attributes$points('1050,750 1400,750 1400,350 1050,350'),
				$elm$svg$Svg$Attributes$fill('white'),
				$elm$svg$Svg$Attributes$stroke('black'),
				$elm$svg$Svg$Attributes$strokeWidth('1')
			]),
		_List_Nil),
		A2(
		$elm$svg$Svg$polygon,
		_List_fromArray(
			[
				$elm$svg$Svg$Attributes$points('1065,445 1385,445 1385,365 1065,365'),
				$elm$svg$Svg$Attributes$fill('white'),
				$elm$svg$Svg$Attributes$stroke('black'),
				$elm$svg$Svg$Attributes$strokeWidth('1')
			]),
		_List_Nil),
		A2(
		$elm$svg$Svg$polygon,
		_List_fromArray(
			[
				$elm$svg$Svg$Attributes$points('1065,460 1215,460 1215,570 1065,570'),
				$elm$svg$Svg$Attributes$fill('white'),
				$elm$svg$Svg$Attributes$stroke('black'),
				$elm$svg$Svg$Attributes$strokeWidth('1')
			]),
		_List_Nil),
		A2(
		$elm$svg$Svg$polygon,
		_List_fromArray(
			[
				$elm$svg$Svg$Attributes$points('1042.5,350 1407.5,350 1407.5,320 1042.5,320'),
				$elm$svg$Svg$Attributes$fill('white'),
				$elm$svg$Svg$Attributes$stroke('black'),
				$elm$svg$Svg$Attributes$strokeWidth('1')
			]),
		_List_Nil),
		A2(
		$elm$svg$Svg$polygon,
		_List_fromArray(
			[
				$elm$svg$Svg$Attributes$points('1400,750 1550,750 1550,500 1400,500'),
				$elm$svg$Svg$Attributes$fill('white'),
				$elm$svg$Svg$Attributes$stroke('black'),
				$elm$svg$Svg$Attributes$strokeWidth('1')
			]),
		_List_Nil)
	]);
var $author$project$Level0$drawRightBox = _List_fromArray(
	[
		A2(
		$elm$svg$Svg$polygon,
		_List_fromArray(
			[
				$elm$svg$Svg$Attributes$points('1240,320 1370,320 1370,220 1240,220'),
				$elm$svg$Svg$Attributes$fill('white'),
				$elm$svg$Svg$Attributes$stroke('black'),
				$elm$svg$Svg$Attributes$strokeWidth('1')
			]),
		_List_Nil),
		A2(
		$elm$svg$Svg$polygon,
		_List_fromArray(
			[
				$elm$svg$Svg$Attributes$points('1232.5,220 1377.5,220 1377.5,205 1232.5,205'),
				$elm$svg$Svg$Attributes$fill('white'),
				$elm$svg$Svg$Attributes$stroke('black'),
				$elm$svg$Svg$Attributes$strokeWidth('1')
			]),
		_List_Nil)
	]);
var $author$project$Level0$drawStair = _List_fromArray(
	[
		A2(
		$elm$svg$Svg$polygon,
		_List_fromArray(
			[
				$elm$svg$Svg$Attributes$points('675,725 815,725 815,750 675,750'),
				$elm$svg$Svg$Attributes$fill('white'),
				$elm$svg$Svg$Attributes$stroke('black'),
				$elm$svg$Svg$Attributes$strokeWidth('1')
			]),
		_List_Nil),
		A2(
		$elm$svg$Svg$polygon,
		_List_fromArray(
			[
				$elm$svg$Svg$Attributes$points('675,700 815,700 815,725 675,725'),
				$elm$svg$Svg$Attributes$fill('white'),
				$elm$svg$Svg$Attributes$stroke('black'),
				$elm$svg$Svg$Attributes$strokeWidth('1')
			]),
		_List_Nil),
		A2(
		$elm$svg$Svg$polygon,
		_List_fromArray(
			[
				$elm$svg$Svg$Attributes$points('675,675 815,675 815,700 675,700'),
				$elm$svg$Svg$Attributes$fill('white'),
				$elm$svg$Svg$Attributes$stroke('black'),
				$elm$svg$Svg$Attributes$strokeWidth('1')
			]),
		_List_Nil),
		A2(
		$elm$svg$Svg$polygon,
		_List_fromArray(
			[
				$elm$svg$Svg$Attributes$points('675,650 815,650 815,675 675,675'),
				$elm$svg$Svg$Attributes$fill('white'),
				$elm$svg$Svg$Attributes$stroke('black'),
				$elm$svg$Svg$Attributes$strokeWidth('1')
			]),
		_List_Nil),
		A2(
		$elm$svg$Svg$polygon,
		_List_fromArray(
			[
				$elm$svg$Svg$Attributes$points('675,625 815,625 815,650 675,650'),
				$elm$svg$Svg$Attributes$fill('white'),
				$elm$svg$Svg$Attributes$stroke('black'),
				$elm$svg$Svg$Attributes$strokeWidth('1')
			]),
		_List_Nil),
		A2(
		$elm$svg$Svg$polygon,
		_List_fromArray(
			[
				$elm$svg$Svg$Attributes$points('675,600 815,600 815,625 675,625'),
				$elm$svg$Svg$Attributes$fill('white'),
				$elm$svg$Svg$Attributes$stroke('black'),
				$elm$svg$Svg$Attributes$strokeWidth('1')
			]),
		_List_Nil),
		A2(
		$elm$svg$Svg$polygon,
		_List_fromArray(
			[
				$elm$svg$Svg$Attributes$points('675,575 815,575 815,600 675,600'),
				$elm$svg$Svg$Attributes$fill('white'),
				$elm$svg$Svg$Attributes$stroke('black'),
				$elm$svg$Svg$Attributes$strokeWidth('1')
			]),
		_List_Nil),
		A2(
		$elm$svg$Svg$polygon,
		_List_fromArray(
			[
				$elm$svg$Svg$Attributes$points('675,550 815,550 815,575 675,575'),
				$elm$svg$Svg$Attributes$fill('white'),
				$elm$svg$Svg$Attributes$stroke('black'),
				$elm$svg$Svg$Attributes$strokeWidth('1')
			]),
		_List_Nil),
		A2(
		$elm$svg$Svg$polygon,
		_List_fromArray(
			[
				$elm$svg$Svg$Attributes$points('675,525 815,525 815,550 675,550'),
				$elm$svg$Svg$Attributes$fill('white'),
				$elm$svg$Svg$Attributes$stroke('black'),
				$elm$svg$Svg$Attributes$strokeWidth('1')
			]),
		_List_Nil),
		A2(
		$elm$svg$Svg$polygon,
		_List_fromArray(
			[
				$elm$svg$Svg$Attributes$points('675,375 815,375 815,525 675,525'),
				$elm$svg$Svg$Attributes$fill('white'),
				$elm$svg$Svg$Attributes$stroke('black'),
				$elm$svg$Svg$Attributes$strokeWidth('1')
			]),
		_List_Nil)
	]);
var $author$project$Level0$drawTelephone = _List_fromArray(
	[
		A2(
		$elm$svg$Svg$polygon,
		_List_fromArray(
			[
				$elm$svg$Svg$Attributes$points('1435,500 1515,500 1515,470 1435,470'),
				$elm$svg$Svg$Attributes$fill('white'),
				$elm$svg$Svg$Attributes$stroke('black'),
				$elm$svg$Svg$Attributes$strokeWidth('1')
			]),
		_List_Nil),
		A2(
		$elm$svg$Svg$circle,
		_List_fromArray(
			[
				$elm$svg$Svg$Attributes$cx('1475'),
				$elm$svg$Svg$Attributes$cy('485'),
				$elm$svg$Svg$Attributes$r('10'),
				$elm$svg$Svg$Attributes$stroke('black'),
				$elm$svg$Svg$Attributes$strokeWidth('1'),
				$elm$svg$Svg$Attributes$fill('white')
			]),
		_List_Nil),
		A2(
		$elm$svg$Svg$polygon,
		_List_fromArray(
			[
				$elm$svg$Svg$Attributes$points('1460,470 1490,470 1490,465 1460,465'),
				$elm$svg$Svg$Attributes$fill('white'),
				$elm$svg$Svg$Attributes$stroke('black'),
				$elm$svg$Svg$Attributes$strokeWidth('1')
			]),
		_List_Nil),
		A2(
		$elm$svg$Svg$polygon,
		_List_fromArray(
			[
				$elm$svg$Svg$Attributes$points('1440,437.5 1510,437.5 1510,422.5 1440,422.5'),
				$elm$svg$Svg$Attributes$fill('white'),
				$elm$svg$Svg$Attributes$stroke('black'),
				$elm$svg$Svg$Attributes$strokeWidth('1')
			]),
		_List_Nil),
		A2(
		$elm$svg$Svg$polygon,
		_List_fromArray(
			[
				$elm$svg$Svg$Attributes$points('1470,465 1470,455 1455,455 1455,430 1460,430 1460,450 1490,450 1490,430 1495,430 1495,455 1480,455 1480,465'),
				$elm$svg$Svg$Attributes$fill('white'),
				$elm$svg$Svg$Attributes$stroke('black'),
				$elm$svg$Svg$Attributes$strokeWidth('1')
			]),
		_List_Nil),
		A2(
		$elm$svg$Svg$polygon,
		_List_fromArray(
			[
				$elm$svg$Svg$Attributes$points('1440,427.5 1425,427.5 1425,440 1430,440 1430,432.5 1440,432.5'),
				$elm$svg$Svg$Attributes$fill('white'),
				$elm$svg$Svg$Attributes$stroke('black'),
				$elm$svg$Svg$Attributes$strokeWidth('1')
			]),
		_List_Nil),
		A2(
		$elm$svg$Svg$polygon,
		_List_fromArray(
			[
				$elm$svg$Svg$Attributes$points('1415,440 1440,440 1440,450 1415,450'),
				$elm$svg$Svg$Attributes$fill('white'),
				$elm$svg$Svg$Attributes$stroke('black'),
				$elm$svg$Svg$Attributes$strokeWidth('1')
			]),
		_List_Nil),
		A2(
		$elm$svg$Svg$polygon,
		_List_fromArray(
			[
				$elm$svg$Svg$Attributes$points('1510,427.5 1525,427.5 1525,440 1520,440 1520,432.5 1510,432.5'),
				$elm$svg$Svg$Attributes$fill('white'),
				$elm$svg$Svg$Attributes$stroke('black'),
				$elm$svg$Svg$Attributes$strokeWidth('1')
			]),
		_List_Nil),
		A2(
		$elm$svg$Svg$polygon,
		_List_fromArray(
			[
				$elm$svg$Svg$Attributes$points('1510,440 1535,440 1535,450 1510,450'),
				$elm$svg$Svg$Attributes$fill('white'),
				$elm$svg$Svg$Attributes$stroke('black'),
				$elm$svg$Svg$Attributes$strokeWidth('1')
			]),
		_List_Nil)
	]);
var $author$project$Level0$drawWardrobe = _List_fromArray(
	[
		A2(
		$elm$svg$Svg$polygon,
		_List_fromArray(
			[
				$elm$svg$Svg$Attributes$points('205,750 55,750 55,730 205,730'),
				$elm$svg$Svg$Attributes$fill('white'),
				$elm$svg$Svg$Attributes$stroke('black'),
				$elm$svg$Svg$Attributes$strokeWidth('1')
			]),
		_List_Nil),
		A2(
		$elm$svg$Svg$polygon,
		_List_fromArray(
			[
				$elm$svg$Svg$Attributes$points('197.5,730 62.5,730 62.5,445 197.5,445'),
				$elm$svg$Svg$Attributes$fill('white'),
				$elm$svg$Svg$Attributes$stroke('black'),
				$elm$svg$Svg$Attributes$strokeWidth('1')
			]),
		_List_Nil),
		A2(
		$elm$svg$Svg$polygon,
		_List_fromArray(
			[
				$elm$svg$Svg$Attributes$points('205,445 55,445 55,425 205,425'),
				$elm$svg$Svg$Attributes$fill('white'),
				$elm$svg$Svg$Attributes$stroke('black'),
				$elm$svg$Svg$Attributes$strokeWidth('1')
			]),
		_List_Nil),
		A2(
		$elm$svg$Svg$polygon,
		_List_fromArray(
			[
				$elm$svg$Svg$Attributes$points('190,730 70,730 70,610 190,660'),
				$elm$svg$Svg$Attributes$fill('white'),
				$elm$svg$Svg$Attributes$stroke('black'),
				$elm$svg$Svg$Attributes$strokeWidth('1')
			]),
		_List_Nil),
		A2(
		$elm$svg$Svg$polygon,
		_List_fromArray(
			[
				$elm$svg$Svg$Attributes$points('190,650 70,600 70,580 190,520'),
				$elm$svg$Svg$Attributes$fill('white'),
				$elm$svg$Svg$Attributes$stroke('black'),
				$elm$svg$Svg$Attributes$strokeWidth('1')
			]),
		_List_Nil),
		A2(
		$elm$svg$Svg$polygon,
		_List_fromArray(
			[
				$elm$svg$Svg$Attributes$points('190,510 70,570 70,452.5 190,452.5'),
				$elm$svg$Svg$Attributes$fill('white'),
				$elm$svg$Svg$Attributes$stroke('black'),
				$elm$svg$Svg$Attributes$strokeWidth('1')
			]),
		_List_Nil)
	]);
var $author$project$Level0$level_0_furniture = _Utils_ap(
	$author$project$Level0$drawFloor,
	_Utils_ap(
		$author$project$Level0$drawCeiling,
		_Utils_ap(
			$author$project$Level0$drawStair,
			_Utils_ap(
				$author$project$Level0$drawDoor,
				_Utils_ap(
					$author$project$Level0$drawPiano,
					_Utils_ap(
						$author$project$Level0$drawPainting,
						_Utils_ap(
							$author$project$Level0$drawWardrobe,
							_Utils_ap(
								$author$project$Level0$drawRack,
								_Utils_ap(
									$author$project$Level0$drawTelephone,
									_Utils_ap(
										$author$project$Level0$drawChair,
										_Utils_ap(
											$author$project$Level0$drawDesk,
											_Utils_ap(
												$author$project$Level0$drawLeftBox,
												_Utils_ap($author$project$Level0$drawRightBox, $author$project$Level0$drawMonitor)))))))))))));
var $author$project$Furnitures$drawCeiling = _List_fromArray(
	[
		A2(
		$elm$svg$Svg$polygon,
		_List_fromArray(
			[
				$elm$svg$Svg$Attributes$points('1000,0 975,0 975,750 1000,750'),
				$elm$svg$Svg$Attributes$fill('white'),
				$elm$svg$Svg$Attributes$stroke('black'),
				$elm$svg$Svg$Attributes$strokeWidth('1')
			]),
		_List_Nil),
		A2(
		$elm$svg$Svg$polygon,
		_List_fromArray(
			[
				$elm$svg$Svg$Attributes$points('975,350 975,375 675,375 675,350'),
				$elm$svg$Svg$Attributes$fill('white'),
				$elm$svg$Svg$Attributes$stroke('black'),
				$elm$svg$Svg$Attributes$strokeWidth('1')
			]),
		_List_Nil),
		A2(
		$elm$svg$Svg$polygon,
		_List_fromArray(
			[
				$elm$svg$Svg$Attributes$points('675,0 650,0 650,750 675,750'),
				$elm$svg$Svg$Attributes$fill('white'),
				$elm$svg$Svg$Attributes$stroke('black'),
				$elm$svg$Svg$Attributes$strokeWidth('1')
			]),
		_List_Nil),
		A2(
		$elm$svg$Svg$polygon,
		_List_fromArray(
			[
				$elm$svg$Svg$Attributes$points('815,375 835,375 835,750 815,750'),
				$elm$svg$Svg$Attributes$fill('white'),
				$elm$svg$Svg$Attributes$stroke('black'),
				$elm$svg$Svg$Attributes$strokeWidth('1')
			]),
		_List_Nil)
	]);
var $author$project$Furnitures$drawDoor = _List_fromArray(
	[
		A2(
		$elm$svg$Svg$polygon,
		_List_fromArray(
			[
				$elm$svg$Svg$Attributes$points('975,375 835,375 835,750 975,750'),
				$elm$svg$Svg$Attributes$fill('white'),
				$elm$svg$Svg$Attributes$stroke('black'),
				$elm$svg$Svg$Attributes$strokeWidth('1')
			]),
		_List_Nil),
		A2(
		$elm$svg$Svg$circle,
		_List_fromArray(
			[
				$elm$svg$Svg$Attributes$cx('950'),
				$elm$svg$Svg$Attributes$cy('550'),
				$elm$svg$Svg$Attributes$r('10'),
				$elm$svg$Svg$Attributes$stroke('black'),
				$elm$svg$Svg$Attributes$strokeWidth('1'),
				$elm$svg$Svg$Attributes$fill('white')
			]),
		_List_Nil)
	]);
var $author$project$Furnitures$drawDrawer = _List_fromArray(
	[
		A2(
		$elm$svg$Svg$polygon,
		_List_fromArray(
			[
				$elm$svg$Svg$Attributes$points('30,700 170,700 170,600 30,600'),
				$elm$svg$Svg$Attributes$fill('white'),
				$elm$svg$Svg$Attributes$stroke('black'),
				$elm$svg$Svg$Attributes$strokeWidth('1')
			]),
		_List_Nil),
		A2(
		$elm$svg$Svg$polygon,
		_List_fromArray(
			[
				$elm$svg$Svg$Attributes$points('35,695 165,695 165,650 35,650'),
				$elm$svg$Svg$Attributes$fill('white'),
				$elm$svg$Svg$Attributes$stroke('black'),
				$elm$svg$Svg$Attributes$strokeWidth('1')
			]),
		_List_Nil),
		A2(
		$elm$svg$Svg$polygon,
		_List_fromArray(
			[
				$elm$svg$Svg$Attributes$points('35,650 165,650 165,605 35,605'),
				$elm$svg$Svg$Attributes$fill('white'),
				$elm$svg$Svg$Attributes$stroke('black'),
				$elm$svg$Svg$Attributes$strokeWidth('1')
			]),
		_List_Nil),
		A2(
		$elm$svg$Svg$polygon,
		_List_fromArray(
			[
				$elm$svg$Svg$Attributes$points('50,700 60,700 60,750 50,750'),
				$elm$svg$Svg$Attributes$fill('white'),
				$elm$svg$Svg$Attributes$stroke('black'),
				$elm$svg$Svg$Attributes$strokeWidth('1')
			]),
		_List_Nil),
		A2(
		$elm$svg$Svg$polygon,
		_List_fromArray(
			[
				$elm$svg$Svg$Attributes$points('140,700 150,700 150,750 140,750'),
				$elm$svg$Svg$Attributes$fill('white'),
				$elm$svg$Svg$Attributes$stroke('black'),
				$elm$svg$Svg$Attributes$strokeWidth('1')
			]),
		_List_Nil)
	]);
var $author$project$Furnitures$drawFloor = _List_fromArray(
	[
		A2(
		$elm$svg$Svg$line,
		_List_fromArray(
			[
				$elm$svg$Svg$Attributes$x1('0'),
				$elm$svg$Svg$Attributes$y1('750'),
				$elm$svg$Svg$Attributes$x2('1600'),
				$elm$svg$Svg$Attributes$y2('750'),
				$elm$svg$Svg$Attributes$stroke('black'),
				$elm$svg$Svg$Attributes$strokeWidth('1')
			]),
		_List_Nil)
	]);
var $author$project$Furnitures$drawLamp = _List_fromArray(
	[
		A2(
		$elm$svg$Svg$polygon,
		_List_fromArray(
			[
				$elm$svg$Svg$Attributes$points('250,80 550,80 550,100 250,100'),
				$elm$svg$Svg$Attributes$fill('white'),
				$elm$svg$Svg$Attributes$stroke('black'),
				$elm$svg$Svg$Attributes$strokeWidth('1')
			]),
		_List_Nil),
		A2(
		$elm$svg$Svg$polygon,
		_List_fromArray(
			[
				$elm$svg$Svg$Attributes$points('290,80 300,80 300,0 290,0'),
				$elm$svg$Svg$Attributes$fill('white'),
				$elm$svg$Svg$Attributes$stroke('black'),
				$elm$svg$Svg$Attributes$strokeWidth('1')
			]),
		_List_Nil),
		A2(
		$elm$svg$Svg$polygon,
		_List_fromArray(
			[
				$elm$svg$Svg$Attributes$points('500,80 510,80 510,0 500,0'),
				$elm$svg$Svg$Attributes$fill('white'),
				$elm$svg$Svg$Attributes$stroke('black'),
				$elm$svg$Svg$Attributes$strokeWidth('1')
			]),
		_List_Nil),
		A2(
		$elm$svg$Svg$polygon,
		_List_fromArray(
			[
				$elm$svg$Svg$Attributes$points('300,30 500,30 500,40 300,40'),
				$elm$svg$Svg$Attributes$fill('white'),
				$elm$svg$Svg$Attributes$stroke('black'),
				$elm$svg$Svg$Attributes$strokeWidth('1')
			]),
		_List_Nil)
	]);
var $author$project$Furnitures$drawLamps = _List_fromArray(
	[
		A2(
		$elm$svg$Svg$line,
		_List_fromArray(
			[
				$elm$svg$Svg$Attributes$x1('1300'),
				$elm$svg$Svg$Attributes$y1('0'),
				$elm$svg$Svg$Attributes$x2('1300'),
				$elm$svg$Svg$Attributes$y2('200'),
				$elm$svg$Svg$Attributes$stroke('black'),
				$elm$svg$Svg$Attributes$strokeWidth('3')
			]),
		_List_Nil),
		A2(
		$elm$svg$Svg$line,
		_List_fromArray(
			[
				$elm$svg$Svg$Attributes$x1('1200'),
				$elm$svg$Svg$Attributes$y1('0'),
				$elm$svg$Svg$Attributes$x2('1200'),
				$elm$svg$Svg$Attributes$y2('150'),
				$elm$svg$Svg$Attributes$stroke('black'),
				$elm$svg$Svg$Attributes$strokeWidth('3')
			]),
		_List_Nil),
		A2(
		$elm$svg$Svg$line,
		_List_fromArray(
			[
				$elm$svg$Svg$Attributes$x1('1400'),
				$elm$svg$Svg$Attributes$y1('0'),
				$elm$svg$Svg$Attributes$x2('1400'),
				$elm$svg$Svg$Attributes$y2('150'),
				$elm$svg$Svg$Attributes$stroke('black'),
				$elm$svg$Svg$Attributes$strokeWidth('3')
			]),
		_List_Nil),
		A2(
		$elm$svg$Svg$polygon,
		_List_fromArray(
			[
				$elm$svg$Svg$Attributes$points('1300,200 1250,250 1350,250'),
				$elm$svg$Svg$Attributes$fill('white'),
				$elm$svg$Svg$Attributes$stroke('black'),
				$elm$svg$Svg$Attributes$strokeWidth('1')
			]),
		_List_Nil),
		A2(
		$elm$svg$Svg$polygon,
		_List_fromArray(
			[
				$elm$svg$Svg$Attributes$points('1200,150 1150,200 1250,200'),
				$elm$svg$Svg$Attributes$fill('white'),
				$elm$svg$Svg$Attributes$stroke('black'),
				$elm$svg$Svg$Attributes$strokeWidth('1')
			]),
		_List_Nil),
		A2(
		$elm$svg$Svg$polygon,
		_List_fromArray(
			[
				$elm$svg$Svg$Attributes$points('1400,150 1350,200 1450,200'),
				$elm$svg$Svg$Attributes$fill('white'),
				$elm$svg$Svg$Attributes$stroke('black'),
				$elm$svg$Svg$Attributes$strokeWidth('1')
			]),
		_List_Nil)
	]);
var $author$project$Furnitures$drawLeftChair = _List_fromArray(
	[
		A2(
		$elm$svg$Svg$polygon,
		_List_fromArray(
			[
				$elm$svg$Svg$Attributes$points('1100,600 1200,600 1200,580 1100,580'),
				$elm$svg$Svg$Attributes$fill('white'),
				$elm$svg$Svg$Attributes$stroke('black'),
				$elm$svg$Svg$Attributes$strokeWidth('1')
			]),
		_List_Nil),
		A2(
		$elm$svg$Svg$polygon,
		_List_fromArray(
			[
				$elm$svg$Svg$Attributes$points('1120,600 1130,600 1130,750 1120,750'),
				$elm$svg$Svg$Attributes$fill('white'),
				$elm$svg$Svg$Attributes$stroke('black'),
				$elm$svg$Svg$Attributes$strokeWidth('1')
			]),
		_List_Nil),
		A2(
		$elm$svg$Svg$polygon,
		_List_fromArray(
			[
				$elm$svg$Svg$Attributes$points('1170,600 1180,600 1180,750 1170,750'),
				$elm$svg$Svg$Attributes$fill('white'),
				$elm$svg$Svg$Attributes$stroke('black'),
				$elm$svg$Svg$Attributes$strokeWidth('1')
			]),
		_List_Nil)
	]);
var $author$project$Furnitures$drawPhotos = _List_fromArray(
	[
		A2(
		$elm$svg$Svg$polygon,
		_List_fromArray(
			[
				$elm$svg$Svg$Attributes$points('200,450 280,450 280,350 200,350'),
				$elm$svg$Svg$Attributes$fill('white'),
				$elm$svg$Svg$Attributes$stroke('black'),
				$elm$svg$Svg$Attributes$strokeWidth('1')
			]),
		_List_Nil),
		A2(
		$elm$svg$Svg$polygon,
		_List_fromArray(
			[
				$elm$svg$Svg$Attributes$points('205,445 275,445 275,355 205,355'),
				$elm$svg$Svg$Attributes$fill('white'),
				$elm$svg$Svg$Attributes$stroke('black'),
				$elm$svg$Svg$Attributes$strokeWidth('1')
			]),
		_List_Nil),
		A2(
		$elm$svg$Svg$polygon,
		_List_fromArray(
			[
				$elm$svg$Svg$Attributes$points('320,380 400,380 400,320 320,320'),
				$elm$svg$Svg$Attributes$fill('white'),
				$elm$svg$Svg$Attributes$stroke('black'),
				$elm$svg$Svg$Attributes$strokeWidth('1')
			]),
		_List_Nil),
		A2(
		$elm$svg$Svg$polygon,
		_List_fromArray(
			[
				$elm$svg$Svg$Attributes$points('325,375 395,375 395,325 325,325'),
				$elm$svg$Svg$Attributes$fill('white'),
				$elm$svg$Svg$Attributes$stroke('black'),
				$elm$svg$Svg$Attributes$strokeWidth('1')
			]),
		_List_Nil),
		A2(
		$elm$svg$Svg$polygon,
		_List_fromArray(
			[
				$elm$svg$Svg$Attributes$points('430,350 500,350 500,270 430,270'),
				$elm$svg$Svg$Attributes$fill('white'),
				$elm$svg$Svg$Attributes$stroke('black'),
				$elm$svg$Svg$Attributes$strokeWidth('1')
			]),
		_List_Nil),
		A2(
		$elm$svg$Svg$polygon,
		_List_fromArray(
			[
				$elm$svg$Svg$Attributes$points('435,345 495,345 495,275 435,275'),
				$elm$svg$Svg$Attributes$fill('white'),
				$elm$svg$Svg$Attributes$stroke('black'),
				$elm$svg$Svg$Attributes$strokeWidth('1')
			]),
		_List_Nil),
		A2(
		$elm$svg$Svg$polygon,
		_List_fromArray(
			[
				$elm$svg$Svg$Attributes$points('530,430 610,430 610,330 530,330'),
				$elm$svg$Svg$Attributes$fill('white'),
				$elm$svg$Svg$Attributes$stroke('black'),
				$elm$svg$Svg$Attributes$strokeWidth('1')
			]),
		_List_Nil),
		A2(
		$elm$svg$Svg$polygon,
		_List_fromArray(
			[
				$elm$svg$Svg$Attributes$points('535,425 605,425 605,335 535,335'),
				$elm$svg$Svg$Attributes$fill('white'),
				$elm$svg$Svg$Attributes$stroke('black'),
				$elm$svg$Svg$Attributes$strokeWidth('1')
			]),
		_List_Nil),
		A2(
		$elm$svg$Svg$polygon,
		_List_fromArray(
			[
				$elm$svg$Svg$Attributes$points('420,440 500,440 500,390 420,390'),
				$elm$svg$Svg$Attributes$fill('white'),
				$elm$svg$Svg$Attributes$stroke('black'),
				$elm$svg$Svg$Attributes$strokeWidth('1')
			]),
		_List_Nil),
		A2(
		$elm$svg$Svg$polygon,
		_List_fromArray(
			[
				$elm$svg$Svg$Attributes$points('425,435 495,435 495,395 425,395'),
				$elm$svg$Svg$Attributes$fill('white'),
				$elm$svg$Svg$Attributes$stroke('black'),
				$elm$svg$Svg$Attributes$strokeWidth('1')
			]),
		_List_Nil)
	]);
var $author$project$Furnitures$drawRightChair = _List_fromArray(
	[
		A2(
		$elm$svg$Svg$polygon,
		_List_fromArray(
			[
				$elm$svg$Svg$Attributes$points('1400,600 1500,600 1500,580 1400,580'),
				$elm$svg$Svg$Attributes$fill('white'),
				$elm$svg$Svg$Attributes$stroke('black'),
				$elm$svg$Svg$Attributes$strokeWidth('1')
			]),
		_List_Nil),
		A2(
		$elm$svg$Svg$polygon,
		_List_fromArray(
			[
				$elm$svg$Svg$Attributes$points('1420,600 1430,600 1430,750 1420,750'),
				$elm$svg$Svg$Attributes$fill('white'),
				$elm$svg$Svg$Attributes$stroke('black'),
				$elm$svg$Svg$Attributes$strokeWidth('1')
			]),
		_List_Nil),
		A2(
		$elm$svg$Svg$polygon,
		_List_fromArray(
			[
				$elm$svg$Svg$Attributes$points('1470,600 1480,600 1480,750 1470,750'),
				$elm$svg$Svg$Attributes$fill('white'),
				$elm$svg$Svg$Attributes$stroke('black'),
				$elm$svg$Svg$Attributes$strokeWidth('1')
			]),
		_List_Nil)
	]);
var $author$project$Furnitures$drawSofa = _List_fromArray(
	[
		A2(
		$elm$svg$Svg$polygon,
		_List_fromArray(
			[
				$elm$svg$Svg$Attributes$points('200,700 600,700 600,710 200,710'),
				$elm$svg$Svg$Attributes$fill('white'),
				$elm$svg$Svg$Attributes$stroke('black'),
				$elm$svg$Svg$Attributes$strokeWidth('1')
			]),
		_List_Nil),
		A2(
		$elm$svg$Svg$polygon,
		_List_fromArray(
			[
				$elm$svg$Svg$Attributes$points('220,710 240,710 240,750 220,750'),
				$elm$svg$Svg$Attributes$fill('white'),
				$elm$svg$Svg$Attributes$stroke('black'),
				$elm$svg$Svg$Attributes$strokeWidth('1')
			]),
		_List_Nil),
		A2(
		$elm$svg$Svg$polygon,
		_List_fromArray(
			[
				$elm$svg$Svg$Attributes$points('560,710 580,710 580,750 560,750'),
				$elm$svg$Svg$Attributes$fill('white'),
				$elm$svg$Svg$Attributes$stroke('black'),
				$elm$svg$Svg$Attributes$strokeWidth('1')
			]),
		_List_Nil),
		A2(
		$elm$svg$Svg$polygon,
		_List_fromArray(
			[
				$elm$svg$Svg$Attributes$points('200,700 225,700 225,625 200,625'),
				$elm$svg$Svg$Attributes$fill('white'),
				$elm$svg$Svg$Attributes$stroke('black'),
				$elm$svg$Svg$Attributes$strokeWidth('1')
			]),
		_List_Nil),
		A2(
		$elm$svg$Svg$polygon,
		_List_fromArray(
			[
				$elm$svg$Svg$Attributes$points('575,700 600,700 600,625 575,625'),
				$elm$svg$Svg$Attributes$fill('white'),
				$elm$svg$Svg$Attributes$stroke('black'),
				$elm$svg$Svg$Attributes$strokeWidth('1')
			]),
		_List_Nil),
		A2(
		$elm$svg$Svg$polygon,
		_List_fromArray(
			[
				$elm$svg$Svg$Attributes$points('225,700 345,700 345,675 225,675'),
				$elm$svg$Svg$Attributes$fill('white'),
				$elm$svg$Svg$Attributes$stroke('black'),
				$elm$svg$Svg$Attributes$strokeWidth('1')
			]),
		_List_Nil),
		A2(
		$elm$svg$Svg$polygon,
		_List_fromArray(
			[
				$elm$svg$Svg$Attributes$points('345,700 455,700 455,675 345,675'),
				$elm$svg$Svg$Attributes$fill('white'),
				$elm$svg$Svg$Attributes$stroke('black'),
				$elm$svg$Svg$Attributes$strokeWidth('1')
			]),
		_List_Nil),
		A2(
		$elm$svg$Svg$polygon,
		_List_fromArray(
			[
				$elm$svg$Svg$Attributes$points('455,700 575,700 575,675 455,675'),
				$elm$svg$Svg$Attributes$fill('white'),
				$elm$svg$Svg$Attributes$stroke('black'),
				$elm$svg$Svg$Attributes$strokeWidth('1')
			]),
		_List_Nil),
		A2(
		$elm$svg$Svg$polygon,
		_List_fromArray(
			[
				$elm$svg$Svg$Attributes$points('225,675 575,675 575,650 225,650'),
				$elm$svg$Svg$Attributes$fill('white'),
				$elm$svg$Svg$Attributes$stroke('black'),
				$elm$svg$Svg$Attributes$strokeWidth('1')
			]),
		_List_Nil),
		A2(
		$elm$svg$Svg$polygon,
		_List_fromArray(
			[
				$elm$svg$Svg$Attributes$points('225,575 575,575 575,650 225,650'),
				$elm$svg$Svg$Attributes$fill('white'),
				$elm$svg$Svg$Attributes$stroke('black'),
				$elm$svg$Svg$Attributes$strokeWidth('1')
			]),
		_List_Nil)
	]);
var $author$project$Furnitures$drawStair = _List_fromArray(
	[
		A2(
		$elm$svg$Svg$polygon,
		_List_fromArray(
			[
				$elm$svg$Svg$Attributes$points('675,725 815,725 815,750 675,750'),
				$elm$svg$Svg$Attributes$fill('white'),
				$elm$svg$Svg$Attributes$stroke('black'),
				$elm$svg$Svg$Attributes$strokeWidth('1')
			]),
		_List_Nil),
		A2(
		$elm$svg$Svg$polygon,
		_List_fromArray(
			[
				$elm$svg$Svg$Attributes$points('675,700 815,700 815,725 675,725'),
				$elm$svg$Svg$Attributes$fill('white'),
				$elm$svg$Svg$Attributes$stroke('black'),
				$elm$svg$Svg$Attributes$strokeWidth('1')
			]),
		_List_Nil),
		A2(
		$elm$svg$Svg$polygon,
		_List_fromArray(
			[
				$elm$svg$Svg$Attributes$points('675,675 815,675 815,700 675,700'),
				$elm$svg$Svg$Attributes$fill('white'),
				$elm$svg$Svg$Attributes$stroke('black'),
				$elm$svg$Svg$Attributes$strokeWidth('1')
			]),
		_List_Nil),
		A2(
		$elm$svg$Svg$polygon,
		_List_fromArray(
			[
				$elm$svg$Svg$Attributes$points('675,650 815,650 815,675 675,675'),
				$elm$svg$Svg$Attributes$fill('white'),
				$elm$svg$Svg$Attributes$stroke('black'),
				$elm$svg$Svg$Attributes$strokeWidth('1')
			]),
		_List_Nil),
		A2(
		$elm$svg$Svg$polygon,
		_List_fromArray(
			[
				$elm$svg$Svg$Attributes$points('675,625 815,625 815,650 675,650'),
				$elm$svg$Svg$Attributes$fill('white'),
				$elm$svg$Svg$Attributes$stroke('black'),
				$elm$svg$Svg$Attributes$strokeWidth('1')
			]),
		_List_Nil),
		A2(
		$elm$svg$Svg$polygon,
		_List_fromArray(
			[
				$elm$svg$Svg$Attributes$points('675,600 815,600 815,625 675,625'),
				$elm$svg$Svg$Attributes$fill('white'),
				$elm$svg$Svg$Attributes$stroke('black'),
				$elm$svg$Svg$Attributes$strokeWidth('1')
			]),
		_List_Nil),
		A2(
		$elm$svg$Svg$polygon,
		_List_fromArray(
			[
				$elm$svg$Svg$Attributes$points('675,575 815,575 815,600 675,600'),
				$elm$svg$Svg$Attributes$fill('white'),
				$elm$svg$Svg$Attributes$stroke('black'),
				$elm$svg$Svg$Attributes$strokeWidth('1')
			]),
		_List_Nil),
		A2(
		$elm$svg$Svg$polygon,
		_List_fromArray(
			[
				$elm$svg$Svg$Attributes$points('675,550 815,550 815,575 675,575'),
				$elm$svg$Svg$Attributes$fill('white'),
				$elm$svg$Svg$Attributes$stroke('black'),
				$elm$svg$Svg$Attributes$strokeWidth('1')
			]),
		_List_Nil),
		A2(
		$elm$svg$Svg$polygon,
		_List_fromArray(
			[
				$elm$svg$Svg$Attributes$points('675,525 815,525 815,550 675,550'),
				$elm$svg$Svg$Attributes$fill('white'),
				$elm$svg$Svg$Attributes$stroke('black'),
				$elm$svg$Svg$Attributes$strokeWidth('1')
			]),
		_List_Nil),
		A2(
		$elm$svg$Svg$polygon,
		_List_fromArray(
			[
				$elm$svg$Svg$Attributes$points('675,375 815,375 815,525 675,525'),
				$elm$svg$Svg$Attributes$fill('white'),
				$elm$svg$Svg$Attributes$stroke('black'),
				$elm$svg$Svg$Attributes$strokeWidth('1')
			]),
		_List_Nil)
	]);
var $author$project$Furnitures$drawTable = _List_fromArray(
	[
		A2(
		$elm$svg$Svg$polygon,
		_List_fromArray(
			[
				$elm$svg$Svg$Attributes$points('1200,500 1400,500 1400,480 1200,480'),
				$elm$svg$Svg$Attributes$fill('white'),
				$elm$svg$Svg$Attributes$stroke('black'),
				$elm$svg$Svg$Attributes$strokeWidth('1')
			]),
		_List_Nil),
		A2(
		$elm$svg$Svg$polygon,
		_List_fromArray(
			[
				$elm$svg$Svg$Attributes$points('1225,500 1245,500 1245,750 1225,750'),
				$elm$svg$Svg$Attributes$fill('white'),
				$elm$svg$Svg$Attributes$stroke('black'),
				$elm$svg$Svg$Attributes$strokeWidth('1')
			]),
		_List_Nil),
		A2(
		$elm$svg$Svg$polygon,
		_List_fromArray(
			[
				$elm$svg$Svg$Attributes$points('1355,500 1375,500 1375,750 1355,750'),
				$elm$svg$Svg$Attributes$fill('white'),
				$elm$svg$Svg$Attributes$stroke('black'),
				$elm$svg$Svg$Attributes$strokeWidth('1')
			]),
		_List_Nil)
	]);
var $author$project$Furnitures$drawWindow = _List_fromArray(
	[
		A2(
		$elm$svg$Svg$polygon,
		_List_fromArray(
			[
				$elm$svg$Svg$Attributes$points('1050,515 1550,515 1550,300 1050,300'),
				$elm$svg$Svg$Attributes$fill('white'),
				$elm$svg$Svg$Attributes$stroke('black'),
				$elm$svg$Svg$Attributes$strokeWidth('1')
			]),
		_List_Nil),
		A2(
		$elm$svg$Svg$polygon,
		_List_fromArray(
			[
				$elm$svg$Svg$Attributes$points('1060,505 1290,505 1290,310 1060,310'),
				$elm$svg$Svg$Attributes$fill('white'),
				$elm$svg$Svg$Attributes$stroke('black'),
				$elm$svg$Svg$Attributes$strokeWidth('1')
			]),
		_List_Nil),
		A2(
		$elm$svg$Svg$polygon,
		_List_fromArray(
			[
				$elm$svg$Svg$Attributes$points('1310,505 1540,505 1540,310 1310,310'),
				$elm$svg$Svg$Attributes$fill('white'),
				$elm$svg$Svg$Attributes$stroke('black'),
				$elm$svg$Svg$Attributes$strokeWidth('1')
			]),
		_List_Nil)
	]);
var $author$project$Furnitures$level_1_furniture = _Utils_ap(
	$author$project$Furnitures$drawWindow,
	_Utils_ap(
		$author$project$Furnitures$drawTable,
		_Utils_ap(
			$author$project$Furnitures$drawFloor,
			_Utils_ap(
				$author$project$Furnitures$drawLeftChair,
				_Utils_ap(
					$author$project$Furnitures$drawRightChair,
					_Utils_ap(
						$author$project$Furnitures$drawLamps,
						_Utils_ap(
							$author$project$Furnitures$drawCeiling,
							_Utils_ap(
								$author$project$Furnitures$drawStair,
								_Utils_ap(
									$author$project$Furnitures$drawDoor,
									_Utils_ap(
										$author$project$Furnitures$drawSofa,
										_Utils_ap(
											$author$project$Furnitures$drawLamp,
											_Utils_ap($author$project$Furnitures$drawDrawer, $author$project$Furnitures$drawPhotos))))))))))));
var $elm$svg$Svg$Attributes$fillOpacity = _VirtualDom_attribute('fill-opacity');
var $elm$svg$Svg$Events$onClick = function (msg) {
	return A2(
		$elm$html$Html$Events$on,
		'click',
		$elm$json$Json$Decode$succeed(msg));
};
var $elm$svg$Svg$rect = $elm$svg$Svg$trustedNode('rect');
var $elm$svg$Svg$Attributes$width = _VirtualDom_attribute('width');
var $elm$svg$Svg$Attributes$x = _VirtualDom_attribute('x');
var $elm$svg$Svg$Attributes$y = _VirtualDom_attribute('y');
var $author$project$Inventory$render_inventory_inside = F2(
	function (grid, lef) {
		var _v0 = function () {
			if (grid.$ === 'Blank') {
				return _Utils_Tuple2(-1, -1);
			} else {
				var a = grid.a;
				return _Utils_Tuple2(a.index, 0);
			}
		}();
		var index = _v0.a;
		var typeid = _v0.b;
		return A2(
			$elm$svg$Svg$rect,
			_List_fromArray(
				[
					$elm$svg$Svg$Attributes$x(
					$elm$core$Debug$toString(lef)),
					$elm$svg$Svg$Attributes$y('760'),
					$elm$svg$Svg$Attributes$width('100'),
					$elm$svg$Svg$Attributes$height('100'),
					$elm$svg$Svg$Attributes$fillOpacity('0.1'),
					$elm$svg$Svg$Attributes$fill('red'),
					$elm$svg$Svg$Events$onClick(
					A2($author$project$Messages$OnClickItem, index, typeid))
				]),
			_List_Nil);
	});
var $elm$svg$Svg$text = $elm$virtual_dom$VirtualDom$text;
var $elm$svg$Svg$text_ = $elm$svg$Svg$trustedNode('text');
var $author$project$Inventory$render_inventory_inside_item = F2(
	function (grid, lef) {
		var _v0 = function () {
			if (grid.$ === 'Blank') {
				return _Utils_Tuple3('Nothing', '', '');
			} else {
				var a = grid.a;
				return _Utils_eq(a.state, $author$project$Picture$Stored) ? _Utils_Tuple3(
					'Pict ',
					$elm$core$Debug$toString(a.index),
					' Stored') : (_Utils_eq(a.state, $author$project$Picture$UnderUse) ? _Utils_Tuple3(
					'Pict ',
					$elm$core$Debug$toString(a.index),
					' Underuse') : (_Utils_eq(a.state, $author$project$Picture$Picked) ? _Utils_Tuple3(
					'Pict ',
					$elm$core$Debug$toString(a.index),
					' Picked') : _Utils_Tuple3(
					'Pict ',
					$elm$core$Debug$toString(a.index),
					' blabla')));
			}
		}();
		var show1 = _v0.a;
		var show2 = _v0.b;
		var show3 = _v0.c;
		var show = _Utils_ap(
			show1,
			_Utils_ap(show2, show3));
		return A2(
			$elm$svg$Svg$text_,
			_List_fromArray(
				[
					$elm$svg$Svg$Attributes$x(
					$elm$core$Debug$toString(lef)),
					$elm$svg$Svg$Attributes$y('800'),
					$elm$svg$Svg$Attributes$width('100'),
					$elm$svg$Svg$Attributes$height('100')
				]),
			_List_fromArray(
				[
					$elm$svg$Svg$text(show)
				]));
	});
var $author$project$Inventory$render_inventory = function (invent) {
	return _Utils_ap(
		A3($elm$core$List$map2, $author$project$Inventory$render_inventory_inside_item, invent.own, invent.locaLeft),
		A3($elm$core$List$map2, $author$project$Inventory$render_inventory_inside, invent.own, invent.locaLeft));
};
var $author$project$Messages$OnClickTriggers = function (a) {
	return {$: 'OnClickTriggers', a: a};
};
var $author$project$Pcomputer$drawnumberbutton = function (number) {
	var tp = $elm$core$String$fromInt(650 + (50 * number.position.a));
	var rnumber = number.position.a + (3 * (number.position.b - 1));
	var lp = $elm$core$String$fromInt(350 + (50 * number.position.b));
	var _v0 = number.position;
	if ((_v0.a === 2) && (_v0.b === 4)) {
		return A2(
			$elm$svg$Svg$circle,
			_List_fromArray(
				[
					$elm$svg$Svg$Attributes$cx(tp),
					$elm$svg$Svg$Attributes$cy(lp),
					$elm$svg$Svg$Attributes$r('20'),
					$elm$svg$Svg$Attributes$fillOpacity('0.0'),
					$elm$svg$Svg$Attributes$stroke('black'),
					$elm$svg$Svg$Events$onClick(
					$author$project$Messages$OnClickTriggers(0))
				]),
			_List_Nil);
	} else {
		return A2(
			$elm$svg$Svg$circle,
			_List_fromArray(
				[
					$elm$svg$Svg$Attributes$cx(tp),
					$elm$svg$Svg$Attributes$cy(lp),
					$elm$svg$Svg$Attributes$r('20'),
					$elm$svg$Svg$Attributes$fillOpacity('0.0'),
					$elm$svg$Svg$Attributes$stroke('black'),
					$elm$svg$Svg$Events$onClick(
					$author$project$Messages$OnClickTriggers(rnumber))
				]),
			_List_Nil);
	}
};
var $author$project$Pcomputer$drawpassword = function (number) {
	var tp = $elm$core$String$fromInt(650 + (50 * number.position.a));
	var rnumber = number.position.a + (3 * (number.position.b - 1));
	var lp = $elm$core$String$fromInt(350 + (50 * number.position.b));
	var _v0 = number.position;
	if ((_v0.a === 2) && (_v0.b === 4)) {
		return A2(
			$elm$svg$Svg$text_,
			_List_fromArray(
				[
					$elm$svg$Svg$Attributes$x(tp),
					$elm$svg$Svg$Attributes$y(lp),
					$elm$svg$Svg$Events$onClick(
					$author$project$Messages$OnClickTriggers(0))
				]),
			_List_fromArray(
				[
					$elm$html$Html$text('0')
				]));
	} else {
		return A2(
			$elm$svg$Svg$text_,
			_List_fromArray(
				[
					$elm$svg$Svg$Attributes$x(tp),
					$elm$svg$Svg$Attributes$y(lp),
					$elm$svg$Svg$Events$onClick(
					$author$project$Messages$OnClickTriggers(rnumber))
				]),
			_List_fromArray(
				[
					$elm$html$Html$text(
					$elm$core$String$fromInt(rnumber))
				]));
	}
};
var $elm$svg$Svg$Attributes$fontSize = _VirtualDom_attribute('font-size');
var $author$project$Pcomputer$drawword = function (word) {
	var lg = $elm$core$List$length(word);
	var x1 = $elm$core$String$fromInt(670 + (50 * (lg - 1)));
	if (word.b) {
		var x = word.a;
		var xs = word.b;
		return _Utils_ap(
			_List_fromArray(
				[
					A2(
					$elm$svg$Svg$text_,
					_List_fromArray(
						[
							$elm$svg$Svg$Attributes$x(x1),
							$elm$svg$Svg$Attributes$y('290'),
							$elm$svg$Svg$Attributes$fontSize('20')
						]),
					_List_fromArray(
						[
							$elm$html$Html$text(
							$elm$core$String$fromInt(x))
						]))
				]),
			$author$project$Pcomputer$drawword(xs));
	} else {
		return _List_Nil;
	}
};
var $author$project$Pcomputer$Numberkey = function (position) {
	return {position: position};
};
var $author$project$Pcomputer$initnumberkey = _List_fromArray(
	[
		$author$project$Pcomputer$Numberkey(
		_Utils_Tuple2(1, 1)),
		$author$project$Pcomputer$Numberkey(
		_Utils_Tuple2(1, 2)),
		$author$project$Pcomputer$Numberkey(
		_Utils_Tuple2(1, 3)),
		$author$project$Pcomputer$Numberkey(
		_Utils_Tuple2(2, 1)),
		$author$project$Pcomputer$Numberkey(
		_Utils_Tuple2(2, 2)),
		$author$project$Pcomputer$Numberkey(
		_Utils_Tuple2(2, 3)),
		$author$project$Pcomputer$Numberkey(
		_Utils_Tuple2(3, 1)),
		$author$project$Pcomputer$Numberkey(
		_Utils_Tuple2(3, 2)),
		$author$project$Pcomputer$Numberkey(
		_Utils_Tuple2(3, 3)),
		$author$project$Pcomputer$Numberkey(
		_Utils_Tuple2(2, 4))
	]);
var $elm$svg$Svg$Attributes$rx = _VirtualDom_attribute('rx');
var $author$project$Pcomputer$drawchargedpc = F2(
	function (a, model) {
		switch (a) {
			case 0:
				return _Utils_ap(
					_List_fromArray(
						[
							A2(
							$elm$svg$Svg$polygon,
							_List_fromArray(
								[
									$elm$svg$Svg$Attributes$points('300,50 1200,50 1200,600 300,600'),
									$elm$svg$Svg$Attributes$fill('black'),
									$elm$svg$Svg$Attributes$stroke('black'),
									$elm$svg$Svg$Attributes$strokeWidth('1')
								]),
							_List_Nil),
							A2(
							$elm$svg$Svg$polygon,
							_List_fromArray(
								[
									$elm$svg$Svg$Attributes$points('310,60 1190,60 1190,590 310,590'),
									$elm$svg$Svg$Attributes$fill('white'),
									$elm$svg$Svg$Attributes$stroke('black'),
									$elm$svg$Svg$Attributes$strokeWidth('1')
								]),
							_List_Nil),
							A2(
							$elm$svg$Svg$polygon,
							_List_fromArray(
								[
									$elm$svg$Svg$Attributes$points('700,600 800,600 800,700 700,700'),
									$elm$svg$Svg$Attributes$fill('silver')
								]),
							_List_Nil),
							A2(
							$elm$svg$Svg$text_,
							_List_fromArray(
								[
									$elm$svg$Svg$Attributes$x('680'),
									$elm$svg$Svg$Attributes$y('150'),
									$elm$svg$Svg$Attributes$fontSize('30')
								]),
							_List_fromArray(
								[
									$elm$html$Html$text('Password')
								])),
							A2(
							$elm$svg$Svg$line,
							_List_fromArray(
								[
									$elm$svg$Svg$Attributes$x1('650'),
									$elm$svg$Svg$Attributes$y1('300'),
									$elm$svg$Svg$Attributes$x2('695'),
									$elm$svg$Svg$Attributes$y2('300'),
									$elm$svg$Svg$Attributes$stroke('black'),
									$elm$svg$Svg$Attributes$strokeWidth('2')
								]),
							_List_Nil),
							A2(
							$elm$svg$Svg$line,
							_List_fromArray(
								[
									$elm$svg$Svg$Attributes$x1('700'),
									$elm$svg$Svg$Attributes$y1('300'),
									$elm$svg$Svg$Attributes$x2('745'),
									$elm$svg$Svg$Attributes$y2('300'),
									$elm$svg$Svg$Attributes$stroke('black'),
									$elm$svg$Svg$Attributes$strokeWidth('2')
								]),
							_List_Nil),
							A2(
							$elm$svg$Svg$line,
							_List_fromArray(
								[
									$elm$svg$Svg$Attributes$x1('750'),
									$elm$svg$Svg$Attributes$y1('300'),
									$elm$svg$Svg$Attributes$x2('795'),
									$elm$svg$Svg$Attributes$y2('300'),
									$elm$svg$Svg$Attributes$stroke('black'),
									$elm$svg$Svg$Attributes$strokeWidth('2')
								]),
							_List_Nil),
							A2(
							$elm$svg$Svg$line,
							_List_fromArray(
								[
									$elm$svg$Svg$Attributes$x1('800'),
									$elm$svg$Svg$Attributes$y1('300'),
									$elm$svg$Svg$Attributes$x2('845'),
									$elm$svg$Svg$Attributes$y2('300'),
									$elm$svg$Svg$Attributes$stroke('black'),
									$elm$svg$Svg$Attributes$strokeWidth('2')
								]),
							_List_Nil),
							A2(
							$elm$svg$Svg$circle,
							_List_fromArray(
								[
									$elm$svg$Svg$Attributes$cx('800'),
									$elm$svg$Svg$Attributes$cy('550'),
									$elm$svg$Svg$Attributes$r('20'),
									$elm$svg$Svg$Attributes$fillOpacity('0.0'),
									$elm$svg$Svg$Attributes$stroke('black'),
									$elm$svg$Svg$Events$onClick(
									$author$project$Messages$OnClickTriggers(10))
								]),
							_List_Nil),
							A2(
							$elm$svg$Svg$rect,
							_List_fromArray(
								[
									$elm$svg$Svg$Attributes$x('850'),
									$elm$svg$Svg$Attributes$y('300'),
									$elm$svg$Svg$Attributes$width('50'),
									$elm$svg$Svg$Attributes$height('20'),
									$elm$svg$Svg$Attributes$stroke('black'),
									$elm$svg$Svg$Attributes$rx('15'),
									$elm$svg$Svg$Events$onClick(
									$author$project$Messages$OnClickTriggers(11))
								]),
							_List_Nil)
						]),
					_Utils_ap(
						A2($elm$core$List$map, $author$project$Pcomputer$drawnumberbutton, $author$project$Pcomputer$initnumberkey),
						_Utils_ap(
							A2($elm$core$List$map, $author$project$Pcomputer$drawpassword, $author$project$Pcomputer$initnumberkey),
							$author$project$Pcomputer$drawword(model.word))));
			case 1:
				return _List_fromArray(
					[
						A2(
						$elm$svg$Svg$polygon,
						_List_fromArray(
							[
								$elm$svg$Svg$Attributes$points('300,50 1200,50 1200,600 300,600'),
								$elm$svg$Svg$Attributes$fill('black'),
								$elm$svg$Svg$Attributes$stroke('black'),
								$elm$svg$Svg$Attributes$strokeWidth('1')
							]),
						_List_Nil),
						A2(
						$elm$svg$Svg$polygon,
						_List_fromArray(
							[
								$elm$svg$Svg$Attributes$points('310,60 1190,60 1190,590 310,590'),
								$elm$svg$Svg$Attributes$fill('white'),
								$elm$svg$Svg$Attributes$stroke('black'),
								$elm$svg$Svg$Attributes$strokeWidth('1')
							]),
						_List_Nil),
						A2(
						$elm$svg$Svg$polygon,
						_List_fromArray(
							[
								$elm$svg$Svg$Attributes$points('700,600 800,600 800,700 700,700'),
								$elm$svg$Svg$Attributes$fill('silver')
							]),
						_List_Nil)
					]);
			default:
				return _List_Nil;
		}
	});
var $author$project$Pcomputer$drawlowbattery = _List_fromArray(
	[
		A2(
		$elm$svg$Svg$polygon,
		_List_fromArray(
			[
				$elm$svg$Svg$Attributes$points('300,50 1200,50 1200,600 300,600'),
				$elm$svg$Svg$Attributes$fill('black'),
				$elm$svg$Svg$Attributes$stroke('black'),
				$elm$svg$Svg$Attributes$strokeWidth('1')
			]),
		_List_Nil),
		A2(
		$elm$svg$Svg$polygon,
		_List_fromArray(
			[
				$elm$svg$Svg$Attributes$points('310,60 1190,60 1190,590 310,590'),
				$elm$svg$Svg$Attributes$fill('white'),
				$elm$svg$Svg$Attributes$stroke('black'),
				$elm$svg$Svg$Attributes$strokeWidth('1')
			]),
		_List_Nil),
		A2(
		$elm$svg$Svg$polygon,
		_List_fromArray(
			[
				$elm$svg$Svg$Attributes$points('700,600 800,600 800,700 700,700'),
				$elm$svg$Svg$Attributes$fill('silver')
			]),
		_List_Nil),
		A2(
		$elm$svg$Svg$rect,
		_List_fromArray(
			[
				$elm$svg$Svg$Attributes$points('550,250 950,250 950,400 550,400'),
				$elm$svg$Svg$Attributes$x('550'),
				$elm$svg$Svg$Attributes$y('250'),
				$elm$svg$Svg$Attributes$width('400'),
				$elm$svg$Svg$Attributes$height('150'),
				$elm$svg$Svg$Attributes$fill('white'),
				$elm$svg$Svg$Attributes$stroke('black'),
				$elm$svg$Svg$Attributes$strokeWidth('1'),
				$elm$svg$Svg$Attributes$rx('15')
			]),
		_List_Nil),
		A2(
		$elm$svg$Svg$polygon,
		_List_fromArray(
			[
				$elm$svg$Svg$Attributes$points('950,300 970,300 970,350 950,350'),
				$elm$svg$Svg$Attributes$fill('black'),
				$elm$svg$Svg$Attributes$stroke('black'),
				$elm$svg$Svg$Attributes$strokeWidth('1')
			]),
		_List_Nil),
		A2(
		$elm$svg$Svg$rect,
		_List_fromArray(
			[
				$elm$svg$Svg$Attributes$x('550'),
				$elm$svg$Svg$Attributes$y('250'),
				$elm$svg$Svg$Attributes$width('20'),
				$elm$svg$Svg$Attributes$height('150'),
				$elm$svg$Svg$Attributes$fill('red'),
				$elm$svg$Svg$Attributes$rx('15')
			]),
		_List_Nil)
	]);
var $author$project$Pcomputer$draw_computer = F3(
	function (commodel, cs, cle) {
		switch (cs) {
			case 0:
				return (!cle) ? _List_fromArray(
					[
						A2(
						$elm$svg$Svg$rect,
						_List_fromArray(
							[
								$elm$svg$Svg$Attributes$x('1270'),
								$elm$svg$Svg$Attributes$y('470'),
								$elm$svg$Svg$Attributes$width('160'),
								$elm$svg$Svg$Attributes$height('90'),
								$elm$svg$Svg$Attributes$fillOpacity('0.0'),
								$elm$svg$Svg$Events$onClick(
								$author$project$Messages$StartChange(
									$author$project$Messages$ChangeScene(5)))
							]),
						_List_Nil)
					]) : _List_Nil;
			case 5:
				var _v1 = commodel.state;
				if (_v1.$ === 'Lowpower') {
					return $author$project$Pcomputer$drawlowbattery;
				} else {
					var a = _v1.a;
					return A2($author$project$Pcomputer$drawchargedpc, a, commodel);
				}
			default:
				return _Debug_todo(
					'Pcomputer',
					{
						start: {line: 173, column: 13},
						end: {line: 173, column: 23}
					})('branch \'_\' not implemented');
		}
	});
var $elm$svg$Svg$Attributes$color = _VirtualDom_attribute('color');
var $author$project$Pclock$drawclock = function (cs) {
	switch (cs) {
		case 0:
			return A2(
				$elm$svg$Svg$circle,
				_List_fromArray(
					[
						$elm$svg$Svg$Attributes$cx('800'),
						$elm$svg$Svg$Attributes$cy('100'),
						$elm$svg$Svg$Attributes$r('30'),
						$elm$svg$Svg$Attributes$fillOpacity('0.0'),
						$elm$svg$Svg$Attributes$color('#FFF'),
						$elm$svg$Svg$Attributes$stroke('#000'),
						$elm$svg$Svg$Attributes$strokeWidth('4px')
					]),
				_List_Nil);
		case 1:
			return A2(
				$elm$svg$Svg$circle,
				_List_fromArray(
					[
						$elm$svg$Svg$Attributes$cx('800'),
						$elm$svg$Svg$Attributes$cy('400'),
						$elm$svg$Svg$Attributes$r('300'),
						$elm$svg$Svg$Attributes$fillOpacity('0.0'),
						$elm$svg$Svg$Attributes$color('#FFF'),
						$elm$svg$Svg$Attributes$stroke('#000'),
						$elm$svg$Svg$Attributes$strokeWidth('4px')
					]),
				_List_Nil);
		default:
			return _Debug_todo(
				'Pclock',
				{
					start: {line: 77, column: 13},
					end: {line: 77, column: 23}
				})('branch \'_\' not implemented');
	}
};
var $elm$core$String$concat = function (strings) {
	return A2($elm$core$String$join, '', strings);
};
var $elm$svg$Svg$ellipse = $elm$svg$Svg$trustedNode('ellipse');
var $author$project$Pclock$hourangle = F2(
	function (hour, minute) {
		return (A2($elm$core$Basics$modBy, 12, hour) * 30) + (minute / 2);
	});
var $elm$svg$Svg$Attributes$ry = _VirtualDom_attribute('ry');
var $elm$svg$Svg$Attributes$transform = _VirtualDom_attribute('transform');
var $author$project$Pclock$drawhourhand = F2(
	function (cs, clock) {
		switch (cs) {
			case 0:
				return A2(
					$elm$svg$Svg$ellipse,
					_List_fromArray(
						[
							$elm$svg$Svg$Attributes$cx('808'),
							$elm$svg$Svg$Attributes$cy('100'),
							$elm$svg$Svg$Attributes$rx('8'),
							$elm$svg$Svg$Attributes$ry('2'),
							$elm$svg$Svg$Attributes$transform(
							$elm$core$String$concat(
								_List_fromArray(
									[
										'rotate(',
										$elm$core$String$fromFloat(
										A2($author$project$Pclock$hourangle, clock.hour, clock.minute) - 90),
										' ',
										'800',
										' ',
										'100)'
									])))
						]),
					_List_Nil);
			case 1:
				return A2(
					$elm$svg$Svg$ellipse,
					_List_fromArray(
						[
							$elm$svg$Svg$Attributes$cx('869'),
							$elm$svg$Svg$Attributes$cy('400'),
							$elm$svg$Svg$Attributes$rx('80'),
							$elm$svg$Svg$Attributes$ry('10'),
							$elm$svg$Svg$Attributes$transform(
							$elm$core$String$concat(
								_List_fromArray(
									[
										'rotate(',
										$elm$core$String$fromFloat(
										A2($author$project$Pclock$hourangle, clock.hour, clock.minute) - 90),
										' ',
										'800',
										' ',
										'400)'
									]))),
							$elm$svg$Svg$Events$onClick(
							$author$project$Messages$OnClickTriggers(1))
						]),
					_List_Nil);
			default:
				return _Debug_todo(
					'Pclock',
					{
						start: {line: 105, column: 13},
						end: {line: 105, column: 23}
					})('branch \'_\' not implemented');
		}
	});
var $author$project$Pclock$minuteangle = function (minute) {
	return minute * 6;
};
var $author$project$Pclock$drawminutehand = F2(
	function (cs, clock) {
		switch (cs) {
			case 0:
				return A2(
					$elm$svg$Svg$ellipse,
					_List_fromArray(
						[
							$elm$svg$Svg$Attributes$cx('810'),
							$elm$svg$Svg$Attributes$cy('100'),
							$elm$svg$Svg$Attributes$rx('12'),
							$elm$svg$Svg$Attributes$ry('2'),
							$elm$svg$Svg$Attributes$transform(
							$elm$core$String$concat(
								_List_fromArray(
									[
										'rotate(',
										$elm$core$String$fromFloat(
										$author$project$Pclock$minuteangle(clock.minute) - 90),
										' ',
										'800',
										' ',
										'100)'
									])))
						]),
					_List_Nil);
			case 1:
				return A2(
					$elm$svg$Svg$ellipse,
					_List_fromArray(
						[
							$elm$svg$Svg$Attributes$cx('910'),
							$elm$svg$Svg$Attributes$cy('400'),
							$elm$svg$Svg$Attributes$rx('120'),
							$elm$svg$Svg$Attributes$ry('10'),
							$elm$svg$Svg$Attributes$transform(
							$elm$core$String$concat(
								_List_fromArray(
									[
										'rotate(',
										$elm$core$String$fromFloat(
										$author$project$Pclock$minuteangle(clock.minute) - 90),
										' ',
										'800',
										' ',
										'400)'
									]))),
							$elm$svg$Svg$Events$onClick(
							$author$project$Messages$OnClickTriggers(0))
						]),
					_List_Nil);
			default:
				return _Debug_todo(
					'Pclock',
					{
						start: {line: 133, column: 13},
						end: {line: 133, column: 23}
					})('branch \'_\' not implemented');
		}
	});
var $author$project$Ppower$drawpowersupply_0 = _List_fromArray(
	[
		A2(
		$elm$svg$Svg$rect,
		_List_fromArray(
			[
				$elm$svg$Svg$Attributes$x('1500'),
				$elm$svg$Svg$Attributes$y('100'),
				$elm$svg$Svg$Attributes$width('50'),
				$elm$svg$Svg$Attributes$height('50'),
				$elm$svg$Svg$Attributes$fill('yellow'),
				$elm$svg$Svg$Attributes$rx('15'),
				$elm$svg$Svg$Events$onClick(
				$author$project$Messages$StartChange(
					$author$project$Messages$ChangeScene(6)))
			]),
		_List_Nil)
	]);
var $author$project$Ppower$drawpowersupply_6_cover = _List_fromArray(
	[
		A2(
		$elm$svg$Svg$rect,
		_List_fromArray(
			[
				$elm$svg$Svg$Attributes$x('500'),
				$elm$svg$Svg$Attributes$y('100'),
				$elm$svg$Svg$Attributes$width('400'),
				$elm$svg$Svg$Attributes$height('500'),
				$elm$svg$Svg$Attributes$fill('white'),
				$elm$svg$Svg$Attributes$stroke('black'),
				$elm$svg$Svg$Attributes$strokeWidth('4')
			]),
		_List_Nil),
		A2(
		$elm$svg$Svg$rect,
		_List_fromArray(
			[
				$elm$svg$Svg$Attributes$x('490'),
				$elm$svg$Svg$Attributes$y('200'),
				$elm$svg$Svg$Attributes$width('20'),
				$elm$svg$Svg$Attributes$height('50'),
				$elm$svg$Svg$Attributes$fill('black')
			]),
		_List_Nil),
		A2(
		$elm$svg$Svg$rect,
		_List_fromArray(
			[
				$elm$svg$Svg$Attributes$x('490'),
				$elm$svg$Svg$Attributes$y('400'),
				$elm$svg$Svg$Attributes$width('20'),
				$elm$svg$Svg$Attributes$height('50'),
				$elm$svg$Svg$Attributes$fill('black')
			]),
		_List_Nil),
		A2(
		$elm$svg$Svg$polygon,
		_List_fromArray(
			[
				$elm$svg$Svg$Attributes$points('680,250 650,380 680,380 650,460 730,350 680,350 730,250 '),
				$elm$svg$Svg$Attributes$fill('yellow'),
				$elm$svg$Svg$Attributes$stroke('black'),
				$elm$svg$Svg$Attributes$strokeWidth('2')
			]),
		_List_Nil),
		A2(
		$elm$svg$Svg$circle,
		_List_fromArray(
			[
				$elm$svg$Svg$Attributes$cx('850'),
				$elm$svg$Svg$Attributes$cy('350'),
				$elm$svg$Svg$Attributes$r('20'),
				$elm$svg$Svg$Attributes$fill('white'),
				$elm$svg$Svg$Attributes$stroke('black'),
				$elm$svg$Svg$Attributes$strokeWidth('2'),
				$elm$svg$Svg$Events$onClick(
				$author$project$Messages$OnClickTriggers(0))
			]),
		_List_Nil),
		A2(
		$elm$svg$Svg$rect,
		_List_fromArray(
			[
				$elm$svg$Svg$Attributes$x('848'),
				$elm$svg$Svg$Attributes$y('335'),
				$elm$svg$Svg$Attributes$width('4'),
				$elm$svg$Svg$Attributes$height('30'),
				$elm$svg$Svg$Attributes$fill('black'),
				$elm$svg$Svg$Events$onClick(
				$author$project$Messages$OnClickTriggers(0))
			]),
		_List_Nil)
	]);
var $author$project$Messages$Charge = function (a) {
	return {$: 'Charge', a: a};
};
var $author$project$Ppower$drawswitch = function (state) {
	if (state.$ === 'Low') {
		return _List_fromArray(
			[
				A2(
				$elm$svg$Svg$rect,
				_List_fromArray(
					[
						$elm$svg$Svg$Attributes$x('830'),
						$elm$svg$Svg$Attributes$y('410'),
						$elm$svg$Svg$Attributes$width('140'),
						$elm$svg$Svg$Attributes$height('30'),
						$elm$svg$Svg$Attributes$fill('black'),
						$elm$svg$Svg$Events$onClick(
						$author$project$Messages$Charge(0))
					]),
				_List_Nil),
				A2(
				$elm$svg$Svg$polygon,
				_List_fromArray(
					[
						$elm$svg$Svg$Attributes$points('860,440 875,440 875,480 925,480 925,440 940,440, 940,495 860,495'),
						$elm$svg$Svg$Attributes$fill('black'),
						$elm$svg$Svg$Events$onClick(
						$author$project$Messages$Charge(0))
					]),
				_List_Nil)
			]);
	} else {
		return _List_fromArray(
			[
				A2(
				$elm$svg$Svg$rect,
				_List_fromArray(
					[
						$elm$svg$Svg$Attributes$x('830'),
						$elm$svg$Svg$Attributes$y('230'),
						$elm$svg$Svg$Attributes$width('140'),
						$elm$svg$Svg$Attributes$height('30'),
						$elm$svg$Svg$Attributes$fill('black')
					]),
				_List_Nil),
				A2(
				$elm$svg$Svg$polygon,
				_List_fromArray(
					[
						$elm$svg$Svg$Attributes$points('860,230 875,230 875,190 925,190 925,230 940,230, 940,175 860,175'),
						$elm$svg$Svg$Attributes$fill('black')
					]),
				_List_Nil)
			]);
	}
};
var $author$project$Ppower$drawpowersupply_6_inner = function (state) {
	return _Utils_ap(
		_List_fromArray(
			[
				A2(
				$elm$svg$Svg$rect,
				_List_fromArray(
					[
						$elm$svg$Svg$Attributes$x('700'),
						$elm$svg$Svg$Attributes$y('100'),
						$elm$svg$Svg$Attributes$width('400'),
						$elm$svg$Svg$Attributes$height('500'),
						$elm$svg$Svg$Attributes$fill('silver'),
						$elm$svg$Svg$Attributes$stroke('black'),
						$elm$svg$Svg$Attributes$strokeWidth('4')
					]),
				_List_Nil),
				A2(
				$elm$svg$Svg$polygon,
				_List_fromArray(
					[
						$elm$svg$Svg$Attributes$points('700,100 500,200 500,700 700,600'),
						$elm$svg$Svg$Attributes$fill('silver'),
						$elm$svg$Svg$Attributes$stroke('black'),
						$elm$svg$Svg$Attributes$strokeWidth('4')
					]),
				_List_Nil),
				A2(
				$elm$svg$Svg$rect,
				_List_fromArray(
					[
						$elm$svg$Svg$Attributes$x('690'),
						$elm$svg$Svg$Attributes$y('200'),
						$elm$svg$Svg$Attributes$width('20'),
						$elm$svg$Svg$Attributes$height('50'),
						$elm$svg$Svg$Attributes$fill('black')
					]),
				_List_Nil),
				A2(
				$elm$svg$Svg$rect,
				_List_fromArray(
					[
						$elm$svg$Svg$Attributes$x('690'),
						$elm$svg$Svg$Attributes$y('400'),
						$elm$svg$Svg$Attributes$width('20'),
						$elm$svg$Svg$Attributes$height('50'),
						$elm$svg$Svg$Attributes$fill('black')
					]),
				_List_Nil),
				A2(
				$elm$svg$Svg$rect,
				_List_fromArray(
					[
						$elm$svg$Svg$Attributes$x('800'),
						$elm$svg$Svg$Attributes$y('200'),
						$elm$svg$Svg$Attributes$width('200'),
						$elm$svg$Svg$Attributes$height('300'),
						$elm$svg$Svg$Attributes$fill('orange'),
						$elm$svg$Svg$Attributes$stroke('black'),
						$elm$svg$Svg$Attributes$strokeWidth('2')
					]),
				_List_Nil),
				A2(
				$elm$svg$Svg$rect,
				_List_fromArray(
					[
						$elm$svg$Svg$Attributes$x('800'),
						$elm$svg$Svg$Attributes$y('200'),
						$elm$svg$Svg$Attributes$width('200'),
						$elm$svg$Svg$Attributes$height('30'),
						$elm$svg$Svg$Attributes$fill('brown')
					]),
				_List_Nil),
				A2(
				$elm$svg$Svg$rect,
				_List_fromArray(
					[
						$elm$svg$Svg$Attributes$x('800'),
						$elm$svg$Svg$Attributes$y('470'),
						$elm$svg$Svg$Attributes$width('200'),
						$elm$svg$Svg$Attributes$height('30'),
						$elm$svg$Svg$Attributes$fill('brown')
					]),
				_List_Nil),
				A2(
				$elm$svg$Svg$rect,
				_List_fromArray(
					[
						$elm$svg$Svg$Attributes$x('845'),
						$elm$svg$Svg$Attributes$y('230'),
						$elm$svg$Svg$Attributes$width('10'),
						$elm$svg$Svg$Attributes$height('180'),
						$elm$svg$Svg$Attributes$fill('black')
					]),
				_List_Nil),
				A2(
				$elm$svg$Svg$rect,
				_List_fromArray(
					[
						$elm$svg$Svg$Attributes$x('890'),
						$elm$svg$Svg$Attributes$y('230'),
						$elm$svg$Svg$Attributes$width('20'),
						$elm$svg$Svg$Attributes$height('180'),
						$elm$svg$Svg$Attributes$fill('black')
					]),
				_List_Nil),
				A2(
				$elm$svg$Svg$rect,
				_List_fromArray(
					[
						$elm$svg$Svg$Attributes$x('945'),
						$elm$svg$Svg$Attributes$y('230'),
						$elm$svg$Svg$Attributes$width('10'),
						$elm$svg$Svg$Attributes$height('180'),
						$elm$svg$Svg$Attributes$fill('black')
					]),
				_List_Nil)
			]),
		$author$project$Ppower$drawswitch(state));
};
var $author$project$Ppower$drawpowersupply_6 = function (model) {
	var _v0 = model.subscene;
	switch (_v0) {
		case 1:
			return $author$project$Ppower$drawpowersupply_6_cover;
		case 2:
			return $author$project$Ppower$drawpowersupply_6_inner(model.state);
		default:
			return _Debug_todo(
				'Ppower',
				{
					start: {line: 113, column: 13},
					end: {line: 113, column: 23}
				})('branch \'_\' not implemented');
	}
};
var $author$project$Ppower$drawpowersupply = F3(
	function (model, cs, cle) {
		switch (cs) {
			case 0:
				return (!cle) ? $author$project$Ppower$drawpowersupply_0 : _List_Nil;
			case 6:
				return $author$project$Ppower$drawpowersupply_6(model);
			default:
				return _List_Nil;
		}
	});
var $author$project$Picture$render_picture_button = A2(
	$elm$svg$Svg$rect,
	_List_fromArray(
		[
			$elm$svg$Svg$Attributes$x('200'),
			$elm$svg$Svg$Attributes$y('270'),
			$elm$svg$Svg$Attributes$width('410'),
			$elm$svg$Svg$Attributes$height('180'),
			$elm$svg$Svg$Attributes$fill('red'),
			$elm$svg$Svg$Attributes$fillOpacity('0'),
			$elm$svg$Svg$Events$onClick(
			$author$project$Messages$StartChange(
				$author$project$Messages$ChangeScene(3)))
		]),
	_List_Nil);
var $author$project$View$render_object_inside = F4(
	function (scne, cle, obj, old) {
		var _new = function () {
			switch (obj.$) {
				case 'Clock':
					var a = obj.a;
					return _List_fromArray(
						[
							$author$project$Pclock$drawclock(scne),
							A2($author$project$Pclock$drawhourhand, scne, a),
							A2($author$project$Pclock$drawminutehand, scne, a)
						]);
				case 'Frame':
					var a = obj.a;
					return (cle === 1) ? _List_fromArray(
						[$author$project$Picture$render_picture_button]) : _List_Nil;
				case 'Computer':
					var a = obj.a;
					return (!cle) ? A3($author$project$Pcomputer$draw_computer, a, 0, cle) : _List_Nil;
				case 'Power':
					var a = obj.a;
					return (!cle) ? A3($author$project$Ppower$drawpowersupply, a, 0, cle) : _List_Nil;
				default:
					return _List_Nil;
			}
		}();
		return _Utils_ap(old, _new);
	});
var $author$project$Messages$DecideLegal = function (a) {
	return {$: 'DecideLegal', a: a};
};
var $author$project$Ptable$get_point = function (location) {
	return $elm$core$Debug$toString(location.x - (0.5 * $author$project$Ptable$blockLength)) + (',' + ($elm$core$Debug$toString(location.y - ($author$project$Ptable$twoOfSquare3 * $author$project$Ptable$blockLength)) + (' ' + ($elm$core$Debug$toString(location.x + (0.5 * $author$project$Ptable$blockLength)) + (',' + ($elm$core$Debug$toString(location.y - ($author$project$Ptable$twoOfSquare3 * $author$project$Ptable$blockLength)) + (' ' + ($elm$core$Debug$toString(location.x + $author$project$Ptable$blockLength) + (',' + ($elm$core$Debug$toString(location.y) + (' ' + ($elm$core$Debug$toString(location.x + (0.5 * $author$project$Ptable$blockLength)) + (',' + ($elm$core$Debug$toString(location.y + ($author$project$Ptable$twoOfSquare3 * $author$project$Ptable$blockLength)) + (' ' + ($elm$core$Debug$toString(location.x - (0.5 * $author$project$Ptable$blockLength)) + (',' + ($elm$core$Debug$toString(location.y + ($author$project$Ptable$twoOfSquare3 * $author$project$Ptable$blockLength)) + (' ' + ($elm$core$Debug$toString(location.x - $author$project$Ptable$blockLength) + (',' + $elm$core$Debug$toString(location.y))))))))))))))))))))));
};
var $author$project$Ptable$draw_single_block = function (block) {
	var y = block.anchor.y;
	var x = block.anchor.x;
	var color = function () {
		var _v0 = block.state;
		if (_v0.$ === 'Active') {
			return 'white';
		} else {
			return 'blue';
		}
	}();
	return A2(
		$elm$svg$Svg$polygon,
		_List_fromArray(
			[
				$elm$svg$Svg$Attributes$fill(color),
				$elm$svg$Svg$Attributes$strokeWidth('5'),
				$elm$svg$Svg$Attributes$points(
				$author$project$Ptable$get_point(block.anchor)),
				$elm$svg$Svg$Events$onClick(
				$author$project$Messages$DecideLegal(block.anchor))
			]),
		_List_Nil);
};
var $author$project$Ptable$draw_block = function (blockSet) {
	return A2($elm$core$List$map, $author$project$Ptable$draw_single_block, blockSet);
};
var $elm$svg$Svg$Attributes$opacity = _VirtualDom_attribute('opacity');
var $author$project$Pmirror$draw_frame = function (locationList) {
	var draw_single_frame = function (location) {
		return A2(
			$elm$svg$Svg$rect,
			_List_fromArray(
				[
					$elm$svg$Svg$Attributes$width(
					$elm$core$Debug$toString(100 - 4)),
					$elm$svg$Svg$Attributes$height(
					$elm$core$Debug$toString(100 - 4)),
					$elm$svg$Svg$Attributes$fill('Blue'),
					$elm$svg$Svg$Attributes$x(
					$elm$core$Debug$toString(location.x)),
					$elm$svg$Svg$Attributes$y(
					$elm$core$Debug$toString(location.y)),
					$elm$svg$Svg$Attributes$opacity('0.1')
				]),
			_List_Nil);
	};
	return A2($elm$core$List$map, draw_single_frame, locationList);
};
var $author$project$Memory$draw_frame_and_memory = function (list) {
	var draw_every_frag = F2(
		function (id, sta) {
			if (_Utils_eq(sta, $author$project$Memory$Locked)) {
				return _List_Nil;
			} else {
				switch (id) {
					case 0:
						return _List_fromArray(
							[
								A2(
								$elm$svg$Svg$rect,
								_List_fromArray(
									[
										$elm$svg$Svg$Attributes$x('100'),
										$elm$svg$Svg$Attributes$y('200'),
										$elm$svg$Svg$Attributes$width('100'),
										$elm$svg$Svg$Attributes$height('200'),
										$elm$svg$Svg$Attributes$fill('red'),
										$elm$svg$Svg$Attributes$fillOpacity('0.2'),
										$elm$svg$Svg$Attributes$stroke('red')
									]),
								_List_Nil)
							]);
					case 1:
						return _List_fromArray(
							[
								A2(
								$elm$svg$Svg$rect,
								_List_fromArray(
									[
										$elm$svg$Svg$Attributes$x('200'),
										$elm$svg$Svg$Attributes$y('200'),
										$elm$svg$Svg$Attributes$width('100'),
										$elm$svg$Svg$Attributes$height('200'),
										$elm$svg$Svg$Attributes$fill('red'),
										$elm$svg$Svg$Attributes$fillOpacity('0.2'),
										$elm$svg$Svg$Attributes$stroke('red')
									]),
								_List_Nil)
							]);
					default:
						return _List_Nil;
				}
			}
		});
	var draw_every_memory = function (memory) {
		return $elm$core$List$concat(
			A3($elm$core$List$map2, draw_every_frag, memory.need, memory.frag));
	};
	return $elm$core$List$concat(
		A2($elm$core$List$map, draw_every_memory, list));
};
var $author$project$Ppiano$keyWidth = 200.0;
var $author$project$Ppiano$draw_single_key = function (key) {
	var color = function () {
		var _v0 = key.keyState;
		if (_v0.$ === 'Up') {
			return 'Blue';
		} else {
			return 'Green';
		}
	}();
	return A2(
		$elm$svg$Svg$rect,
		_List_fromArray(
			[
				$elm$svg$Svg$Attributes$width(
				$elm$core$String$fromFloat($author$project$Ppiano$keyLength)),
				$elm$svg$Svg$Attributes$height(
				$elm$core$String$fromFloat($author$project$Ppiano$keyWidth)),
				$elm$svg$Svg$Attributes$x(
				$elm$core$String$fromFloat(key.anchor.x)),
				$elm$svg$Svg$Attributes$y(
				$elm$core$String$fromFloat(key.anchor.y)),
				$elm$svg$Svg$Attributes$fill(color),
				$elm$svg$Svg$Attributes$stroke('Pink'),
				$elm$svg$Svg$Attributes$strokeWidth('3'),
				$elm$html$Html$Events$onClick(
				$author$project$Messages$OnClickTriggers(key.index))
			]),
		_List_Nil);
};
var $author$project$Ppiano$draw_key_set = function (pianoKeySet) {
	return A2($elm$core$List$map, $author$project$Ppiano$draw_single_key, pianoKeySet);
};
var $elm$svg$Svg$Attributes$d = _VirtualDom_attribute('d');
var $elm$svg$Svg$Attributes$id = _VirtualDom_attribute('id');
var $elm$core$List$map5 = _List_map5;
var $elm$svg$Svg$path = $elm$svg$Svg$trustedNode('path');
var $author$project$Pmirror$draw_light = function (lightSet) {
	var y2 = A2(
		$elm$core$List$map,
		function (line) {
			return $elm$core$String$fromFloat(line.secondPoint.y);
		},
		lightSet);
	var y1 = A2(
		$elm$core$List$map,
		function (line) {
			return $elm$core$String$fromFloat(line.firstPoint.y);
		},
		lightSet);
	var x2 = A2(
		$elm$core$List$map,
		function (line) {
			return $elm$core$String$fromFloat(line.secondPoint.x);
		},
		lightSet);
	var x1 = A2(
		$elm$core$List$map,
		function (line) {
			return $elm$core$String$fromFloat(line.firstPoint.x);
		},
		lightSet);
	var command = A2(
		$elm$core$List$append,
		_List_fromArray(
			['M ']),
		A2(
			$elm$core$List$repeat,
			(-1) + $elm$core$List$length(lightSet),
			'L'));
	var path_argument = A3(
		$elm$core$List$foldr,
		$elm$core$Basics$append,
		'',
		A6(
			$elm$core$List$map5,
			F5(
				function (a, b, c, d, e) {
					return a + (' ' + (b + (' ' + (c + (' ' + ('L ' + (d + (' ' + (e + ' ')))))))));
				}),
			command,
			x1,
			y1,
			x2,
			y2));
	return $elm$core$List$singleton(
		A2(
			$elm$svg$Svg$path,
			_List_fromArray(
				[
					$elm$svg$Svg$Attributes$id('light'),
					$elm$svg$Svg$Attributes$d(path_argument),
					$elm$svg$Svg$Attributes$strokeWidth('2'),
					$elm$svg$Svg$Attributes$stroke('blue'),
					$elm$svg$Svg$Attributes$fill('none')
				]),
			_List_Nil));
};
var $author$project$Pmirror$draw_single_mirror = function (mirror) {
	var y2 = $elm$core$String$fromFloat(mirror.body.secondPoint.y);
	var y1 = $elm$core$String$fromFloat(mirror.body.firstPoint.y);
	var x2 = $elm$core$String$fromFloat(mirror.body.secondPoint.x);
	var x1 = $elm$core$String$fromFloat(mirror.body.firstPoint.x);
	return A2(
		$elm$svg$Svg$line,
		_List_fromArray(
			[
				$elm$svg$Svg$Attributes$x1(x1),
				$elm$svg$Svg$Attributes$x2(x2),
				$elm$svg$Svg$Attributes$y1(y1),
				$elm$svg$Svg$Attributes$y2(y2),
				$elm$svg$Svg$Attributes$stroke('blue'),
				$elm$svg$Svg$Attributes$strokeWidth('10'),
				$elm$html$Html$Events$onClick(
				$author$project$Messages$OnClickTriggers(mirror.index))
			]),
		_List_Nil);
};
var $author$project$Pmirror$draw_mirror = function (mirrorSet) {
	return A2($elm$core$List$map, $author$project$Pmirror$draw_single_mirror, mirrorSet);
};
var $author$project$Messages$BeginMemory = function (a) {
	return {$: 'BeginMemory', a: a};
};
var $author$project$View$render_frame_outline = F2(
	function (index, memo) {
		var eff = _Utils_eq(memo.state, $author$project$Memory$Unlocked) ? $author$project$Messages$StartChange(
			$author$project$Messages$BeginMemory(index)) : $author$project$Messages$OnClickTriggers(index);
		if (!index) {
			return _List_fromArray(
				[
					A2(
					$elm$svg$Svg$rect,
					_List_fromArray(
						[
							$elm$svg$Svg$Attributes$x('100'),
							$elm$svg$Svg$Attributes$y('200'),
							$elm$svg$Svg$Attributes$width('200'),
							$elm$svg$Svg$Attributes$height('200'),
							$elm$svg$Svg$Attributes$fill('red'),
							$elm$svg$Svg$Attributes$fillOpacity('0.2'),
							$elm$svg$Svg$Attributes$stroke('red'),
							$elm$svg$Svg$Events$onClick(eff)
						]),
					_List_Nil)
				]);
		} else {
			return _List_Nil;
		}
	});
var $author$project$View$render_object_only = F3(
	function (model, cs, objects) {
		var tar = A2($author$project$Model$list_index_object, cs - 1, objects);
		switch (tar.$) {
			case 'Mirror':
				var a = tar.a;
				return _Utils_ap(
					$author$project$Pmirror$draw_frame(a.frame),
					_Utils_ap(
						$author$project$Pmirror$draw_mirror(a.mirrorSet),
						$author$project$Pmirror$draw_light(a.lightSet)));
			case 'Clock':
				var a = tar.a;
				return _List_fromArray(
					[
						$author$project$Pclock$drawclock(cs),
						A2($author$project$Pclock$drawhourhand, cs, a),
						A2($author$project$Pclock$drawminutehand, cs, a)
					]);
			case 'Table':
				var a = tar.a;
				return $author$project$Ptable$draw_block(a.blockSet);
			case 'Frame':
				var a = tar.a;
				return _Utils_ap(
					$author$project$Memory$draw_frame_and_memory(model.memory),
					$elm$core$List$concat(
						A3(
							$elm$core$List$map2,
							$author$project$View$render_frame_outline,
							_List_fromArray(
								[0]),
							model.memory)));
			case 'Computer':
				var a = tar.a;
				return A3($author$project$Pcomputer$draw_computer, a, 5, model.cscreen.clevel);
			case 'Power':
				var a = tar.a;
				return A3($author$project$Ppower$drawpowersupply, a, 6, model.cscreen.clevel);
			case 'Piano':
				var a = tar.a;
				return $author$project$Ppiano$draw_key_set(a.pianoKeySet);
			default:
				var a = tar.a;
				return _List_fromArray(
					[
						A2(
						$elm$svg$Svg$text_,
						_List_Nil,
						_List_fromArray(
							[
								$elm$svg$Svg$text('aba')
							]))
					]);
		}
	});
var $author$project$Pbulb$drawlight = function (bulb) {
	var tp = $elm$core$String$concat(
		_List_fromArray(
			[
				$elm$core$String$fromInt(20 * bulb.position.a),
				'%'
			]));
	var number = bulb.position.b + (3 * (bulb.position.a - 1));
	var lp = $elm$core$String$concat(
		_List_fromArray(
			[
				$elm$core$String$fromInt(10 * bulb.position.b),
				'%'
			]));
	var color = function () {
		var _v0 = bulb.color;
		if (_v0.$ === 'Red') {
			return 'red';
		} else {
			return '#000';
		}
	}();
	return A2(
		$elm$html$Html$button,
		_List_fromArray(
			[
				A2($elm$html$Html$Attributes$style, 'position', 'absolute'),
				A2($elm$html$Html$Attributes$style, 'top', tp),
				A2($elm$html$Html$Attributes$style, 'left', lp),
				A2($elm$html$Html$Attributes$style, 'height', '10%'),
				A2($elm$html$Html$Attributes$style, 'width', '5%'),
				A2($elm$html$Html$Attributes$style, 'background', color),
				A2($elm$html$Html$Attributes$style, 'border-radius', '50%'),
				$elm$html$Html$Events$onClick(
				$author$project$Messages$OnClickTriggers(number))
			]),
		_List_Nil);
};
var $author$project$Pbulb$render_bulb = F2(
	function (cs, model) {
		if (cs === 8) {
			return A2($elm$core$List$map, $author$project$Pbulb$drawlight, model.bulb);
		} else {
			return _List_Nil;
		}
	});
var $author$project$View$render_object_only_html = F2(
	function (cs, objs) {
		var tar = A2($author$project$Model$list_index_object, cs - 1, objs);
		if (tar.$ === 'Bul') {
			var a = tar.a;
			return _Utils_ap(
				A2($author$project$Pbulb$render_bulb, 8, a),
				_List_fromArray(
					[
						$elm$html$Html$text('sdfgh')
					]));
		} else {
			return _List_Nil;
		}
	});
var $author$project$View$render_picture_index = function (index) {
	switch (index) {
		case 0:
			return A2(
				$elm$svg$Svg$rect,
				_List_fromArray(
					[
						$elm$svg$Svg$Attributes$x('1300'),
						$elm$svg$Svg$Attributes$y('400'),
						$elm$svg$Svg$Attributes$width('100'),
						$elm$svg$Svg$Attributes$height('30'),
						$elm$svg$Svg$Attributes$fill('red'),
						$elm$svg$Svg$Events$onClick(
						A2($author$project$Messages$OnClickItem, 0, 0))
					]),
				_List_Nil);
		case 1:
			return A2(
				$elm$svg$Svg$rect,
				_List_fromArray(
					[
						$elm$svg$Svg$Attributes$x('1400'),
						$elm$svg$Svg$Attributes$y('600'),
						$elm$svg$Svg$Attributes$width('100'),
						$elm$svg$Svg$Attributes$height('30'),
						$elm$svg$Svg$Attributes$fill('red'),
						$elm$svg$Svg$Events$onClick(
						A2($author$project$Messages$OnClickItem, 1, 0))
					]),
				_List_Nil);
		case 2:
			return A2(
				$elm$svg$Svg$rect,
				_List_fromArray(
					[
						$elm$svg$Svg$Attributes$x('1400'),
						$elm$svg$Svg$Attributes$y('600'),
						$elm$svg$Svg$Attributes$width('100'),
						$elm$svg$Svg$Attributes$height('30'),
						$elm$svg$Svg$Attributes$fill('red'),
						$elm$svg$Svg$Events$onClick(
						A2($author$project$Messages$OnClickItem, 2, 0))
					]),
				_List_Nil);
		default:
			return A2($elm$svg$Svg$rect, _List_Nil, _List_Nil);
	}
};
var $author$project$View$render_picture = function (list) {
	var render_pict_inside = function (pict) {
		return _Utils_eq(pict.state, $author$project$Picture$Show) ? $author$project$View$render_picture_index(pict.index) : A2($elm$svg$Svg$rect, _List_Nil, _List_Nil);
	};
	return A2($elm$core$List$map, render_pict_inside, list);
};
var $author$project$Memory$default_memory = A4(
	$author$project$Memory$Memory,
	0,
	$author$project$Memory$Locked,
	_List_fromArray(
		[$author$project$Memory$Locked, $author$project$Memory$Locked]),
	_List_fromArray(
		[0, 1]));
var $author$project$Memory$list_index_memory = F2(
	function (index, list) {
		list_index_memory:
		while (true) {
			if (_Utils_cmp(
				index,
				$elm$core$List$length(list)) > 0) {
				return $author$project$Memory$default_memory;
			} else {
				if (list.b) {
					var x = list.a;
					var xs = list.b;
					if (!index) {
						return x;
					} else {
						var $temp$index = index - 1,
							$temp$list = xs;
						index = $temp$index;
						list = $temp$list;
						continue list_index_memory;
					}
				} else {
					return $author$project$Memory$default_memory;
				}
			}
		}
	});
var $author$project$View$render_test_information = function (model) {
	var under = _Utils_eq(model.underUse, $author$project$Inventory$Blank) ? 'Blank' : 'Have';
	var show4 = $elm$core$Debug$toString(model.inventory.num);
	var show3 = $elm$core$Debug$toString(model.cscreen.cscene);
	var fram = A2($author$project$Memory$list_index_memory, 0, model.memory);
	var show2 = _Utils_eq(fram.state, $author$project$Memory$Locked) ? 'Locked' : 'Unlocked';
	return _List_fromArray(
		[
			A2(
			$elm$svg$Svg$text_,
			_List_fromArray(
				[
					$elm$svg$Svg$Attributes$x('100'),
					$elm$svg$Svg$Attributes$y('200')
				]),
			_List_fromArray(
				[
					$elm$svg$Svg$text(under + (' ' + (show2 + (' ' + (show3 + (' ' + show4))))))
				]))
		]);
};
var $elm$svg$Svg$svg = $elm$svg$Svg$trustedNode('svg');
var $elm$svg$Svg$Attributes$viewBox = _VirtualDom_attribute('viewBox');
var $author$project$View$render_object = function (model) {
	return A2(
		$elm$svg$Svg$svg,
		_List_fromArray(
			[
				$elm$svg$Svg$Attributes$width('100%'),
				$elm$svg$Svg$Attributes$height('100%'),
				$elm$svg$Svg$Attributes$viewBox('0 0 1600 900')
			]),
		_Utils_ap(
			function () {
				if (!model.cscreen.cscene) {
					var _v0 = model.cscreen.clevel;
					switch (_v0) {
						case 0:
							return _Utils_ap(
								$author$project$Level0$level_0_furniture,
								A3(
									$elm$core$List$foldr,
									A2($author$project$View$render_object_inside, model.cscreen.cscene, model.cscreen.clevel),
									_List_Nil,
									model.objects));
						case 1:
							return _Utils_ap(
								$author$project$Furnitures$level_1_furniture,
								A3(
									$elm$core$List$foldr,
									A2($author$project$View$render_object_inside, model.cscreen.cscene, model.cscreen.clevel),
									_List_Nil,
									model.objects));
						default:
							return A3(
								$elm$core$List$foldr,
								A2($author$project$View$render_object_inside, model.cscreen.cscene, model.cscreen.clevel),
								_List_Nil,
								model.objects);
					}
				} else {
					return _Utils_ap(
						$author$project$View$render_picture(model.pictures),
						_Utils_ap(
							A3($author$project$View$render_object_only, model, model.cscreen.cscene, model.objects),
							_Utils_ap(
								A2($author$project$View$render_object_only_html, model.cscreen.cscene, model.objects),
								$author$project$View$render_test_information(model))));
				}
			}(),
			$author$project$Inventory$render_inventory(model.inventory)));
};
var $author$project$View$render_level = function (model) {
	return _Utils_ap(
		_List_fromArray(
			[
				$author$project$View$render_object(model)
			]),
		$author$project$View$render_button_level(model.cscreen.clevel));
};
var $author$project$Memory$Dialogue = {$: 'Dialogue'};
var $author$project$Memory$Page = F5(
	function (content, speaker, backPict, figure, act) {
		return {act: act, backPict: backPict, content: content, figure: figure, speaker: speaker};
	});
var $author$project$Memory$default_page = A5($author$project$Memory$Page, 'test', 'Maria', 'none', 'none', $author$project$Memory$Dialogue);
var $author$project$Memory$list_index_page = F2(
	function (index, list) {
		list_index_page:
		while (true) {
			if (_Utils_cmp(
				index,
				$elm$core$List$length(list)) > 0) {
				return $author$project$Memory$default_page;
			} else {
				if (list.b) {
					var x = list.a;
					var xs = list.b;
					if (!index) {
						return x;
					} else {
						var $temp$index = index - 1,
							$temp$list = xs;
						index = $temp$index;
						list = $temp$list;
						continue list_index_page;
					}
				} else {
					return $author$project$Memory$default_page;
				}
			}
		}
	});
var $author$project$Messages$EndMemory = {$: 'EndMemory'};
var $author$project$Messages$Forward = {$: 'Forward'};
var $author$project$Messages$Choice = F2(
	function (a, b) {
		return {$: 'Choice', a: a, b: b};
	});
var $elm$svg$Svg$Attributes$fontFamily = _VirtualDom_attribute('font-family');
var $author$project$Memory$svg_text = F5(
	function (x_, y_, wid, hei, content) {
		return A2(
			$elm$svg$Svg$text_,
			_List_fromArray(
				[
					$elm$svg$Svg$Attributes$x(
					$elm$core$Debug$toString(x_)),
					$elm$svg$Svg$Attributes$y(
					$elm$core$Debug$toString(y_)),
					$elm$svg$Svg$Attributes$width(
					$elm$core$Debug$toString(wid)),
					$elm$svg$Svg$Attributes$height(
					$elm$core$Debug$toString(hei)),
					$elm$svg$Svg$Attributes$fontSize('30'),
					$elm$svg$Svg$Attributes$fontFamily('Times New Roman')
				]),
			_List_fromArray(
				[
					$elm$svg$Svg$text(content)
				]));
	});
var $author$project$Memory$svg_tran_button = F5(
	function (x_, y_, wid, hei, eff) {
		return A2(
			$elm$svg$Svg$rect,
			_List_fromArray(
				[
					$elm$svg$Svg$Attributes$x(
					$elm$core$Debug$toString(x_)),
					$elm$svg$Svg$Attributes$y(
					$elm$core$Debug$toString(y_)),
					$elm$svg$Svg$Attributes$width(
					$elm$core$Debug$toString(wid)),
					$elm$svg$Svg$Attributes$height(
					$elm$core$Debug$toString(hei)),
					$elm$svg$Svg$Attributes$fill('white'),
					$elm$svg$Svg$Attributes$fillOpacity('0.5'),
					$elm$svg$Svg$Attributes$strokeWidth('1'),
					$elm$svg$Svg$Attributes$stroke('black'),
					$elm$svg$Svg$Events$onClick(eff)
				]),
			_List_Nil);
	});
var $author$project$Memory$render_choice = F2(
	function (index, page) {
		var _v0 = function () {
			if (!index) {
				return _Utils_Tuple3('A story about ideal love', 'A fantastic novel', 'autobiography');
			} else {
				return _Utils_Tuple3('', '', '');
			}
		}();
		var ca = _v0.a;
		var cb = _v0.b;
		var cc = _v0.c;
		return _List_fromArray(
			[
				A2(
				$elm$html$Html$embed,
				_List_fromArray(
					[
						$elm$html$Html$Attributes$type_('image/png'),
						$elm$html$Html$Attributes$src(page.backPict),
						A2($elm$html$Html$Attributes$style, 'top', '20%'),
						A2($elm$html$Html$Attributes$style, 'left', '0%'),
						A2($elm$html$Html$Attributes$style, 'width', '100%'),
						A2($elm$html$Html$Attributes$style, 'height', '100%'),
						A2($elm$html$Html$Attributes$style, 'position', 'absolute')
					]),
				_List_Nil),
				A2(
				$elm$html$Html$div,
				_List_fromArray(
					[
						A2($elm$html$Html$Attributes$style, 'width', '100%'),
						A2($elm$html$Html$Attributes$style, 'height', '100%'),
						A2($elm$html$Html$Attributes$style, 'position', 'absolute')
					]),
				_List_fromArray(
					[
						A2(
						$elm$svg$Svg$svg,
						_List_fromArray(
							[
								$elm$svg$Svg$Attributes$width('100%'),
								$elm$svg$Svg$Attributes$height('100%'),
								$elm$svg$Svg$Attributes$viewBox('0 0 1600 900')
							]),
						_List_fromArray(
							[
								A5(
								$author$project$Memory$svg_tran_button,
								700,
								300,
								200,
								60,
								$author$project$Messages$StartChange(
									A2($author$project$Messages$Choice, index, 0))),
								A5(
								$author$project$Memory$svg_tran_button,
								700,
								400,
								200,
								60,
								$author$project$Messages$StartChange(
									A2($author$project$Messages$Choice, index, 1))),
								A5(
								$author$project$Memory$svg_tran_button,
								700,
								500,
								200,
								60,
								$author$project$Messages$StartChange(
									A2($author$project$Messages$Choice, index, 2))),
								A5($author$project$Memory$svg_text, 700, 300, 200, 60, ca),
								A5($author$project$Memory$svg_text, 700, 400, 200, 60, cb),
								A5($author$project$Memory$svg_text, 700, 500, 200, 60, cc)
							]))
					]))
			]);
	});
var $elm$core$Basics$round = _Basics_round;
var $author$project$Memory$svg_rect = F4(
	function (x_, y_, wid, hei) {
		return A2(
			$elm$svg$Svg$rect,
			_List_fromArray(
				[
					$elm$svg$Svg$Attributes$x(
					$elm$core$Debug$toString(x_)),
					$elm$svg$Svg$Attributes$y(
					$elm$core$Debug$toString(y_)),
					$elm$svg$Svg$Attributes$width(
					$elm$core$Debug$toString(wid)),
					$elm$svg$Svg$Attributes$height(
					$elm$core$Debug$toString(hei)),
					$elm$svg$Svg$Attributes$fill('white'),
					$elm$svg$Svg$Attributes$fillOpacity('0.5'),
					$elm$svg$Svg$Attributes$strokeWidth('1'),
					$elm$svg$Svg$Attributes$stroke('black')
				]),
			_List_Nil);
	});
var $author$project$Memory$render_page = function (page) {
	var hei = 100;
	var wid = $elm$core$Basics$round((((hei / 16) / 16) * 7) * 9);
	var eff = function () {
		var _v1 = page.act;
		switch (_v1.$) {
			case 'Dialogue':
				return $author$project$Messages$StartChange($author$project$Messages$Forward);
			case 'End':
				return $author$project$Messages$StartChange($author$project$Messages$EndMemory);
			default:
				return $author$project$Messages$StartChange($author$project$Messages$Forward);
		}
	}();
	var _v0 = page.act;
	if (_v0.$ === 'Choose') {
		var a = _v0.a;
		return A2($author$project$Memory$render_choice, a, page);
	} else {
		return _List_fromArray(
			[
				A2(
				$elm$html$Html$embed,
				_List_fromArray(
					[
						$elm$html$Html$Attributes$type_('image/png'),
						$elm$html$Html$Attributes$src(page.backPict),
						A2($elm$html$Html$Attributes$style, 'top', '20%'),
						A2($elm$html$Html$Attributes$style, 'left', '0%'),
						A2($elm$html$Html$Attributes$style, 'width', '100%'),
						A2($elm$html$Html$Attributes$style, 'height', '100%'),
						A2($elm$html$Html$Attributes$style, 'position', 'absolute')
					]),
				_List_Nil),
				A2(
				$elm$html$Html$embed,
				_List_fromArray(
					[
						$elm$html$Html$Attributes$type_('image/png'),
						$elm$html$Html$Attributes$src(page.figure),
						A2($elm$html$Html$Attributes$style, 'bottom', '-4%'),
						A2($elm$html$Html$Attributes$style, 'left', '25%'),
						A2(
						$elm$html$Html$Attributes$style,
						'width',
						$elm$core$Debug$toString(wid) + '%'),
						A2(
						$elm$html$Html$Attributes$style,
						'height',
						$elm$core$Debug$toString(hei) + '%'),
						A2($elm$html$Html$Attributes$style, 'position', 'absolute')
					]),
				_List_Nil),
				A2(
				$elm$html$Html$div,
				_List_fromArray(
					[
						A2($elm$html$Html$Attributes$style, 'top', '58%'),
						A2($elm$html$Html$Attributes$style, 'left', '0%'),
						A2($elm$html$Html$Attributes$style, 'width', '100%'),
						A2($elm$html$Html$Attributes$style, 'height', '42%'),
						A2($elm$html$Html$Attributes$style, 'position', 'absolute')
					]),
				_List_fromArray(
					[
						A2(
						$elm$svg$Svg$svg,
						_List_fromArray(
							[
								$elm$svg$Svg$Attributes$width('100%'),
								$elm$svg$Svg$Attributes$height('100%'),
								$elm$svg$Svg$Attributes$viewBox('0 0 1000 420')
							]),
						_List_fromArray(
							[
								A4($author$project$Memory$svg_rect, 0, 70, 1000, 300),
								A4($author$project$Memory$svg_rect, 50, 40, 150, 60),
								A5($author$project$Memory$svg_text, 50, 160, 500, 300, page.content),
								A5($author$project$Memory$svg_text, 70, 80, 150, 60, page.speaker)
							])),
						$author$project$Button$trans_button_sq(
						A7($author$project$Button$Button, 0, 0, 100, 100, '', eff, 'block'))
					]))
			]);
	}
};
var $author$project$Memory$Choose = function (a) {
	return {$: 'Choose', a: a};
};
var $author$project$Memory$End = {$: 'End'};
var $author$project$Memory$textBase_0 = _List_fromArray(
	[
		A5($author$project$Memory$Page, 'So I\'m in a cafe, lots of customers.', 'I', 'assets/wall1.png', 'assets/girl1.png', $author$project$Memory$Dialogue),
		A5($author$project$Memory$Page, 'Wait, it seems that Maria is there. She is merged in something. ', 'I', 'assets/wall1.png', 'assets/girl1.png', $author$project$Memory$Dialogue),
		A5($author$project$Memory$Page, 'Oh, I was told that she is a freelancer before.', 'I', 'assets/wall1.png', 'assets/girl1.png', $author$project$Memory$Dialogue),
		A5($author$project$Memory$Page, 'So what kind of thing is she working on?', 'I', 'assets/wall1.png', 'assets/girl1.png', $author$project$Memory$Dialogue),
		A5(
		$author$project$Memory$Page,
		'',
		'',
		'assets/wall1.png',
		'',
		$author$project$Memory$Choose(0)),
		A5($author$project$Memory$Page, 'Well, it isn’t mandatory to tell others my idea, but if you are really interested in.', 'Maira', 'assets/wall1.png', 'assets/girl1.png', $author$project$Memory$Dialogue),
		A5($author$project$Memory$Page, 'After I expressed my strong will, Maria continued.', 'Maira', 'assets/wall1.png', 'assets/girl1.png', $author$project$Memory$Dialogue),
		A5($author$project$Memory$Page, 'It’s a story for my ideal love, exactly. ', 'Maira', 'assets/wall1.png', 'assets/girl1.png', $author$project$Memory$Dialogue),
		A5($author$project$Memory$Page, 'After breaking out with him, I always think about it.', 'Maira', 'assets/wall1.png', 'assets/girl1.png', $author$project$Memory$Dialogue),
		A5($author$project$Memory$Page, 'Why I failed to hold love, or, what should it look like? ', 'Maira', 'assets/wall1.png', 'assets/girl1.png', $author$project$Memory$Dialogue),
		A5($author$project$Memory$Page, 'End', 'I', 'assets/wall1.png', 'assets/girl1.png', $author$project$Memory$End),
		A5($author$project$Memory$Page, 'Wait', 'I', '', '', $author$project$Memory$End)
	]);
var $author$project$Memory$render_memory = F2(
	function (cm, cp) {
		var needText = function () {
			if (!cm) {
				return $author$project$Memory$textBase_0;
			} else {
				return _List_Nil;
			}
		}();
		var needPage = A2($author$project$Memory$list_index_page, cp, needText);
		return $author$project$Memory$render_page(needPage);
	});
var $author$project$Messages$Achievement = {$: 'Achievement'};
var $author$project$Messages$MovePage = function (a) {
	return {$: 'MovePage', a: a};
};
var $author$project$Messages$Pause = {$: 'Pause'};
var $author$project$Messages$RecallMemory = {$: 'RecallMemory'};
var $author$project$Messages$Reset = {$: 'Reset'};
var $author$project$View$render_ui_button = F2(
	function (cstate, model) {
		var testMemory = A7(
			$author$project$Button$Button,
			14,
			2,
			4,
			4,
			'test',
			$author$project$Messages$StartChange(
				$author$project$Messages$BeginMemory(0)),
			'block');
		var testBack = A7(
			$author$project$Button$Button,
			14,
			2,
			4,
			4,
			'main',
			$author$project$Messages$StartChange($author$project$Messages$EndMemory),
			'block');
		var reset = A7($author$project$Button$Button, 8, 2, 4, 4, 'Reset', $author$project$Messages$Reset, 'block');
		var prev = A7(
			$author$project$Button$Button,
			2.8,
			87.5,
			4.2,
			8,
			'Prev',
			$author$project$Messages$StartChange(
				$author$project$Messages$MovePage(-1)),
			'block');
		var pause = A7(
			$author$project$Button$Button,
			2.6,
			4.5,
			3.66,
			6.5,
			'Pause',
			$author$project$Messages$StartChange($author$project$Messages$Pause),
			'block');
		var next = A7(
			$author$project$Button$Button,
			8.5,
			87.5,
			5,
			8,
			'Next',
			$author$project$Messages$StartChange(
				$author$project$Messages$MovePage(1)),
			'block');
		var increase = A7($author$project$Button$Button, 88.75, 87.5, 4, 6, '+', $author$project$Messages$Increase, 'block');
		var enterMemory = A7(
			$author$project$Button$Button,
			40,
			20,
			20,
			10,
			'Memory',
			$author$project$Messages$StartChange($author$project$Messages$RecallMemory),
			'block');
		var decrease = A7($author$project$Button$Button, 93.75, 87.5, 4, 6, '-', $author$project$Messages$Decrease, 'block');
		var backAchi = A7(
			$author$project$Button$Button,
			2,
			2,
			4,
			4,
			'Back',
			$author$project$Messages$StartChange($author$project$Messages$Pause),
			'block');
		var back = A7(
			$author$project$Button$Button,
			2.6,
			4.5,
			3.66,
			6.5,
			'Back',
			$author$project$Messages$StartChange($author$project$Messages$Back),
			'block');
		var achieve = A7(
			$author$project$Button$Button,
			40,
			50,
			20,
			10,
			'Achievement',
			$author$project$Messages$StartChange($author$project$Messages$Achievement),
			'block');
		switch (cstate) {
			case 0:
				return _List_fromArray(
					[
						$author$project$Button$trans_button_sq(pause),
						$author$project$Button$test_button(reset),
						$author$project$Button$test_button(testMemory),
						$author$project$Button$test_button(increase),
						$author$project$Button$test_button(decrease)
					]);
			case 1:
				return _List_fromArray(
					[
						$author$project$Button$test_button(back),
						$author$project$Button$test_button(reset),
						$author$project$Button$test_button(enterMemory),
						$author$project$Button$test_button(achieve)
					]);
			case 2:
				return _List_fromArray(
					[
						$author$project$Button$trans_button_sq(back),
						$author$project$Button$trans_button_sq(next)
					]);
			case 3:
				return _List_fromArray(
					[
						$author$project$Button$trans_button_sq(next),
						$author$project$Button$trans_button_sq(prev),
						$author$project$Button$trans_button_sq(back)
					]);
			case 4:
				return _List_fromArray(
					[
						$author$project$Button$trans_button_sq(prev),
						$author$project$Button$trans_button_sq(back)
					]);
			case 10:
				return _List_fromArray(
					[
						$author$project$Button$test_button(backAchi)
					]);
			case 11:
				return _List_fromArray(
					[
						$author$project$Button$test_button(pause),
						$author$project$Button$test_button(reset),
						$author$project$Button$test_button(testMemory)
					]);
			case 12:
				return _List_fromArray(
					[
						$author$project$Button$test_button(pause),
						$author$project$Button$test_button(reset),
						$author$project$Button$test_button(testMemory)
					]);
			case 20:
				return _List_fromArray(
					[
						$author$project$Button$test_button(pause),
						$author$project$Button$test_button(reset),
						$author$project$Button$test_button(testBack)
					]);
			default:
				return _List_Nil;
		}
	});
var $author$project$View$style = $elm$html$Html$Attributes$style;
var $author$project$View$render_wall_1 = A2(
	$elm$html$Html$embed,
	_List_fromArray(
		[
			$elm$html$Html$Attributes$type_('image/png'),
			$elm$html$Html$Attributes$src('assets/wall1.png'),
			A2($author$project$View$style, 'top', '12%'),
			A2($author$project$View$style, 'left', '0%'),
			A2($author$project$View$style, 'width', '100%'),
			A2($author$project$View$style, 'height', '72%'),
			A2($author$project$View$style, 'position', 'absolute')
		]),
	_List_Nil);
var $author$project$View$view = function (model) {
	var gcontent = $author$project$Gradient$get_Gcontent(model.gradient);
	var bkgdColor = (model.cscreen.cstate === 20) ? '#ffffff' : '#ffffff';
	var _v0 = model.size;
	var w = _v0.a;
	var h = _v0.b;
	var _v1 = (_Utils_cmp((9 / 16) * w, h) > -1) ? _Utils_Tuple2((16 / 9) * h, h) : _Utils_Tuple2(w, (9 / 16) * w);
	var wid = _v1.a;
	var het = _v1.b;
	var _v2 = (_Utils_cmp((9 / 16) * w, h) > -1) ? _Utils_Tuple2(0.5 * (w - wid), 0) : _Utils_Tuple2(0, 0.5 * (h - het));
	var lef = _v2.a;
	var to = _v2.b;
	return A2(
		$elm$html$Html$div,
		_List_fromArray(
			[
				A2($author$project$View$style, 'width', '100%'),
				A2($author$project$View$style, 'height', '100%'),
				A2($author$project$View$style, 'position', 'absolute'),
				A2($author$project$View$style, 'left', '0'),
				A2($author$project$View$style, 'top', '0'),
				A2($author$project$View$style, 'background-color', '#000000')
			]),
		_List_fromArray(
			[
				_Utils_eq(gcontent, $author$project$Gradient$OnlyWord) ? A2(
				$elm$html$Html$div,
				_List_fromArray(
					[
						A2(
						$author$project$View$style,
						'width',
						$elm$core$String$fromFloat(wid) + 'px'),
						A2(
						$author$project$View$style,
						'height',
						$elm$core$String$fromFloat(het) + 'px'),
						A2($author$project$View$style, 'position', 'absolute'),
						A2(
						$author$project$View$style,
						'left',
						$elm$core$String$fromFloat(lef) + 'px'),
						A2(
						$author$project$View$style,
						'top',
						$elm$core$String$fromFloat(to) + 'px'),
						A2($author$project$View$style, 'background-color', bkgdColor)
					]),
				_List_Nil) : A2($elm$html$Html$div, _List_Nil, _List_Nil),
				A2(
				$elm$html$Html$div,
				_List_fromArray(
					[
						A2(
						$author$project$View$style,
						'width',
						$elm$core$String$fromFloat(wid) + 'px'),
						A2(
						$author$project$View$style,
						'height',
						$elm$core$String$fromFloat(het) + 'px'),
						A2($author$project$View$style, 'position', 'absolute'),
						A2(
						$author$project$View$style,
						'left',
						$elm$core$String$fromFloat(lef) + 'px'),
						A2(
						$author$project$View$style,
						'top',
						$elm$core$String$fromFloat(to) + 'px'),
						A2($author$project$View$style, 'background-color', bkgdColor),
						A2(
						$author$project$View$style,
						'opacity',
						$elm$core$Debug$toString(model.opac))
					]),
				function () {
					var _v3 = model.cscreen.cstate;
					switch (_v3) {
						case 98:
							return _List_fromArray(
								[
									$elm$html$Html$text('this is cover'),
									A2(
									$elm$html$Html$button,
									_List_fromArray(
										[
											$elm$html$Html$Events$onClick(
											$author$project$Messages$StartChange($author$project$Messages$EnterState))
										]),
									_List_fromArray(
										[
											$elm$html$Html$text('Enter')
										]))
								]);
						case 99:
							return $author$project$Intro$render_intro(model.intro);
						case 0:
							return _Utils_ap(
								_List_fromArray(
									[
										A2(
										$elm$html$Html$img,
										_List_fromArray(
											[
												$elm$html$Html$Attributes$src('assets/memory_menu.png'),
												A2($author$project$View$style, 'top', '0%'),
												A2($author$project$View$style, 'left', '0%'),
												A2($author$project$View$style, 'width', '100%'),
												A2($author$project$View$style, 'height', '100%'),
												A2($author$project$View$style, 'position', 'absolute')
											]),
										_List_Nil),
										A2(
										$elm$html$Html$div,
										_List_fromArray(
											[
												A2($author$project$View$style, 'width', '100%'),
												A2($author$project$View$style, 'height', '100%'),
												A2($author$project$View$style, 'position', 'absolute')
											]),
										(!model.cscreen.cscene) ? $author$project$View$render_level(model) : A2(
											$elm$core$List$cons,
											$author$project$View$render_object(model),
											_Utils_ap(
												A2($author$project$View$render_button_inside, model.cscreen.cscene, model.objects),
												_Utils_ap(
													A2($author$project$View$render_documents, model.docu, model.cscreen.cscene),
													A2($author$project$View$play_piano_audio, model.cscreen.cscene, model.objects))))),
										A2(
										$elm$html$Html$audio,
										_List_fromArray(
											[
												$elm$html$Html$Attributes$src('assets/bgm.ogg'),
												$elm$html$Html$Attributes$id('bgm'),
												$elm$html$Html$Attributes$autoplay(true)
											]),
										_List_Nil)
									]),
								A2($author$project$View$render_ui_button, 0, model));
						case 1:
							return A2($author$project$View$render_ui_button, 1, model);
						case 2:
							return _Utils_ap(
								_List_fromArray(
									[
										$author$project$View$render_wall_1,
										A2(
										$elm$html$Html$embed,
										_List_fromArray(
											[
												$elm$html$Html$Attributes$type_('image/png'),
												$elm$html$Html$Attributes$src('assets/memory_menu1.png'),
												A2($author$project$View$style, 'top', '0%'),
												A2($author$project$View$style, 'left', '0%'),
												A2($author$project$View$style, 'width', '15%'),
												A2($author$project$View$style, 'height', '100%'),
												A2($author$project$View$style, 'position', 'absolute')
											]),
										_List_Nil)
									]),
								_Utils_ap(
									A2($author$project$Document$render_docu_list, 0, model.docu),
									A2($author$project$View$render_ui_button, 2, model)));
						case 3:
							return _Utils_ap(
								_List_fromArray(
									[
										$author$project$View$render_wall_1,
										A2(
										$elm$html$Html$embed,
										_List_fromArray(
											[
												$elm$html$Html$Attributes$type_('image/png'),
												$elm$html$Html$Attributes$src('assets/memory_menu2.png'),
												A2($author$project$View$style, 'top', '0%'),
												A2($author$project$View$style, 'left', '0%'),
												A2($author$project$View$style, 'width', '15%'),
												A2($author$project$View$style, 'height', '100%'),
												A2($author$project$View$style, 'position', 'absolute')
											]),
										_List_Nil)
									]),
								A2($author$project$View$render_ui_button, 3, model));
						case 4:
							return _Utils_ap(
								_List_fromArray(
									[
										$author$project$View$render_wall_1,
										A2(
										$elm$html$Html$embed,
										_List_fromArray(
											[
												$elm$html$Html$Attributes$type_('image/png'),
												$elm$html$Html$Attributes$src('assets/memory_menu3.png'),
												A2($author$project$View$style, 'top', '0%'),
												A2($author$project$View$style, 'left', '0%'),
												A2($author$project$View$style, 'width', '15%'),
												A2($author$project$View$style, 'height', '100%'),
												A2($author$project$View$style, 'position', 'absolute')
											]),
										_List_Nil),
										A2(
										$elm$html$Html$div,
										_List_fromArray(
											[
												A2($author$project$View$style, 'top', '87%'),
												A2($author$project$View$style, 'left', '8%'),
												A2($author$project$View$style, 'height', '10%'),
												A2($author$project$View$style, 'width', '6%'),
												A2($author$project$View$style, 'background-color', 'white'),
												A2($author$project$View$style, 'position', 'absolute')
											]),
										_List_Nil)
									]),
								A2($author$project$View$render_ui_button, 4, model));
						case 10:
							return _Utils_ap(
								A2($author$project$View$render_ui_button, 10, model),
								_List_fromArray(
									[
										$elm$html$Html$text('this is Achievement page')
									]));
						case 11:
							return _Utils_ap(
								A2($author$project$View$render_ui_button, 11, model),
								$author$project$Document$render_document_detail(model.cscreen.cdocu));
						case 12:
							return _Utils_ap(
								A2($author$project$View$render_ui_button, 12, model),
								$author$project$Document$render_document_detail(model.cscreen.cdocu));
						case 20:
							return _Utils_ap(
								A2($author$project$View$render_ui_button, 20, model),
								A2($author$project$Memory$render_memory, model.cscreen.cmemory, model.cscreen.cpage));
						default:
							return _List_fromArray(
								[
									$elm$html$Html$text(
									$elm$core$Debug$toString(model.cscreen.cstate))
								]);
					}
				}())
			]));
};
var $author$project$Main$main = $elm$browser$Browser$element(
	{init: $author$project$Main$init, subscriptions: $author$project$Main$subscriptions, update: $author$project$Update$update, view: $author$project$View$view});
_Platform_export({'Main':{'init':$author$project$Main$main(
	$elm$json$Json$Decode$succeed(_Utils_Tuple0))(0)}});}(this));