_ = require("underscore")
CombinedVersion = require("./combined_version")

class Data
  constructor: (options = {}) ->
    @data = options.data || []
    @threshold = options.threshold || 1

    @_format()

  all: -> @data

  _format: ->
    @data = _.map(@data, (datum) =>
      datum.versions = @_combine_versions(datum.versions)
      datum
    )

  _combine_versions: (versions) ->
    combined_versions = []
    combined_version = new CombinedVersion()
    _.each(versions, (version) =>
      if (version.percentage < @threshold) && !version.current
        combined_version.add(version)
      else
        combined_versions.push(combined_version.build())
        combined_versions.push(version)
    )
    combined_versions.push(combined_version.build())
    _.pick(combined_versions, _.identity)

module.exports = Data
