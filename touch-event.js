(function () {
    const appNode = document.getElementById('elm-app');
    const app = appNode && appNode.elmApp;

    // Touchstart listener
    document.addEventListener("touchstart", (event) => {
        const touchCount = event.touches.length;
        if (app && app.ports && app.ports.touchStart) {
            app.ports.touchStart.send(touchCount);
        }
    });

    // Touchend listener
    document.addEventListener("touchend", () => {
        if (app && app.ports && app.ports.touchEnd) {
            app.ports.touchEnd.send(null);
        }
    });
})();
