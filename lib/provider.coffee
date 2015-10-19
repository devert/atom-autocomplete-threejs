fs = require 'fs'
path = require 'path'

module.exports =
  # This will work on JavaScript files, but not in js comments.
  selector: '.source.js'
  disableForSelector: '.source.js .comment'
  filterSuggestions: true

  # This will take priority over the default provider, which has a priority
  # of 0.`excludeLowerPriority` will suppress any providers with a
  # lower priority i.e. The default provider will be suppressed
  inclusionPriority: 1
  excludeLowerPriority: true

  loadCompletions: ->
    @completions = {}
    fs.readFile path.resolve(__dirname, '..', 'completions.json'), (error, content) =>
      @completions = JSON.parse(content) unless error?
      return

  # Required: Return a promise, an array of suggestions, or null.
  getSuggestions: ({editor, bufferPosition, scopeDescriptor, prefix}) ->
    new Promise (resolve) ->
      resolve([text: 'something'])

  # (optional): called _after_ the suggestion `replacementPrefix` is replaced
  # by the suggestion `text` in the buffer
  onDidInsertSuggestion: ({editor, triggerPosition, suggestion}) ->

  # (optional): called when your provider needs to be cleaned up. Unsubscribe
  # from things, kill any processes, etc.
  dispose: ->
