angular.module('app').controller 'mainCtrl', class IndexController

  @$inject: ['$scope', '$log', '$location', '$mdDialog', '$mdIcon', '$mdSidenav', '$mdToast', 'cart', 'breadcrumb', 'user']
  constructor: (@scope, @log, @location, @mdDialog, @mdIcon, @mdSidenav, @mdToast, @cart, @breadcrumb, @user) ->
    #@mdIcon('android').then((iconEl) -> console.log('test'))

    @scope.user = @user
    @scope.breadcrumb = @breadcrumb
    @scope.cart = @cart

    @scope.buttonsrc = "img/icon/add.svg"
    @scope.menuItems = [
      icon: 'img/icon/products.svg'
      title: 'Products'
      href: '/client-website/'
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
            toast = @mdToast.simple()
              .content(@user.loggedUser.name + ' has logged in')
              .hideDelay(500)
              .position("top right")

            @mdToast.show(toast)

            @scope.buttonsrc = "img/icon/account.svg"
      )
    # logout
    else
      confirm = @mdDialog.confirm
        title: 'Logout'
        content: 'You are about to log out from your account'
        ok: 'OK'
        cancel: 'Cancel'

      name = @user.loggedUser.name

      @mdDialog.show(confirm).then(() =>
        # Reset user
        @user.currentUser =
          userId: -1
          name: ''
          email: ''
          telephone: ''
          username: ''
          password: ''
          balance: 0.0
          nfcCards: []

        @user.loggedUser =
          userId: -1
          name: 'Login'
          email: ''
          telephone: ''
          username: ''
          password: ''
          balance: 0.0
          nfcCards: []

        @log.debug('User is logged out')

        # Redirect home
        @location.path('/')

        # Reset icon
        @scope.buttonsrc = "img/icon/add.svg"

        toast = @mdToast.simple()
        .content(name + ' is logged out')
        .hideDelay(500)
        .position("top right")

        @mdToast.show(toast)

      , () =>
        @log.debug('User cancels logging out')
      )

