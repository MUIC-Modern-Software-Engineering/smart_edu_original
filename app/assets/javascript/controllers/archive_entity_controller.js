window.confirmArchive = function(entityId, entityName, basePath) {
    if (!entityId || !basePath) {
        console.error("Error: Missing entityId or basePath in confirmArchive");
        return;
    }

    if (!entityName) {
        console.error("Error: entityName is undefined in confirmArchive");
        return;
    }

    console.log(`Opening archive modal for ${entityName} (Path: ${basePath}/${entityId})`);

    document.getElementById("archiveEntityEmail").innerText = entityName;
    document.getElementById("archiveForm").action = `${basePath}/${entityId}`;
    document.getElementById("archiveModal").style.display = "flex";

    window.closeArchiveModal = function() {
        document.getElementById("archiveModal").style.display = "none";
    }
};
