exec = (require "child_process").exec
spawn = (require "child_process").spawn

module.exports = (grunt)->
  grunt.initConfig({
    pkg: grunt.file.readJSON 'package.json'
    sass: {
      dist: {
        files: [{
          expand: true,
          cwd: 'www/src/view/sass/',
          src: ['*.scss'],
          dest: 'www/css',
          ext: '.css'
        }]
      }
    },
    haml: {
      dist: {
        files: [{
          expand: true,
          cwd: 'www/src/view/haml/',
          src: ['*.haml'],
          dest: 'www',
          ext: '.html'
        }]
      }
    }
    watch:
      scripts:{
        files: ['www/src/**/*'],
        tasks: ['browserify', 'sass'] #, 'run:android'],
        options:
          livereload: true
      }

    connect:
      options:
        hostname: 'localhost'
        livereload: 35729
        port: 3000
      server:
        options:
          base: 'www'
          open: true
  });
  grunt.loadNpmTasks('grunt-contrib-watch');
  grunt.loadNpmTasks('grunt-phonegap');
  grunt.loadNpmTasks 'grunt-contrib-connect'
  grunt.loadNpmTasks('grunt-contrib-sass');
  grunt.loadNpmTasks('grunt-contrib-haml');

  grunt.registerTask "default", ['browserify', 'sass', 'run:android']
  grunt.registerTask 'server', ->
    grunt.task.run 'connect:server'
    grunt.task.run 'watch:all'

  grunt.task.registerTask "browserify", "Bundle all js files", ->
    done = this.async();
    exec("browserify -t coffeeify www/src/index.coffee > www/js/bundle.js", (err, stdout, stderr) ->
      grunt.log.write "stderr:: #{stderr}" if stderr?
      grunt.log.write "stdout:: #{stdout}" if stdout?
      if stderr.length then throw new grunt.util.error(stderr)
      done();
    )
  grunt.task.registerTask "run", "Run on device", (target)->
    done = this.async();
    exec("cordova run #{target}", (err, stdout, stderr) ->
      grunt.log.write "stderr:: #{stderr}"
      grunt.log.write "stdout:: #{stdout}"
      done();
    )
  grunt.task.registerTask "test", "Test with mocha", (target)->
    done = this.async();
    exec("npm test", (err, stderr, stdout) ->
      grunt.log.write "stderr:: #{stderr}" if stderr.length
      if stderr.length then throw new grunt.util.error(stderr)
      grunt.log.write "stdout:: #{stdout}" if stdout.length
      done();
    )
