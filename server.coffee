require('zappajs') ->


  @use require('connect-assets') paths: ['bower_components', 'assets/js']
  @locals.clients = 0

  @get '/': ->
    @render 'index.blade'


  @on connection: (socket) ->
    ++ @locals.clients
    console.log '*** user connected ***'

  @on disconnect: (socket) ->
    console.log '*** user disconnected ***'
    @broadcast message: "{@clients} left"
