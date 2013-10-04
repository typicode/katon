module.exports = (grunt) ->

  grunt.initConfig
    clean: 'lib'

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

  grunt.loadNpmTasks 'grunt-contrib'

  grunt.registerTask 'default', ['coffee']