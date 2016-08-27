
read-all-stdin-sync
===================
Save one level of indentation in scripts that won't do anything anyway
until they've read all of stdin.


Usage
-----
```javascript
var data = require('read-all-stdin-sync')();
console.dir(Object.keys(JSON.parse(data)));
```

If you want to get rid of a possible leading Byte-Order Mark:

```javascript
var data = require('read-all-stdin-sync')({ stripBOM: true });
console.dir(Object.keys(JSON.parse(data)));
```

Actually, there's a shorthand for BOM stripping and parsing JSON:

```javascript
var data = require('read-all-stdin-sync')(JSON);
console.dir(Object.keys(data));
```

You can read buffers, too:

```javascript
var data = require('read-all-stdin-sync')({ encoding: null });
console.dir(data);
```

Easier to remember:

```javascript
var data = require('read-all-stdin-sync')(Buffer);
console.dir(data);
```





License
-------
ISC
