_ = require("underscore")

class Browsers
  constructor: (options = {}) ->
    @$el = options.$el
    @browsers = options.browsers
    @_bind_events()

  render: -> @$el.html(@_render_browsers())

  filter: (callback) -> _.invoke(@browsers, "filter", callback)

  _bind_events: ->
    $(window).on("browsers:filter", @_filter_browsers)

  _render_browsers: -> _.invoke(@browsers, "render")

  _filter_browsers: (event, { callback }) => @filter(callback)

module.exports = Browsers
