
require.config({
	baseUrl: './js',
	paths: {
		jquery: 'libs/jquery-2.1.1',
		underscore: 'libs/underscore'
	},
	skim: {

	}
});

require(['jquery', 'dist/app'], function($, App) {
	$(function() {
		App.init();
	});
});