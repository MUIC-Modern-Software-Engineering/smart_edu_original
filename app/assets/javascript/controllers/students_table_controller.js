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
    console.log("Waiting for page to load...");

    console.log("Initializing DataTable...");

    const tableId = "#students-table";

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
    });

    console.log("DataTable initialized successfully!");

    await waitForPageLoad();
}

initializeDataTable().then(r => console.log("DataTable initialized!"));
