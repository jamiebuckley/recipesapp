const context = require.context("../controllers", true, /\.js$/)

import { Application } from "@hotwired/stimulus"
import { definitionsFromContext } from "@hotwired/stimulus-webpack-helpers"
import Sortable from 'stimulus-sortable'
const application = Application.start()
application.load(definitionsFromContext(context))

application.register('sortable', Sortable);

// Configure Stimulus development experience
application.debug = false
window.Stimulus   = application

export { application }