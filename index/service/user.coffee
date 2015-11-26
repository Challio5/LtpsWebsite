angular.module('app').service 'user', class User
  constructor: () ->
    @currentUser =
      userId: -1
      name: ''
      email: ''
      telephone: ''
      username: ''
      password: ''
      nfcCards: []

    @loggedUser =
      userId: -1
      name: 'Login'
      email: ''
      telephone: ''
      username: ''
      password: ''
      nfcCards: []