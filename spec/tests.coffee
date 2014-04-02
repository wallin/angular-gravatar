'use strict'

describe 'Directive: gravatarSrc', ->
  beforeEach module 'ui.gravatar'
  element = {}

  it 'should set the src attribute with Gravatar URL', inject ($rootScope, $compile) ->
    $rootScope.email = "test@example.com"
    element = angular.element '<img gravatar-src="email">'
    element = $compile(element) $rootScope
    $rootScope.$apply()
    expect(element.attr('src')).toBeTruthy()

  it 'should set the src attribute from static src', inject ($rootScope, $compile) ->
    element = angular.element '<img gravatar-src="\'sebastian.wallin@gmail.com\'">'
    element = $compile(element) $rootScope
    $rootScope.$apply()
    expect(element.attr('src')).toBeTruthy()

describe 'Service: gravatarService', ->
  beforeEach module 'ui.gravatar'

  gravatarService = {}
  beforeEach inject (_gravatarService_) ->
    gravatarService = _gravatarService_

  email = 'sebastian.wallin@gmail.com'
  emailmd5 = '46ab5c60ced85b09c35fd31a510206ef'

  describe '#url:', ->
    it 'should generate an url without parameters to gravatar avatar endpoint', ->
      url = gravatarService.url(email)
      expect(url).toBe 'http://www.gravatar.com/avatar/' + emailmd5

    it 'should generate an url with provided parameters', ->
      opts =
        size: 100
        default: 'mm'

      url = gravatarService.url(email, opts)
      for k, v of opts
        expect(url).toContain("#{k}=#{v}")

    it 'should URL encode options in final URL', ->
      url = 'http://placekitten.com/100/100'
      urlEscaped = escape('http://placekitten.com/100/100')
      opts =
        default: url

      expect(gravatarService.url(email, opts)).toMatch(urlEscaped)

    it 'should not re-encode the source if it is already a lowercase MD5 hash', ->
      expect(gravatarService.url(emailmd5)).toMatch(emailmd5)

    it 'should not re-encode the source if it is already an uppercase MD5 hash', ->
      src = emailmd5.toUpperCase()
      expect(gravatarService.url(src)).toMatch(src)

    it 'should not overwrite default options', ->
      opts =
        size: 100

      url = gravatarService.url(email, opts)
      url = gravatarService.url(email)

      expect(url).not.toContain('size')
