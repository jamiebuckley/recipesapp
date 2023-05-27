import { createApp } from "vue";
import AddIngredient from './components/AddIngredient.vue'

document.addEventListener('turbo:load', () => {
    const addIngredientAppDiv = document.getElementById("addIngredientAppWrapper");
    if (!addIngredientAppDiv) {
        return;
    }

    const app = createApp(AddIngredient, {
        unitsOfMeasure: window.unitsOfMeasure,
        ingredientPostUrl: window.ingredientPostUrl,
        recipeUrl: window.recipeUrl,
        recipeId: window.recipeId
    })
    app.mount('#addIngredientAppWrapper');
    console.log("mounted");
})