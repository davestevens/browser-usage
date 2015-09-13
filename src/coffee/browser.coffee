$ = require("jquery")
_ = require("underscore")
bootstrap = require("bootstrap-sass")
Colours = require("./colours")
Version = require("./version")

template = '
<div class="browser">
  <div class="browser__total js-browser-total"
       style="background-color: <%= background_color %>">
    <h4>
      <%= name %>
      <i class="browser__expand"></i>
      <span class="badge badge--total"><%= total %>%</span>
    </h4>
  </div>
  <div class="js-browser-versions collapse"></div>
</div>
'
class Browser
  constructor: (options = {}) ->
    @name = options.name || "Browser"
    @index = options.index || 0
    @value = options.value
    @colours = options.colours || new Colours(count: 12)
    @versions = @_build_versions(options.versions || [])
    @template = _.template(template)

  render: ->
    @$el = $(@_render_template())
    @$versions = @$el.find(".js-browser-versions")
    @$versions.html(_.invoke(@versions, "render"))
    @_bind_events()
    @$el

  colour: (alpha = 1) -> @colours.create(@index, alpha)

  enable: ->
    _.invoke(@versions, "enable")
    $(window).trigger("chart:update:display")

  disable: ->
    _.invoke(@versions, "disable")
    $(window).trigger("chart:update:display")

  _build_versions: (versions) ->
    _.map(versions, (version) =>
      new Version(
        browser: @
        label: version.label
        value: version.percentage
        index: version.index
      )
    )

  _render_template: ->
    @template(
      name: @name
      background_color: @colour()
      total: @value.toFixed(2)
    )

  _bind_events: ->
    @$el.on("click", ".js-browser-total", @_toggle)

  _toggle: =>
    if @$el.hasClass("expanded") then @_collapse() else @_expand()

  _collapse: ->
    @$versions.collapse("hide")
    @$el.removeClass("expanded")

  _expand: ->
    @$versions.collapse("show")
    @$el.addClass("expanded")

module.exports = Browser
