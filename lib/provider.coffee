Fuse = require('fuse.js');

module.exports =
  selector: '.source.js'
  disableForSelector: '.source.js .comment, .source.js .string'
  filterSuggestions: true

  completions: []

  loadCompletions: ->
    classes = require("../completions.json")
    for classname,classfunctions of classes
      cls = {}
      cls.text = classname
      cls.type = "class"
      @completions.push(cls)
      for funcname,properties of classfunctions
        func = {}
        func.text = funcname
        func.snippet = funcname+"("
        func.leftLabel = classname+"."
        for property,i in properties
          if(i>0)
            func.snippet += ","
          func.snippet += "${"+(i+1)+":"+property+"}"
        func.type = "function"
        func.snippet+=")"
        @completions.push(func)

  getSuggestions: (request) ->
    {prefix} = request
    suggestions = []
    options = {
      keys: ['text'],
      threshold: 0.25
    }
    f = new Fuse(@completions, options)
    suggestions = f.search(prefix)
    for func in suggestions
      func.replacementPrefix = prefix
    suggestions
