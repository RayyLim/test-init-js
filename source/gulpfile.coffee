'use strict'
gulp         = require 'gulp'
path         = require 'path'
browserify   = require 'browserify'
source       = require 'vinyl-source-stream'
jade         = require 'gulp-jade'
rename       = require 'gulp-rename'
clean        = require 'gulp-clean'
coffeelint   = require 'gulp-coffeelint'
sass         = require 'gulp-sass'
autoprefixer = require 'gulp-autoprefixer'
browserSync  = require 'browser-sync'

gulp.task 'clean', ->
    gulp.src 'build/*', {read : false}
        .pipe clean()

# HTML
gulp.task 'html', ->
    gulp.src 'source/**/*.jade'
        .pipe jade()
        .pipe rename {extname:""}
        .pipe gulp.dest 'build'
        .pipe browserSync.stream()

# lint
gulp.task 'lint', ->
    gulp.src 'source/javascripts/**/*.coffee'
        .pipe coffeelint()
        .pipe coffeelint.reporter()
    
# JS
gulp.task 'js', ['lint'], ->
    browserify
        debug: true
        entries: ['./source/javascripts/app.js.coffee']
        extensions: ['.coffee', '.js', '.js.coffee']
        paths: ['./source/javascripts']
    .transform 'coffeeify'
    .bundle()
    .pipe source 'app.js'
    .pipe gulp.dest 'build/javascripts'
    # .pipe browserSync.stream()

# CSS
gulp.task 'css', ->
    gulp.src 'source/stylesheets/**/*.css'
        .pipe gulp.dest 'build/stylesheets'
        .pipe browserSync.stream()
    
    gulp.src 'source/stylesheets/**/*.scss'
        .pipe sass
            includePaths: ['bower_components/bootstrap-sass-official/assets/stylesheets', '.']
        .pipe autoprefixer 'last 2 version'
        .pipe rename {extname:""}
        .pipe gulp.dest 'build/stylesheets'
        .pipe browserSync.stream()

gulp.task 'build', ['html', 'js', 'css'] 

gulp.task 'default', ['clean'], -> gulp.start 'build'

gulp.task 'server', ['build'], ->
    browserSync.init
        server:
            baseDir: './build/'

gulp.task 'watch', ['server'], ->
    gulp.watch 'source/**/*.coffee', ['js']
    gulp.watch 'source/**/*.sass', ['css']
    gulp.watch 'source/**/*.css', ['css']
    gulp.watch 'source/**/*.jade', ['html']