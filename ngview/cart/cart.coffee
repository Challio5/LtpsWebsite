angular.module('app').controller 'cartCtrl', class CartController
  
  @$inject: ['$scope', '$http', '$log', '$mdDialog', '$mdToast', 'cart', 'user', 'server']
  constructor: (@scope, @http, @log, @mdDialog, @mdToast, @cart, @user, @server) ->
    # Bind function to scope
    angular.extend @scope,
      increase: @increase
      decrease: @decrease
      deleteOrder: @deleteOrder
      deleteProductOrder: @deleteProductOrder
      createOrder: @createOrder
      placeOrder: @placeOrder

  increase: (index) =>
    productOrder = @cart.products.items[index]
    productOrder.amount++

  decrease: (index) =>
    productOrder = @cart.products.items[index]
    productOrder.amount--

  deleteOrder: =>
    @cart.products.items = []

  deleteProductOrder: (index) =>
    @cart.products.items.splice(index, 1)

  # Function for checking ordering conditions
  createOrder: (ev) =>
    if @user.loggedUser.userId < 0
      @mdDialog.show(
        controller: 'loginCtrl'
        templateUrl: 'ngview/login/logout.html'
        targetEvent: ev
        clickOutsideToClose: true
        onRemoving: () ->
          if @user.loggedUser.userId > 0
            @scope.placeOrder()
      )
    else
      @scope.placeOrder()

  placeOrder: =>
    # Update order
    @cart.order.userId = @user.loggedUser.userId

    # Create order
    orderUrl = 'http://' + @server.serverIp + ':' + @server.port + '/order'

    @log.debug('Preform POST request for order with url: ' + orderUrl)
    @log.debug('Preform POST request for order with data: ')
    @log.debug(@cart.order)

    @http.post(orderUrl, @cart.order).success (data, status, headers, config) =>
      orderId = headers('Location').split('/').pop()

      @log.debug('Respons of POST request with returned headers: ')
      @log.debug(headers())

      productOrderUrl = 'http://' + @server.serverIp + ':' + @server.port + '/product_order'

      # Add products to order
      for productOrder in @cart.products.items
        @log.debug('Preform POST request for productorder with url: ' + productOrderUrl)
        @log.debug('Preform POST request for order with data: ')
        @log.debug(productOrder)

        productOrder.orderId = orderId

        @http.post(productOrderUrl, productOrder).success (data, status, headers, config) =>
          @log.debug('Respons of POST request with returned headers: ')
          @log.debug(headers)

      # Toast message
      toast = @mdToast.simple()
      .content('Order placed with id: ' + orderId)
      .hideDelay(500)
      .position("top right")

      @mdToast.show(toast)

      # Clear cart
      # Order object
      @cart.order =
        code: ''
        statusId: 1
        machineId: null
        userId: 1

      # Array of product IDs
      @cart.products =
        items: []