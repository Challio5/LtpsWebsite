angular.module('app').service 'server', class Server
  constructor: () ->
    @serverIp = '10.0.0.121'
    @port = 8080
    @debug = false