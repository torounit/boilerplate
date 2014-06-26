module.exports = (grunt) ->

  # ==================================
  #
  # Load Tasks.
  #
  # ==================================
  pkg = grunt.file.readJSON('package.json')

  for taskName of pkg.devDependencies
    grunt.loadNpmTasks taskName  if taskName.substring(0, 6) is 'grunt-'

  # ==================================
  #
  # Grunt Task Settings.
  #
  # ==================================

  grunt.initConfig



    # ==================================
    #
    # Directory Setting.
    #
    # ==================================
    dir:
      assets: 'assets'
      coffee: '<%= dir.assets %>/coffee'
      javascripts: '<%= dir.assets %>/javascripts'
      vendor: '<%= dir.assets %>/vendor'
      stylesheets: '<%= dir.assets %>/stylesheets'
      sass: '<%= dir.assets %>/sass'


    # ==================================
    #
    # Watch File and Task.
    #
    # ==================================
    esteWatch: {
      options:
        dirs: [ './', '<%= dir.sass %>', '<%= dir.sass %>/**', '<%= dir.coffee %>' , '<%= dir.stylesheets %>', '<%= dir.javascripts %>'  ]
        extensions: ['scss','coffee','js','css','php','html']
        livereload:
          extensions: ['js','css','php']
          enabled: true

      scss: (filepath) ->
        return ['compass:dev']


      coffee: (filepath) ->
        return ['clean' ,'coffee','concat']

    }



    # ==================================
    #
    # Compass.
    # use config.rb.
    #
    # ==================================

    compass: {
      dev: {
        options: {
          bundleExec: true
          config: 'config.rb'
          environment: 'development'
        }
      }

      dist: {
        options: {
          bundleExec: true
          config: 'config.rb'
          environment: 'production'
        }
      }

    }


    # =================================


    cssmin: {
      minify: {
        expand: true,
        cwd: '<%= dir.stylesheets %>',
        src: ['*.css', '!*.min.css'],
        dest: '<%= dir.stylesheets %>',
        ext: '.min.css'
      }
    }


    # ==================================
    #
    # clean compile js
    #
    # ==================================

    clean:
      coffee: ['<%= dir.javascripts %>/src/']


    # ==================================
    #
    # Style Guide
    #
    # ==================================

    # KSS styleguide generator for grunt.
    kss:
      options:
        includeType: 'css'
        includePath: '<%= dir.stylesheets %>/all.css'
      dist:
        files:
          'docs/styleguide': ['<%= dir.sass %>']



    # ==================================
    #
    # CoffeeScript Compile.
    #
    # ==================================

    coffee:
      compile:
        files: [
          expand: true
          cwd: '<%= dir.coffee %>/'
          src: '*.coffee'
          dest: '<%= dir.javascripts %>/src/'
          ext: '.js'
        ]

    # ==================================
    #
    # join jsFiles.
    #
    # ==================================
    concat:
      options:
        separator: ';',
      dist:
        src: '<%= dir.javascripts %>/src/*.js',
        dest: '<%= dir.javascripts %>/all.js', #jsはすべて、all.jsに。


    # ==================================
    #
    # minify javascripts.
    #
    # ==================================
    uglify:
      compress:
        files:
          '<%= dir.javascripts %>/all.min.js': ['<%= dir.javascripts %>/all.js']
      bower:
        files:
          '<%= dir.javascripts %>/lib.min.js': ['<%= dir.javascripts %>/lib.js']


    # ==================================
    #
    # create vendor/lib.js
    #
    # ==================================
    bower_concat:
      all:
        dest: '<%= dir.javascripts %>/lib.js'
        exclude: [
            'jquery'
            'modernizr'
            'underscore'
            'backbone'
            'vue'
            "sass-mq"
            "Retina-sprites-for-Compass"
        ]
        bowerOptions:
          relative: false


  # ==================================
  #
  # Register Task.
  #
  # grunt           - watch and Compile.
  # grunt bowerinit - build javascript installed by bower.
  #
  # ==================================

  grunt.registerTask 'build', ['compass:dist','kss','cssmin','coffee','concat','bower_concat','uglify']
  grunt.registerTask 'default', ['esteWatch']