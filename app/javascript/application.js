// Configure your import map in config/importmap.rb. Read more: https://github.com/rails/importmap-rails
import "@hotwired/turbo-rails"
import "../../public/controllers/index"
import "./add_ingredient"
import "./shopping_list"
import * as bulmaToast from 'bulma-toast'
window.bulmaToast = bulmaToast;

const wireUpHamburgerMenu = () => {
    // Get all "navbar-burger" elements
    const $navbarBurgers = Array.prototype.slice.call(document.querySelectorAll('.navbar-burger'), 0);

    // Add a click event on each of them
    $navbarBurgers.forEach(el => {
        el.addEventListener('click', () => {
            // Get the target from the "data-target" attribute
            const target = el.dataset.target;
            const $target = document.getElementById(target);

            // Toggle the "is-active" class on both the "navbar-burger" and the "navbar-menu"
            el.classList.toggle('is-active');
            $target.classList.toggle('is-active');

        });
    });
}

const pageStartController = () => {
    wireUpHamburgerMenu();
}

document.addEventListener("turbo:load", pageStartController)