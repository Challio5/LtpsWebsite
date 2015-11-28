angular.module('app').controller 'orderCtrl', class OrderController

  @$inject: ['$scope', '$http', '$log', '$routeParams', '$mdDialog', '$mdToast', 'server', 'debug']
  constructor: (@scope, @http, @log, @routeParams, @mdToast, @mdDialog, @server, @debug) ->
    @scope.orders = []
    @scope.noOrders = false

    url = 'http://' + @server.serverIp + ':' + @server.port + '/order/search/findByUserIdOrderByOrderIdDesc?userId=' + @routeParams.userId
    @log.debug('Preform GET request for orders with url: ' + url)

    if @debug.debug == true
      @debug.orderPush(@scope.orders)
    else
      @http.get(url).success((response) =>
        @log.debug('Response of GET request: ')
        @log.debug(response)

        if response.hasOwnProperty("_embedded")
          for item in response._embedded.order
            @scope.orders.push(item)
        else
          @log.debug('No orders available')
          @scope.noOrders = true
      )

    # Bind functions to scope
    angular.extend @scope,
      onSwipeRight: @onSwipeRight
      increase: @increase
      decrease: @decrease
      deleteOrder: @deleteOrder
      deleteProductOrder: @deleteProductOrder

  onSwipeRight: (index) =>
    @scope.orders(index, 1)

  increase: (orderIndex, productOrderIndex) =>
    productOrder = @scope.orders[orderIndex]._embedded.productOrders[productOrderIndex]
    productOrder.amount++

    if !@debug.debug
      data = "{\"amount\" : " + productOrder.amount + "}"

      @log.debug('Preform PATCH request for updating orderamount with url: ' + productOrder._links.self.href)
      @log.debug('Preform PATCH request for updating orderamount with data: ')
      @log.debug(data)

      @http.patch(productOrder._links.self.href, data).success (data, status, headers, config) =>
        @log.debug('Respons of PATCH request with returned headers: ')
        @log.debug(headers)

  decrease: (orderIndex, productOrderIndex) =>
    productOrder = @scope.orders[orderIndex]._embedded.productOrders[productOrderIndex]
    productOrder.amount--

    if !@debug.debug
      data = "{\"amount\" : " + productOrder.amount + "}"

      @log.debug('Preform PATCH request for updating orderamount with url: ' + productOrder._links.self.href)
      @log.debug('Preform PATCH request for updating orderamount with data: ')
      @log.debug(data)

      @http.patch(productOrder._links.self.href, data).success (data, status, headers, config) =>
        @log.debug('Respons of PATCH request with returned headers: ')
        @log.debug(headers)

  deleteOrder: (index) =>
    if @debug.debug
      @debug.deleteOrder(@scope.orders, index)

    else
      url = 'http://' + @server.serverIp + ':' + @server.port + '/order/' + @scope.orders[index].orderId
      @log.debug('Preform DELETE request for deleting order with url: ' + url)

      @http.delete(url).success (response) =>
        dialog = @mdDialog.confirm
          title: 'Attention'
          content: 'You are about to delete order with id: ' + order[index].orderId
          ok: 'OK'
          cancel: 'Cancel'

        @mdDialog.show(dialog).then =>
          @log.debug('User removes order')

          order = @scope.orders.splice(index, 1)

          toast = @mdToast.simple()
          .content('Order deleted with id: ' + order[index].orderId)
          .hideDelay(1000)
          .position("top right")

          @mdToast.show(toast)
        , =>
          @log.debug('User cancels to remove order')

  deleteProductOrder: (orderIndex, productOrderIndex) =>
    if @debug.debug
      @debug.deleteProductOrder(@scope.orders, orderIndex, productOrderIndex)

    else
      url = 'http://' + @server.serverIp + ':' + @server.port + '/product_order/' + @scope.orders[orderIndex]._embedded.productOrders[productOrderIndex].id
      @log.debug('Preform DELETE request for deleting productorder with url: ' + url)

      @http.delete(url).success (response) =>
        dialog = @mdDialog.confirm
          title: 'Attention'
          content: 'You are about to remove all: ' + productOrder[0].product.name
          ok: 'OK'
          cancel: 'Cancel'

        dialog.show(dialog).then =>
          @log.debug('User removes productOrder')

          productOrder = @scope.orders[orderIndex]._embedded.productOrders.splice(productOrderIndex, 1)

          toast = @mdToast.simple()
          .content('Products deleted: ' + productOrder[0].product.name)
          .hideDelay(1000)
          .position("top right")

          @mdToast.show(toast)

          if @scope.orders[orderIndex]._embedded.productOrders.length == 0
            @deleteOrder(orderIndex)

        , =>
          @log.debug('User cancels to remove a productOrder')