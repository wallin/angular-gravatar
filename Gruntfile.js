'use strict';

module.exports = function (grunt) {
	// load all grunt tasks
	require('matchdep').filterDev('grunt-*').forEach(grunt.loadNpmTasks);

	grunt.initConfig({
		karma: {
			unit: {
				configFile: 'karma.conf.js',
				singleRun: true
			}
		},
		coffee: {
		  options: {
		  	bare: true,
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
		uglify: {
			dist: {
				files: {
					'build/angular-gravatar.min.js': 'build/angular-gravatar.js'
				}
			}
		}
	});

	grunt.registerTask('test', [
		'coffee',
		'karma'
	]);

	grunt.registerTask('build', [
		'coffee',
		'uglify'
	]);

	grunt.registerTask('default', ['build']);
};
