$ = require("jquery")
_ = require("underscore")
filters = [
  { label: "All", callback: (_version) -> true }
  { label: "Latest", callback: (version) -> version.index == 0 }
  { label: "Latest -1", callback: (version) -> version.index >= -1 }
  { label: "Latest -2", callback: (version) -> version.index >= -2 }
]

template = '
<div class="form-horizontal">
  <div class="form-group">
    <label for="js-version-filter" class="control-label col-sm-2">Filter</label>
    <div class="col-sm-10">
      <select id="js-version-filter"
              class="form-control js-version-filter"
              name="js-version-filter"></select>
    </div>
  </div>
</div>
'

class Filter
  constructor: (options = {}) ->
    @$el = options.$el
    @filters = filters
    @template = _.template(template)

  render: ->
    @$el.html(@_render_template())
    @$el.find(".js-version-filter").html(@_render_options())
    @_bind_events()

  _render_template: -> @template()

  _render_options: ->
    _.map(@filters, (filter) ->
      $("<option/>", text: filter.label, data: { callback: filter.callback })
    )

  _bind_events: ->
    @$el.on("change", ".js-version-filter", ->
      $(window).trigger("browsers:filter", $(@).find(":selected").data())
    )

module.exports = Filter
