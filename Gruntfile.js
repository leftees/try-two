module.exports = function(grunt) {

  grunt.initConfig({
    jasmine: {
      src: 'js/Application.js',
      options: {
        specs: 'jasmine/spec/ApplicationSpec.js',
        vendor: [ 'js/jquery-1.12.2.min.js',
                  'js/jquery.loadTemplate-1.5.6.min.js',
                  'jasmine/lib/jasmine-jquery.js' ],
        helpers: [ 'jasmine/spec/requests.js',
                   'jasmine/spec/fixtures.js' ]
      }
    }
  });
  grunt.loadNpmTasks('grunt-contrib-jasmine');
};