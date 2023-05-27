<script>
import Sortable from 'sortablejs';

function debounce(func, timeout = 500) {
  let timer;
  return (...args) => {
    clearTimeout(timer);
    timer = setTimeout(() => {
      func.apply(this, args);
    }, timeout);
  };
}

const processInput = debounce((newVal, callback) => {
  fetch(`/ingredients/search/${newVal}`)
      .then(results => results.json())
      .then(callback)
})

export default {
  props: {
    unitsOfMeasure: Array,
    ingredientPostUrl: String,
    recipeUrl: String,
    recipeId: String
  },
  data() {
    return {
      isFocused: false,
      searchResults: [],
      searchTerm: '',
      quantity: 0,
      unit: 'g',
      ingredients: []
    }
  },
  created() {
    const url = `/recipes/${recipeId}/ingredients/`
    fetch(url, {
      headers: {
        'Accept': 'application/json',
        "Content-Type": "application/json",
      }
    }).then(data => data.json()).then(data => {
      this.ingredients = data;
    });
  },
  mounted() {
    var el = document.getElementById('sortableItems');
    var sortable = new Sortable(el, {
      handle: ".handle",
      onEnd: (evt) => {
        this.onItemDragged(evt.oldIndex, evt.newIndex);
      }
    });
  },
  methods: {
    onItemDragged(oldIndex, newIndex) {

      const csrfToken = document.querySelector("[name='csrf-token']").content;
      const sourceIngredient = this.ingredients[oldIndex];

      this.ingredients.splice(oldIndex, 1);
      this.ingredients.splice(newIndex, 0, sourceIngredient);
      console.log(this.ingredients);
      for (let i = 0; i < this.ingredients.length; i++) {
        const ingredient = this.ingredients[i];
        if (ingredient.position !== i + 1) {
          const url = `/recipes/${recipeId}/ingredients/${ingredient.id}`
          fetch(url, {
            headers: {
              "X-CSRF-Token": csrfToken,
              "Content-Type": "application/json",
            },
            method: "put",
            body: JSON.stringify({
              "recipe_ingredient": {
                "position": i + 1
              }
            })
          })
          ingredient.position = i + 1;
        }
      }
    },
    focus: function (ev) {
      this.isFocused = true;
    },
    complete: function (ev) {
      this.isFocused = false;
      ev.preventDefault()
    },
    selected: function (data) {
      this.searchTerm = data;
      this.isFocused = false;
    },
    delete: function (ingredientId) {
      console.log(ingredientId);
      const csrfToken = document.querySelector("[name='csrf-token']").content;
      const url = `/recipes/${recipeId}/ingredients/${ingredientId}`
      fetch(url, {
        headers: {
          "X-CSRF-Token": csrfToken,
          "Content-Type": "application/json",
          'Accept': 'application/json',
        },
        method: "delete"
      }).then(data => {
        const ingredientIndex = this.ingredients.findIndex(i => i.id === ingredientId);
        this.ingredients.splice(ingredientIndex, 1);
      })
    },
    onFocusQuantity() {
      setTimeout(() => {
        this.$refs.quantity.scrollIntoView({behavior: "smooth"});
      }, 500);
    },
    submit() {
      const csrfToken = document.querySelector("[name='csrf-token']").content;
      const url = `/recipes/${recipeId}/ingredients/`
      fetch(url, {
        headers: {
          "X-CSRF-Token": csrfToken,
          "Content-Type": "application/json",
          'Accept': 'application/json',
        },
        method: "post",
        body: JSON.stringify({
          "recipe_ingredient": {
            "ingredient": {
              "name": this.searchTerm
            },
            quantity: this.quantity,
            "unit": this.unit
          }
        })
      })
      .then(data => data.json())
      .then(data => {
        this.searchTerm = "";
        this.quantity = 0;
        this.ingredients.push(data)
        setTimeout(() => {
          this.$refs.recipeIngredientsList.scrollTop = this.$refs.recipeIngredientsList.scrollHeight;
        }, 500);
      });
    }
  },
  watch: {
    searchTerm: function (newVal, oldVal) {
      if (newVal == '') {
        this.searchResults = [];
        return
      } else {
        processInput(newVal, results => this.searchResults = results);
      }
    }
  }
}
</script>

<template>
  <div class="recipeIngredientsApp">
    <div class="mb-4">
      <a :href="recipeUrl" class="button">
      <span class="icon">
        <i class="fas fa-arrow-left"></i>
      </span>
        <span>Back to recipe</span>
      </a>
    </div>
    <div class="recipeIngredientsList" v-show="!isFocused" ref="recipeIngredientsList">
      <ul class="mb-6" id="sortableItems">
        <li class="recipecard card mb-2" v-for="recipeIngredient in ingredients" :key="recipeIngredient.id">
          <div class="card-content">
            <div class="columns is-mobile">
              <div class="column is-3 handle">
              <span class="icon is-large">
                <i class="fas fa-arrows"></i>
              </span>
              </div>
              <div class="column">
                <p class="title is-size-5">
                  {{ recipeIngredient.name }}
                </p>
                <p class="subtitle">
                  {{ recipeIngredient.quantity }} {{ recipeIngredient.unit }}
                </p>
              </div>
              <div class="column is-one-quarter">
                <button @click="this.delete(recipeIngredient.id)" class="delete is-large is-pulled-right"/>
              </div>
            </div>
          </div>
        </li>
      </ul>
    </div>
    <div class="recipeAddIngredient">
      <form :action="ingredientPostUrl" method="post">

        <div class="field has-addons">
          <div class="control is-expanded">
            <input class="input is-large mb-4" name="recipe_ingredient[ingredient][name]"
                   placeholder="Ingredient Name" autocomplete="off"
                   @click="this.focus"
                   v-model="this.searchTerm"/>
          </div>
          <div class="control" v-if="this.isFocused">
            <a class="button is-large is-primary" @click="this.complete">
              Add
            </a>
          </div>
        </div>

        <div v-if="isFocused">
          <div v-for="ingredient in searchResults" class="searchItem is-size-3" @click="this.selected(ingredient)">
            {{ ingredient }}
          </div>
        </div>

        <div v-else>
          <div class="field has-addons flex-wrap">
            <div class="control is-expanded">
              <input class="input is-large mb-4" type="number" step="any" name="recipe_ingredient[quantity]"
                     ref="quantity"
                     v-model="this.quantity"
                     placeholder="Ingredient Quantity" autocomplete="off" @focus="onFocusQuantity()"/>
            </div>
            <div class="select is-large">
              <select name="recipe_ingredient[unit]" v-model="this.unit">
                <option v-for="unit in unitsOfMeasure" :value="unit">{{ unit }}</option>
              </select>
            </div>
          </div>
          <div class="control is-clearfix">
            <input type="button" value="Add Ingredient" class="button is-primary is-pulled-right is-large"
                   @click="submit"/>
          </div>
        </div>
      </form>
    </div>
  </div>
</template>

<style>
.recipeIngredientsApp {
  display: flex;
  flex-direction: column;
  height: 100%;
}

.recipeIngredientsList {
  flex-grow: 1;
  overflow-y: scroll;
}

.recipeAddIngredient {
  height: 254px;
  padding: 10px;
}

.recipecard {
  max-width: 800px;
  margin: 0px auto;
}

.fullpage {
  left: 0px;
  padding: 8px;
  position: fixed;
  width: 100%;
  height: 100%;
  top: 52px;
  background: white;
  z-index: 5;
}

.partpage {
  position: fixed;
  bottom: 0px;
  left: 0px;
  padding: 8px;
  width: 100%;
  background: white;
}

.recipe_ingredients_list .card-content .icon {
  z-index: -5;
}

.movesection {
  z-index: -6;
}

.ingredient_list_item {
  z-index: -7;
}

.searchItem {
  padding: 16px;
  border-bottom: 1px solid #e2e2e2;
}

.add-ingredient-fab {
  position: absolute !important;
}
</style>