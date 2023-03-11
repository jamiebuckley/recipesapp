<template>
  <div class="container p-2">

    <div class="shopping-list-area">
      <div v-for="group in shopping_list_items.groups">
        <div class="has-text-weight-bold is-size-4 mb-2">{{ group.name }}</div>
        <div class="box mb-2" v-for="item in group.items">
          <div class="columns is-mobile">
            <div class="column is-3 handle">
                <span class="icon is-large item-move-arrows">
                  <i class="fas fa-arrows"></i>
                </span>
            </div>
            <div class="column" :class="{ strikethrough: item.checked }">
              <div>
                <p class="title is-size-5">
                  {{ item.name }}
                </p>
                <p class="subtitle">
                  {{ item.quantity }}
                </p>
              </div>
            </div>
            <div class="column is-one-quarter">
              <button class="button is-fullwidth" @click="item.checked = !item.checked" :class="{ 'is-success': item.checked }">
                <span class="icon" v-if="!item.checked">
                  <i class="far fa-circle"></i>
                </span>
                <span class="icon" v-if="item.checked">
                  <i class="far fa-check-circle"></i>
                </span>
              </button>
            </div>
          </div>
        </div>
      </div>
    </div>
    <div class="bottom-editor">
      <div class="field">
        <label class="label">Add item</label>
        <div class="control">
          <div class="select is-fullwidth">
            <select v-model="newItemCategory">
              <option v-for="category in categories" v-bind:value="category">{{category}}</option>
            </select>
          </div>
        </div>
      </div>

      <div class="field has-addons">
        <div class="control is-expanded">
          <input class="input" type="text" placeholder="Add item" v-model="newItemName">
        </div>
        <div class="control">
          <a class="button is-success" @click="addNewItem">
            Add
          </a>
        </div>
      </div>
    </div>
  </div>
</template>

<script>
export default {
  data() {
    return {
      shopping_list_items: {},
      newItemName: "",
      newItemCategory: "Ungrouped",
      categories: ["Ungrouped"]
    }
  },
  methods: {
    addNewItem() {
      const group = this.shopping_list_items.groups.find(g => g.name === this.newItemCategory);

      const csrfToken = document.querySelector("[name='csrf-token']").content
      fetch("/shopping_list_additional_items",
          {
            method: "post",
            headers: {
              "X-CSRF-Token": csrfToken,
              "Content-Type": "application/json"
            },
            body: JSON.stringify({
              name: this.newItemName,
              category: this.newItemCategory
            })
          })
      .then(response => response.json())
      .then(data => {
        group.items.push({
          id: data.id,
          name: data.name,
          checked: false
        })
        this.newItemName = "";
      });
    }
  },
  created() {
    const options = {
      headers: {"Content-Type": "application/json"}
    };

    fetch("/shopping_lists.json", options)
        .then(response => response.json())
        .then(data => {
          this.shopping_list_items = data;
          this.categories = data.groups.map(g => g.name)
          if (this.categories.indexOf("Ungrouped") === -1) this.categories.push("Ungrouped");
        });
  }
}
</script>

<style>
.strikethrough {
  text-decoration: line-through;
  opacity: 0.8;
}

.shopping-list-area {
  overflow-y: scroll;
  margin-bottom: 132px;
}

.bottom-editor {
  position:fixed;
  bottom: 0px;
  width: 96%;
  background: white;
  padding-bottom: 8px;
}
</style>