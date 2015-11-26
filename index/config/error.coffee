angular.module('app').config ($httpProvider) ->
  $httpProvider.interceptors.push ($q, $log) ->
    'requestError': (rejection) ->
      $log.debug('RequestError ' + rejection.status)
      $q.rejection
    ,
    'responseError': (rejection) ->
      $log.debug('ResponseError ' + rejection.status)
      $q.rejection
