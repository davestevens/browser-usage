_ = require("underscore")

class Browsers
  constructor: (options = {}) ->
    @$el = options.$el
    @browsers = options.browsers

  render: -> @$el.html(@_render_browsers())

  _render_browsers: -> _.invoke(@browsers, "render")

module.exports = Browsers
