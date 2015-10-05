(function() {
  var gravatarDirectiveFactory;

  gravatarDirectiveFactory = function(bindOnce) {
    return [
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
            var directiveName, item, opts, unbind;
            directiveName = bindOnce ? 'gravatarSrcOnce' : 'gravatarSrc';
            item = attrs[directiveName];
            delete attrs[directiveName];
            opts = filterKeys('gravatar', attrs);
            unbind = scope.$watch(item, function(newVal) {
              element.attr('src', gravatarService.url(newVal, opts));
              if (bindOnce) {
                if (newVal == null) {
                  return;
                }
                unbind();
              }
            });
          }
        };
      }
    ];
  };

  angular.module('ui.gravatar', ['md5']).provider('gravatarService', [
    'md5', function(md5) {
      var hashRegex, self, serialize;
      self = this;
      hashRegex = /^[0-9a-f]{32}$/i;
      serialize = function(object) {
        var k, params, v;
        params = [];
        for (k in object) {
          v = object[k];
          params.push("" + k + "=" + (encodeURIComponent(v)));
        }
        return params.join('&');
      };
      this.defaults = {};
      this.secure = false;
      this.protocol = null;
      this.urlFunc = function(opts) {
        var params, pieces, prefix, src, urlBase;
        prefix = opts.protocol ? opts.protocol + ':' : '';
        urlBase = opts.secure ? 'https://secure' : prefix + '//www';
        src = hashRegex.test(opts.src) ? opts.src : md5(opts.src);
        pieces = [urlBase, '.gravatar.com/avatar/', src];
        params = serialize(opts.params);
        if (params.length > 0) {
          pieces.push('?' + params);
        }
        return pieces.join('');
      };
      this.$get = [
        function() {
          return {
            url: function(src, params) {
              if (src == null) {
                src = '';
              }
              if (params == null) {
                params = {};
              }
              return self.urlFunc({
                params: angular.extend(angular.copy(self.defaults), params),
                protocol: self.protocol,
                secure: self.secure,
                src: src
              });
            }
          };
        }
      ];
      return this;
    }
  ]).directive('gravatarSrc', gravatarDirectiveFactory()).directive('gravatarSrcOnce', gravatarDirectiveFactory(true));

}).call(this);
