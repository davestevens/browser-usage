ChartJS = require("chart.js")
_ = require("underscore")

class Chart
  colors: [
    "#5DA5DA",
    "#FAA43A",
    "#60BD68",
    "#F17CB0",
    "#B2912F",
    "#B276B2",
    "#DECF3F",
    "#F15854",
    "#4D4D4D"
  ]

  constructor: (options = {}) ->
    @$el = options.$el
    @browsers = options.browsers || []
    @precision = options.precision || 3

  render: ->
    context = @$el[0].getContext("2d")
    data = _.sortBy(@_build_data(), (datum) -> -parseFloat(datum.value))
    data.push(@_include_unknown(data))
    @chart = new ChartJS(context).Pie(data)

  _include_unknown: (data) ->
    unknown = _.chain(data)
      .map((value) -> parseFloat(value.value))
      .reduce(((memo, number) -> memo + number), 0)
      .value()

    value: (100 - unknown).toFixed(@precision)
    label: "Unknown Browser"
    color: "#000000"

  _build_data: ->
    _.map(@browsers, (browser, index) =>
      value: @_total_percentage(browser.versions).toFixed(@precision)
      label: browser.name
      color: @colors[index % @colors.length]
    )

  _total_percentage: (versions) ->
    _.chain(versions)
      .pluck("percentage")
      .reduce(((memo, number) -> memo + number), 0)
      .value()

module.exports = Chart
