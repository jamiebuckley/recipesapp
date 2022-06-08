import { createApp } from "vue";
import Autocomplete from './components/Autocomplete.vue'

document.addEventListener('DOMContentLoaded', () => {
    const static_ingredient = document.getElementById("static_ingredient");
    static_ingredient.parentNode.removeChild(static_ingredient);

    const autocomplete = document.getElementById("autocomplete");
    if (!autocomplete) {
        return;
    }

    const app = createApp(Autocomplete)
    app.mount('#autocomplete');
    console.log("mounted");
})