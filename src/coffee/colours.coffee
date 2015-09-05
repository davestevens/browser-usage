colours = [
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

class Colours
  constructor: (options = {}) ->
    @list = options.list || []

  get: (index) -> @list[index % @list.length]

module.exports = new Colours(list: colours)
