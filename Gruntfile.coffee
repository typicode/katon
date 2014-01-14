module.exports = (grunt) ->

  grunt.initConfig
    clean: ['lib']

    coffee:
      compile:
        expand: true
        cwd: 'src'
        src: ['**/*.coffee']
        dest: 'lib/'
        ext: '.js'

    watch:
      coffee:
        files: 'src/**/*.coffee'
        tasks: 'coffee'

    coffeelint:
      files: ['src/**/*.coffee', 'test/**/*.coffee']

  grunt.loadNpmTasks 'grunt-contrib'
  grunt.loadNpmTasks 'grunt-coffeelint'

  grunt.registerTask 'default', ['clean', 'coffee', 'watch']