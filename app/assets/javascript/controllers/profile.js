document.addEventListener("DOMContentLoaded", function () {
    const editPasswordButton = document.getElementById("edit-password");
    const passwordModal = document.getElementById("password-modal");
    const closeModalButton = document.getElementById("close-modal");
    const toggleNewPassword = document.getElementById("toggle-new-password");
    const toggleConfirmPassword = document.getElementById("toggle-confirm-password");
    const newPassword = document.getElementById("new-password");
    const confirmPassword = document.getElementById("confirm-password");

    function togglePasswordVisibility(button, input) {
        if (input.type === "password") {
            input.type = "text";
            button.innerHTML = '<i class="fas fa-eye-slash"></i>';
        } else {
            input.type = "password";
            button.innerHTML = '<i class="fas fa-eye"></i>';
        }
    }

    // Add event listeners
    if (toggleNewPassword) {
        toggleNewPassword.addEventListener("click", function () {
            togglePasswordVisibility(toggleNewPassword, newPassword);
        });
    }

    if (toggleConfirmPassword) {
        toggleConfirmPassword.addEventListener("click", function () {
            togglePasswordVisibility(toggleConfirmPassword, confirmPassword);
        });
    }
    if (editPasswordButton) {
        editPasswordButton.addEventListener("click", function () {
            passwordModal.classList.remove("hidden");
        });
    }

    if (closeModalButton) {
        closeModalButton.addEventListener("click", function () {
            passwordModal.classList.add("hidden");
        });
    }
});
