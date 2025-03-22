document.addEventListener("DOMContentLoaded", function () {
    window.confirmApprove = function(userId, userEmail) {
        console.log("Opening approve modal for", userEmail);
        document.getElementById("approveUserEmail").innerText = userEmail;
        document.getElementById("approveForm").action = `/users/${userId}/approve`; // Set form action dynamically
        document.getElementById("approveModal").style.display = "flex";
    };

    window.closeApproveModal = function() {
        document.getElementById("approveModal").style.display = "none";
    };
});
