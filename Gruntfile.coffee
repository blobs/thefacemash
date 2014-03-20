module.exports = (grunt) ->
  grunt.initConfig
    pkg: grunt.file.readJSON 'package.json'
    watch:
      coffee:
        files: ['./coffee/**/*.coffee'],
        tasks: 'coffee'
    coffee:
      compile:
        expand: true
        cwd: 'coffee'
        src: ['**/*.coffee']
        dest: './js/'
        ext: '.js'
  grunt.loadNpmTasks 'grunt-contrib-coffee'
  grunt.loadNpmTasks 'grunt-contrib-watch'
  grunt.registerTask 'default', ['coffee', 'watch']
  return
