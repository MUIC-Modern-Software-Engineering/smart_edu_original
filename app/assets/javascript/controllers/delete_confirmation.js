document.addEventListener("DOMContentLoaded", function () {
    document.querySelectorAll(".delete-student-btn").forEach(button => {
        button.addEventListener("click", function (event) {
            event.preventDefault(); // Stop the form from submitting immediately

            let studentName = this.dataset.studentName;
            let confirmation = confirm(`Are you sure you want to delete ${studentName}?`);

            if (confirmation) {
                this.closest("form").submit(); // Submit the delete form
            }
        });
    });
});
