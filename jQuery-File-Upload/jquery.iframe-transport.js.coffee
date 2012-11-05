#
# * jQuery Iframe Transport Plugin 1.5
# * https://github.com/blueimp/jQuery-File-Upload
# *
# * Copyright 2011, Sebastian Tschan
# * https://blueimp.net
# *
# * Licensed under the MIT license:
# * http://www.opensource.org/licenses/MIT
# 

#jslint unparam: true, nomen: true 

#global define, window, document 
((factory) ->
  "use strict"
  if typeof define is "function" and define.amd
    
    # Register as an anonymous AMD module:
    define ["jquery"], factory
  else
    
    # Browser globals:
    factory window.jQuery
) ($) ->
  "use strict"
  
  # Helper variable to create unique names for the transport iframes:
  counter = 0
  
  # The iframe transport accepts three additional options:
  # options.fileInput: a jQuery collection of file input fields
  # options.paramName: the parameter name for the file form data,
  #  overrides the name property of the file input field(s),
  #  can be a string or an array of strings.
  # options.formData: an array of objects with name and value properties,
  #  equivalent to the return data of .serializeArray(), e.g.:
  #  [{name: 'a', value: 1}, {name: 'b', value: 2}]
  $.ajaxTransport "iframe", (options) ->
    if options.async and (options.type is "POST" or options.type is "GET")
      form = undefined
      iframe = undefined
      send: (_, completeCallback) ->
        form = $("<form style=\"display:none;\"></form>")
        form.attr "accept-charset", options.formAcceptCharset
        
        # javascript:false as initial iframe src
        # prevents warning popups on HTTPS in IE6.
        # IE versions below IE8 cannot set the name property of
        # elements that have already been added to the DOM,
        # so we set the name along with the iframe HTML markup:
        iframe = $("<iframe src=\"javascript:false;\" name=\"iframe-transport-" + (counter += 1) + "\"></iframe>").bind("load", ->
          fileInputClones = undefined
          paramNames = (if $.isArray(options.paramName) then options.paramName else [options.paramName])
          iframe.unbind("load").bind "load", ->
            response = undefined
            
            # Wrap in a try/catch block to catch exceptions thrown
            # when trying to access cross-domain iframe contents:
            try
              response = iframe.contents()
              
              # Google Chrome and Firefox do not throw an
              # exception when calling iframe.contents() on
              # cross-domain requests, so we unify the response:
              throw new Error()  if not response.length or not response[0].firstChild
            catch e
              response = `undefined`
            
            # The complete callback returns the
            # iframe content document as response object:
            completeCallback 200, "success",
              iframe: response

            
            # Fix for IE endless progress bar activity bug
            # (happens on form submits to iframe targets):
            $("<iframe src=\"javascript:false;\"></iframe>").appendTo form
            form.remove()

          form.prop("target", iframe.prop("name")).prop("action", options.url).prop "method", options.type
          if options.formData
            $.each options.formData, (index, field) ->
              $("<input type=\"hidden\"/>").prop("name", field.name).val(field.value).appendTo form

          if options.fileInput and options.fileInput.length and options.type is "POST"
            fileInputClones = options.fileInput.clone()
            
            # Insert a clone for each file input field:
            options.fileInput.after (index) ->
              fileInputClones[index]

            if options.paramName
              options.fileInput.each (index) ->
                $(this).prop "name", paramNames[index] or options.paramName

            
            # Appending the file input fields to the hidden form
            # removes them from their original location:
            
            # enctype must be set as encoding for IE:
            form.append(options.fileInput).prop("enctype", "multipart/form-data").prop "encoding", "multipart/form-data"
          form.submit()
          
          # Insert the file input fields at their original location
          # by replacing the clones with the originals:
          if fileInputClones and fileInputClones.length
            options.fileInput.each (index, input) ->
              clone = $(fileInputClones[index])
              $(input).prop "name", clone.prop("name")
              clone.replaceWith input

        )
        form.append(iframe).appendTo document.body

      abort: ->
        
        # javascript:false as iframe src aborts the request
        # and prevents warning popups on HTTPS in IE6.
        # concat is used to avoid the "Script URL" JSLint error:
        iframe.unbind("load").prop "src", "javascript".concat(":false;")  if iframe
        form.remove()  if form

  
  # The iframe transport returns the iframe content document as response.
  # The following adds converters from iframe to text, json, html, and script:
  $.ajaxSetup converters:
    "iframe text": (iframe) ->
      $(iframe[0].body).text()

    "iframe json": (iframe) ->
      $.parseJSON $(iframe[0].body).text()

    "iframe html": (iframe) ->
      $(iframe[0].body).html()

    "iframe script": (iframe) ->
      $.globalEval $(iframe[0].body).text()

