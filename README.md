angular-gravatar
==============

Angular.JS directive for [Gravatar](http://www.gravatar.com).

Copyright (C) 2013, Sebastian Wallin <sebastian.wallin@gmail.com>

Usage
-----
Include both md5.js and angular-gravatar.js in your application.

```html
<script src="components/angular-gravatar/src/md5.js"></script>
<script src="components/angular-gravatar/build/angular-gravatar.js"></script>
```

Add the module `ui.gravatar` as a dependency to your app:

```js
var app = angular.module('app', ['ui.gravatar']);
```

Then use the directive on an image tag and it will set the correct `src`
attribute for you.

```html
<img gravatar-src="'sebastian.wallin@gmail.com'" gravatar-size="100">
```

If the source is already an MD5 hash, it will be left untouched (thanks @thewarpaint)

Configuration
-----

The options that are sent along to Gravatar can be set either
directly in the directive as seen above with `size` or configured as default
parameters via the `gravatarServiceProvider`:

```js
angular.module('ui.gravatar').config([
  'gravatarServiceProvider', function(gravatarServiceProvider) {
    gravatarServiceProvider.defaults = {
      size     : 100,
      "default": 'mm'  // Mystery man as default for missing avatars
    };

    // Use https endpoint
    gravatarServiceProvider.secure = true;
  }
]);
```

All the available options can be seen over at the [Gravatar docs for image
requests](https://sv.gravatar.com/site/implement/images/)


