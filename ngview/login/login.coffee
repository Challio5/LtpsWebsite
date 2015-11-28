angular.module('app').controller 'loginCtrl', class LoginController

  @$inject: ['$scope', '$http', '$log', '$mdDialog','user', 'server', 'debug']
  constructor: (@scope, @http, @log, @mdDialog, @user, @server, @debug) ->
    # Bind user to view
    @scope.user = @user
    @scope.login = @login

    @scope.telephone = "(\\\\+|04)[0-9]+"

    @scope.login =
      username: ''
      password: ''

    @scope.show = false

    angular.extend @scope,
      redirectLogin: @redirectLogin
      login: @login
      addUser: @addUser

  redirectLogin: (keyEvent) =>
    if keyEvent.which == 13 and @scope.loginForm.$invalid == false
      @login()

  login: =>
    if @debug.debug == true
      @debug.login()

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
    if !@debug.debug
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