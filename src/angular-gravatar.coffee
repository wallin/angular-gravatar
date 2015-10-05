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
          element.attr('src', gravatarService.url(newVal, opts))
          if bindOnce
            return unless newVal?
            unbind()

          return
        return
  ]

angular.module('ui.gravatar', ['md5'])
.provider('gravatarService', ['md5', (md5) ->

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

  @protocol = null

  # Set default URL function if not already configured
  @urlFunc = (opts) ->
    prefix = if opts.protocol then (opts.protocol + ':') else ''
    urlBase = if opts.secure then 'https://secure' else (prefix + '//www')
    # Don't do MD5 if the string is already MD5
    src = if hashRegex.test(opts.src) then opts.src else md5(opts.src)
    pieces = [urlBase, '.gravatar.com/avatar/', src]

    params = serialize(opts.params)
    pieces.push('?' + params) if params.length > 0
    pieces.join('')

  @$get = [->
    # Generate URL from source (email or md5 hash)
    url: (src = '', params = {}) ->
      self.urlFunc(
        params: angular.extend(angular.copy(self.defaults), params)
        protocol: self.protocol,
        secure: self.secure,
        src: src
      )
  ]
  @
])
.directive('gravatarSrc', gravatarDirectiveFactory())
.directive('gravatarSrcOnce', gravatarDirectiveFactory(true))
