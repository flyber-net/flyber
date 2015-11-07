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

const clone = (obj, copy)->
    if typeof! obj is \Object
      for attr of obj
          switch typeof! obj[attr]
            case \Function 
              copy[attr] = ->
                  console.log \FuncInvoke, attr
                  obj[attr].apply obj, arguments
            else          
              copy[attr] = obj[attr]
    if typeof! obj is \Function
      copy.$get = obj
const object = (name, object)->
   const pub =
      name |> register |> transform
   clone object, pub




const xonom =  {}
 ..require = (path)->
    path |> require |> load
 ..run = (f)->
        load(f)
        xonom
 ..service = (name, func)->
    func |> load |> object name, _
    xonom
 ..object = (name, o)->
    object name, o
    xonom

xonom.object \$xonom, xonom


module.exports = xonom
    

    
        



