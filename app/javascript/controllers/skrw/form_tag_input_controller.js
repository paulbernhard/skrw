// controller for input / textarea with tags suggestions
// use with <input type="text" name="tags" data-controller="skrw--form-tag-input">
// set setting with data attributes:
// whitelist (possible tags)
//  => data-skrw--form-tag-input-whitelist="apple, pear, banana"
// enforeWhitelist (allow only whitelisted tags, default: true)
//  => data-skrw--form-tag-input-enfore-whitelist="false"
// url to request a whitelist with ajax
//  => data-skrw--form-tag-input-url="/tags"

import { Controller } from "stimulus"
import Tagify from "@yaireo/tagify"

export default class extends Controller {

  connect() {
    console.log("connect form-tag-input controller", this.element)

    // set options
    let options = {
      enforceWhitelist: this.enforceWhitelist,
      dropdown: { enabled: 1 }
    }

    if (this.whitelistUrl) {
      // fetch whitelist from URL request
      this.fetchWhitelist().then((data) => {
        options.whitelist = data
        this.init(options)
      })
    } else {
      // get whotelist from data-attribute
      options.whitelist = this.whitelist ? this.whitelist : []
      this.init(options)
    }
  }

  init(options) {
    this.tagify = new Tagify(this.element, options)
    this.tagify
      .on("add", (event) => { this.updateInput(event) })
      .on("remove", (event) => { this.updateInput(event) })
  }

  updateInput(event) {
    console.log("update tag input", event.detail)
    const tags = this.tagify.value
    const tagsAsString = tags.map((t) => { return t.value }).join(", ")
    this.element.value = tagsAsString
  }

  // fetch and override whitelist with AJAX request
  async fetchWhitelist() {
    const url = this.whitelistUrl
    const response = await fetch(url)
    const data = await response.json()
    return data
  }

  get whitelist() {
    return this.data.has("whitelist") ? this.data.get("whitelist") : false
  }

  get whitelistUrl() {
    return this.data.has("url") ? this.data.get("url") : false
  }

  get enforceWhitelist() {
    return this.data.get("enforceWhitelist") == "false" ? false : true
  }
}
