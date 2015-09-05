ChartJS = require("chart.js")
_ = require("underscore")
colours = require("./colours")

class Chart
  constructor: (options = {}) ->
    @$el = options.$el
    @browsers = options.browsers || []
    @precision = options.precision || 2

  render: ->
    context = @$el[0].getContext("2d")
    @chart = new ChartJS(context).Pie(@_build_data(), {
      segmentStrokeWidth: 0.5
      animateScale: true
      animateRotate: true
    })

  _include_unknown: (data) ->
    unknown = _.chain(data)
      .map((value) -> parseFloat(value.value))
      .reduce(((memo, number) -> memo + number), 0)
      .value()

    value: (100 - unknown).toFixed(@precision)
    label: "Unknown Browser"
    color: "#000000"

  _build_data: ->
    browsers = []
    _.each(@browsers, (browser, index) =>
      _.each(browser.versions, (version) =>
        browsers.push(
          value: version.percentage.toFixed(@precision)
          label: "#{browser.name} - #{version.label}"
          color: colours.get(index)
        )
      )
    )
    browsers.push(@_include_unknown(browsers))
    browsers

module.exports = Chart
