
![Flyber](http://res.cloudinary.com/nixar-work/image/upload/v1473975258/13268115_880281065449309_626424912755329334_o.jpg)

AngularJS service model for nodejs

keywords: node-angular, angularjs-nodejs

##Install

```Bash
npm install flyber
```

##Motivation
Desire to get rid of these ugly statements


```Javascript

require('../../myservice.js')
require('../config.json')
...

```
Actually it is false. the motivation is only one. I love AngularJS design and want to reuse it in Nodejs


##EXAMPLE


```Javascript 

var func = function ($flyber) {
  
  $flyber.service("myservice", function() {
      return {
         func1: function() {  console.log("print1"); },
         func2: function() {  console.log("print2"); }
      }
  });
  
  $flyber.run(function(myservice, config) {
  
      myservice.func1() //==> print1
      myservice.func2() //==> print2
      console.log(config) //==> { common: 'object' }
  
  });
   
};




var flyber = require('flyber');

//Add object to flyber
flyber.object('config', { common: 'object' });

//Apply flyber to function
flyber.run(func)



//Or put javascript in files
flyber.require('./config.js');
flyber.require('../*.js');

```

