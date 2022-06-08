# Pin npm packages by running ./bin/importmap

pin "application", preload: true
pin "@hotwired/turbo-rails", to: "turbo.min.js", preload: true
pin "@hotwired/stimulus", to: "stimulus.min.js", preload: true
pin "@hotwired/stimulus-loading", to: "stimulus-loading.js", preload: true
pin "@shopify/draggable", to: "https://ga.jspm.io/npm:@shopify/draggable@1.0.0-beta.8/lib/draggable.bundle.js"
pin_all_from "app/javascript/controllers", under: "controllers"
pin "stimulus-sortable", to: "https://ga.jspm.io/npm:stimulus-sortable@3.2.0/dist/stimulus-sortable.es.js"
pin "vue", to: "https://ga.jspm.io/npm:vue@3.2.37/dist/vue.runtime.esm-bundler.js", preload: true
pin "@vue/reactivity", to: "https://ga.jspm.io/npm:@vue/reactivity@3.2.37/dist/reactivity.esm-bundler.js", preload: true
pin "@vue/runtime-core", to: "https://ga.jspm.io/npm:@vue/runtime-core@3.2.37/dist/runtime-core.esm-bundler.js", preload: true
pin "@vue/runtime-dom", to: "https://ga.jspm.io/npm:@vue/runtime-dom@3.2.37/dist/runtime-dom.esm-bundler.js", preload: true
pin "@vue/shared", to: "https://ga.jspm.io/npm:@vue/shared@3.2.37/dist/shared.esm-bundler.js", preload: true
