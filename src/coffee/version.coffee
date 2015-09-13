$ = require("jquery")
_ = require("underscore")

template = '
<label class="browser__version">
  <%= label %>
  <input type="checkbox"
         class="browser__checkbox js-browser-checkbox"
         checked="checked" />
  <span class="badge badge--<%= usage_class %>"><%= value %>%</span>
</label>
'

class Version
  constructor: (options = {}) ->
    @browser = options.browser
    @label = options.label
    @value = options.value
    @index = options.index
    @template = _.template(template)

    @active = true
    @chart_reference = null

  render: ->
    @$el = $(@_render_template())
    @_bind_events()
    @$el

  disable: ->
    @$el.find(".js-browser-checkbox").prop("checked", false)
    @active = false
    $(window).trigger("chart:update:value", index: @chart_index, value: 0)
    $(window).trigger("chart:update:unsupported", +@value)

  enable: ->
    @$el.find(".js-browser-checkbox").prop("checked", true)
    @active = true
    $(window).trigger("chart:update:value", index: @chart_index, value: @value)
    $(window).trigger("chart:update:unsupported", -@value)

  associate_to_chart: (index) -> @chart_index = index

  to_chart_data: ->
    value: @value
    label: "#{@browser.name} - #{@label}"
    color: @browser.colour()
    highlight: @browser.colour(0.75)

  _render_template: ->
    @template(
      label: @label
      usage_class: if @index == 0 then "current" else "default"
      value: @value.toFixed(2)
    )

  _bind_events: ->
    @$el.on("change", ".js-browser-checkbox", @_toggle)

  _toggle: (event) =>
    if @active then @disable() else @enable()
    $(window).trigger("chart:update:display")

module.exports = Version
