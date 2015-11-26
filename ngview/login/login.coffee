angular.module('app').controller 'loginCtrl', class LoginController

  @$inject: ['$scope', '$http', '$log', '$mdDialog','user', 'server']
  constructor: (@scope, @http, @log, @mdDialog, @user, @server) ->
    # Bind user to view
    @scope.user = @user
    @scope.login = @login

    @scope.telephone = "(\\\\+|04)[0-9]+"

    @scope.saveDisable = false

    @scope.login =
      username: ''
      password: ''

    @scope.loginDisable= false
    #@scope.loginDisable = @scope.login.username == '' || @scope.login.password == ''

    @scope.show = false

    angular.extend @scope,
      redirectLogin: @redirectLogin
      login: @login
      addUser: @addUser
      debug: @debug

  redirectLogin: (keyEvent) =>
    if keyEvent.which == 13 and @scope.loginDisable == false
      @login()

  login: =>
    @log.debug(@scope.loginForm)

    if @server.debug == true
      @debug()

    else
      url = 'http://' + @server.serverIp + ':' + @server.port + '/user/search/findByUsernameAndPassword?user_name=' +
          @scope.login.username +
          "&password=" +
          @scope.login.password

      @log.debug('Preform GET request for user with url: ' + url)

      @http.get(url).then (response) =>
      # Success
        @log.debug('Response of GET request: ')
        @log.debug(response)

        if response.data.hasOwnProperty("_embedded")
          angular.forEach response.data._embedded.user[0], (value, key) =>
            @user.loggedUser[key] = value
            @user.currentUser[key] = value

          @mdDialog.hide()
        else
          @log.debug('User does not exist')
      # Error
      , (response) =>
        @log.debug('Error message')
        @log.debug(response)


  addUser: =>
    url = 'http://' + @server.serverIp + ':' + @server.port + '/user'

    @log.debug('Preform POST request for adding user with url: ' + url)
    @log.debug('Preform POST request for user with data: ')
    @log.debug(@user.currentUser)

    @http.post(url, @user.currentUser).success (data, status, headers, config) =>
      userId = headers('Location').split('/').pop()

      @log.debug('Respons of POST request with returned headers: ')
      @log.debug(headers())

      @user.currentUser.userId = userId
      @user.loggedUser = @user.currentUser

      @mdDialog.hide()

  debug: =>
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