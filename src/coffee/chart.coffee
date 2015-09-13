ChartJS = require("chart.js")
$ = require("jquery")
_ = require("underscore")

class Chart
  constructor: (options = {}) ->
    @$el = options.$el
    @$container = @$el.parent()
    @browsers = options.browsers

    @_bind_events()

  _bind_events: ->
    $(window).on("chart:update:display", => @chart.update())
    $(window).on("chart:update:value", @_update_value)
    $(window).on("chart:update:unsupported", @_update_unsupported)

  render: ->
    data = []
    _.each(@browsers, (browser) =>
      _.each(browser.versions, (version) =>
        data.push(version.to_chart_data())
        version.associate_to_chart(data.length - 1)
      )
    )
    @chart = @_create(@$el[0].getContext("2d"), data)
    @_include_unknown()
    @_include_unsupported()

  _create: (context, data = []) ->
    new ChartJS(context).Pie(data, {
      responsive: true
      maintainAspectRatio: false
      segmentStrokeWidth: 0.1
      animateScale: true
      animateRotate: true
    })

  _include_unknown: ->
    known = _.chain(@browsers)
      .map((value) -> parseFloat(value.value))
      .reduce(((memo, number) -> memo + number), 0)
      .value()

    @chart.addData(
      value: (100 - known).toFixed(2)
      label: "Unknown Browser"
      color: "rgba(0, 0, 0, 0.75)"
      highlight: "rgba(0, 0, 0, 0.5)"
    )

  _include_unsupported: ->
    @chart.addData(
      value: 0
      label: "Unsupported Browser"
      color: "rgba(0, 0, 0, 0.4)"
      highlight: "rgba(0, 0, 0, 0.25)"
    )
    @unsupported = @chart.segments[@chart.segments.length - 1]

  _update_value: (_event, { index, value }) =>
    @chart.segments[index].value = value

  _update_unsupported: (_event, value) => @unsupported.value += value

module.exports = Chart
