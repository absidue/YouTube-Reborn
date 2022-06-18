const callback = function() {
    chrome.storage.sync.get({
        // Video Options
        enablePictureInPictureButtonOption: true,
        disableAutoPlayOption: false,
        disableCaptionsOption: false,
        // NavBar Options
        hideVoiceSearchButtonOption: false,
        hideCountrySymbolNextToLogoOption: false,
        // Overlay Options
        hideAutoPlaySwitchOption: false,
        hideCaptionsButtonOption: false,
        hideInfoCardButtonOption: false,
        hideMiniplayerButtonOption: false,
        hideTheaterModeButtonOption: false,
        hidePreviousButtonOption: false,
        hideNextButtonOption: false
    }, function(items) {
        // Video Options

        // Enable Picture In Picture Button
        if (items.enablePictureInPictureButtonOption == true) {
            $(".ytp-pip-button").removeAttr("style");
        }
        // Disable AutoPlay
        if (items.disableAutoPlayOption == true) {
            if ($(".ytp-autonav-toggle-button").attr("aria-checked") === "true") {
                $(".ytp-button[data-tooltip-target-id='ytp-autonav-toggle-button']").click();
            }
        }
        // Disable Captions
        if (items.disableCaptionsOption == true) {
            $(".ytp-subtitles-button[aria-pressed='true']").click();
        }

        // NavBar Options

        // Hide Voice Search Button
        if (items.hideVoiceSearchButtonOption == true) {
            $("#voice-search-button").remove();
        }
        // Hide Country Symbol Next To Logo
        if (items.hideCountrySymbolNextToLogoOption == true) {
            $("#country-code").remove();
        }

        // Overlay Options

        // Hide AutoPlay Switch
        if (items.hideAutoPlaySwitchOption == true) {
            $(".ytp-button[data-tooltip-target-id='ytp-autonav-toggle-button']").remove();
        }
        // Hide Captions Button
        if (items.hideCaptionsButtonOption == true) {
            $(".ytp-subtitles-button").remove();
        }
        // Hide InfoCard Button
        if (items.hideInfoCardButtonOption == true) {
            $(".ytp-cards-button-icon").remove();
        }
        // Hide Miniplayer Button
        if (items.hideMiniplayerButtonOption == true) {
            $(".ytp-miniplayer-button").remove();
        }
        // Hide Theather Mode Button
        if (items.hideTheaterModeButtonOption == true) {
            $(".ytp-size-button").remove();
        }
        // Hide Previous Button
        if (items.hidePreviousButtonOption == true) {
            $(".ytp-prev-button").remove();
        }
        // Hide Next Button
        if (items.hideNextButtonOption == true) {
            $(".ytp-next-button").remove();
        }
    });
}

new MutationObserver(callback).observe(document.body, {childList: true, subtree: true });