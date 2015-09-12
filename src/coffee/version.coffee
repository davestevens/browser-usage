$ = require("jquery")
_ = require("underscore")

class Version
  constructor: (options = {}) ->
    @browser = options.browser
    @label = options.label
    @value = options.value
    @index = options.index

    @active = true
    @chart_reference = null

  render: ->
    @$el = $("<label/>", class: "browser__version", text: @label)
      .append(@_render_checkbox(), @_render_usage())

  _render_checkbox: ->
    @$input = $("<input/>",
      type: "checkbox"
      class: "browser__checkbox"
      checked: "checked"
    ).on("change", @_toggle)

  _render_usage: ->
    color = if @index == 0 then "current" else "default"
    $("<span/>"
      class: "badge badge--#{color}"
      text: @_display_percentage(@value)
    )

  _display_percentage: (value) -> "#{value.toFixed(2)}%"

  _toggle: =>
    if @active then @disable() else @enable()
    $(window).trigger("chart:update:display")

  disable: ->
    @$input.prop("checked", false)
    @active = false
    @chart_reference.value = 0
    $(window).trigger("chart:update:unsupported", +@value)

  enable: ->
    @$input.prop("checked", true)
    @active = true
    @chart_reference.value = @value
    $(window).trigger("chart:update:unsupported", -@value)

  associate_to_chart: (reference) -> @chart_reference = reference

  to_chart_data: ->
    value: @value
    label: "#{@browser.name} - #{@label}"
    color: @browser.colour()
    highlight: @browser.colour(0.75)

module.exports = Version
