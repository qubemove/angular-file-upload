#
# * jQuery File Upload Plugin 5.19.3
# * https://github.com/blueimp/jQuery-File-Upload
# *
# * Copyright 2010, Sebastian Tschan
# * https://blueimp.net
# *
# * Licensed under the MIT license:
# * http://www.opensource.org/licenses/MIT
# 

#jslint nomen: true, unparam: true, regexp: true 

#global define, window, document, Blob, FormData, location 
((factory) ->
  "use strict"
  if typeof define is "function" and define.amd
    
    # Register as an anonymous AMD module:
    define ["jquery", "jquery.ui.widget"], factory
  else
    
    # Browser globals:
    factory window.jQuery
) ($) ->
  "use strict"
  
  # The FileReader API is not actually used, but works as feature detection,
  # as e.g. Safari supports XHR file uploads via the FormData API,
  # but not non-multipart XHR file uploads:
  $.support.xhrFileUpload = !!(window.XMLHttpRequestUpload and window.FileReader)
  $.support.xhrFormDataFileUpload = !!window.FormData
  
  # The fileupload widget listens for change events on file input fields defined
  # via fileInput setting and paste or drop events of the given dropZone.
  # In addition to the default jQuery Widget methods, the fileupload widget
  # exposes the "add" and "send" methods, to add or directly send files using
  # the fileupload API.
  # By default, files added via file input selection, paste, drag & drop or
  # "add" method are uploaded immediately, but it is possible to override
  # the "add" callback option to queue file uploads.
  $.widget "blueimp.fileupload",
    options:
      
      # The drop target element(s), by the default the complete document.
      # Set to null to disable drag & drop support:
      dropZone: $(document)
      
      # The paste target element(s), by the default the complete document.
      # Set to null to disable paste support:
      pasteZone: $(document)
      
      # The file input field(s), that are listened to for change events.
      # If undefined, it is set to the file input fields inside
      # of the widget element on plugin initialization.
      # Set to null to disable the change listener.
      fileInput: `undefined`
      
      # By default, the file input field is replaced with a clone after
      # each input field change event. This is required for iframe transport
      # queues and allows change events to be fired for the same file
      # selection, but can be disabled by setting the following option to false:
      replaceFileInput: true
      
      # The parameter name for the file form data (the request argument name).
      # If undefined or empty, the name property of the file input field is
      # used, or "files[]" if the file input name property is also empty,
      # can be a string or an array of strings:
      paramName: `undefined`
      
      # By default, each file of a selection is uploaded using an individual
      # request for XHR type uploads. Set to false to upload file
      # selections in one request each:
      singleFileUploads: true
      
      # To limit the number of files uploaded with one XHR request,
      # set the following option to an integer greater than 0:
      limitMultiFileUploads: `undefined`
      
      # Set the following option to true to issue all file upload requests
      # in a sequential order:
      sequentialUploads: false
      
      # To limit the number of concurrent uploads,
      # set the following option to an integer greater than 0:
      limitConcurrentUploads: `undefined`
      
      # Set the following option to true to force iframe transport uploads:
      forceIframeTransport: false
      
      # Set the following option to the location of a redirect url on the
      # origin server, for cross-domain iframe transport uploads:
      redirect: `undefined`
      
      # The parameter name for the redirect url, sent as part of the form
      # data and set to 'redirect' if this option is empty:
      redirectParamName: `undefined`
      
      # Set the following option to the location of a postMessage window,
      # to enable postMessage transport uploads:
      postMessage: `undefined`
      
      # By default, XHR file uploads are sent as multipart/form-data.
      # The iframe transport is always using multipart/form-data.
      # Set to false to enable non-multipart XHR uploads:
      multipart: true
      
      # To upload large files in smaller chunks, set the following option
      # to a preferred maximum chunk size. If set to 0, null or undefined,
      # or the browser does not support the required Blob API, files will
      # be uploaded as a whole.
      maxChunkSize: `undefined`
      
      # When a non-multipart upload or a chunked multipart upload has been
      # aborted, this option can be used to resume the upload by setting
      # it to the size of the already uploaded bytes. This option is most
      # useful when modifying the options object inside of the "add" or
      # "send" callbacks, as the options are cloned for each file upload.
      uploadedBytes: `undefined`
      
      # By default, failed (abort or error) file uploads are removed from the
      # global progress calculation. Set the following option to false to
      # prevent recalculating the global progress data:
      recalculateProgress: true
      
      # Interval in milliseconds to calculate and trigger progress events:
      progressInterval: 100
      
      # Interval in milliseconds to calculate progress bitrate:
      bitrateInterval: 500
      
      # Additional form data to be sent along with the file uploads can be set
      # using this option, which accepts an array of objects with name and
      # value properties, a function returning such an array, a FormData
      # object (for XHR file uploads), or a simple object.
      # The form of the first fileInput is given as parameter to the function:
      formData: (form) ->
        form.serializeArray()

      
      # The add callback is invoked as soon as files are added to the fileupload
      # widget (via file input selection, drag & drop, paste or add API call).
      # If the singleFileUploads option is enabled, this callback will be
      # called once for each file in the selection for XHR file uplaods, else
      # once for each file selection.
      # The upload starts when the submit method is invoked on the data parameter.
      # The data object contains a files property holding the added files
      # and allows to override plugin options as well as define ajax settings.
      # Listeners for this callback can also be bound the following way:
      # .bind('fileuploadadd', func);
      # data.submit() returns a Promise object and allows to attach additional
      # handlers using jQuery's Deferred callbacks:
      # data.submit().done(func).fail(func).always(func);
      add: (e, data) ->
        data.submit()

      
      # Other callbacks:
      # Callback for the submit event of each file upload:
      # submit: function (e, data) {}, // .bind('fileuploadsubmit', func);
      # Callback for the start of each file upload request:
      # send: function (e, data) {}, // .bind('fileuploadsend', func);
      # Callback for successful uploads:
      # done: function (e, data) {}, // .bind('fileuploaddone', func);
      # Callback for failed (abort or error) uploads:
      # fail: function (e, data) {}, // .bind('fileuploadfail', func);
      # Callback for completed (success, abort or error) requests:
      # always: function (e, data) {}, // .bind('fileuploadalways', func);
      # Callback for upload progress events:
      # progress: function (e, data) {}, // .bind('fileuploadprogress', func);
      # Callback for global upload progress events:
      # progressall: function (e, data) {}, // .bind('fileuploadprogressall', func);
      # Callback for uploads start, equivalent to the global ajaxStart event:
      # start: function (e) {}, // .bind('fileuploadstart', func);
      # Callback for uploads stop, equivalent to the global ajaxStop event:
      # stop: function (e) {}, // .bind('fileuploadstop', func);
      # Callback for change events of the fileInput(s):
      # change: function (e, data) {}, // .bind('fileuploadchange', func);
      # Callback for paste events to the pasteZone(s):
      # paste: function (e, data) {}, // .bind('fileuploadpaste', func);
      # Callback for drop events of the dropZone(s):
      # drop: function (e, data) {}, // .bind('fileuploaddrop', func);
      # Callback for dragover events of the dropZone(s):
      # dragover: function (e) {}, // .bind('fileuploaddragover', func);
      
      # The plugin options are used as settings object for the ajax calls.
      # The following are jQuery ajax settings required for the file uploads:
      processData: false
      contentType: false
      cache: false

    
    # A list of options that require a refresh after assigning a new value:
    _refreshOptionsList: ["fileInput", "dropZone", "pasteZone", "multipart", "forceIframeTransport"]
    _BitrateTimer: ->
      @timestamp = +(new Date())
      @loaded = 0
      @bitrate = 0
      @getBitrate = (now, loaded, interval) ->
        timeDiff = now - @timestamp
        if not @bitrate or not interval or timeDiff > interval
          @bitrate = (loaded - @loaded) * (1000 / timeDiff) * 8
          @loaded = loaded
          @timestamp = now
        @bitrate

    _isXHRUpload: (options) ->
      not options.forceIframeTransport and ((not options.multipart and $.support.xhrFileUpload) or $.support.xhrFormDataFileUpload)

    _getFormData: (options) ->
      formData = undefined
      return options.formData(options.form)  if typeof options.formData is "function"
      return options.formData  if $.isArray(options.formData)
      if options.formData
        formData = []
        $.each options.formData, (name, value) ->
          formData.push
            name: name
            value: value


        return formData
      []

    _getTotal: (files) ->
      total = 0
      $.each files, (index, file) ->
        total += file.size or 1

      total

    _onProgress: (e, data) ->
      if e.lengthComputable
        now = +(new Date())
        total = undefined
        loaded = undefined
        return  if data._time and data.progressInterval and (now - data._time < data.progressInterval) and e.loaded isnt e.total
        data._time = now
        total = data.total or @_getTotal(data.files)
        loaded = parseInt(e.loaded / e.total * (data.chunkSize or total), 10) + (data.uploadedBytes or 0)
        @_loaded += loaded - (data.loaded or data.uploadedBytes or 0)
        data.lengthComputable = true
        data.loaded = loaded
        data.total = total
        data.bitrate = data._bitrateTimer.getBitrate(now, loaded, data.bitrateInterval)
        
        # Trigger a custom progress event with a total data property set
        # to the file size(s) of the current upload and a loaded data
        # property calculated accordingly:
        @_trigger "progress", e, data
        
        # Trigger a global progress event for all current file uploads,
        # including ajax calls queued for sequential file uploads:
        @_trigger "progressall", e,
          lengthComputable: true
          loaded: @_loaded
          total: @_total
          bitrate: @_bitrateTimer.getBitrate(now, @_loaded, data.bitrateInterval)


    _initProgressListener: (options) ->
      that = this
      xhr = (if options.xhr then options.xhr() else $.ajaxSettings.xhr())
      
      # Accesss to the native XHR object is required to add event listeners
      # for the upload progress event:
      if xhr.upload
        $(xhr.upload).bind "progress", (e) ->
          oe = e.originalEvent
          
          # Make sure the progress event properties get copied over:
          e.lengthComputable = oe.lengthComputable
          e.loaded = oe.loaded
          e.total = oe.total
          that._onProgress e, options

        options.xhr = ->
          xhr

    _initXHRData: (options) ->
      formData = undefined
      file = options.files[0]
      
      # Ignore non-multipart setting if not supported:
      multipart = options.multipart or not $.support.xhrFileUpload
      paramName = options.paramName[0]
      options.headers = options.headers or {}
      options.headers["Content-Range"] = options.contentRange  if options.contentRange
      unless multipart
        options.headers["Content-Disposition"] = "attachment; filename=\"" + encodeURI(file.name) + "\""
        options.contentType = file.type
        options.data = options.blob or file
      else if $.support.xhrFormDataFileUpload
        if options.postMessage
          
          # window.postMessage does not allow sending FormData
          # objects, so we just add the File/Blob objects to
          # the formData array and let the postMessage window
          # create the FormData object out of this array:
          formData = @_getFormData(options)
          if options.blob
            formData.push
              name: paramName
              value: options.blob

          else
            $.each options.files, (index, file) ->
              formData.push
                name: options.paramName[index] or paramName
                value: file


        else
          if options.formData instanceof FormData
            formData = options.formData
          else
            formData = new FormData()
            $.each @_getFormData(options), (index, field) ->
              formData.append field.name, field.value

          if options.blob
            options.headers["Content-Disposition"] = "attachment; filename=\"" + encodeURI(file.name) + "\""
            options.headers["Content-Description"] = encodeURI(file.type)
            formData.append paramName, options.blob, file.name
          else
            $.each options.files, (index, file) ->
              
              # File objects are also Blob instances.
              # This check allows the tests to run with
              # dummy objects:
              formData.append options.paramName[index] or paramName, file, file.name  if file instanceof Blob

        options.data = formData
      
      # Blob reference is not needed anymore, free memory:
      options.blob = null

    _initIframeSettings: (options) ->
      
      # Setting the dataType to iframe enables the iframe transport:
      options.dataType = "iframe " + (options.dataType or "")
      
      # The iframe transport accepts a serialized array as form data:
      options.formData = @_getFormData(options)
      
      # Add redirect url to form data on cross-domain uploads:
      if options.redirect and $("<a></a>").prop("href", options.url).prop("host") isnt location.host
        options.formData.push
          name: options.redirectParamName or "redirect"
          value: options.redirect


    _initDataSettings: (options) ->
      if @_isXHRUpload(options)
        unless @_chunkedUpload(options, true)
          @_initXHRData options  unless options.data
          @_initProgressListener options
        
        # Setting the dataType to postmessage enables the
        # postMessage transport:
        options.dataType = "postmessage " + (options.dataType or "")  if options.postMessage
      else
        @_initIframeSettings options, "iframe"

    _getParamName: (options) ->
      fileInput = $(options.fileInput)
      paramName = options.paramName
      unless paramName
        paramName = []
        fileInput.each ->
          input = $(this)
          name = input.prop("name") or "files[]"
          i = (input.prop("files") or [1]).length
          while i
            paramName.push name
            i -= 1

        paramName = [fileInput.prop("name") or "files[]"]  unless paramName.length
      else paramName = [paramName]  unless $.isArray(paramName)
      paramName

    _initFormSettings: (options) ->
      
      # Retrieve missing options from the input field and the
      # associated form, if available:
      if not options.form or not options.form.length
        options.form = $(options.fileInput.prop("form"))
        
        # If the given file input doesn't have an associated form,
        # use the default widget file input's form:
        options.form = $(@options.fileInput.prop("form"))  unless options.form.length
      options.paramName = @_getParamName(options)
      options.url = options.form.prop("action") or location.href  unless options.url
      
      # The HTTP request method must be "POST" or "PUT":
      options.type = (options.type or options.form.prop("method") or "").toUpperCase()
      options.type = "POST"  if options.type isnt "POST" and options.type isnt "PUT"
      options.formAcceptCharset = options.form.attr("accept-charset")  unless options.formAcceptCharset

    _getAJAXSettings: (data) ->
      options = $.extend({}, @options, data)
      @_initFormSettings options
      @_initDataSettings options
      options

    
    # Maps jqXHR callbacks to the equivalent
    # methods of the given Promise object:
    _enhancePromise: (promise) ->
      promise.success = promise.done
      promise.error = promise.fail
      promise.complete = promise.always
      promise

    
    # Creates and returns a Promise object enhanced with
    # the jqXHR methods abort, success, error and complete:
    _getXHRPromise: (resolveOrReject, context, args) ->
      dfd = $.Deferred()
      promise = dfd.promise()
      context = context or @options.context or promise
      if resolveOrReject is true
        dfd.resolveWith context, args
      else dfd.rejectWith context, args  if resolveOrReject is false
      promise.abort = dfd.promise
      @_enhancePromise promise

    
    # Parses the Range header from the server response
    # and returns the uploaded bytes:
    _getUploadedBytes: (jqXHR) ->
      range = jqXHR.getResponseHeader("Range")
      parts = range and range.split("-")
      upperBytesPos = parts and parts.length > 1 and parseInt(parts[1], 10)
      upperBytesPos and upperBytesPos + 1

    
    # Uploads a file in multiple, sequential requests
    # by splitting the file up in multiple blob chunks.
    # If the second parameter is true, only tests if the file
    # should be uploaded in chunks, but does not invoke any
    # upload requests:
    _chunkedUpload: (options, testOnly) ->
      that = this
      file = options.files[0]
      fs = file.size
      ub = options.uploadedBytes = options.uploadedBytes or 0
      mcs = options.maxChunkSize or fs
      slice = file.slice or file.webkitSlice or file.mozSlice
      dfd = $.Deferred()
      promise = dfd.promise()
      jqXHR = undefined
      upload = undefined
      return false  if not (@_isXHRUpload(options) and slice and (ub or mcs < fs)) or options.data
      return true  if testOnly
      if ub >= fs
        file.error = "Uploaded bytes exceed file size"
        return @_getXHRPromise(false, options.context, [null, "error", file.error])
      
      # The chunk upload method:
      upload = (i) ->
        
        # Clone the options object for each chunk upload:
        o = $.extend({}, options)
        o.blob = slice.call(file, ub, ub + mcs)
        
        # Store the current chunk size, as the blob itself
        # will be dereferenced after data processing:
        o.chunkSize = o.blob.size
        
        # Expose the chunk bytes position range:
        o.contentRange = "bytes " + ub + "-" + (ub + o.chunkSize - 1) + "/" + fs
        
        # Process the upload data (the blob and potential form data):
        that._initXHRData o
        
        # Add progress listeners for this chunk upload:
        that._initProgressListener o
        
        # Create a progress event if upload is done and
        # no progress event has been invoked for this chunk:
        
        # File upload not yet complete,
        # continue with the next chunk:
        jqXHR = ($.ajax(o) or that._getXHRPromise(false, o.context)).done((result, textStatus, jqXHR) ->
          ub = that._getUploadedBytes(jqXHR) or (ub + o.chunkSize)
          unless o.loaded
            that._onProgress $.Event("progress",
              lengthComputable: true
              loaded: ub - o.uploadedBytes
              total: ub - o.uploadedBytes
            ), o
          options.uploadedBytes = o.uploadedBytes = ub
          if ub < fs
            upload()
          else
            dfd.resolveWith o.context, [result, textStatus, jqXHR]
        ).fail((jqXHR, textStatus, errorThrown) ->
          dfd.rejectWith o.context, [jqXHR, textStatus, errorThrown]
        )

      @_enhancePromise promise
      promise.abort = ->
        jqXHR.abort()

      upload()
      promise

    _beforeSend: (e, data) ->
      if @_active is 0
        
        # the start callback is triggered when an upload starts
        # and no other uploads are currently running,
        # equivalent to the global ajaxStart event:
        @_trigger "start"
        
        # Set timer for global bitrate progress calculation:
        @_bitrateTimer = new @_BitrateTimer()
      @_active += 1
      
      # Initialize the global progress values:
      @_loaded += data.uploadedBytes or 0
      @_total += @_getTotal(data.files)

    _onDone: (result, textStatus, jqXHR, options) ->
      unless @_isXHRUpload(options)
        
        # Create a progress event for each iframe load:
        @_onProgress $.Event("progress",
          lengthComputable: true
          loaded: 1
          total: 1
        ), options
      options.result = result
      options.textStatus = textStatus
      options.jqXHR = jqXHR
      @_trigger "done", null, options

    _onFail: (jqXHR, textStatus, errorThrown, options) ->
      options.jqXHR = jqXHR
      options.textStatus = textStatus
      options.errorThrown = errorThrown
      @_trigger "fail", null, options
      if options.recalculateProgress
        
        # Remove the failed (error or abort) file upload from
        # the global progress calculation:
        @_loaded -= options.loaded or options.uploadedBytes or 0
        @_total -= options.total or @_getTotal(options.files)

    _onAlways: (jqXHRorResult, textStatus, jqXHRorError, options) ->
      @_active -= 1
      options.textStatus = textStatus
      if jqXHRorError and jqXHRorError.always
        options.jqXHR = jqXHRorError
        options.result = jqXHRorResult
      else
        options.jqXHR = jqXHRorResult
        options.errorThrown = jqXHRorError
      @_trigger "always", null, options
      if @_active is 0
        
        # The stop callback is triggered when all uploads have
        # been completed, equivalent to the global ajaxStop event:
        @_trigger "stop"
        
        # Reset the global progress values:
        @_loaded = @_total = 0
        @_bitrateTimer = null

    _onSend: (e, data) ->
      that = this
      jqXHR = undefined
      aborted = undefined
      slot = undefined
      pipe = undefined
      options = that._getAJAXSettings(data)
      send = ->
        that._sending += 1
        
        # Set timer for bitrate progress calculation:
        options._bitrateTimer = new that._BitrateTimer()
        jqXHR = jqXHR or (((aborted or that._trigger("send", e, options) is false) and that._getXHRPromise(false, options.context, aborted)) or that._chunkedUpload(options) or $.ajax(options)).done((result, textStatus, jqXHR) ->
          that._onDone result, textStatus, jqXHR, options
        ).fail((jqXHR, textStatus, errorThrown) ->
          that._onFail jqXHR, textStatus, errorThrown, options
        ).always((jqXHRorResult, textStatus, jqXHRorError) ->
          that._sending -= 1
          that._onAlways jqXHRorResult, textStatus, jqXHRorError, options
          if options.limitConcurrentUploads and options.limitConcurrentUploads > that._sending
            
            # Start the next queued upload,
            # that has not been aborted:
            nextSlot = that._slots.shift()
            isPending = undefined
            while nextSlot
              
              # jQuery 1.6 doesn't provide .state(),
              # while jQuery 1.8+ removed .isRejected():
              isPending = (if nextSlot.state then nextSlot.state() is "pending" else not nextSlot.isRejected())
              if isPending
                nextSlot.resolve()
                break
              nextSlot = that._slots.shift()
        )
        jqXHR

      @_beforeSend e, options
      if @options.sequentialUploads or (@options.limitConcurrentUploads and @options.limitConcurrentUploads <= @_sending)
        if @options.limitConcurrentUploads > 1
          slot = $.Deferred()
          @_slots.push slot
          pipe = slot.pipe(send)
        else
          pipe = (@_sequence = @_sequence.pipe(send, send))
        
        # Return the piped Promise object, enhanced with an abort method,
        # which is delegated to the jqXHR object of the current upload,
        # and jqXHR callbacks mapped to the equivalent Promise methods:
        pipe.abort = ->
          aborted = [`undefined`, "abort", "abort"]
          unless jqXHR
            slot.rejectWith options.context, aborted  if slot
            return send()
          jqXHR.abort()

        return @_enhancePromise(pipe)
      send()

    _onAdd: (e, data) ->
      that = this
      result = true
      options = $.extend({}, @options, data)
      limit = options.limitMultiFileUploads
      paramName = @_getParamName(options)
      paramNameSet = undefined
      paramNameSlice = undefined
      fileSet = undefined
      i = undefined
      if not (options.singleFileUploads or limit) or not @_isXHRUpload(options)
        fileSet = [data.files]
        paramNameSet = [paramName]
      else if not options.singleFileUploads and limit
        fileSet = []
        paramNameSet = []
        i = 0
        while i < data.files.length
          fileSet.push data.files.slice(i, i + limit)
          paramNameSlice = paramName.slice(i, i + limit)
          paramNameSlice = paramName  unless paramNameSlice.length
          paramNameSet.push paramNameSlice
          i += limit
      else
        paramNameSet = paramName
      data.originalFiles = data.files
      $.each fileSet or data.files, (index, element) ->
        newData = $.extend({}, data)
        newData.files = (if fileSet then element else [element])
        newData.paramName = paramNameSet[index]
        newData.submit = ->
          newData.jqXHR = @jqXHR = (that._trigger("submit", e, this) isnt false) and that._onSend(e, this)
          @jqXHR

        result = that._trigger("add", e, newData)

      result

    _replaceFileInput: (input) ->
      inputClone = input.clone(true)
      $("<form></form>").append(inputClone)[0].reset()
      
      # Detaching allows to insert the fileInput on another form
      # without loosing the file input value:
      input.after(inputClone).detach()
      
      # Avoid memory leaks with the detached file input:
      $.cleanData input.unbind("remove")
      
      # Replace the original file input element in the fileInput
      # elements set with the clone, which has been copied including
      # event handlers:
      @options.fileInput = @options.fileInput.map((i, el) ->
        return inputClone[0]  if el is input[0]
        el
      )
      
      # If the widget has been initialized on the file input itself,
      # override this.element with the file input clone:
      @element = inputClone  if input[0] is @element[0]

    _handleFileTreeEntry: (entry, path) ->
      that = this
      dfd = $.Deferred()
      errorHandler = (e) ->
        e.entry = entry  if e and not e.entry
        
        # Since $.when returns immediately if one
        # Deferred is rejected, we use resolve instead.
        # This allows valid files and invalid items
        # to be returned together in one set:
        dfd.resolve [e]

      dirReader = undefined
      path = path or ""
      if entry.isFile
        if entry._file
          
          # Workaround for Chrome bug #149735
          entry._file.relativePath = path
          dfd.resolve entry._file
        else
          entry.file ((file) ->
            file.relativePath = path
            dfd.resolve file
          ), errorHandler
      else if entry.isDirectory
        dirReader = entry.createReader()
        dirReader.readEntries ((entries) ->
          that._handleFileTreeEntries(entries, path + entry.name + "/").done((files) ->
            dfd.resolve files
          ).fail errorHandler
        ), errorHandler
      else
        
        # Return an empy list for file system items
        # other than files or directories:
        dfd.resolve []
      dfd.promise()

    _handleFileTreeEntries: (entries, path) ->
      that = this
      $.when.apply($, $.map(entries, (entry) ->
        that._handleFileTreeEntry entry, path
      )).pipe ->
        Array::concat.apply [], arguments_


    _getDroppedFiles: (dataTransfer) ->
      dataTransfer = dataTransfer or {}
      items = dataTransfer.items
      if items and items.length and (items[0].webkitGetAsEntry or items[0].getAsEntry)
        return @_handleFileTreeEntries($.map(items, (item) ->
          entry = undefined
          if item.webkitGetAsEntry
            entry = item.webkitGetAsEntry()
            
            # Workaround for Chrome bug #149735:
            entry._file = item.getAsFile()  if entry
            return entry
          item.getAsEntry()
        ))
      $.Deferred().resolve($.makeArray(dataTransfer.files)).promise()

    _getSingleFileInputFiles: (fileInput) ->
      fileInput = $(fileInput)
      entries = fileInput.prop("webkitEntries") or fileInput.prop("entries")
      files = undefined
      value = undefined
      return @_handleFileTreeEntries(entries)  if entries and entries.length
      files = $.makeArray(fileInput.prop("files"))
      unless files.length
        value = fileInput.prop("value")
        return $.Deferred().resolve([]).promise()  unless value
        
        # If the files property is not available, the browser does not
        # support the File API and we add a pseudo File object with
        # the input value as name with path information removed:
        files = [name: value.replace(/^.*\\/, "")]
      else if files[0].name is `undefined` and files[0].fileName
        
        # File normalization for Safari 4 and Firefox 3:
        $.each files, (index, file) ->
          file.name = file.fileName
          file.size = file.fileSize

      $.Deferred().resolve(files).promise()

    _getFileInputFiles: (fileInput) ->
      return @_getSingleFileInputFiles(fileInput)  if (fileInput not instanceof $) or fileInput.length is 1
      $.when.apply($, $.map(fileInput, @_getSingleFileInputFiles)).pipe ->
        Array::concat.apply [], arguments_


    _onChange: (e) ->
      that = this
      data =
        fileInput: $(e.target)
        form: $(e.target.form)

      @_getFileInputFiles(data.fileInput).always (files) ->
        data.files = files
        that._replaceFileInput data.fileInput  if that.options.replaceFileInput
        that._onAdd e, data  if that._trigger("change", e, data) isnt false


    _onPaste: (e) ->
      cbd = e.originalEvent.clipboardData
      items = (cbd and cbd.items) or []
      data = files: []
      $.each items, (index, item) ->
        file = item.getAsFile and item.getAsFile()
        data.files.push file  if file

      false  if @_trigger("paste", e, data) is false or @_onAdd(e, data) is false

    _onDrop: (e) ->
      e.preventDefault()
      that = this
      dataTransfer = e.dataTransfer = e.originalEvent.dataTransfer
      data = {}
      @_getDroppedFiles(dataTransfer).always (files) ->
        data.files = files
        that._onAdd e, data  if that._trigger("drop", e, data) isnt false


    _onDragOver: (e) ->
      dataTransfer = e.dataTransfer = e.originalEvent.dataTransfer
      return false  if @_trigger("dragover", e) is false
      dataTransfer.dropEffect = "copy"  if dataTransfer
      e.preventDefault()

    _initEventHandlers: ->
      if @_isXHRUpload(@options)
        @_on @options.dropZone,
          dragover: @_onDragOver
          drop: @_onDrop

        @_on @options.pasteZone,
          paste: @_onPaste

      @_on @options.fileInput,
        change: @_onChange


    _destroyEventHandlers: ->
      @_off @options.dropZone, "dragover drop"
      @_off @options.pasteZone, "paste"
      @_off @options.fileInput, "change"

    _setOption: (key, value) ->
      refresh = $.inArray(key, @_refreshOptionsList) isnt -1
      @_destroyEventHandlers()  if refresh
      @_super key, value
      if refresh
        @_initSpecialOptions()
        @_initEventHandlers()

    _initSpecialOptions: ->
      options = @options
      if options.fileInput is `undefined`
        options.fileInput = (if @element.is("input[type=\"file\"]") then @element else @element.find("input[type=\"file\"]"))
      else options.fileInput = $(options.fileInput)  unless options.fileInput instanceof $
      options.dropZone = $(options.dropZone)  unless options.dropZone instanceof $
      options.pasteZone = $(options.pasteZone)  unless options.pasteZone instanceof $

    _create: ->
      options = @options
      
      # Initialize options set via HTML5 data-attributes:
      $.extend options, $(@element[0].cloneNode(false)).data()
      @_initSpecialOptions()
      @_slots = []
      @_sequence = @_getXHRPromise(true)
      @_sending = @_active = @_loaded = @_total = 0
      @_initEventHandlers()

    _destroy: ->
      @_destroyEventHandlers()

    
    # This method is exposed to the widget API and allows adding files
    # using the fileupload API. The data parameter accepts an object which
    # must have a files property and can contain additional options:
    # .fileupload('add', {files: filesList});
    add: (data) ->
      that = this
      return  if not data or @options.disabled
      if data.fileInput and not data.files
        @_getFileInputFiles(data.fileInput).always (files) ->
          data.files = files
          that._onAdd null, data

      else
        data.files = $.makeArray(data.files)
        @_onAdd null, data

    
    # This method is exposed to the widget API and allows sending files
    # using the fileupload API. The data parameter accepts an object which
    # must have a files or fileInput property and can contain additional options:
    # .fileupload('send', {files: filesList});
    # The method returns a Promise object for the file upload call.
    send: (data) ->
      if data and not @options.disabled
        if data.fileInput and not data.files
          that = this
          dfd = $.Deferred()
          promise = dfd.promise()
          jqXHR = undefined
          aborted = undefined
          promise.abort = ->
            aborted = true
            return jqXHR.abort()  if jqXHR
            dfd.reject null, "abort", "abort"
            promise

          @_getFileInputFiles(data.fileInput).always (files) ->
            return  if aborted
            data.files = files
            jqXHR = that._onSend(null, data).then((result, textStatus, jqXHR) ->
              dfd.resolve result, textStatus, jqXHR
            , (jqXHR, textStatus, errorThrown) ->
              dfd.reject jqXHR, textStatus, errorThrown
            )

          return @_enhancePromise(promise)
        data.files = $.makeArray(data.files)
        return @_onSend(null, data)  if data.files.length
      @_getXHRPromise false, data and data.context

