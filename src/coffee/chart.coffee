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
    $(window).on("chart:update:unsupported", @_update_unsupported)

  render: ->
    # TODO: Alternative way to this to make first render smoother?
    @chart = @_create(@$el[0].getContext("2d"))
    _.each(@browsers, (browser) =>
      _.each(browser.versions, (version) =>
        @chart.addData(version.to_chart_data())
        segment = @chart.segments[@chart.segments.length - 1]
        version.associate_to_chart(segment)
      )
    )
    @_include_unknown()
    @_include_unsupported()
    @chart.update()

  _create: (context) ->
    new ChartJS(context).Pie([], {
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

  _update_unsupported: (_event, value) => @unsupported.value += value

module.exports = Chart
