import { Controller } from "stimulus"
import autosize from "autosize"

export default class extends Controller {

  connect() {
    console.log("connect", this.element)
    autosize(this.element)
  }
}
