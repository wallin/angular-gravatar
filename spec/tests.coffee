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