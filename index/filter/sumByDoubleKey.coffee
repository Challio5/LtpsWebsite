angular.module('app').filter('sumByDoubleKey', ->
  (data, key1, key2) ->
    if typeof(data) == 'undefined' || typeof(key1) == 'undefined' || typeof(key2) == 'undefined'
      return 0

    sum = 0
    for item in data
      sum += parseFloat(item[key1]) * parseFloat(item[key2])

    return sum;
)