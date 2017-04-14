TRY ONLY

NodePie = require("nodepie")

csFeedUrl = "https://cloudstaff.com/feed/"

module.exports = (robot) ->
  robot.respond /CS top (\d+)?/i, (msg) ->
    msg.http(csFeedUrl).get() (err, res, body) ->
      if res.statusCode is not 200
        msg.send "Something went wrong. Please try again later."
      else
        feed = new NodePie(body)
        try
          feed.init()
          count = msg.match[1] || 5
          items = feed.getItems(0, count)
          msg.send item.getTitle() + ": " + item.getPermalink() + " (" + item.getComments()?.html + ")" for item in items
        catch e
          console.log(e)
          msg.send "Something's gone awry"

  robot.hear /CS(\.top|\[\d+\])/i, (msg) ->
     msg.http(csFeedUrl).get() (err, res, body) ->
       if res.statusCode is not 200
         msg.send "Something went wrong. Please try again later."
       else
         feed = new NodePie(body)
         try
           feed.init()
         catch e
           console.log(e)
           msg.send "Something's gone awry"
         element = msg.match[1]
         if element == "CS.top"
           idx = 0
         else
           idx = (Number) msg.match[0].replace(/[^0-9]/g, '') - 1
         try
           item = feed.getItems()[idx]
           msg.send item.getTitle() + ": " + item.getPermalink() + " (" + item.getComments()?.html + ")"
         catch e
           console.log(e)
           msg.send "Something went wrong. Please try again later."
