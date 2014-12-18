'use strict'

describe 'Directive: gravatarSrc', ->
  beforeEach module 'ui.gravatar'
  element = {}

  email = 'sebastian.wallin@gmail.com'
  emailmd5 = '46ab5c60ced85b09c35fd31a510206ef'

  $compile = {}
  gravatarService = {}
  beforeEach inject (_gravatarService_, _$compile_) ->
    gravatarService = _gravatarService_
    $compile = _$compile_

  createElement = (html, scope) ->
    element = angular.element(html)
    element = $compile(element) scope
    scope.$apply()
    element

  it 'sets the src attribute with Gravatar URL', inject ($rootScope, $compile) ->
    $rootScope.email = "test@example.com"
    element = createElement '<img gravatar-src="email">', $rootScope
    expect(element.attr('src')).toBeTruthy()

  it 'sets the src attribute from static src', inject ($rootScope, $compile) ->
    element = createElement '<img gravatar-src="\'sebastian.wallin@gmail.com\'">', $rootScope
    expect(element.attr('src')).toContain('46ab5c60ced85b09c35fd31a510206ef')

  it 'generates a gravatar image for empty src', inject ($rootScope, $compile) ->
    $rootScope.email = null
    element = createElement '<img gravatar-src="email">', $rootScope
    expect(element.attr('src')).toContain('gravatar')

  it 'does not include the directive name in the gravatar url', inject ($rootScope) ->
    $rootScope.email = email
    element = createElement('<img gravatar-src-once="email">', $rootScope)
    expect(element.attr('src')).not.toContain 'src'


  describe 'when gravatar-src-once is used', ->
    it 'does not change src when email is changed', inject ($rootScope) ->
      $rootScope.email = 'diaper.dynamo@example.com'
      element = createElement('<img gravatar-src-once="email">', $rootScope)
      srcBefore = element.attr('src')
      $rootScope.email = 'something.else@example.com'
      $rootScope.$apply()
      expect(element.attr('src')).toBe srcBefore

    it 'does not lock on null', inject ($rootScope) ->
      element = createElement('<img gravatar-src-once="email">', $rootScope)

      expect(element.attr('src')).toBeUndefined();

      $rootScope.email = email
      $rootScope.$apply()
      expect(element.attr('src')).toContain(emailmd5)

      $rootScope.email = 'something.else@example.com'
      $rootScope.$apply()
      expect(element.attr('src')).toContain(emailmd5)

    it 'does not include the directive name in the gravatar url', inject ($rootScope) ->
      $rootScope.email = email
      element = createElement('<img gravatar-src-once="email">', $rootScope)
      expect(element.attr('src')).not.toContain 'once'

  describe 'when using specific protocol', ->
    it 'does not include the directive name in the gravatar url', inject ($rootScope) ->
      $rootScope.email = email
      element = createElement('<img data-protocol="http" gravatar-src-once="email">', $rootScope)
      expect(element.attr('src')).toContain('http://www.')

describe 'Service: gravatarService', ->
  beforeEach module 'ui.gravatar'

  gravatarService = {}
  beforeEach inject (_gravatarService_) ->
    gravatarService = _gravatarService_

  email = 'sebastian.wallin@gmail.com'
  emailmd5 = '46ab5c60ced85b09c35fd31a510206ef'

  describe '#url:', ->
    it 'generates an url without parameters to gravatar avatar endpoint', ->
      url = gravatarService.url(email)
      expect(url).toBe '//www.gravatar.com/avatar/' + emailmd5

    it 'generates an url with provided parameters', ->
      opts =
        size: 100
        default: 'mm'

      url = gravatarService.url(email, opts)
      for k, v of opts
        expect(url).toContain("#{k}=#{v}")

    it 'URL encodes options in final URL', ->
      url = 'http://placekitten.com/100/100'
      urlEscaped = encodeURIComponent('http://placekitten.com/100/100')
      opts =
        default: url

      expect(gravatarService.url(email, opts)).toMatch(urlEscaped)

    it 'does not re-encode the source if it is already a lowercase MD5 hash', ->
      expect(gravatarService.url(emailmd5)).toMatch(emailmd5)

    it 'does not re-encode the source if it is already an uppercase MD5 hash', ->
      src = emailmd5.toUpperCase()
      expect(gravatarService.url(src)).toMatch(src)

    it 'does not overwrite default options', ->
      opts =
        size: 100

      url = gravatarService.url(email, opts)
      url = gravatarService.url(email)

      expect(url).not.toContain('size')

    it 'generates an url forcing the specified protocol', ->
      url = gravatarService.url(email, {}, 'mock-protocol')
      expect(url).toBe 'mock-protocol://www.gravatar.com/avatar/' + emailmd5

