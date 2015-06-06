_ = require 'angular'

m = angular.module 'filter1', []

m.filter 'filter11', ->
  (x) -> x