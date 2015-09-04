$ = require("jquery")
data = require("./data.json")

Browsers = require("./browsers")
$browsers = $(".js-browsers")
$browsers.append(new Browsers(browsers: data.desktop).render())
$browsers.append(new Browsers(browsers: data.mobile).render())

Chart = require("./chart")
$chart = $(".js-chart")
all_browsers = data.desktop.concat(data.mobile)
new Chart($el: $chart, browsers: all_browsers).render()
