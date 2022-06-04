// Configure your import map in config/importmap.rb. Read more: https://github.com/rails/importmap-rails
import "@hotwired/turbo-rails"
import {Sortable} from '@shopify/draggable';

document.addEventListener('DOMContentLoaded', () => {
    const containerSelectorMirror = '.StackedListMirror';
    const containerSelector = '.StackedList';
    const containers = document.querySelectorAll(containerSelector);

    if (containers.length === 0) {
        return false;
    }

    const sortable = new Sortable(containers, {
        draggable: '.StackedListItem--isDraggable',
        mirror: {
            appendTo: containerSelectorMirror,
            constrainDimensions: true,
        },
    });

    sortable.on('sortable:sorted', (ev) => {
        console.log([].slice.call(sortable.containers[0].children));
        console.log([].slice.call(sortable.containers[0].children).map(x => x.dataset["id"]));
    })

    return sortable;
});