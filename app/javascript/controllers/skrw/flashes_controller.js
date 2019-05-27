import { Controller } from "stimulus"

export default class extends Controller {

  connect() {
    this.timeout()
  }

  timeout() {
    this.timeout = window.setTimeout(() => {
      this.element.parentNode.removeChild(this.element)
    }, this.timeoutDelay)
  }

  get timeoutDelay() {
    return 3000
  }
}
