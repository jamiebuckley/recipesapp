import { createApp } from "vue";
import Autocomplete from './components/Autocomplete.vue'

document.addEventListener('turbo:load', () => {
    const static_ingredient = document.getElementById("static_ingredient");
    if (!static_ingredient) return;
    static_ingredient.parentNode.removeChild(static_ingredient);

    const autocomplete = document.getElementById("autocomplete");
    if (!autocomplete) {
        return;
    }

    const app = createApp(Autocomplete)
    app.mount('#autocomplete');
    console.log("mounted");
})