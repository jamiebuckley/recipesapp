import { createApp } from "vue";
import ShoppingList from './components/ShoppingList.vue'

document.addEventListener('turbo:load', () => {
    const static_data = document.getElementById("static_data");
    if (!static_data) return;
    static_data.parentNode.removeChild(static_data);

    const shopping_list = document.getElementById("shopping_list");
    if (!shopping_list) {
        return;
    }

    const share_code = window.share_code;
    const app = createApp(ShoppingList, {
        shareCode: share_code,
        shareUrl: share_url
    })
    app.mount('#shopping_list');
})