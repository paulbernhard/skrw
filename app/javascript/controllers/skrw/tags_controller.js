// controller for input / textarea with tags suggestions
// use with <input type="text" name="tags" data-controller="skrw--tags">
// set setting with data attributes:
// whitelist (possible tags)
//  => data-skrw--tags-whitelist="apple, pear, banana"
// enforeWhitelist (allow only whitelisted tags, default: true)
//  => data-skrw--tags-enfore-whitelist="false"
// url to request a whitelist with ajax
//  => data-skrw--tags-url="/tags"

import { Controller } from "stimulus"
import Tagify from "@yaireo/tagify"

export default class extends Controller {

  connect() {
    console.log("connect tags controller", this.element)

    // set options
    let options = {
      enforceWhitelist: this.enforceWhitelist,
      dropdown: { enabled: 1 }
    }

    if (this.whitelistUrl) {
      // fetch whitelist from URL request
      this.fetchWhitelist().then((data) => {
        options.whitelist = data
        console.log(data)
        this.init(options)
      })
    } else {
      // get whotelist from data-attribute
      options.whitelist = this.whitelist ? this.whitelist : []
      this.init(options)
    }
  }

  // initialize tagify
  init(options) {
    this.tagify = new Tagify(this.element, options)
    this.formatInput()
    this.tagify
      .on("add", (e) => { this.formatInput() })
      .on("remove", (e) => { this.formatInput() })
  }

  // format tagify value as comma seperated list
  formatInput() {
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
    return this.data.get("enforceWhitelist") == "true" ? true : false
  }
}
