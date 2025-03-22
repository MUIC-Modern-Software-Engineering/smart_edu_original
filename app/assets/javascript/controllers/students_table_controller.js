document.addEventListener("DOMContentLoaded", function () {
    let gradeDropdown = document.getElementById("grade");

    gradeDropdown.addEventListener("change", function () {
        document.getElementById("gradeFilterForm").submit(); // Auto-submit form
    });
});

async function waitForPageLoad() {
    return new Promise((resolve) => {
        if (document.readyState === "complete") {
            resolve();
        } else {
            window.addEventListener("load", resolve);
        }
    });
}

async function initializeDataTable() {
    console.log("Initializing DataTable...");

    const tableId = "#shared-table";

    // Destroy DataTable if it already exists
    if ($.fn.DataTable.isDataTable(tableId)) {
        $(tableId).DataTable().destroy();
    }

    // Initialize DataTable
    $(tableId).DataTable({
        responsive: true,
        pageLength: 10,
        language: {
            search: "",
            searchPlaceholder: "Search students...",
        },
        initComplete: function () {
            styleDataTableElements();
        },
        drawCallback: function () {
            styleDataTableElements(); // Apply styles every time the page updates
        }
    });

    console.log("DataTable initialized successfully!");

    await waitForPageLoad();
}

// Function to apply consistent styling
function styleDataTableElements() {
    // Style search input
    $("div.dt-container .dt-search input").css({
        "border": "1px solid #aaa",
        "border-radius": "10px",
        "padding": "5px",
        "background-color": "transparent",
        "color": "inherit",
        "margin-left": "3px",
        "width": "400px",
    });

    // Style select dropdown
    $("div.dt-container select.dt-input").css({
        "border": "1px solid #aaa",
        "border-radius": "10px",
        "padding": "5px",
        "background-color": "transparent",
        "color": "inherit",
    });

    // Style pagination buttons consistently
    $("div.dt-container .dt-paging-button").css({
        "border": "1px solid #aaa",
        "border-radius": "10px",
        "padding": "10px",
        "background-color": "transparent",
        "color": "inherit",
    });

    // Ensure the current page button stands out
    $("div.dt-container .dt-paging-button.current").css({
        "border": "1px solid #aaa",
        "border-radius": "10px",
        "padding": "10px",
        "background-color": "transparent",
        "color": "inherit"
    });
}

initializeDataTable().then(r => console.log("DataTable initialized!"));

initializeDataTable().then(r => console.log("DataTable initialized!"));
