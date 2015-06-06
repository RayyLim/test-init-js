_ = require 'angular'
_ = require '../services/services'
_ = require '../directives/directives'


m = angular.module 'indexRoute', []

m.controller 'IndexCtrl', ($rootScope, $scope, $routeParams, $location) ->
  angular.extend $scope,
    goodbye: 'goodbye'