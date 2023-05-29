// src/controllers/clipboard_controller.js
import { Controller } from "@hotwired/stimulus"


function getCookie(cname) {
    let name = cname + "=";
    let decodedCookie = decodeURIComponent(document.cookie);
    let ca = decodedCookie.split(';');
    for(let i = 0; i <ca.length; i++) {
        let c = ca[i];
        while (c.charAt(0) == ' ') {
            c = c.substring(1);
        }
        if (c.indexOf(name) == 0) {
            return c.substring(name.length, c.length);
        }
    }
    return null;
}

export default class extends Controller {

    static targets = [ "searchbox", "tagsCheckboxes", "sourceCheckboxes" ]

    isVisible = false;

    tags = [];

    sources = [];

    copy() {
    }

    connect() {
        this.searchboxTarget.style.display = "none";

        let tagsCookie = getCookie("tags");
        if (tagsCookie != null) {
            this.tags = JSON.parse(tagsCookie);
            for (let i = 0; i < this.tags.length; i++) {
                let thisTag = this.tags[i];
                const cbTarget = this.tagsCheckboxesTargets.find(t => { return t.name === `tags[${thisTag}]` });
                cbTarget.checked = true;
            }
        }

        let sourcesCookie = getCookie("sources");
        if (sourcesCookie != null) {
            this.sources = JSON.parse(sourcesCookie);
            for (let i = 0; i < this.sources.length; i++) {
                let thisSource = this.sources[i];
                const cbTarget = this.sourceCheckboxesTargets.find(t => { return t.name === `source[${thisSource}]` });
                cbTarget.checked = true;
            }
        }
    }

    toggle() {
        this.isVisible = !this.isVisible;
        if (this.isVisible) {
            this.searchboxTarget.style.display = "block";
        } else {
            this.searchboxTarget.style.display = "none";
        }
    }

    tag_change(event) {
        const isChecked = event.target.checked;
        const tagName = event.params.tag;
        if (!isChecked) this.tags.splice(this.tags.indexOf(tagName));
        else this.tags.push(tagName);

        document.cookie = "tags=" + JSON.stringify(this.tags);
    }

    source_change(event) {
        const isChecked = event.target.checked;
        const sourceName = event.params.source;

        if (!isChecked) this.sources.splice(this.sources.indexOf(sourceName));
        else this.sources.push(sourceName);

        document.cookie = "sources=" + JSON.stringify(this.sources);
    }
}