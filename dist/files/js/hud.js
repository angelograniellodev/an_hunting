
window.addEventListener('message', (event) => {
    if (event.data.type === 'updateHUD') {
        const barFill = document.querySelector('.bar-fill');
        if (barFill) {
            barFill.style.width = `${event.data.health}%`;
        }


        const playerId = document.querySelector('#player-id')
        if (playerId) {
            playerId.textContent = event.data.playerId;
        }
    }

    if (event.data.type === 'LogoHud') { 
        const logoElement = document.querySelector('#logo-link');
        const logoContainer = document.querySelector('.server-logo');



        if (event.data.display) {
            logoContainer.style.display = 'block';
            logoElement.src = event.data.url;

            console.log("server logo enabled, logo url:, event.data.url");
        } else {
            logoContainer.style.display = 'none';
        }
    }

});


console.log("hud.js loaded");