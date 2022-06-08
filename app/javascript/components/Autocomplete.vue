<script>
function debounce(func, timeout = 800){
  let timer;
  return (...args) => {
    clearTimeout(timer);
    timer = setTimeout(() => { func.apply(this, args); }, timeout);
  };
}

const processInput = debounce((newVal, callback) => {
  fetch(`/ingredients/${newVal}`)
      .then(results => results.json())
      .then(callback)
})

export default {
  data() {
    return {
      isFocused: false,
      searchResults: [],
      searchTerm: ''
    }
  },
  methods: {
    complete: function(ev) {
      this.isFocused = false;
      ev.preventDefault()
    },
    selected: function(data) {
      this.searchTerm = data;
      this.isFocused = false;
    }
  },
  watch: {
    searchTerm: function(newVal, oldVal) {
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
  <div v-bind:class = "(isFocused)?'fullpage':''">
   <input class="input is-large" name="recipe_ingredient[ingredient][name]" placeholder="Ingredient Name" autocomplete="off" @click="isFocused=true" :value="this.searchTerm" @input="this.searchTerm = $event.target.value"/>

    <div v-if="isFocused">
      <div v-for="ingredient in searchResults" class="searchItem is-size-3" @click="this.selected(ingredient)">
        {{ingredient}}
      </div>

      <a class="button is-floating is-primary is-large" @click="this.complete">
        <i class="fas fa-check"></i>
      </a>
    </div>
  </div>
</template>

<style>
.fullpage {
  margin-left:-6px;
  padding: 4px;
  position:fixed;
  width:100%;
  height:100%;
  top:52px;
  background:white;
  z-index:5;
}

.searchItem {
  padding: 16px;
  border-bottom: 1px solid #e2e2e2;
}
</style>