_ = require 'angular'
_ = require 'jquery'
_ = require './hello-world'
_ = require './notepad'

m = angular.module 'directives', [
  'helloWorld'
  'notepad'
]