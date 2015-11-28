angular.module('app').controller 'categoryCtrl', class CategoryController

  @$inject: ['$scope', '$http', '$log', '$location', 'cart', 'breadcrumb', 'server', 'debug']
  constructor: (@scope, @http, @log, @location, @cart, @breadcrumb, @server, @debug) ->
    @scope.categories = []

    @scope.error =
      show: false
      message: ''

    if @debug.debug
      @debug.categoryPush(@scope.categories)
    else
      url = 'http://' + @server.serverIp + ':' + @server.port + '/productCategories/search/findByParentId'
      @log.debug('Preform GET request for productcategorie with url: ' + url)

      @http.get(url).then (response) =>
        @log.debug('Response of GET request: ')
        @log.debug(response)

        for item in response._embedded.productCategories
          @scope.categories.push(item)

    angular.extend @scope,
      addBreadcrumb: @addBreadcrumb

  # Function
  addBreadcrumb: (title, id) =>
    # Update path
    @location.path('/Products/' + id)

    # Push breadcrumb
    @breadcrumb.push(
      text: title
      path: '/' + id
    )