document.addEventListener("DOMContentLoaded", function () {
    window.confirmDelete = function(entityId, entityEmail, basePath) {
        if (!entityId || !basePath) {
            console.error("Error: Missing entityId or basePath in confirmDelete");
            return;
        }

        console.log(`Opening delete modal for ${entityEmail} (Path: ${basePath}/${entityId})`);

        document.getElementById("deleteEntityEmail").innerText = entityEmail;
        document.getElementById("deleteForm").action = `${basePath}/${entityId}`;
        document.getElementById("deleteModal").style.display = "flex";
    };

    window.closeModal = function() {
        document.getElementById("deleteModal").style.display = "none";
    };
});
