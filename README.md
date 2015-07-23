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
  
  $xonom.func(function(myservice) {
  
      myservice.func1() //==> print1
      myservice.func2() //==> print2
  
  });
   
};




var xonom = require('xonom');

//Apply xonom to function
xonom.func(func)

//Or apply xonom to file
xonom.file('./config.js');
xonom.file('./myservice.js');

//Apply xonom to object
xonom.object('config', { common: 'object' });

xonom.func(function(config) {

  console.log(config) //=> { common: 'object' }

})
```

