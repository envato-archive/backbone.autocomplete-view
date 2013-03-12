KEY_ENTER      = 13
KEY_UP_ARROW   = 38
KEY_DOWN_ARROW = 40

class Backbone.AutocompleteView extends Backbone.View

  events:
    'click':     '_click'
    'mouseout':  '_mouseOut'
    'mouseover': '_mouseOver'
    'mousedown': '_mouseDown'

  initialize: ->
    $input = @options.$input

    $input.on 'focus.autocomplete', (event) => @_inputFocus(event)
    $input.on 'blur.autocomplete', (event) => @_inputBlur(event)

    $input.on 'keyup.autocomplete', (event) => @_inputKeyUp(event)
    $input.on 'keydown.autocomplete', (event) => @_inputKeyDown(event)

  setup: ->
    # If the user mouses down on the autocomplete, then mouses up somewhere esle
    # on the page
    jQuery(document.body).on 'mouseup.autocomplete', (event) => @_bodyMouseUp()

    @$el.css position: 'absolute', zIndex: 99999, width: @options.$input.outerWidth()
    @$el.position
      of: @options.$input
      my: 'left top left'
      at: 'left bottom left'

    jQuery(document.body).prepend @el

    @setup = => # No operation anymore

  remove: ->
    @$el.remove()
    @options.$input.off '.autocomplete'
    jQuery(document.body).off '.autocomplete'

  render: (query) ->
    @setup()
    @$el.show().html @options.template(query)

  hide: ->
    @$el.hide()

  next: ->
    item = if current = @$current()
      current.next()
    else
      @$el.find("#{@options.selectors.item}:first")

    @highlight item

  prev: ->
    item = if current = @$current()
      current.prev()
    else
      @$el.find("#{@options.selectors.item}:last")

    @highlight item

  highlight: ($item) ->
    activeClass = @options.classes.active

    current.removeClass activeClass  if current = @$current()
    $item.addClass activeClass if $item

  $current: ->
    $current = @$el.find(".#{@options.classes.active}:first")

    # Will return null if there is no active item
    $current.length && $current || null

  _closestItemToEvent: (event) ->
    jQuery(event.target).closest(@options.selectors.item)

  _click: (event) ->
    event.preventDefault()

    @trigger 'select', @_closestItemToEvent(event)

  _mouseOver: (event) ->
    @highlight @_closestItemToEvent(event)

  _mouseOut: (event) ->
    @highlight() # Unhighlight what ever is active

  _mouseDown: (event) ->
    @_mouseDown = true

  _bodyMouseUp: (event) ->
    @_mouseDown = false
    # When a user mouses down on the autocompletor, and lifts the mouse while not on the autocomplete, it should
    # attempt to hide it. This gives JS 100ms to handle the before before this does.
    setTimeout =>
      if @_mouseDown
        @hide()
    , 100

  _inputFocus: (event) ->
    # If you try and focus during the click event, things get a bit crazy.
    setTimeout =>
      input = @options.$input[0]
      # Don't blow up if the function isn't defined in this browser
      input.select() if input['select']
      @render @options.$input.val()
    , 50

  _inputBlur: (event) ->
    # When you click something in the list, it causes a blur event, but that would hide the dropdown, and thus,
    # not let you click anything. Here we only hide if the blur event occurs AND 100ms later the users mouse is
    # up
    setTimeout =>
      # If the user isn't clicking on something in the list
      unless @_mouseDown
        @hide()
    , 100

  _inputKeyUp: (event) ->
    event.stopPropagation()
    event.preventDefault()

    switch event.which
      when KEY_ENTER then @trigger 'select', @$current()
      when KEY_UP_ARROW then break
      when KEY_DOWN_ARROW then break
      else @render @options.$input.val()

  _inputKeyDown: (event) ->
    event.stopPropagation()

    key = event.which
    if key == KEY_DOWN_ARROW || key == KEY_UP_ARROW
      event.preventDefault()
      switch key
        when KEY_UP_ARROW then @prev()
        when KEY_DOWN_ARROW then @next()
