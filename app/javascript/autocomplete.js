document.addEventListener('DOMContentLoaded', () => {
    const app = new Vue({
        vuetify: new Vuetify(),
        render: h => h(App)
    }).$mount()
    document.body.appendChild(app.$el)

    console.log(app)
})