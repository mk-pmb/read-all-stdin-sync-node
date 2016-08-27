
read-all-stdin-sync
===================
Save one level of indentation in scripts that won't do anything anyway
until they've read all of stdin.


Usage
-----
```javascript
var stdin = require('read-all-stdin-sync')();
console.log(Object.keys(JSON.parse(stdin)));
```

```javascript
var stdin = require('read-all-stdin-sync')({ encoding: null });
console.dir(stdin);
```


License
-------
ISC
