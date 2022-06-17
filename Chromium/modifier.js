chrome.storage.sync.get({
    hideVoiceSearchButtonOption: false,
    hideAutoPlaySwitchOption: false,
    hideCaptionsButtonOption: false,
    hideInfoCardButtonOption: false
}, function(items) {
    if (items.hideVoiceSearchButtonOption == true) {
        $("#voice-search-button").remove();
    }
    if (items.hideAutoPlaySwitchOption == true) {
        $(".ytp-autonav-toggle-button-container").remove();
    }
    if (items.hideCaptionsButtonOption == true) {
        $(".ytp-subtitles-button").remove();
    }
    if (items.hideInfoCardButtonOption == true) {
        $(".ytp-cards-button-icon").remove();
    }
});