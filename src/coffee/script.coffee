$ = require("jquery")
Data = require("./data.coffee")
data = new Data(data: require("./data.json"), threshold: 1)

$(document).ready(->
  Browsers = require("./browsers")
  $browsers = $(".js-browsers")
  new Browsers($el: $browsers, browsers: data.all()).render()

  $chart_container= $(".chart-container")

  Chart = require("./chart")
  $chart = $(".js-chart")
    .attr("width", $chart_container.width())
    .attr("height", $chart_container.height())
  new Chart($el: $chart, browsers: data.all()).render()
)