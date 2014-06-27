os = require 'os'

require('zappajs') port: 3000, ->

  @use require('connect-assets')()
  @use 'static'
  @use 'logger'


  @view '/partial/school.blade': '''
    h2 ZappaJS
    div
      | has inline templates, too.  Define with 
      span.text-primary @view
      | :
    pre
      |
        @view '/partial/school.blade': ''\'
          h2 ZappaJS
          div
            | has inline templates, too.  Define with 
            span.text-primary @view
            | :
      p ...
    '''

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


