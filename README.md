# xonom
Service model provider for nodejs

##Install

```Bash
npm install xonom
```

##EXAMPLE


```Javascript 

module.exports = function ($xonom) {
  
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
xonom.func(module.exports)

//Apply xonom to file
xonom.file('./user.service.js');
xonom.file('./domain.service.js');

//Apply xonom to object
xonom.object('obj', { common: 'object' });

xonom.func(function(obj) {

  console.log(obj) //=> { common: 'object' }

})
```

