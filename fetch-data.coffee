request = require("request")
cheerio = require("cheerio")
_ = require("underscore")
fs = require("fs")

url = "http://caniuse.com/usage-table"
desktop_browsers = ["IE", "Edge", "Firefox", "Chrome", "Safari", "Opera"]
output_filename = "src/coffee/data.json"

calculate_index = ($stat) ->
  if $stat.hasClass("current")
    0
  else if $stat.hasClass("past")
    -($stat.nextAll(".past").length + 1)
  else if $stat.hasClass("future")
    $stat.prevAll(".future").length + 1
  else
    "?"

request(url, (_error, _response, html) ->
  $ = cheerio.load(html)

  $browsers = $(".support-container .support-list")
  browsers = _.map($browsers, (browser) ->
    $browser = $(browser)
    {
      name: $browser.find("h4").text()
      versions: _.map($browser.find(".stat-cell"), (stat) ->
        $stat = $(stat)
        {
          label: parseFloat($stat.find(".stat-cell__label").text())
          percentage: parseFloat($stat.find(".stat-cell__percentage").text())
          index: calculate_index($stat)
        }
      )
    }
  )

  # Include flag for Desktop
  browsers = _.map(browsers, (browser) ->
    browser.desktop = _.contains(desktop_browsers, browser.name)
    browser
  )
  # Write to file
  fs.writeFile(output_filename, JSON.stringify(browsers, null, "  "), (error) ->
    console.log error || "Data extracted and saved to #{output_filename}"
  )
)
