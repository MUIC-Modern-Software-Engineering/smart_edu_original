# Pin npm packages by running ./bin/importmap

pin "application"
pin "@hotwired/turbo-rails", to: "turbo.min.js"
pin "@hotwired/stimulus", to: "stimulus.min.js"
pin "@hotwired/stimulus-loading", to: "stimulus-loading.js"
pin_all_from "app/javascript/controllers", under: "controllers"
pin "@zxing/browser", to: "https://ga.jspm.io/npm:@zxing/browser@0.1.5/esm/index.js"
pin "@zxing/library", to: "https://ga.jspm.io/npm:@zxing/library@0.21.3/esm/index.js"
pin "ts-custom-error", to: "https://ga.jspm.io/npm:ts-custom-error@3.3.1/dist/custom-error.mjs"
pin "datatables.net" # @2.2.2
pin "jquery" # @3.7.1
