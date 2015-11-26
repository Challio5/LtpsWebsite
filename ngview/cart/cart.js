// Generated by CoffeeScript 1.10.0
(function() {
  var CartController,
    bind = function(fn, me){ return function(){ return fn.apply(me, arguments); }; };

  angular.module('app').controller('cartCtrl', CartController = (function() {
    CartController.$inject = ['$scope', '$http', '$log', '$mdDialog', '$mdToast', 'cart', 'user', 'server'];

    function CartController(scope, http, log, mdDialog, mdToast, cart, user, server) {
      this.scope = scope;
      this.http = http;
      this.log = log;
      this.mdDialog = mdDialog;
      this.mdToast = mdToast;
      this.cart = cart;
      this.user = user;
      this.server = server;
      this.placeOrder = bind(this.placeOrder, this);
      this.createOrder = bind(this.createOrder, this);
      this.deleteProductOrder = bind(this.deleteProductOrder, this);
      this.deleteOrder = bind(this.deleteOrder, this);
      this.decrease = bind(this.decrease, this);
      this.increase = bind(this.increase, this);
      angular.extend(this.scope, {
        increase: this.increase,
        decrease: this.decrease,
        deleteOrder: this.deleteOrder,
        deleteProductOrder: this.deleteProductOrder,
        createOrder: this.createOrder,
        placeOrder: this.placeOrder
      });
    }

    CartController.prototype.increase = function(index) {
      var productOrder;
      productOrder = this.cart.products.items[index];
      return productOrder.amount++;
    };

    CartController.prototype.decrease = function(index) {
      var productOrder;
      productOrder = this.cart.products.items[index];
      return productOrder.amount--;
    };

    CartController.prototype.deleteOrder = function() {
      return this.cart.products.items = [];
    };

    CartController.prototype.deleteProductOrder = function(index) {
      return this.cart.products.items.splice(index, 1);
    };

    CartController.prototype.createOrder = function(ev) {
      if (this.user.loggedUser.userId < 0) {
        return this.mdDialog.show({
          controller: 'loginCtrl',
          templateUrl: 'ngview/login/logout.html',
          targetEvent: ev,
          clickOutsideToClose: true,
          onRemoving: function() {
            if (this.user.loggedUser.userId > 0) {
              return this.scope.placeOrder();
            }
          }
        });
      } else {
        return this.scope.placeOrder();
      }
    };

    CartController.prototype.placeOrder = function() {
      var orderUrl;
      this.cart.order.userId = this.user.loggedUser.userId;
      orderUrl = 'http://' + this.server.serverIp + ':' + this.server.port + '/order';
      this.log.debug('Preform POST request for order with url: ' + orderUrl);
      this.log.debug('Preform POST request for order with data: ');
      this.log.debug(this.cart.order);
      return this.http.post(orderUrl, this.cart.order).success((function(_this) {
        return function(data, status, headers, config) {
          var i, len, orderId, productOrder, productOrderUrl, ref, toast;
          orderId = headers('Location').split('/').pop();
          _this.log.debug('Respons of POST request with returned headers: ');
          _this.log.debug(headers());
          productOrderUrl = 'http://' + _this.server.serverIp + ':' + _this.server.port + '/product_order';
          ref = _this.cart.products.items;
          for (i = 0, len = ref.length; i < len; i++) {
            productOrder = ref[i];
            _this.log.debug('Preform POST request for productorder with url: ' + productOrderUrl);
            _this.log.debug('Preform POST request for order with data: ');
            _this.log.debug(productOrder);
            productOrder.orderId = orderId;
            _this.http.post(productOrderUrl, productOrder).success(function(data, status, headers, config) {
              _this.log.debug('Respons of POST request with returned headers: ');
              return _this.log.debug(headers);
            });
          }
          toast = _this.mdToast.simple().content('Order placed with id: ' + orderId).hideDelay(500).position("top right");
          _this.mdToast.show(toast);
          _this.cart.order = {
            code: '',
            statusId: 1,
            machineId: null,
            userId: 1
          };
          return _this.cart.products = {
            items: []
          };
        };
      })(this));
    };

    return CartController;

  })());

}).call(this);

//# sourceMappingURL=cart.js.map
