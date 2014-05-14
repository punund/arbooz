os = require 'os'

require('zappajs') port: 3000, ->

  @use require('connect-assets')()

  @get
    '/partial/:name': ->
      @render "partial/#{@params.name}.blade"

    '/api/:name': ->
      @json
        string: @params.name
        time: Date()
        os: os.platform()
        cpu: os.cpus()[0].model

    '*': ->
      @render 'index.blade'


