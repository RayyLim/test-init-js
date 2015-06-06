_ = require 'angular'

m = angular.module 'notepad', []
  
m.directive 'notepad', (notesFactory) ->
  restrict: 'AE'
  scope: {}
  link: (scope, elem, attrs) ->
    scope.restore = ->
      scope.editMode = false
      scope.index = -1
      scope.noteText = ''

    scope.openEditor = (index) ->
      scope.editMode = true
      
      if index != undefined
        scope.noteText = notesFactory.get(index).content
        scope.index = index
      else
        scope.noteText = undefined
      
    scope.save = ->
      if scope.noteText != '' || scope.noteText != undefined
        note = {}

        if scope.noteText.length > 10
          note.title = scope.noteText.substring(0, 10)
        else
          note.title = scope.noteText

        note.content = scope.noteText
        if scope.index != -1
          note.id = scope.index
        else
          note.id = localStorage.length
        scope.notes = notesFactory.put(note)
      scope.restore()

    editor = elem.find('#editor')

    scope.restore()
    scope.notes = notesFactory.getAll()

    editor.bind 'keyup keydown', ->
      scope.noteText = editor.text().trim()

  templateUrl: 'templates/directives/notepad.html'

m.factory 'notesFactory', ->
  put: (note) ->
    localStorage.setItem 'note'+note.id, JSON.stringify(note)
    this.getAll()
  get: (index) ->
    JSON.parse localStorage.getItem('note' + index)
  getAll: ->
    notes = []
    for i in [0 .. localStorage.length-1]
      if localStorage.key(i).indexOf('note') != -1
        note = localStorage.getItem(localStorage.key(i))
        notes.push(JSON.parse(note))
    notes