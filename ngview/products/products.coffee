angular.module('app').controller 'productCtrl', class ProductController

  @$inject: ['$scope', '$http', '$log', '$routeParams', '$mdToast', 'cart', 'server', 'debug']
  constructor: (@scope, @http, @log, @routeParams, @mdToast, @cart, @server, @debug) ->
    # Array with products available
    @scope.products = []
    # Check if valid id
    if @debug.debug == true
      @debug.productPush(@scope.products)
    else
      if(@routeParams.categoryId > '0')
        url = 'http://' + @server.serverIp + ':' + @server.port + '/products/search/findByProductCategoryId?productCategoryId=' + @routeParams.categoryId
        @log.debug('Preform GET request for products with url: ' + url)

        @http.get(url).success((response) =>
          @log.debug('Response of GET request: ')
          @log.debug(response)

          for item in response._embedded.products
            @scope.products.push(item)
        )

    # Expose functions to scope
    angular.extend @scope,
      addToCart: @addToCart

  # Function to add product to the cart
  addToCart: (item) =>

    # Toast message
    toast = @mdToast.simple()
      .content('Product added: ' + item.name)
      .hideDelay(500)
      .position("top right")

    @mdToast.show(toast)

    # Check if product already ordered
    for product in @cart.products.items
      if product.productId == item.productId
        product.amount++
        return

    # Else create order for product
    @cart.products.items.push(
      orderId: ''
      productId: item.productId
      name: item.name #TODO remove in post
      amount: 1
      price: item.price
    )