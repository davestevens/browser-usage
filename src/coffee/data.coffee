_ = require("underscore")
Colours = require("./colours")
Browser = require("./browser")
CombinedVersion = require("./combined_version")

class Data
  constructor: (options = {}) ->
    @data = options.data || []
    @threshold = options.threshold || 1
    @colours = new Colours(count: @data.length)

    @data = @_format()

  all: -> @data

  _format: ->
    _.chain(@data)
      .map((datum) =>
        datum.versions = @_combine_versions(datum.versions)
        datum.percentage = @_total_percentage(datum.versions)
        datum
      )
      .sortBy((datum) -> -parseFloat(datum.percentage))
      .map((datum, index) =>
        new Browser(
          name: datum.name
          value: datum.percentage
          index: index
          colours: @colours
          versions: datum.versions
        )
      )
      .value()

  _combine_versions: (versions) ->
    combined_versions = []
    combined_version = new CombinedVersion()
    _.each(versions, (version) =>
      if (version.percentage < @threshold) && version.index != 0
        combined_version.add(version)
      else
        combined_versions.push(combined_version.build())
        combined_versions.push(version)
    )
    combined_versions.push(combined_version.build())
    _.filter(combined_versions, (version) -> !!version)

  _total_percentage: (versions) ->
    _.chain(versions)
      .pluck("percentage")
      .reduce(((memo, number) -> memo + number), 0)
      .value()

module.exports = Data
