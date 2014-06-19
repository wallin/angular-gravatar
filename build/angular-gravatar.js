angular.module('ui.gravatar', ['md5']).provider('gravatarService', function() {
  var hashRegex, self, serialize;
  self = this;
  hashRegex = /^[0-9a-f]{32}$/i;
  serialize = function(object) {
    var k, params, v;
    params = [];
    for (k in object) {
      v = object[k];
      params.push("" + k + "=" + (escape(v)));
    }
    return params.join('&');
  };
  this.defaults = {};
  this.secure = false;
  this.$get = [
    'md5', function(md5) {
      return {
        url: function(src, opts) {
          var params, pieces, urlBase;
          if (src == null) {
            src = '';
          }
          if (opts == null) {
            opts = {};
          }
          opts = angular.extend(angular.copy(self.defaults), opts);
          urlBase = self.secure ? 'https://secure' : 'http://www';
          src = hashRegex.test(src) ? src : md5(src);
          pieces = [urlBase, '.gravatar.com/avatar/', src];
          params = serialize(opts);
          if (params.length > 0) {
            pieces.push('?' + params);
          }
          return pieces.join('');
        }
      };
    }
  ];
  return this;
}).directive('gravatarSrc', [
  'gravatarService', function(gravatarService) {
    var filterKeys;
    filterKeys = function(prefix, object) {
      var k, retVal, v;
      retVal = {};
      for (k in object) {
        v = object[k];
        if (k.indexOf(prefix) !== 0) {
          continue;
        }
        k = k.substr(prefix.length).toLowerCase();
        if (k.length > 0) {
          retVal[k] = v;
        }
      }
      return retVal;
    };
    return {
      restrict: 'A',
      link: function(scope, element, attrs) {
        var opts;
        opts = filterKeys('gravatar', attrs);
        delete opts.src;
        return scope.$watch(attrs.gravatarSrc, function(src) {
          return element.attr('src', gravatarService.url(src, opts));
        });
      }
    };
  }
]);
