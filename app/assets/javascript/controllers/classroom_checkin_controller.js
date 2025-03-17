document.addEventListener("DOMContentLoaded", async function () {
    for (const button of document.querySelectorAll(".check-in-btn")) {
        let studentId = button.dataset.studentId;

        let { checked_in, authorized } = await fetchCheckInStatus(studentId);
        button.dataset.checkedIn = checked_in ? "true" : "false";
        updateButtonStyle(button);

        if (!authorized) {
            button.disabled = true; // Disable the button
            button.style.pointerEvents = "none"; // Prevent clicks entirely
            button.style.opacity = "1";
            continue;
        }

        button.addEventListener("click", async function (event) {
            event.preventDefault();

            if (button.disabled) return; // Double check before executing

            try {
                let response = await fetch(window.attendancesPath, {
                    method: "POST",
                    headers: {
                        "X-CSRF-Token": document.querySelector("meta[name='csrf-token']").content,
                        "Content-Type": "application/json"
                    },
                    body: JSON.stringify({ student_id: studentId })
                });

                let result = await response.json();
                if (response.ok && result.status === "success") {
                    button.dataset.checkedIn = button.dataset.checkedIn === "true" ? "false" : "true";
                    window.location.reload();
                } else {
                    console.error("Check-in failed:", result);
                }
            } catch (error) {
                console.error("Check-in request error:", error);
            }
        });
    }
});

// Function to fetch both check-in status and authorization
async function fetchCheckInStatus(studentId) {
    try {
        let response = await fetch(`/attendances/${studentId}/status`);
        let result = await response.json();
        return { checked_in: result.checked_in, authorized: result.authorized };
    } catch (error) {
        console.error("Error checking check-in status:", error);
        return { checked_in: false, authorized: false };
    }
}

// Function to update button style dynamically
function updateButtonStyle(button) {
    let isCheckedIn = button.dataset.checkedIn === "true";
    button.classList.toggle("checked-in", isCheckedIn);
    button.style.backgroundColor = isCheckedIn ? "lightgreen" : "lightgray";
    button.textContent = isCheckedIn ? "Checked In" : "Check-In";
}
