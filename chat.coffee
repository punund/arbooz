#
# emits and broadcasts are given arrays due to the bug in socket.io:
# https://github.com/Automattic/socket.io/issues/1639
# 
# Iļja Ketris <ike@vo.id.lv>
#

chance = new require('chance')()
mongo = require 'promised-mongo'
fs = require('bluebird').promisifyAll require 'fs'

chatlog = mongo('mongodb://localhost/test').collection 'chatlog'

require('zappajs') ->

   @locals.clients = 0

   @helper writeLog: (did) ->
      row = time: Date.now()
      row[did] = @client.name
      chatlog.insert row
      .then (x) =>
         @broadcast_to 'log', service: [JSON.stringify x]
         @broadcast_to 'log', service: ["Active clients: #{@locals.clients}.\n"]
      .catch console.error

   @get
      '/': ->
         @render 'index.blade'
      '/source': ->
         fs.readFileAsync __filename
         .then @send

   @on connection: ->
      @join 'chat'
      @join 'log'
      @client.name = "#{chance.first()} #{chance.last()}"
      ++ @locals.clients
      @broadcast_to 'chat', message: ["Oh joy! #{@client.name} just in."]
      @emit message: ["Welcome, #{@client.name}!"]
      @emit nick: [@client.name]
      @writeLog 'connected'

   @on disconnect: ->
      -- @locals.clients
      @writeLog 'disconnected'

   @on message: ->
      @broadcast_to 'chat', message: [@client.name, @data]

   @client '/main.js': ->
      @connect()

      $ =>
         $.get '/source'
         .then $('#src').text
         # $('#src').text source
         # hljs.initHighlighting()

         $('#form').submit (e) =>
            $('#phrase').val (i, v) =>
               @emit message: v
               ''
            e.preventDefault()

         @on service: ->
            $('#log').append "
               <div class='row'>
                  <em class=col-sm-12>#{@data}</div>
               </div>"

         @on nick: ->
            $('#nick').text @data

         @on message: ->
            $('#chat').append "
               <div class='row'>
                  <div class=col-sm-3>#{@data[0]}</div>
                  <div class='col-sm-9 text-info'>#{@data[1] or ''}</div>
               </div>
               "



