'use strict';

angular.module('ui.gravatar', ['md5'])
.provider('gravatarService', [->

  self = @

  # Options that will be passed along in the URL
  @defaults = {}

  @secure = no

  @$get = ['md5', (md5) ->
    # Generate URL from email
    url: (email, opts = {}) ->
      opts = angular.extend(self.defaults, opts)
      urlBase = if self.secure then 'https://secure' else 'http://www'
      pieces = [urlBase, '.gravatar.com/avatar/', md5(email)]
      params = ("#{k}=#{escape(v)}" for k, v of opts).join('&')
      pieces.push('?' + params) if params.length > 0
      pieces.join('')
  ]
  @
])
.directive('gravatarSrc', [
  'gravatarService'
  (gravatarService) ->

    # Get and strip keys with certain prefix only
    filterKeys = (prefix, object) ->
      retVal = {}
      for k, v of object
        if k.indexOf(prefix) is 0
          k = k.substr(prefix.length).toLowerCase()
          retVal[k] = v if k.length > 0
      retVal

    restrict: 'A'
    link: (scope, element, attrs) ->
      # Look for gravatar options
      opts = filterKeys 'gravatar', attrs
      delete opts['src']
      scope.$watch attrs.gravatarSrc, (email) ->
        return unless email?
        element.attr('src', gravatarService.url(email, opts))

])
