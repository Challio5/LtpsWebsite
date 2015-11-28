angular.module('app').controller 'cartCtrl', class CartController
  
  @$inject: ['$scope', '$http', '$log', '$mdDialog', '$mdToast', 'cart', 'user', 'server', 'debug']
  constructor: (@scope, @http, @log, @mdDialog, @mdToast, @cart, @user, @server, @debug) ->
    # Bind function to scope
    angular.extend @scope,
      increase: @increase
      decrease: @decrease
      deleteOrder: @deleteOrder
      deleteProductOrder: @deleteProductOrder
      createOrder: @createOrder
      placeOrder: @placeOrder
      feedback: @feedback

  increase: (index) =>
    productOrder = @cart.products.items[index]
    productOrder.amount++

  decrease: (index) =>
    productOrder = @cart.products.items[index]
    productOrder.amount--

  deleteOrder: =>
    confirm = @mdDialog.confirm
      title: 'Attention'
      content: 'You are about to remove all items from your cart'
      ok: 'OK'
      cancel: 'Cancel'

    @mdDialog.show(confirm).then(() =>
      @log.debug('User clears cart')

      @cart.products.items = []

      toast = @mdToast.simple()
      .content('Cart is cleared')
      .hideDelay(500)
      .position("top right")

      @mdToast.show(toast)

    , () =>
      @log.debug('User cancels clearing cart')
    )

  deleteProductOrder: (index) =>
    confirm = @mdDialog.confirm
      title: 'Attention'
      content: 'You are about to remove all ' + @cart.products.items[index].name + ' from your cart'
      ok: 'OK'
      cancel: 'Cancel'

    @mdDialog.show(confirm).then(() =>
      @log.debug('User clears productamount from cart')

      item = @cart.products.items.splice(index, 1)

      toast = @mdToast.simple()
      .content(item[0].name + ' is cleared from cart')
      .hideDelay(500)
      .position("top right")

      @mdToast.show(toast)

    , () =>
      @log.debug('User cancels clearing productamount from cart')
    )

  # Function for checking ordering conditions
  createOrder: (ev) =>
    if @user.loggedUser.userId < 0
      @mdDialog.show(
        controller: 'loginCtrl'
        templateUrl: 'ngview/login/login.html'
        targetEvent: ev
        clickOutsideToClose: true
        onRemoving: () =>
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

    if(@debug.debug)
      @feedback(999)

    else
      @http.post(orderUrl, @cart.order).success (data, status, headers, config) =>
        orderId = headers('Location').split('/').pop()

        @log.debug('Response of POST request with returned headers: ')
        @log.debug(headers())

        productOrderUrl = 'http://' + @server.serverIp + ':' + @server.port + '/product_order'

        # Add products to order
        for productOrder in @cart.products.items
          @log.debug('Preform POST request for productorder with url: ' + productOrderUrl)
          @log.debug('Preform POST request for order with data: ')
          @log.debug(productOrder)

          productOrder.orderId = orderId

          @http.post(productOrderUrl, productOrder).success (data, status, headers, config) =>
            @log.debug('Response of POST request with returned headers: ')
            @log.debug(headers)

        @feedback(orderId)


  feedback: (orderId) =>
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
    @cart.products.items = []