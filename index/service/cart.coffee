angular.module('app').service 'cart', class Cart
  constructor: () ->
    @orderId = ''

    # Order object
    @order =
      code: ''
      statusId: 1
      machineId: null
      userId: 1

    # Array of product IDs
    @products =
      items: []