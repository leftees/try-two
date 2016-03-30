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
                   'jasmine/spec/fixtures.js' ],
      },
      coverage: {
        src: 'js/Application.js',
        options: {
          specs: 'jasmine/spec/ApplicationSpec.js',
          template: require('grunt-template-jasmine-istanbul'),
          templateOptions: {
            coverage: 'jasmine/coverage.json',
            report: {
              type: 'lcov'
            }
          }
        }
      }
    }
  });
  grunt.loadNpmTasks('grunt-contrib-jasmine');
};