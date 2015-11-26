// Generated by CoffeeScript 1.10.0
(function() {
  var CategoryController,
    bind = function(fn, me){ return function(){ return fn.apply(me, arguments); }; };

  angular.module('app').controller('categoryCtrl', CategoryController = (function() {
    CategoryController.$inject = ['$scope', '$http', '$log', '$location', '$parse', 'cart', 'breadcrumb', 'server'];

    function CategoryController(scope, http, log, location, parse, cart, breadcrumb, server) {
      var url;
      this.scope = scope;
      this.http = http;
      this.log = log;
      this.location = location;
      this.parse = parse;
      this.cart = cart;
      this.breadcrumb = breadcrumb;
      this.server = server;
      this.addBreadcrumb = bind(this.addBreadcrumb, this);
      this.scope.products = [];
      this.scope.error = {
        show: false,
        message: ''
      };
      url = 'http://' + this.server.serverIp + ':' + this.server.port + '/productCategories/search/findByParentId';
      this.log.debug('Preform GET request for productcategorie with url: ' + url);
      this.http.get(url).then((function(_this) {
        return function(response) {
          var i, item, len, ref, results;
          _this.log.debug('Response of GET request: ');
          _this.log.debug(response);
          ref = response._embedded.productCategories;
          results = [];
          for (i = 0, len = ref.length; i < len; i++) {
            item = ref[i];
            results.push(_this.scope.products.push(item));
          }
          return results;
        };
      })(this));
      if (this.server.debug === true) {
        this.debug();
      }
      angular.extend(this.scope, {
        addBreadcrumb: this.addBreadcrumb,
        debug: this.debug
      });
    }

    CategoryController.prototype.addBreadcrumb = function(title, id) {
      this.location.path('/Products/' + id);
      return this.breadcrumb.push({
        text: title,
        path: '/' + id
      });
    };

    CategoryController.prototype.debug = function() {
      this.scope.products.push({
        src: 'img/soda.png',
        name: 'Soda',
        productCategoryId: -1
      });
      this.scope.products.push({
        src: 'img/hamburger.png',
        name: 'Food',
        productCategoryId: -2
      });
      this.scope.products.push({
        src: 'img/salad.ico',
        name: 'Salat',
        productCategoryId: 0
      });
      return this.scope.products.push({
        src: 'img/candy.png',
        name: 'Candy',
        productCategoryId: 0
      });
    };

    return CategoryController;

  })());

}).call(this);

//# sourceMappingURL=category.js.map
