import { Controller } from "@hotwired/stimulus";

// Connects to data-controller="submit"
export default class extends Controller {
  submit(event) {
    clearTimeout(this.timeout);
    this.timeout = setTimeout(() => {
      this.element.requestSubmit();
    }, 300); // Debounce input to avoid excessive requests
  }
}
