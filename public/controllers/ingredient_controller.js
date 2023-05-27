import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  connect() {
    const containerSelector = '.StackedList';
    const containers = document.querySelectorAll(containerSelector);
    if (containers.length === 0) {
      return false;
    }

    const sortable = new Sortable(containers, {
      draggable: '.StackedListItem--isDraggable',
      mirror: {
        appendTo: containerSelector,
        constrainDimensions: true,
      },
    });

    sortable.on("")
  }
}
