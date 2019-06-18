import { Controller } from "stimulus"

export default class extends Controller {

  connect() {
    if (this.loggedIn) {
      this.element.classList.add(this.minClass)
    }
  }

  toggle() {
    this.element.classList.toggle(this.minClass)
  }

  get minClass() {
    return "skrw-session--min"
  }

  get loggedIn() {
    const loggedIn = this.data.get("loggedIn")
    return loggedIn == "true" ? true : false
  }
}
