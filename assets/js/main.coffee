
angular.module 'arbooz', ['btford.socket-io']

.factory 'theSocket', (socketFactory) ->
  socketFactory()

.controller 'playground', (theSocket) ->
  console.log theSocket.connect
  # theSocket.connect()
  