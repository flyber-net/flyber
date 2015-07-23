# xonom
Service model provider for nodejs

##Install

```Bash
npm install xonom
```

##Motivation
Desire to get rid of these ugly statements


```Javascript

require('../../myservice.js')
require('../config.json')
...

```

##EXAMPLE


```Javascript 

var func = function ($xonom) {
  
  $xonom.service("myservice", function() {
      return {
         func1: function() {  console.log("print1"); },
         func2: function() {  console.log("print2"); }
      }
  });
  
  $xonom.run(function(myservice) {
  
      myservice.func1() //==> print1
      myservice.func2() //==> print2
  
  });
   
};




var xonom = require('xonom');

//Add object to xonom
xonom.object('config', { common: 'object' });

//Apply xonom to function
xonom.run(func)


xonom.run(function(config) {

  console.log(config) //=> { common: 'object' }

});



//Or put javascript in files
xonom.require('./config.js');
xonom.require('./myservice.js');

```

