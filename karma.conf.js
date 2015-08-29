'use strict';

module.exports = function (config) {
	config.set({
		basePath: '',
		frameworks: ['jasmine'],
		logLevel: config.LOG_INFO,
		browsers: ['PhantomJS'],
		singleRun: true,
		reporters: ['dots', 'coverage'],
		files: [
			'bower_components/angular/angular.js',
			'bower_components/angular-mocks/angular-mocks.js',
			'src/md5.js',
			'build/angular-gravatar.js',
			'build/spec/tests.js'
		],
		preprocessors: {
			'build/angular-gravatar.js': 'coverage'
		}
	});
};
