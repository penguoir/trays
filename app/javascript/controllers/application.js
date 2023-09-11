import { Application } from "@hotwired/stimulus"
import Autosave from 'stimulus-rails-autosave'

const application = Application.start()

// Configure Stimulus development experience
application.debug = true
window.Stimulus   = application

export { application }
