chrome.storage.sync.get({
    enablePictureInPictureButtonOption: true,
    hideVoiceSearchButtonOption: false,
    hideAutoPlaySwitchOption: false,
    hideCaptionsButtonOption: false,
    hideInfoCardButtonOption: false,
    hideMiniplayerButtonOption: false,
    hideTheaterModeButtonOption: false
}, function(items) {
    if (items.enablePictureInPictureButtonOption == true) {
        $(".ytp-pip-button").removeAttr("style");
    }
    if (items.hideVoiceSearchButtonOption == true) {
        $("#voice-search-button").remove();
    }
    if (items.hideAutoPlaySwitchOption == true) {
        $(".ytp-autonav-toggle-button-container").remove();
        $("[data-tooltip-target-id='ytp-autonav-toggle-button']").remove();
    }
    if (items.hideCaptionsButtonOption == true) {
        $(".ytp-subtitles-button").remove();
    }
    if (items.hideInfoCardButtonOption == true) {
        $(".ytp-cards-button-icon").remove();
    }
    if (items.hideMiniplayerButtonOption == true) {
        $(".ytp-miniplayer-button").remove();
    }
    if (items.hideTheaterModeButtonOption == true) {
        $(".ytp-size-button").remove();
    }
});