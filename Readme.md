# Backbone.AutocompleteView

This is a different type of Autocompletor. Instead of having some library render your list,
we give _you_ control of how you list looks and behaves.

_Note:_ This class is currently built to work with data bootstrapted into it. It doesn't have a callback
mechanism that would allow you to grab the data via AJAX.

## Example

This example makes use of [Backbone.ProxyView](https://github.com/envato/backbone.proxy-view) and [Handlebars](https://github.com/wycats/handlebars.js/)

```HTML
<div id="autocompletor">
  <input type="text" />
</div>

<script>
  new AutoCompleteProxyView.new({
    el: "#autocompletor",
    data: [ { id: 1, name: "Envato" }, { name: id: 2 "Microlancer" } ]
  });
</script>
```

```coffeescript
#= require handlebars
#= require backbone.proxy-view
#= require backbone.autocomplete-view

class AutoCompleteProxyView extends Backbone.ProxyView

  template: Handlebars.compile """
    {{#if query}}
      <ul>
        {{#each results}}
          <li data-value="{{id}}">{{{name}}}</li>
        {{/each}}
      </ul>
    {{/if}}
  """

  requirements:
    input: 'input[type=text]'

  ready: ->
    @autocomplete = new Backbone.AutocompleteView
      $input: @$requirement('input') # The input to watch for events on
      template: (query) => # The template to render
        @render(query)
      classes:
        active: 'active' # When they press/up down, what class to add to the item
      selectors:
        item: 'li' # A css selector that signifies what is an item in the list

    # The AutocompleteView class emits a 'select' event
    # when something is selected
    @autocomplete.on 'select', ($el) =>
      console.log "selected #{$el}"

  render: (query) ->
    query = query || ""
    search = new RegExp query.replace(/[^a-zA-Z1-9\s]/, ''), "i"

    results = []
    for item in @data
      results.push item if search.test item.name

    @template query: query, results: results

  remove: ->
    @autocomplete.remove()
```

## Contributing

We encourage all community contributions. Keeping this in mind, please follow these general guidelines when contributing:

* Fork the project
* Create a topic branch for what you’re working on (git checkout -b awesome_feature)
* Commit away, push that up (git push your\_remote awesome\_feature)
* Create a new GitHub Issue with the commit, asking for review. Alternatively, send a pull request with details of what you added.

## License

backbone.autocomplete-view is released under the MIT License (see the [license file](https://github.com/envato/backbone.autocomplete-view/blob/master/LICENCE)) and is copyright Envato & Keith Pitt, 2013.
