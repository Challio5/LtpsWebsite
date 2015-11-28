angular.module('app').service 'debug', class DebugService

  @$inject: ['$routeParams', '$log', '$mdDialog', '$mdToast', 'user']
  constructor: (@routeParams, @log, @mdDialog, @mdToast, @user) ->
    @debug = true

  ### Login debug ###
  login: =>
    @user.loggedUser.userId = 999
    @user.loggedUser.name = 'admin'

    @user.currentUser.userId = 999
    @user.currentUser.name = 'admin'
    @user.currentUser.email = 'admin@admin.com'
    @user.currentUser.telephone = '123456789'

    @user.currentUser.username = 'admin'
    @user.currentUser.password = 'pass'
    @user.currentUser.balance = 10.0

    @user.currentUser.enabled = true

    @user.currentUser.nfcCards = [
      cardId: 1237657
    ,
      cardId: 2345897
    ,
      cardId: 1329487
    ]

    @mdDialog.hide()

  ### Category debug ###
  categoryPush: (categories) =>
    categories.push(
      src: 'img/soda.png'
      name: 'Soda'
      productCategoryId: -1
    )

    categories.push(
      src: 'img/hamburger.png'
      name: 'Food'
      productCategoryId: -2
    )

    categories.push(
      src: 'img/salad.ico'
      name: 'Salat'
      productCategoryId: 0
    )

    categories.push(
      src: 'img/candy.png'
      name: 'Candy'
      productCategoryId: 0
    )

  ### Product debug ###
  productPush: (products) =>
    if(@routeParams.categoryId == '-2')
      products.push(
        productId: -1,
        name: "Fries",
        description: "Puntzak frites",
        price: 1.5,
        productCategoryId: @routeParams.categoryID,
        src: 'img/food/fries.jpeg')

      products.push(
        productId: -2,
        name: "Hamburger",
        description: "Broodje Hamburger",
        price: 2.4,
        productCategoryId: @routeParams.categoryID,
        src: 'img/food/hamburger.jpg'
      )

    else if(@routeParams.categoryId == '-1')
      products.push(
        productId: -3,
        name: "Fanta",
        description: "Blikje Fanta",
        price: 1.8,
        productCategoryId: @routeParams.categoryID,
        src: 'img/drinks/fanta.jpg'
      )

      products.push(
        productId: -4,
        name: "Cola",
        description: "Blikje Cola",
        price: 2.2,
        productCategoryId: @routeParams.categoryID,
        src: 'img/drinks/cola.jpg'
      )

  ### Cart debug ###

  ### Order debug ###
  deleteProductOrder: (orders, orderIndex, productOrderIndex) =>
    dialog = @mdDialog.confirm
      title: 'Attention'
      content: 'You are about to remove all: ' + orders[orderIndex]._embedded.productOrders[productOrderIndex].id
      ok: 'OK'
      cancel: 'Cancel'

    @mdDialog.show(dialog).then =>
      @log.debug('User removes productOrder')

      productOrder = orders[orderIndex]._embedded.productOrders.splice(productOrderIndex, 1)

      toast = @mdToast.simple()
      .content('Products deleted: ' + productOrder[0].product.name)
      .hideDelay(1000)
      .position("top right")

      @mdToast.show(toast)

      if orders[orderIndex]._embedded.productOrders.length == 0
        @deleteOrder(orderIndex)

    , =>
      @log.debug('User cancels to remove a productOrder')

  deleteOrder: (orders, index) =>
    dialog = @mdDialog.confirm
      title: 'Attention'
      content: 'You are about to delete order with id: ' + orders[index].orderId
      ok: 'OK'
      cancel: 'Cancel'

    @mdDialog.show(dialog).then =>
      @log.debug('User removes order')

      order = orders.splice(index, 1)

      toast = @mdToast.simple()
      .content('Order deleted with id: ' + order[0].orderId)
      .hideDelay(1000)
      .position("top right")

      @mdToast.show(toast)
    , =>
      @log.debug('User cancels to remove order')

  orderPush: (orders) =>
    orders.push(
      orderId: -9
      show: false
      statusId: 1
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

    orders.push(
      orderId: -10
      show: false
      statusId: 2
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

  ### Credit debug ###

  ### Settings debug ###