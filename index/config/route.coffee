angular.module('app').config ($routeProvider, $locationProvider) ->
  $routeProvider
  .when '/',
    templateUrl: 'ngview/category/category.html',
    controller: 'categoryCtrl'
  .when '/Products/:categoryId',
    templateUrl: 'ngview/products/products.html',
    controller: 'productCtrl'
  .when '/Cart/:userId',
    templateUrl: 'ngview/cart/cart.html',
    controller: 'cartCtrl'
  .when '/Orders/:userId',
    templateUrl: 'ngview/orders/orders.html',
    controller: 'orderCtrl'
  .when '/Settings/:userId',
    templateUrl: 'ngview/settings/settings.html',
    controller: 'dataCtrl'

  $locationProvider.html5Mode(true)