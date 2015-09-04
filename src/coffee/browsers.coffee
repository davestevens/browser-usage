_ = require("underscore")

class Browsers
  constructor: (options = {}) ->
    @browsers = options.browsers || []

  render: ->
    $("<ul/>", class: "list-group")
      .append(_.map(@browsers, @_render_browser))

  _render_browser: (browser) =>
    $("<li/>", class: "list-group-item", text: browser.name)
      .append(@_render_versions(browser.versions))

  _render_versions: (versions) ->
    $("<ul/>", class: "list-group")
      .append(_.map(versions, @_render_version))

  _render_version: (version) =>
    $("<li/>",
      class: "list-group-item js-browser-version",
      text: version.version
    )
      .append(@_render_usage(version))

  _render_usage: (version) ->
    color = if version.current then "current" else "default"
    $("<span/>", class: "badge badge--#{color}", text: version.percentage)

module.exports = Browsers
