_ = require("underscore")
Colours = require("./colours")
bootstrap = require("bootstrap-sass")

class Browsers
  constructor: (options = {}) ->
    @$el = options.$el
    @browsers = options.browsers || []
    @colours = options.colours || new Colours(count: @browsers.length)

  render: ->
    @$el.html(_.map(@browsers, @_render_browser))

  _render_browser: (browser, index) =>
    $("<div/>", class: "browser")
      .append(
        @_render_browser_total(browser, index),
        @_render_versions(browser.versions)
      )

  _colour: (index) -> @colours.create(index)

  _render_browser_total: (browser, index) ->
    $("<div/>",
      class: "browser__total"
      style: "background-color: #{@_colour(index)}"
    )
      .on("click", ->
        $(this).next(".collapse").collapse("toggle")
      )
      .append(@_render_browser_name(browser))

  _render_browser_name: (browser) ->
    $("<h4/>", text: browser.name)
      .append(@_render_total(browser.percentage))

  _render_versions: (versions) ->
    $("<div/>", class: "collapse")
      .append(_.map(versions, @_render_version))

  _render_version: (version) =>
    $("<li/>",
      class: "browser__version"
      text: version.label
    )
      .append(@_render_usage(version))

  _render_usage: (version) ->
    color = if version.index == 0 then "current" else "default"
    $("<span/>",
      class: "badge badge--#{color}",
      text: @_display_percentage(version.percentage)
    )

  _render_total: (percentage) ->
    $("<span/>",
      class: "badge badge--total",
      text: @_display_percentage(percentage)
    )

  _display_percentage: (value) -> "#{value.toFixed(2)}%"

module.exports = Browsers
