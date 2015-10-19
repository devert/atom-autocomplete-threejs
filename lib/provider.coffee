fuse = require 'fuse.js'
yaml = require 'js-yaml'
fs = require 'fs'
path = require 'path'

module.exports =
  selector: '.source.js'
  disableForSelector: '.source.js .comment, .source.js .string'
  filterSuggestions: true
  inclusionPriority: 9
  exvludeLowerPriority: false

  globalScope: 'THREE'
  completions: [
    {
      text: 'THREE',
      type: 'function',
      rightLabel: 'Global'
      description: 'The global three.js function',
      descriptionMoreURL: 'http://threejs.org/docs/'
    }
  ]

  loadCompletions: ->
    reference = yaml.safeLoad(fs.readFileSync(path.resolve(__dirname, '..', 'completions.yaml'), 'utf8'));

    # Parse the classes
    for className,classValue of reference.classes
      obj = {}
      obj.type = 'class'
      if (classValue.hasOwnProperty('constructor'))
        obj.snippet = 'THREE.' + className + '('
        for argument,i in classValue.constructor
          if(i>0)
            obj.snippet += ', '
          obj.snippet += '${'+(i+1)+':'+argument+'}'
        obj.snippet += ")${0}"
      obj.description = classValue.description
      obj.descriptionMoreURL = classValue.descriptionMoreURL
      obj.text = 'THREE.' + className
      obj.leftLabel = 'THREE'
      obj.rightLabel = 'Constructor'
      obj.displayText = 'THREE.' + className
      @completions.push(obj)

  getPrefix: (editor, bufferPosition) ->
    line = editor.getTextInRange([[bufferPosition.row, 0], bufferPosition])
    index = line.lastIndexOf('THREE.')
    if (index == -1)
      index = ''
    else
      index = line.slice(index)

    return index

  getSuggestions: ({editor, bufferPosition}) ->
    prefix = this.getPrefix(editor, bufferPosition)
    matches = []
    options = {
      keys: ['text'],
      threshold: 0.25
    }
    f = new fuse(@completions, options)
    matches = f.search(prefix)
    for func in matches
      func.replacementPrefix = prefix

    return matches
