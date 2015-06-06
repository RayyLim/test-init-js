_ = require 'angular'

m = angular.module 'helloWorld', []

m.directive 'helloWorld', ->
  scope:
    color: '@' # one way bind
  restrict: 'AE'
  replace: true
  templateUrl: 'templates/directives/hello-world.html'
  link: (scope, elem, attrs) ->
    elem.bind 'click', ->
      elem.css 'background-color', 'blue'
      scope.$apply ->
        scope.color = green
    elem.bind 'mouseover', ->
      elem.css 'cursor', 'pointer'