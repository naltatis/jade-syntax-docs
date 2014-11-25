$ ->

  jade2html = (input, data) ->
    jade.compile(input, pretty: true, doctype: "5")(data)

  update = ($jade) ->
    $data = $jade.siblings(".json")
    json = $data.val() || "{}"
    $html = $jade.closest(".row").find("textarea.html")
    $jade.closest(".row").find("textarea").removeClass("error")
    try
      data = JSON.parse json
    catch error
      $data.addClass("error")
      $html.val("[json] " + error.message).addClass("error")
      return
    input = $jade.val()
    try
      html = jade2html input, data
    catch error
      $jade.addClass("error")
      $html.val("[jade] " + error.message).addClass("error")
      return
    html = html.trim()
    $html.val html

  $("textarea.jade")
    .each -> update $(@)
    .on "keyup", -> update $(@)

  $("textarea.json").on "keyup", ->
    update $(@).siblings(".jade")

  $("#basics .row").addClass "annotate"

  $.fn.tabOverride.autoIndent = true
  $.fn.tabOverride.tabSize(2)
  $("textarea.jade, textarea.json").tabOverride()

  navTop = $('.subnav').length && $('.subnav').offset().top
  isFixed = 0
  $(window).on "scroll", ->
    i = undefined
    scrollTop = $(window).scrollTop()
    if scrollTop >= navTop and not isFixed
      isFixed = 1
      $('.subnav').addClass "subnav-fixed"
    else if scrollTop <= navTop and isFixed
      isFixed = 0
      $('.subnav').removeClass "subnav-fixed"