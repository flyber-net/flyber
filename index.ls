const p =
  require \prelude-ls

STRIP_COMMENTS = /((\/\/.*$)|(\/\*[\s\S]*?\*\/))/mg
ARGUMENT_NAMES = /([^\s,]+)/g

params = (func)->
  const fnStr = func.toString!.replace(STRIP_COMMENTS, '')
  const result = fnStr.slice(fnStr.indexOf('(')+1, fnStr.indexOf(')')).match(ARGUMENT_NAMES)
  if result is null
     []
  else
    result

services = []

register = (name)->
  return if services.index-of(name)>-1
  o = -> 
     o.$get?apply?(o, arguments)
  services.push [name, o]
  name

transform = (name)->
  services |> p.find (.0 is name) |> (.1)

const load-string = (str)->
    if str.index-of(\*) > -1
        require(\glob).sync(str).for-each load
    else 
       str |> require |> load

const load = (any)->
   | typeof! any is \Function => any |> params |> p.each register |> p.map transform |> any.apply @, _
   | typeof! any is \String => any |> load-string
   | _ => any

const clone-service = (obj, copy)->
    switch typeof! obj
      case \Object
        clone-object obj, copy
      case \Function
        copy.$get = obj

const clone-object = (obj, copy)->
    for attr of obj
      switch typeof! obj[attr]
        case \Function
          if attr is \post
            console.log \attr, attr
            copy[attr] = ->
                console.log \apply, attr, arguments
                obj[attr].apply undefined, arguments
          else 
            copy[attr] = obj[attr]
          
        else 
          copy[attr] = obj[attr]
      

const object = (name, object)->
   const pub =
      name |> register |> transform
   clone-object object, pub

const service = (name, object)->
   const pub =
      name |> register |> transform
   clone-service object, pub



const xonom =  {}
xonom
 ..require = (path)->
   path |> require |> load
 ..run = (f)->
   load(f)
   xonom
 ..service = (name, func)->
   func |> load |> service name, _
   xonom
 ..object = (name, o)->
   object name, o
   xonom

xonom.object \$xonom, xonom


module.exports = xonom
    

    
        



