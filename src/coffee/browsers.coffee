_ = require("underscore")
colours = require("./colours")

class Browsers
  constructor: (options = {}) ->
    @$el = options.$el
    @browsers = options.browsers || []

  render: ->
    @$el.html($("<ul/>", class: "list-group")
      .append(_.map(@browsers, @_render_browser))
    )

  _render_browser: (browser, index) =>
    $("<li/>",
      class: "list-group-item",
      style: "background-color: #{colours.get(index)}"
    )
      .append(
        @_render_browser_name(browser),
        @_render_versions(browser.versions)
      )

  _render_browser_name: (browser) ->
    $("<h4/>", text: browser.name).append(@_render_total(browser.percentage))

  _render_versions: (versions) ->
    $("<ul/>", class: "list-group")
      .append(_.map(versions, @_render_version))

  _render_version: (version) =>
    $("<li/>",
      class: "list-group-item js-browser-version",
      text: version.label
    )
      .append(@_render_usage(version))

  _render_usage: (version) ->
    color = if version.current then "current" else "default"
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
