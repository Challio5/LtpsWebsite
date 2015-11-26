// Generated by CoffeeScript 1.10.0
(function() {
  var OrderController,
    bind = function(fn, me){ return function(){ return fn.apply(me, arguments); }; };

  angular.module('app').controller('orderCtrl', OrderController = (function() {
    OrderController.$inject = ['$scope', '$http', '$log', '$routeParams', '$mdToast', 'server'];

    function OrderController(scope, http, log, routeParams, mdToast, server) {
      var url;
      this.scope = scope;
      this.http = http;
      this.log = log;
      this.routeParams = routeParams;
      this.mdToast = mdToast;
      this.server = server;
      this.debug = bind(this.debug, this);
      this.deleteProductOrder = bind(this.deleteProductOrder, this);
      this.deleteOrder = bind(this.deleteOrder, this);
      this.decrease = bind(this.decrease, this);
      this.increase = bind(this.increase, this);
      this.onSwipeRight = bind(this.onSwipeRight, this);
      this.scope.orders = [];
      this.scope.noOrders = false;
      url = 'http://' + this.server.serverIp + ':' + this.server.port + '/order/search/findByUserIdOrderByOrderIdDesc?userId=' + this.routeParams.userId;
      this.log.debug('Preform GET request for orders with url: ' + url);
      this.http.get(url).success((function(_this) {
        return function(response) {
          var i, item, len, ref, results;
          _this.log.debug('Response of GET request: ');
          _this.log.debug(response);
          if (response.hasOwnProperty("_embedded")) {
            ref = response._embedded.order;
            results = [];
            for (i = 0, len = ref.length; i < len; i++) {
              item = ref[i];
              results.push(_this.scope.orders.push(item));
            }
            return results;
          } else {
            _this.log.debug('No orders available');
            return _this.scope.noOrders = true;
          }
        };
      })(this));
      if (this.server.debug === true) {
        this.debug();
      }
      angular.extend(this.scope, {
        onSwipeRight: this.onSwipeRight,
        increase: this.increase,
        decrease: this.decrease,
        deleteOrder: this.deleteOrder,
        deleteProductOrder: this.deleteProductOrder,
        debug: this.debug
      });
    }

    OrderController.prototype.onSwipeRight = function(index) {
      return this.scope.orders(index, 1);
    };

    OrderController.prototype.increase = function(orderIndex, productOrderIndex) {
      var data, productOrder;
      productOrder = this.scope.orders[orderIndex]._embedded.productOrders[productOrderIndex];
      productOrder.amount++;
      data = "{\"amount\" : " + productOrder.amount + "}";
      this.log.debug('Preform PATCH request for updating orderamount with url: ' + productOrder._links.self.href);
      this.log.debug('Preform PATCH request for updating orderamount with data: ');
      this.log.debug(data);
      return this.http.patch(productOrder._links.self.href, data).success((function(_this) {
        return function(data, status, headers, config) {
          _this.log.debug('Respons of PATCH request with returned headers: ');
          return _this.log.debug(headers);
        };
      })(this));
    };

    OrderController.prototype.decrease = function(orderIndex, productOrderIndex) {
      var data, productOrder;
      productOrder = this.scope.orders[orderIndex]._embedded.productOrders[productOrderIndex];
      productOrder.amount--;
      data = "{\"amount\" : " + productOrder.amount + "}";
      this.log.debug('Preform PATCH request for updating orderamount with url: ' + productOrder._links.self.href);
      this.log.debug('Preform PATCH request for updating orderamount with data: ');
      this.log.debug(data);
      return this.http.patch(productOrder._links.self.href, data).success((function(_this) {
        return function(data, status, headers, config) {
          _this.log.debug('Respons of PATCH request with returned headers: ');
          return _this.log.debug(headers);
        };
      })(this));
    };

    OrderController.prototype.deleteOrder = function(index) {
      var url;
      url = 'http://' + this.server.serverIp + ':' + this.server.port + '/order/' + this.scope.orders[index].orderId;
      this.log.debug('Preform DELETE request for deleting order with url: ' + url);
      return this.http["delete"](url).success((function(_this) {
        return function(response) {
          var order, toast;
          order = _this.scope.orders.splice(index, 1);
          toast = _this.mdToast.simple().content('Order deleted with id: ' + order[0].orderId).hideDelay(1000).position("top right");
          return _this.mdToast.show(toast);
        };
      })(this));
    };

    OrderController.prototype.deleteProductOrder = function(orderIndex, productOrderIndex) {
      var url;
      url = 'http://' + this.server.serverIp + ':' + this.server.port + '/product_order/' + this.scope.orders[orderIndex]._embedded.productOrders[productOrderIndex].id;
      this.log.debug('Preform DELETE request for deleting productorder with url: ' + url);
      return this.http["delete"](url).success((function(_this) {
        return function(response) {
          var productOrder, toast;
          productOrder = _this.scope.orders[orderIndex]._embedded.productOrders.splice(productOrderIndex, 1);
          toast = _this.mdToast.simple().content('Products deleted: ' + productOrder[0].product.name).hideDelay(1000).position("top right");
          _this.mdToast.show(toast);
          if (_this.scope.orders[orderIndex]._embedded.productOrders.length === 0) {
            return _this.deleteOrder(orderIndex);
          }
        };
      })(this));
    };

    OrderController.prototype.debug = function() {
      this.scope.orders.push({
        orderId: -9,
        show: false,
        _embedded: {
          productOrders: [
            {
              product: {
                id: -99,
                name: 'Cola'
              },
              amount: 1,
              price: 1.5
            }, {
              product: {
                id: -88,
                name: 'Patat'
              },
              amount: 5,
              price: 2.8
            }, {
              product: {
                id: -11,
                name: 'Hamburger'
              },
              amount: 3,
              price: 3.5
            }
          ]
        }
      });
      return this.scope.orders.push({
        orderId: -10,
        show: false,
        _embedded: {
          productOrders: [
            {
              product: {
                id: -99,
                name: 'Cola'
              },
              amount: 3,
              price: 1.5
            }, {
              product: {
                id: -33,
                name: 'Snoep'
              },
              amount: 2,
              price: 0.7
            }, {
              product: {
                id: -22,
                name: 'Bamischijf'
              },
              amount: 6,
              price: 2.2
            }
          ]
        }
      });
    };

    return OrderController;

  })());

}).call(this);

//# sourceMappingURL=orders.js.map