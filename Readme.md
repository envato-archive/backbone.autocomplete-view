## Example

This example makes use of [Backbone.ProxyView](https://github.com/envato/backbone.proxy-view) and [Handlebars](https://github.com/wycats/handlebars.js/)

```HTML
<div id="autocompletor">
  <input type="text" />
</div>

<script>
  new AutoCompleteProxyView.new({ el: "#autocompletor" });
</script>
```

```coffeescript
class AutoCompleteProxyView extends Backbone.ProxyView

  template: Handlebars.compile """
    {{#if query}}
      <ul id="search-form-results">
        {{#each results}}
          <li data-value="{{slug}}" class="query-item">{{{highlighted}}}</li>
        {{/each}}
      </ul>
    {{/if}}
  """

  requirements:
    input: 'input[type=text]'

  ready: ->
    @autocomplete = new Backbone.AutocompleteView
      $input: @$requirement('input')
      template: _.memoize(_.bind(@render, this), @_cacheKey)
      classes:
        active: 'active'
      selectors:
        item: 'li'

    @autocomplete.on 'select', ($el) =>
      console.log "Selected #{$el}"

  render: (query) ->
    query = query || ""
    search = new RegExp query.replace(/[^a-zA-Z1-9\s]/, ''), "i"

    partial = query.replace(/[\-\[\]{}()*+?.,\\\^$|#\s]/g, '\\$&')
    highlighter = new RegExp('(' + partial + ')', 'i')

    results = []
    for category in @options.categories
      if search.test category.name
        results.push
          highlighted: category.name.replace(highlighter, ($1, match) -> "<strong>#{match}</strong>")

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
