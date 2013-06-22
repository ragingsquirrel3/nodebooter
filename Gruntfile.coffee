# Good reference here: https://github.com/Dignifiedquire/yaas/blob/master/Gruntfile.coffee
fs = require 'fs'
util = require 'util'

module.exports = (grunt) ->
  # Constants
  BUILD_PATH = 'build'
  APP_PATH   = 'app'
  DEV_BUILD_PATH = "#{BUILD_PATH}/development"
  JS_DEV_BUILD_PATH = "#{DEV_BUILD_PATH}/js"
  PRODUCTION_BUILD_PATH = "#{BUILD_PATH}/production"

  grunt.initConfig
    clean:
      development: [DEV_BUILD_PATH]
      production: [PRODUCTION_BUILD_PATH]
      js_pre_production: ["#{PRODUCTION_BUILD_PATH}/js"]
      
    
    copy:
      development:
        files: [
          { expand: true, cwd: "#{APP_PATH}/public", src:['**'], dest: DEV_BUILD_PATH }
        ]
      production:
        files: [
          { expand: true, cwd: DEV_BUILD_PATH, src:['**'], dest: PRODUCTION_BUILD_PATH },
        ]
      production_copy_require_js:
        files: [
          { expand: true, flatten: true, src: ["#{JS_DEV_BUILD_PATH}/vendor/require.js"], dest: "#{PRODUCTION_BUILD_PATH}/js/vendor" },
        ]
        
    coffee:
      development:
        options:
          sourceMap: true
        files: [
          expand: true
          cwd: "#{APP_PATH}/coffee"
          dest: "#{DEV_BUILD_PATH}/js"
          src: ["*.coffee", "**/*.coffee"]
          ext: ".js"
        ]
    
    
    stylus:
      development:
        files: [
          {
            src: "#{APP_PATH}/stylesheets/main.styl"
            dest: "#{DEV_BUILD_PATH}/stylesheets/main.css"
          }
        ]

    jade:
      development:
        options:
          pretty: false

        files: [
          {
            src: "#{APP_PATH}/index.jade"
            dest: "#{DEV_BUILD_PATH}/index.html"
          }
        ]
        
    # requirejs:
    #   production:
    #     options:
    #       baseUrl: JS_DEV_BUILD_PATH
    #       name: 'main'
    #       paths:
    #         'jquery': "vendor/jquery.min" # "//ajax.googleapis.com/ajax/libs/jquery/1.9.1/jquery.min"
    #         'jquery-ui': "vendor/jquery-ui-min"
    #         'jquery-number': "vendor/jquery-number-min"
    #         'backbone': "vendor/backbone-min"
    #         'underscore': "vendor/underscore-min"
    #         'd3': "vendor/d3-min"
    #         'jade': "vendor/jade-min"
    #       shim:
    #         'jquery': exports: '$'
    #         'backbone':
    #           deps: ['underscore', 'jquery']
    #           exports: 'Backbone'
    #         'underscore': exports: '_'
    #         'jade': exports: 'jade'
    #         'd3': exports: 'd3'  
    #       out: "#{PRODUCTION_BUILD_PATH}/js/main.js"
    
    # To serve the production version, change base and static path to PRODUCTION_BUILD_PATH.
    connect:
      server:
        options:
          hostname: ''
          port: 3000
          base: "./#{DEV_BUILD_PATH}"
          middleware: (connect, options) -> [
            connect.compress()
            connect.static(DEV_BUILD_PATH),
          ]

    watch:
      coffee:
        files: ["#{APP_PATH}/coffee/*.coffee", "#{APP_PATH}/coffee/**/*.coffee"]
        tasks: 'coffee:development'
      # sass:
      #   files: ["#{APP_PATH}/sass/*.scss", "#{APP_PATH}/sass/**/*.scss"]
      #   tasks: ['sass:development', 'copy:development']
      jade:
        files: ["#{APP_PATH}/client_templates/*.jade", "#{APP_PATH}/client_templates/**/*.jade"]
        tasks: ['jade:development', 'client_templates']
      copied:
        files: ["#{APP_PATH}/public/*", "#{APP_PATH}/public/**/*"]
        tasks: 'copy:development'

  grunt.loadNpmTasks 'grunt-contrib-connect'
  grunt.loadNpmTasks 'grunt-contrib-watch'

  grunt.loadNpmTasks 'grunt-contrib-coffee'
  grunt.loadNpmTasks 'grunt-contrib-jade'
  grunt.loadNpmTasks 'grunt-contrib-stylus'
  grunt.loadNpmTasks 'grunt-contrib-copy'
  grunt.loadNpmTasks 'grunt-contrib-clean'
  grunt.loadNpmTasks 'grunt-contrib-requirejs'
            
  grunt.registerTask 'client_templates', 'Compile and concatenate Jade templates for client.', -> 
    jade = require 'jade'
    
    templates =
      "public_index": "#{APP_PATH}/client_templates/public_index.jade"
    
    tmplFileContents = "define(['jade'], function(jade) {\n"
    tmplFileContents += 'var JST = {};\n'
    
    for namespace, filename of templates
      path = "#{__dirname}/#{filename}"
      contents = jade.compile(
        fs.readFileSync(path, 'utf8'), { client: true, compileDebug: false, filename: path }
      ).toString()
      tmplFileContents += "JST['#{namespace}'] = #{contents};\n"
      
    tmplFileContents += 'return JST;\n'
    tmplFileContents += '});\n'
    fs.writeFileSync "#{DEV_BUILD_PATH}/js/templates.js", tmplFileContents


  grunt.registerTask 'development', [
    'clean:development'
    'stylus:development'
    'copy:development'
    'coffee:development'
    'jade:development'
    'client_templates'
  ]
  
  grunt.registerTask 'production', [
    'clean:production'
    'development'
    'copy:production'
    'clean:js_pre_production'
    'requirejs'
    'copy:production_copy_require_js'
  ]
  
  grunt.registerTask 'heroku', ['clean', 'copy', 'coffee', 'jade', 'client_templates']
  
  grunt.registerTask 'default', [
    'development'
    'connect:server'
    'watch'
  ]
