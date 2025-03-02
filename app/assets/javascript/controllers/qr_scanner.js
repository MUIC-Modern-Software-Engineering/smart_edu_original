document.addEventListener("DOMContentLoaded", function () {
  let scanner = new Instascan.Scanner({ video: document.getElementById("preview") });
  let activeCamera = null;
  let scanning = true;

  scanner.addListener("scan", function (content) {
    if (!scanning) return;
    scanning = false;

    console.log("Scanned content:", content);

    let parts = content.split(",");
    if (parts.length !== 2) {
      alert("Invalid QR code! Please scan a valid check-in code.");
      return resumeScanning();
    }

    let [uid, hash] = parts.map(part => part.trim());
    if (!uid || !hash) {
      alert("Invalid QR code! Missing required data.");
      return resumeScanning();
    }

    fetch("/admin/checkin", {
      method: "POST",
      headers: {
        "Content-Type": "application/json",
        "X-CSRF-Token": document.querySelector('meta[name="csrf-token"]').content,
      },
      body: JSON.stringify({ uid: uid, hash: hash })
    })
    .then(response => response.json())
    .then(data => {
      alert(data.message || "Check-in failed!");
      resumeScanning();
    })
    .catch(error => {
      console.error("Error:", error);
      alert("Error processing QR code. Please try again.");
      resumeScanning();
    });
  });

  // Get available cameras and start the scanner with the first available one
  Instascan.Camera.getCameras()
    .then(function (cameras) {
      if (cameras.length > 0) {
        activeCamera = cameras[0];
        scanner.start(activeCamera);
      } else {
        console.error("No cameras found.");
      }
    })
    .catch(function (e) {
      console.error(e);
    });

  function resumeScanning() {
    setTimeout(() => {
      scanning = true;
    }, 1000); // Small delay to prevent duplicate scans
  }

  // Stop the camera when navigating away
  function stopScanner() {
    if (scanner) {
      scanner.stop();
    }
    if (activeCamera && activeCamera.stream) {
      activeCamera.stream.getTracks().forEach(track => track.stop());
    }
  }

  window.addEventListener("beforeunload", stopScanner);
  window.addEventListener("pagehide", stopScanner);
});
