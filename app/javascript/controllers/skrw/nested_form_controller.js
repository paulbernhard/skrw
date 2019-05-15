import { Controller } from "stimulus"

export default class extends Controller {

  static targets = ["template"]

  // add association
  // adds a new field wrapper with a timestamp id to the form
  add(event) {
    event.preventDefault()

    // use template and replace record index with timestamp
    const content = this.templateTarget.innerHTML.replace(/NEW_RECORD/g, new Date().getTime())
    event.target.insertAdjacentHTML("beforebegin", content)
  }

  // remove association
  // sets hidden _destroy field to 1 and hides field wrapper
  remove(event) {
    event.preventDefault()
    const wrapper = event.target.parentNode
    wrapper.querySelector("input[name*='_destroy']").value = 1
    wrapper.style.display = "none"
    event.target.parentNode.removeChild(event.target)
  }
}
