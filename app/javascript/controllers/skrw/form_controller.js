import { Controller } from "stimulus"
import autosize from "autosize"

export default class extends Controller {

  connect() {
    // init autosize for textareas
    this.textareas = this.element.querySelectorAll("textarea")
    if (this.textareas.length > 0) {
      autosize(this.textareas)
    }
  }

  disconnect() {
    // destroy autosize for textareas
    if (this.textareas.length > 0) {
      autosize.destroy(this.textareas)
    }
  }
}
