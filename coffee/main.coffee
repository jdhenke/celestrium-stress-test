requirejs.config
  baseUrl: "/js"

# returns milliseconds since first call to getTime
getGetTime = do ->
  return ->
    start = null
    return ->
      if start?
        return + new Date() - start
      else
        start = + new Date()
        return 0

require ["Celestrium"], (Celestrium) ->

  plugins =
    "Layout":
      el: document.querySelector "body"
    "GraphModel":
      nodeHash: (node) -> node.text
      linkHash: (link) -> link.source.text + link.target.text
    "GraphView": {}

  Celestrium.init plugins, (instances) ->

    m = instances["GraphModel"]

    window.test = (numNodes, numLinks) ->

      nodes = []
      for x in [1..numNodes]
        nodes.push {"text": x}

      links = []
      addLink = do ->
        i = 0
        j = i + 1
        return ->
          if j >= nodes.length
            i += 1
            j = i + 1
          if i < nodes.length and j < nodes.length
            do ->
              links.push
                "source": nodes[i+0]
                "target": nodes[j+0]
                "strength": 1
            j += 1
      for x in [1..numLinks]
        addLink()

      getNodeTime = getGetTime()
      getLinkTime = getGetTime()
      getTime = getGetTime()

      graphView = instances["GraphView"]
      log = window.log = []
      last = null
      graphView.on "tick", () ->
        now = getTime()
        last ?= now
        delta = now - last
        log.push {time: now, delta: delta}
        last = now

      nodeBegin = getNodeTime()
      nodes.forEach (node) ->
        m.putNode(node)
      nodeEnd = getNodeTime()
      console.log("Node time", nodeEnd - nodeBegin)

      linkBegin = getLinkTime()
      links.forEach (link) ->
        m.putLink(link)
      linkEnd = getLinkTime()
      console.log("Link time", linkEnd - linkBegin)

      setTimeout ->
        graphView.getForceLayout().stop()
        total = 0
        total += entry.delta for entry in log
        total -= log[1].delta
        console.log "mean ms/tick", total / (log.length - 2)
      , 10000

      null
