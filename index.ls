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

$new = ->
    
    services = {}
    
    register = (name)->
      return if services[name]?
      o = -> 
         o.$get?apply?(o, arguments)
      services[name] =o
      name
    
    transform = (name)->
      services[name]
    
    load-string = (str)->
        if str.index-of(\*) > -1
            require(\glob).sync(str).for-each load
        else 
           str |> require |> load
    
    load = (any)->
       | typeof! any is \Function => any |> params |> p.each register |> p.map transform |> any.apply @, _
       | typeof! any is \String => any |> load-string
       | _ => any
    
    clone-service = (obj, copy)->
        switch typeof! obj
          case \Object
            clone-object obj, copy
          case \Function
            copy.$get = obj
    
    clone = (obj, copy, attr)->
        switch typeof! obj[attr]
            case \Function
              copy[attr] = ->
                obj[attr].apply obj, arguments
            else 
              copy[attr] = obj[attr]
    
    clone-object = (obj, copy)->
        for attr of obj
          clone obj, copy, attr
          
    
    object = (name, object)->
       pub =
          name |> register |> transform
       clone-object object, pub
    
    service = (name, object)->
       pub =
          name |> register |> transform
       clone-service object, pub
    xonom =  {}
    
    xonom
     ..require = (path)->
       path |> require |> load
     ..run = (f)->
       load f
       xonom
     ..service = (name, func)->
       func |> load |> service name, _
       xonom
     ..object = (name, o)->
       object name, o
       xonom
     ..eval = load
     ..$new = $new
    xonom.object \$xonom, xonom
    xonom

module.exports = $new!
    

    
        



