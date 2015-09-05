$ = require("jquery")
Data = require("./data.coffee")
data = new Data(data: require("./data.json"), threshold: 1)

Browsers = require("./browsers")
$browsers = $(".js-browsers")
new Browsers($el: $browsers, browsers: data.all()).render()

Chart = require("./chart")
$chart = $(".js-chart")
new Chart($el: $chart, browsers: data.all()).render()
