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
  services.push [name, {}]
  name

transform = (name)->
  services |> p.find (.0 is name) |> (.1)

const load-string = (str)->
    if str.index-of(\*) > -1
        require(\glob) str, [], (err, files) ->
          files.for-each load
       xonom
    else 
       str |> require |> load

const load = (any)->
   | typeof! any is \Function => any |> params |> p.each register |> p.map transform |> any.apply @, _
   | typeof! any is \String => any |> load-string
   | _ => any

const clone = (obj, copy)->
    for attr of obj
      copy[attr] = obj[attr]

const object = (name, object)->
   const pub =
      name |> register |> transform
   clone object, pub


class Promise
  ->
    @callbacks= []
    @ready =  no
  success: (result) ->
      console.log \result, result, @callbacks
      if @callbacks.length > 0
         const func = @callbacks.0
         @callbacks.splice(0, 1)
         console.log func
         func result
      @ready = yes
      @result = result
  on-success: (callback)->
    if @ready
       callback @result
    else
       @callbacks.push callback


const xonom =  {}
xonom
 ..require = (path)->
    path |> require |> load
 ..run = (f)->
        result = load(f)
        if typeof! result?on-success is \Function
          done = (func)->
              result.on-success ->
                 func!
          
          console.log result
          result
            ..run = (f)->
              done ->
                xonom.run(f)
              result
            ..service = (name, func)->
              done ->
                xonom.service(name, func)
              result
            ..object = (name, o)->
              done ->
                xonom.object(name, o)
              result
            ..require = (path)->
                throw "'require' method is not allowed during async execution"
          result
        else
          xonom
 ..service = (name, func)->
    func |> load |> object name, _
    xonom
 ..object = (name, o)->
    object name, o
    xonom

xonom.object \$xonom, xonom
xonom.service \$promise, ->
          new Promise!


module.exports = xonom
    

    
        



