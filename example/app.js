var app = angular.module('app', ['ui.gravatar']);
angular.module('ui.gravatar').config([
  'gravatarServiceProvider', function(gravatarServiceProvider) {
    gravatarServiceProvider.defaults = {
      size     : 100,
      "default": 'mm'
    };
    // Force protocol
    gravatarServiceProvider.protocol = 'http';
  }
]);