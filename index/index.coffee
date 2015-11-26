angular.module('app').controller 'mainCtrl', class IndexController

  @$inject: ['$mdIcon', '$mdSidenav', '$scope', '$filter', '$http', '$log', '$location', '$mdDialog', 'cart', 'breadcrumb', 'user']
  constructor: (@mdIcon, @mdSidenav, @scope, @filter, @http, @log, @location, @mdDialog, @cart, @breadcrumb, @user) ->
    #@mdIcon('android').then((iconEl) -> console.log('test'))

    @scope.user = @user
    @scope.breadcrumb = @breadcrumb
    @scope.cart = @cart

    @scope.buttonsrc = "img/icon/add.svg"
    @scope.menuItems = [
      icon: 'img/icon/products.svg'
      title: 'Products'
      href: '/Website/'
    ,
      icon: 'img/icon/cart.svg'
      title: 'Cart'
      href: 'Cart/' + @user.loggedUser.userId
    ]


    @scope.userItems = [
      icon: 'img/icon/hamburger.svg'
      title: 'Orders'
    ,
      icon: 'img/icon/balance.svg'
      title: 'Credits'
    ,
      icon: 'img/icon/settings.svg'
      title: 'Settings'
    ]

    angular.extend @scope,
      sidenavToggle: @sidenavToggle
      updateBreadcrumb: @updateBreadcrumb
      showAdd: @showAdd

  sidenavToggle: =>
    @mdSidenav('sideNav').toggle()

  updateBreadcrumb: (index) =>
    @breadcrumb.splice(index + 1, @breadcrumb.length - index - 1)

  showAdd: (ev) =>
    # login
    if @user.loggedUser.userId < 0
      @mdDialog.show(
        controller: 'loginCtrl'
        templateUrl: 'ngview/login/login.html'
        targetEvent: ev
        clickOutsideToClose: true
        onRemoving: () ->
          if @user.loggedUser.userId > 0
            @scope.buttonsrc = "img/icon/account.svg"
      )
    # logout
    else
      @mdDialog.show(
        controller: 'logoutCtrl'
        templateUrl: 'ngview/logout/logout.html'
        targetEvent: ev
        clickOutsideToClose: true
        onRemoving: () ->
          if @user.loggedUser.userId == -1
            @scope.buttonsrc = "img/icon/add.svg"
      )



