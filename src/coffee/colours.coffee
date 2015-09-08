class Colours
  constructor: (options = {}) ->
    @count = options.count || 10
    @saturation = options.saturation || 70
    @lightness = options.lightness || 50

  create: (index, count = @count) ->
    hue = index * (360 / count)
    "hsl(#{hue}, #{@saturation}%, #{@lightness}%)"

module.exports = Colours
