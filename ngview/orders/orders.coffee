angular.module('app').controller 'orderCtrl', class OrderController

  @$inject: ['$scope', '$http', '$log', '$routeParams', '$mdToast', 'server']
  constructor: (@scope, @http, @log, @routeParams, @mdToast, @server) ->
    @scope.orders = []
    @scope.noOrders = false

    url = 'http://' + @server.serverIp + ':' + @server.port + '/order/search/findByUserIdOrderByOrderIdDesc?userId=' + @routeParams.userId
    @log.debug('Preform GET request for orders with url: ' + url)

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

    if @server.debug == true
      @debug()

    # Bind functions to scope
    angular.extend @scope,
      onSwipeRight: @onSwipeRight
      increase: @increase
      decrease: @decrease
      deleteOrder: @deleteOrder
      deleteProductOrder: @deleteProductOrder
      debug: @debug

  onSwipeRight: (index) =>
    @scope.orders(index, 1)

  increase: (orderIndex, productOrderIndex) =>
    productOrder = @scope.orders[orderIndex]._embedded.productOrders[productOrderIndex]
    productOrder.amount++

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

    data = "{\"amount\" : " + productOrder.amount + "}"

    @log.debug('Preform PATCH request for updating orderamount with url: ' + productOrder._links.self.href)
    @log.debug('Preform PATCH request for updating orderamount with data: ')
    @log.debug(data)

    @http.patch(productOrder._links.self.href, data).success (data, status, headers, config) =>
      @log.debug('Respons of PATCH request with returned headers: ')
      @log.debug(headers)

  deleteOrder: (index) =>
    url = 'http://' + @server.serverIp + ':' + @server.port + '/order/' + @scope.orders[index].orderId
    @log.debug('Preform DELETE request for deleting order with url: ' + url)

    @http.delete(url).success (response) =>
      order = @scope.orders.splice(index, 1)

      toast = @mdToast.simple()
      .content('Order deleted with id: ' + order[0].orderId)
      .hideDelay(1000)
      .position("top right")

      @mdToast.show(toast)

  deleteProductOrder: (orderIndex, productOrderIndex) =>
    url = 'http://' + @server.serverIp + ':' + @server.port + '/product_order/' + @scope.orders[orderIndex]._embedded.productOrders[productOrderIndex].id
    @log.debug('Preform DELETE request for deleting productorder with url: ' + url)

    @http.delete(url).success (response) =>
      productOrder = @scope.orders[orderIndex]._embedded.productOrders.splice(productOrderIndex, 1)

      toast = @mdToast.simple()
      .content('Products deleted: ' + productOrder[0].product.name)
      .hideDelay(1000)
      .position("top right")

      @mdToast.show(toast)

      if @scope.orders[orderIndex]._embedded.productOrders.length == 0
        @deleteOrder(orderIndex)

  # Debug
  debug: =>
    @scope.orders.push(
      orderId: -9
      show: false
      _embedded:
        productOrders: [
          product:
            id: -99
            name: 'Cola'
          amount: 1
          price: 1.5
        ,
          product:
            id: -88
            name: 'Patat'
          amount: 5
          price: 2.8
        ,
          product:
            id: -11
            name: 'Hamburger'
          amount: 3
          price: 3.5
        ])

    @scope.orders.push(
      orderId: -10
      show: false
      _embedded:
        productOrders: [
          product:
            id: -99
            name: 'Cola'
          amount: 3
          price: 1.5
        ,
          product:
            id: -33
            name: 'Snoep'
          amount: 2
          price: 0.7
        ,
          product:
            id: -22
            name: 'Bamischijf'
          amount: 6
          price: 2.2
        ])