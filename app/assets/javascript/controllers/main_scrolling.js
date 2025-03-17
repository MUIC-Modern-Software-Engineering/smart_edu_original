document.addEventListener("DOMContentLoaded", function () {

    const getStartedLink = document.querySelector('a[href="#tier-section"]');
    if (getStartedLink) {
        getStartedLink.addEventListener("click", function (event) {
            event.preventDefault();
            const tierSection = document.querySelector("#tier-section");
            tierSection.scrollIntoView({behavior: "smooth"});
        });
    }
});
