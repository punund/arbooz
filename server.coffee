os = require 'os'

require('zappajs') port: 3000, ->

  @use 'logger'
  @use require('connect-assets')()
  @use static: 'assets'

  @enable 'databag'


  @view '/partial/school.blade': """
    h2= params.framework
    div
      | has inline templates, too.  This view is defined with 
      span.text-primary @view
      | :
    pre
      |
        @view '/partial/school.blade': '''
          h2= params.framework
          div
            | has inline templates, too.  This view is defined with 
            span.text-primary @view
            | :
      p ...
    div
      | This was called by a client route as: 
      span.text-primary /partial/school?framework=ZappaJS
      | . Note the parameter.

    """

  @get
    '/partial/:name': ->
      @render "partial/#{@params.name}.blade"

    '/api/:name': ->
      @json
        string: @params.name
        time: Date()
        os: os.platform() + ' ' + os.release()
        cpu: os.cpus()[0].model

    '*': ->
      @render 'index.blade'


