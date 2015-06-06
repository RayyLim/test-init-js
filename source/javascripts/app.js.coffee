_ = require 'angular'
_ = require 'angular-route'

_ = require './directives/directives'
_ = require './services/services'
_ = require './filters/filters'

_ = require './routes/index-route'

m = angular.module 'helloApp', [
  'ngRoute'
  'directives'
  'services'
  'filters'
  'indexRoute'
]

routes = [
  path: ''
  templateName: 'index-route'
  controller: 'IndexCtrl'
]

m.config ($routeProvider) ->
  for route in routes
    $routeProvider.when "/#{route.path}",
      templateUrl: "templates/routes/#{route.templateName}.html"
      controller: route.controller
  $routeProvider.otherwise { redirectTo: '/' }