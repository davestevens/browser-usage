class Colours
  constructor: (options = {}) ->
    @count = options.count || 10
    @saturation = options.saturation || 70
    @lightness = options.lightness || 50

  create: (index, { count = @count, alpha = 1 } = {}) ->
    hue = index * (360 / count)
    "hsla(#{hue}, #{@saturation}%, #{@lightness}%, #{alpha})"

module.exports = Colours
