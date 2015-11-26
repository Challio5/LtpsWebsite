angular.module('app').controller 'categoryCtrl', class CategoryController

  @$inject: ['$scope', '$http', '$log', '$location', '$parse', 'cart', 'breadcrumb', 'server']
  constructor: (@scope, @http, @log, @location, @parse, @cart, @breadcrumb, @server) ->
    @scope.products = []

    @scope.error =
      show: false
      message: ''

    url = 'http://' + @server.serverIp + ':' + @server.port + '/productCategories/search/findByParentId'
    @log.debug('Preform GET request for productcategorie with url: ' + url)

    @http.get(url).then (response) =>
      @log.debug('Response of GET request: ')
      @log.debug(response)

      for item in response._embedded.productCategories
        @scope.products.push(item)

    if(@server.debug == true)
      @debug()

    angular.extend @scope,
      addBreadcrumb: @addBreadcrumb
      debug: @debug

  # Function
  addBreadcrumb: (title, id) =>
    # Update path
    @location.path('/Products/' + id)

    # Push breadcrumb
    @breadcrumb.push(
      text: title
      path: '/' + id
    )

  # Debug
  debug: ->
    @scope.products.push(
      src: 'img/soda.png'
      name: 'Soda'
      productCategoryId: -1
    )

    @scope.products.push(
      src: 'img/hamburger.png'
      name: 'Food'
      productCategoryId: -2
    )

    @scope.products.push(
      src: 'img/salad.ico'
      name: 'Salat'
      productCategoryId: 0
    )

    @scope.products.push(
      src: 'img/candy.png'
      name: 'Candy'
      productCategoryId: 0
    )