let Room = {
  init(socket, element) {
    if (!element) { return }

    let roomId = element.getAttribute("data-room-id")
    let userId = element.getAttribute("data-user-id")
    socket.connect()

    this.onReady(roomId, socket)
  },

  onReady(roomId, socket) {
    let msgContainer  = document.getElementById("message-feed")
    let msgInput      = document.getElementById("message-input")
    let roomChannel   = socket.channel("room:" + roomId)
    let msgSendButton = document.getElementById("message-send")

    msgSendButton.addEventListener("click", e => {
      let payload = {
        body: msgInput.value
      }
      roomChannel.push("msg:new", payload, 10000)
        .receive("error", e => console.log(e))
      msgInput.value = ""
    })

    roomChannel.on("msg:created", (resp) => {
      this.renderMessage(msgContainer, resp)
    })

    roomChannel.join()
      .receive("ok", resp => msgContainer.scrollTop = msgContainer.scrollHeight)
      .receive("error", reason => console.log("join failed", reason) )
  },

  renderMessage(msgContainer, {template, id, message_user_id}) {
    let userId = msgContainer.getAttribute("data-user-id")
    msgContainer.insertAdjacentHTML("beforeend", template)
    let message = document.getElementById("message-" + id)

    if (message_user_id == userId) {
      this.addClass(message, " hl-bg-light-yellow fr")
    } else {
      this.addClass(message, " hl-bg-light-aqua fl")
    }

    msgContainer.scrollTop = msgContainer.scrollHeight
  },

  addClass(element, classString) {
    let oldClassString = element.className
    let newClassString = oldClassString.concat(classString)
    element.className = newClassString
  }
}

export default Room
