'use strict';

module.exports = function (grunt) {
  // load all grunt tasks
  require('matchdep').filterDev('grunt-*').forEach(grunt.loadNpmTasks);
  grunt.loadNpmTasks('grunt-coffeelint');
  grunt.initConfig({
    karma: {
      unit: {
        configFile: 'karma.conf.js',
        singleRun: true
      }
    },
    coffee: {
      options: {
        force: true
      },
      dist: {
        files: [
          {
            expand: true,
            cwd: 'src',
            src: "angular-gravatar.coffee",
            dest: "build",
            ext: ".js"
          }
        ]
      },
      test: {
        files: [
          {
            expand: true,
            cwd: 'spec',
            src: "tests.coffee",
            dest: "build/spec",
            ext: ".js"
          }
        ]
      }
    },
    coffeelint: {
      app: ['src/*.coffee']
    },
    copy: {
      dist: {
        files: [
          {
            src: 'src/md5.js',
            dest: 'build/md5.js'
          }
        ]
      }
    },
    jshint: {
      options: {
        reporter: require('jshint-stylish'),
        jshintrc: true
      },
      target: ['build/angular-gravatar.js']
    },
    uglify: {
      dist: {
        files: {
          'build/angular-gravatar.min.js': 'build/angular-gravatar.js',
          'build/md5.min.js': 'build/md5.js'
        }
      }
    }
  });

  grunt.registerTask('test', [
    'coffeelint',
    'coffee',
    'jshint',
    'karma'
  ]);

  grunt.registerTask('build', [
    'test',
    'copy',
    'uglify'
  ]);

  grunt.registerTask('default', ['build']);
};
