// Generated by CoffeeScript 1.10.0
(function() {
  angular.module('app').config(function($routeProvider, $locationProvider) {
    $routeProvider.when('/', {
      templateUrl: 'ngview/category/category.html',
      controller: 'categoryCtrl'
    }).when('/Products/:categoryId', {
      templateUrl: 'ngview/products/products.html',
      controller: 'productCtrl'
    }).when('/Cart/:userId', {
      templateUrl: 'ngview/cart/cart.html',
      controller: 'cartCtrl'
    }).when('/Orders/:userId', {
      templateUrl: 'ngview/orders/orders.html',
      controller: 'orderCtrl'
    }).when('/Settings/:userId', {
      templateUrl: 'ngview/settings/settings.html',
      controller: 'dataCtrl'
    });
    return $locationProvider.html5Mode(true);
  });

}).call(this);

//# sourceMappingURL=route.js.map
