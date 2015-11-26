angular.module('app').controller 'logoutCtrl', class LogoutController

  @$inject: ['$scope', '$http', '$log', '$location', '$mdDialog','user', 'server']
  constructor: (@scope, @http, @log, @location, @mdDialog, @user, @server) ->
    angular.extend @scope,
      logout: @logout
      cancel: @cancel

  cancel: =>
    @mdDialog.hide()

  logout: =>
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
    @mdDialog.hide()

    # Redirect home
    @location.path('/')