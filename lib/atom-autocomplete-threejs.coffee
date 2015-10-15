AtomAutocompleteThreejsView = require './atom-autocomplete-threejs-view'
{CompositeDisposable} = require 'atom'

module.exports = AtomAutocompleteThreejs =
  atomAutocompleteThreejsView: null
  modalPanel: null
  subscriptions: null

  activate: (state) ->
    @atomAutocompleteThreejsView = new AtomAutocompleteThreejsView(state.atomAutocompleteThreejsViewState)
    @modalPanel = atom.workspace.addModalPanel(item: @atomAutocompleteThreejsView.getElement(), visible: false)

    # Events subscribed to in atom's system can be easily cleaned up with a CompositeDisposable
    @subscriptions = new CompositeDisposable

    # Register command that toggles this view
    @subscriptions.add atom.commands.add 'atom-workspace', 'atom-autocomplete-threejs:toggle': => @toggle()

  deactivate: ->
    @modalPanel.destroy()
    @subscriptions.dispose()
    @atomAutocompleteThreejsView.destroy()

  serialize: ->
    atomAutocompleteThreejsViewState: @atomAutocompleteThreejsView.serialize()

  toggle: ->
    console.log 'AtomAutocompleteThreejs was toggled!'

    if @modalPanel.isVisible()
      @modalPanel.hide()
    else
      @modalPanel.show()
