'use strict';

angular.module('ui.gravatar', ['md5'])
.provider('gravatarService', [->

  self = @
  hashRegex = /^[0-9a-f]{32}$/i

  # Options that will be passed along in the URL
  @defaults = {}

  @secure = no

  @$get = ['md5', (md5) ->
    # Generate URL from source (email or md5 hash)
    url: (src, opts = {}) ->
      opts = angular.extend(self.defaults, opts)
      urlBase = if self.secure then 'https://secure' else 'http://www'
      pieces = [urlBase, '.gravatar.com/avatar/', if hashRegex.test(src) then src else md5(src)]

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
      scope.$watch attrs.gravatarSrc, (src) ->
        return unless src?
        element.attr('src', gravatarService.url(src, opts))

])
