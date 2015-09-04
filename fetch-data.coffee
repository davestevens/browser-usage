request = require("request")
cheerio = require("cheerio")
_ = require("underscore")
fs = require("fs")

url = "http://caniuse.com/usage-table"
desktop_browsers = ["IE", "Edge", "Firefox", "Chrome", "Safari", "Opera"]
output_filename = "src/coffee/data.json"

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
          version: parseFloat($stat.find(".stat-cell__label").text())
          percentage: parseFloat($stat.find(".stat-cell__percentage").text())
          current: $stat.hasClass("current")
        }
      )
    }
  )

  # Split browsers based on mobile/desktop
  data =
    desktop: _.filter(browsers, (browser) ->
      _.contains(desktop_browsers, browser.name)
    )
    mobile: _.filter(browsers, (browser) ->
      !_.contains(desktop_browsers, browser.name)
    )
  # Write to file
  fs.writeFile(output_filename, JSON.stringify(data, null, "  "), (error) ->
    console.log error || "Data extracted and saved to #{output_filename}"
  )
)
