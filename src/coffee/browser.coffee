$ = require("jquery")
_ = require("underscore")
bootstrap = require("bootstrap-sass")
Colours = require("./colours")
Version = require("./version")

class Browser
  constructor: (options = {}) ->
    @name = options.name || "Browser"
    @index = options.index || 0
    @value = options.value
    @colours = options.colours || new Colours(count: 12)
    @versions = @_build_versions(options.versions || [])

  render: ->
    $("<div/>", class: "browser")
      .append(
        @_render_browser_total()
        @_render_versions()
    )

  colour: (alpha = 1) -> @colours.create(@index, alpha)

  enable: ->
    _.invoke(@versions, "enable")
    $(window).trigger("chart:update:display")

  disable: ->
    _.invoke(@versions, "disable")
    $(window).trigger("chart:update:display")

  _render_browser_total: ->
    $("<div/>",
      class: "browser__total"
      style: "background-color: #{@colour()}"
    )
      .on("click", -> $(this).next(".collapse").collapse("toggle"))
      .append(@_render_browser_name())

  _render_versions: ->
    $("<div/>", class: "collapse")
      .append(_.invoke(@versions, "render"))

  _render_browser_name: ->
    $("<h4/>", text: @name).append(@_render_total())

  _render_total: ->
    $("<span/>",
      class: "badge badge--total",
      text: @_display_percentage(@value)
    )

  _display_percentage: (value) -> "#{value.toFixed(2)}%"

  _build_versions: (versions) ->
    _.map(versions, (version) =>
      new Version(
        browser: @
        label: version.label
        value: version.percentage
        index: version.index
      )
    )

module.exports = Browser
