_ = require 'angular'
_ = require 'ng-uuid'

_ = require '../services/services'
_ = require '../directives/directives'


m = angular.module 'indexRoute', ['uuid']

m.controller 'IndexCtrl', ($rootScope, $scope, $routeParams, $location, uuid,
$filter) ->
  angular.extend $scope,
    goodbye: 'goodbye'
    inputTime: new Date(new Date().setMilliseconds(0))
    entry: undefined
    entries:[]
    submit: ->
      $scope.entries.push {id:uuid.new(), text:$scope.entry}
      