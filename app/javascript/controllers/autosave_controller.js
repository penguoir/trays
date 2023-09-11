import { Controller } from "@hotwired/stimulus"
import debounce from "lodash.debounce"

// Connects to data-controller="autosave"
export default class extends Controller {
  static values = { delay: Number }

  initialize() {
    this.save = this.save.bind(this)
  }

  connect() {
    if (this.delayValue > 0) {
      this.save = debounce(this.save, this.delayValue)
    }
  }

  save() {
    this.element.requestSubmit()
  }
}
