chrome.storage.sync.get({
    hideVoiceSearchButtonOption: false,
    hideAutoPlaySwitchOption: false,
    hideInfoCardButtonOption: false
}, function(items) {
    if (items.hideVoiceSearchButtonOption == true) {
        $("#voice-search-button").remove();
    }
    if (items.hideAutoPlaySwitchOption == true) {
        $(".ytp-autonav-toggle-button-container").remove();
    }
    if (items.hideInfoCardButtonOption == true) {
        $(".ytp-cards-button-icon").remove();
    }
});

// document.addEventListener("DOMContentLoaded", run);