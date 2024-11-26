(function () {
    const appNode = document.getElementById('elm-app');
    const sendToElm = (eventName, data) => {
        if (appNode && appNode.elmApp) {
            appNode.elmApp.ports[eventReceiver].send({ eventName, data });
        }
    };

    // Touchstart listener
    document.addEventListener("touchstart", (event) => {
        const touchCount = event.touches.length;
        sendToElm("touchstart", touchCount);
    });

    // Touchend listener
    document.addEventListener("touchend", () => {
        sendToElm("touchend", 0);
    });
})();
