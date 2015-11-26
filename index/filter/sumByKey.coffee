angular.module('app').filter('sumByKey', ->
  (data, key) ->
    if typeof(data) == 'undefined' || typeof(key) == 'undefined'
      return 0

    sum = 0
    for item in data
      sum += parseInt(item[key])

    return sum;
)