'use strict'
gulp           = require 'gulp'
path           = require 'path'
browserify     = require 'browserify'
source         = require 'vinyl-source-stream'
jade           = require 'gulp-jade'
rename         = require 'gulp-rename'
clean          = require 'gulp-clean'
coffeelint     = require 'gulp-coffeelint'
sass           = require 'gulp-sass'
autoprefixer   = require 'gulp-autoprefixer'
browserSync    = require 'browser-sync'
qunit          = require 'gulp-qunit'
mainBowerFiles = require 'main-bower-files'
gulpFilter     = require 'gulp-filter'
concat         = require 'gulp-concat'
debug          = require 'gulp-debug'

gulp.task 'clean', ->
    gulp.src 'build/*', {read : false}
        .pipe clean()

gulp.task 'bower-css', ->
    cssFilter = gulpFilter '**/*.css'
    gulp.src(mainBowerFiles({includeDev:'inclusive'}))
        .pipe cssFilter
        .pipe gulp.dest 'build/stylesheets'

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

gulp.task 'build', ['bower-css', 'html', 'js', 'css'] 

gulp.task 'default', ['clean'], -> gulp.start 'test'

gulp.task 'watch', ->
    gulp.watch 'source/**/*.coffee', ['js']
    gulp.watch 'tests/**/*.coffee', ['test']
    gulp.watch 'source/**/*.sass', ['css']
    gulp.watch 'source/**/*.css', ['css']
    gulp.watch 'source/**/*.jade', ['html']

gulp.task 'test', ['build'], ->
    browserify
        debug: true
        entries: ['./tests/javascripts/tests.js.coffee']
        extensions: ['.coffee', '.js', '.js.coffee']
        paths: ['./tests/javascripts']
    .transform 'coffeeify'
    .bundle()
    .pipe source 'tests.js'
    .pipe gulp.dest 'build/javascripts'

gulp.task 'server', ['build'], ->
    browserSync.init
        server:
            baseDir: './build/'
