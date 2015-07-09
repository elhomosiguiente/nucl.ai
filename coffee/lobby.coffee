$ ->
  if $("#section-lobby").length == 0 then return

  thisSameDate = (date1, date2) ->
    return date1.getMonth() == date2.getMonth() && date1.getDate() == date2.getDate()

  maxShowingNumber = 1 # number of current / next slots showing

  updateTalk = () ->
    date = new Date() # default date
    if url("?date") != null then date = new Date decodeURIComponent url("?date")

    room = "all"
    if url("?room") then room = url("?room")

    $("table").each ->
      dayStr = $(@).attr("date")
      day = new Date dayStr
      if thisSameDate(date, day) 
        #consider this date
        slots = []
        $(@).find("div.track").each ->
          if room == "all" || $(@).attr("room") == "all" || room == $(@).attr("room")
            slots.push $(@)
          else 
            $(@).remove()

        slots.sort (a,b) ->
          a.dateStart = new Date dayStr + " " + a.attr("time-start")
          a.dateEnd = new Date dayStr + " " + a.attr("time-finish")
          b.dateStart = new Date dayStr + " " + b.attr("time-start")
          b.dateEnd = new Date dayStr + " " + b.attr("time-finish")
          a.dateStart - b.dateStart

        toShow = maxShowingNumber

        for slot in slots
          if slot.dateStart > date && toShow > 0
              slot.show()
              slot.addClass("selected")
              toShow--
          else 
              slot.hide()
              slot.removeClass("selected")
      else
          $(@).hide()
          $(@).removeClass("selected")

    setTimeout updateTalk, 1000

  sponsorTimeout = 1000
  if url("?sponsorTimeout") != null then sponsorTimeout = parseInt url("?sponsorTimeout")

  updateSponsor = () ->
    date = new Date() # default date
    if url("?date") != null then date = new Date decodeURIComponent url("?date")
    #disable all days which are not this one
    days = []
    $(".sponsors-list .day").each ->
      day = $(@)
      day.addClass("animated zoomIn")
      day.date = new Date day.attr "date"
      days.push day

    currentDay = null
    for day in days
      if day.date.getDate() == date.getDate()
        currentDay = day.addClass("selected")
        day.height(day.width());
      else
        day.removeClass("selected")

    sponsors = []
    currentDay.find("item.sponsor").each ->
      sponsors.push $(@)

    selectNext = false
    for sponsor in sponsors
      if sponsor.hasClass("selected")
        sponsor.removeClass("selected")
        selectNext = true
      else if selectNext
        sponsor.addClass("selected")
        break;

    # if none is selected - select first
    if currentDay.find("item.sponsor.selected").length == 0
      currentDay.find("item.sponsor").first().addClass("selected")


    # $("table .track item.sponsor").remove();
    # $(".track.selected").append $("item.sponsor.selected").clone()


    setTimeout updateSponsor, sponsorTimeout

  updateTalk()
  updateSponsor()