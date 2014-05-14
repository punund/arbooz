
angular.module('arbooz', ['ngRoute', 'ui.bootstrap'])

.constant 'azHeader', [
  title: 'Home'
  uri: '/'
  route:
    templateUrl: '/partial/root'
,
  title: 'Street'
  uri: '/street'
  route:
    template: '''
      <h2>You are in the street</h2>
      <p>This comes from an inline template.</p>
      '''
,
  title: 'Gym'
  uri: '/gym'
  route:
    templateUrl: '/partial/gym'
    controller: 'az-gym'
,
  title: 'Shop'
  uri: '/shop'
  route:
    templateUrl: '/partial/shop'
    controller: 'az-shop'
]

.config ($locationProvider, $routeProvider, azHeader) ->
  $locationProvider.html5Mode on
  for item in azHeader
    $routeProvider.when item.uri, item.route

.controller 'az-gym', ($scope) ->
  $scope.time = -> Date()

.controller 'az-shop', ($scope, $http) ->
  $http.get '/api/shop'
  .success (data, status, headers) ->
    $scope.data = data
    console.log data
  .error (data, status, headers) ->
    console.error status


.controller 'HeaderController', ($scope, $location) ->
  $scope.isActive = (viewLocation) ->
    viewLocation is $location.path()

.directive 'azMenu', (azHeader) ->
  template = ''
  for item in azHeader
    template += """
      <li ng-class="{active: isActive('#{item.uri}')}">
        <a ng-href="#{item.uri}">#{item.title}</a>
      </li>
      """

  restrict: 'A'
  {template}
