_ = require("underscore")

class CombinedVersion
  constructor: (options = {}) ->
    @versions = options.versions = []

  add: (version) -> @versions.push(version)

  build: ->
    return null unless @versions.length
    version = {
      label: @_label()
      percentage: @_percentage()
      current: @_current()
    }
    @versions = []
    version

  _label: ->
    [first, ..., last] = @versions
    label = first.label
    label += " - #{last.label}" if @versions.length > 1
    label

  _percentage: ->
    _.reduce(@versions, ((memo, version) -> memo + version.percentage), 0)

  _current: ->
    _.every(@versions, (version) -> version.current)

module.exports = CombinedVersion
