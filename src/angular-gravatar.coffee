gravatarDirectiveFactory = (bindOnce) ->
  [
    'gravatarService'
    (gravatarService) ->
      # Get and strip keys with certain prefix only
      filterKeys = (prefix, object) ->
        retVal = {}
        for k, v of object
          continue unless k.indexOf(prefix) is 0
          k = k.substr(prefix.length).toLowerCase()
          retVal[k] = v if k.length > 0
        retVal

      restrict: 'A'
      link: (scope, element, attrs) ->
        directiveName = if bindOnce then 'gravatarSrcOnce' else 'gravatarSrc'
        item = attrs[directiveName]
        delete attrs[directiveName]
        # Look for gravatar options
        opts = filterKeys 'gravatar', attrs
        unbind = scope.$watch item, (newVal) ->
          if bindOnce
            return unless newVal?
            unbind()

          element.attr('src', gravatarService.url(newVal, opts, attrs.protocol))
          return
        return
  ]

angular.module('ui.gravatar', ['md5'])
.provider('gravatarService', ->

  self = @
  hashRegex = /^[0-9a-f]{32}$/i

  serialize = (object) ->
    params = []
    for k, v of object
      params.push "#{k}=#{encodeURIComponent(v)}"
    params.join('&')

  # Options that will be passed along in the URL
  @defaults = {}

  @secure = no

  @$get = ['md5', (md5) ->
    # Generate URL from source (email or md5 hash)
    url: (src = '', opts = {}, protocol) ->
      protocol = if protocol then protocol + '://www' else '//www'
      opts = angular.extend(angular.copy(self.defaults), opts)
      urlBase = if self.secure then 'https://secure' else protocol
      # Don't do MD5 if the string is already MD5
      src = if hashRegex.test(src) then src else md5(src)
      pieces = [urlBase, '.gravatar.com/avatar/', src]

      params = serialize(opts)
      pieces.push('?' + params) if params.length > 0
      pieces.join('')
  ]
  @
)
.directive('gravatarSrc', gravatarDirectiveFactory())
.directive('gravatarSrcOnce', gravatarDirectiveFactory(true))
