function addKillFeed(killerName, playerName, killerColor, playerColor) {
    const killFeedContainer = document.getElementById('killFeedContainer');
    const killFeedElement = document.createElement('div');
    killFeedElement.className = 'kill-feed';
    killFeedElement.innerHTML = `
        <span style="color: ${killerColor};">${killerName}</span>
        <div class="weapon">
            <i class="fa-solid fa-skull"></i>
        </div>
        <span style="color: ${playerColor};">${playerName}</span>
    `;
    killFeedContainer.appendChild(killFeedElement);
    setTimeout(() => {
        killFeedElement.style.opacity = '0';
        setTimeout(() => killFeedContainer.removeChild(killFeedElement), 1000);
    }, 5000);
}


window.addEventListener('message', function(event) {
    if (event.data.action === 'addKillFeed') {
            addKillFeed(event.data.killerName, event.data.playerName, event.data.killerColor, event.data.playerColor);
    }
});

console.log("killfed loaded js")