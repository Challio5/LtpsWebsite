angular.module('app').controller 'dataCtrl', class DataController

  @$inject: ['$scope', '$http', '$log', 'user', 'server', 'debug']
  constructor: (@scope, @http, @log, @user, @server, @debug) ->
    @scope.editMode =
      index: -1
      key: ''

    @scope.editable = ['name', 'email', 'telephone', 'password']

    # Bind functions to scope
    angular.extend @scope,
      edit: @edit
      editModeOff: @editModeOff
      removeNfcCard: @removeNfcCard

  edit: (index, key) =>
    @scope.editMode.index = index
    @scope.editMode.key = key

  editModeOff: (keyEvent) =>
    if keyEvent.which == 13

      data = "{\"" + @scope.editMode.key + "\" : \"" + @user.currentUser[@scope.editMode.key] + "\"}"

      @scope.editMode.index = -1
      @scope.editMode.key = ''

      if !@debug.debug
        @log.debug('Preform PATCH request for updating userdata with url: ' + @user.currentUser._links.self.href.split('{')[0])
        @log.debug('Preform PATCH request for updating orderamount with data: ')
        @log.debug(data)

        @http.patch(@user.currentUser._links.self.href.split('{')[0], data).success (data, status, headers, config) =>
          @log.debug('Respons of PATCH request with returned headers: ')
          @log.debug(headers())

  removeNfcCard: (index) =>
    if @debug.debug
      @user.currentUser.nfcCards.splice(index, 1)
    else
      url = 'http://' + @server.serverIp + ':' + @server.port + '/nfc_card/' + @user.currentUser.nfcCards[index].cardId
      @log.debug('Preform DELETE request for deleting order with url: ' + url)

      @http.delete(url).success (data, status, headers, config) =>
        @user.currentUser.nfcCards.splice(index, 1)