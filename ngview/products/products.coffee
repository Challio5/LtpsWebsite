angular.module('app').controller 'productCtrl', class ProductController

  @$inject: ['$scope', '$http', '$log', '$routeParams', '$mdToast', 'cart', 'server']
  constructor: (@scope, @http, @log, @routeParams, @mdToast, @cart, @server) ->
    # Array with products available
    @scope.products = []

    # Check if valid id
    if(@routeParams.categoryId > '0')
      url = 'http://' + @server.serverIp + ':' + @server.port + '/products/search/findByProductCategoryId?productCategoryId=' + @routeParams.categoryId
      @log.debug('Preform GET request for products with url: ' + url)

      @http.get(url).success((response) =>
        @log.debug('Response of GET request: ')
        @log.debug(response)

        for item in response._embedded.products
          @scope.products.push(item)
      )

    # Debug
    if @server.debug == true
      @debug()

    # Expose functions to scope
    angular.extend @scope,
      addToCart: @addToCart
      debug: @debug

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

  # Debug function
  debug: =>
    if(@routeParams.categoryId == '-2')
      @scope.products.push(
        productId: -1,
        name: "Fries",
        description: "Puntzak frites",
        price: 1.5,
        productCategoryId: @routeParams.categoryID,
        src: 'img/food/fries.jpeg')

      @scope.products.push(
        productId: -2,
        name: "Hamburger",
        description: "Broodje Hamburger",
        price: 2.4,
        productCategoryId: @routeParams.categoryID,
        src: 'img/food/hamburger.jpg'
      )

    else if(@routeParams.categoryId == '-1')
      @scope.products.push(
        productId: -3,
        name: "Fanta",
        description: "Blikje Fanta",
        price: 1.8,
        productCategoryId: @routeParams.categoryID,
        src: 'img/drinks/fanta.jpg'
      )

      @scope.products.push(
        productId: -4,
        name: "Cola",
        description: "Blikje Cola",
        price: 2.2,
        productCategoryId: @routeParams.categoryID,
        src: 'img/drinks/cola.jpg'
      )