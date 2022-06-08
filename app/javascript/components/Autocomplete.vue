<script>
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
        fetch(`/ingredients/${newVal}`).then(results => results.json())
            .then(results => this.searchResults = results)
      }
    }
  }
}
</script>

<template>
  <div v-bind:class = "(isFocused)?'fullpage':''">
   <input class="input is-large" placeholder="Ingredient Name" @click="isFocused=true" v-model="searchTerm"/>

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