const options = ["PLAY", "LEAVE"];
let currentIndex = 0;

const clickSound = new Audio("/dist/files/assets/click.mp3");
const joinSound = new Audio("/dist/files/assets/join.mp3");

function changeOption(direction) {
    clickSound.play();
    if (direction === "left") {
        currentIndex = (currentIndex === 0) ? options.length - 1 : currentIndex - 1;
    } else {
        currentIndex = (currentIndex === options.length - 1) ? 0 : currentIndex + 1;
    }
    document.getElementById("option-text").textContent = options[currentIndex];
}

function executeAction() {
    joinSound.play();
  
    if (options[currentIndex] == "PLAY") { 
        hideStartMenu()

        fetch(`https://${GetParentResourceName()}/StartMenuPlay`, {
            method: "POST",
            headers: {
                "Content-Type": "application/json"
            },
            body: JSON.stringify({})
        });
    } else if (options[currentIndex] == "LEAVE") {
        fetch(`https://${GetParentResourceName()}/StartMenuLeave`, {
            method: "POST",
            headers: {
                "Content-Type": "application/json"
            },
            body: JSON.stringify({})
        });
    } else {
        console.log("error critico");
    }


}

function hideStartMenu() {
    let menu = document.querySelector(".container-start-menu"); 
    menu.style.display = "none";
}