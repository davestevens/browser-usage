ChartJS = require("chart.js")
_ = require("underscore")
Colours = require("./colours")

class Chart
  constructor: (options = {}) ->
    @$el = options.$el
    @browsers = options.browsers || []
    @precision = options.precision || 2
    @colours = options.colours || new Colours(count: @browsers.length)
    @_bind_events()

  _bind_events: ->
    $(window).on("browser:off", @_disable_data_item)
    $(window).on("browser:on", @_enable_data_item)

  render: ->
    context = @$el[0].getContext("2d")
    @chart = new ChartJS(context).Pie(@_build_data(), {
      segmentStrokeWidth: 0.1
      animateScale: true
      animateRotate: true
    })
    window.chart = @chart

  _disable_data_item: (_event, data) =>
    browser = @browsers[data.browser]
    version = browser.versions[data.version]
    x = @_chart_segment_from_indexes(data.browser, data.version)
    @chart.segments[x].value = 0
    @chart.segments[@chart.segments.length - 1].value += version.percentage
    @chart.update()

  _enable_data_item: (_event, data) =>
    browser = @browsers[data.browser]
    version = browser.versions[data.version]
    x = @_chart_segment_from_indexes(data.browser, data.version)
    @chart.segments[x].value = version.percentage
    @chart.segments[@chart.segments.length - 1].value -= version.percentage
    @chart.update()

  _chart_segment_from_indexes: (browser_index, version_index) ->
    index = _.reduce(@browsers[0...browser_index], (memo, browser) ->
      memo + browser.versions.length
    , 0)
    index + +version_index

  _include_unknown: (data) ->
    unknown = _.chain(data)
      .map((value) -> parseFloat(value.value))
      .reduce(((memo, number) -> memo + number), 0)
      .value()

    value: (100 - unknown).toFixed(@precision)
    label: "Unknown Browser"
    color: "rgba(0, 0, 0, 0.75)"
    highlight: "rgba(0, 0, 0, 0.5)"

  _include_unsupported: ->
    value: 0
    label: "Unsupported Browser"
    color: "rgba(0, 0, 0, 0.4)"
    highlight: "rgba(0, 0, 0, 0.25)"

  _build_data: ->
    browsers = []
    _.each(@browsers, (browser, index) =>
      _.each(browser.versions, (version) =>
        browsers.push(
          value: version.percentage.toFixed(@precision)
          label: "#{browser.name} (#{version.label})"
          color: @colours.create(index)
          highlight: @colours.create(index, alpha: 0.75)
        )
      )
    )
    browsers.push(@_include_unknown(browsers))
    browsers.push(@_include_unsupported())
    browsers

module.exports = Chart
