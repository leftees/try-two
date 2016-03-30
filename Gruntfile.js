module.exports = function(grunt) {

  grunt.initConfig({
    jasmine: {
      src: '../js/Application.js',
      options: {
        specs: 'spec/ApplicationSpec.js'
      }
    }
  });
  grunt.loadNpmTasks('grunt-contrib-jasmine');
};