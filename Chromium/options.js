function save_options() {
    chrome.storage.sync.set({
        // Video Options
        enablePictureInPictureButtonOption: document.getElementById('enablePictureInPictureButtonCheckBox').checked,
        disableAutoPlayOption: document.getElementById('disableAutoPlayCheckBox').checked,
        disableCaptionsOption: document.getElementById('disableCaptionsCheckBox').checked,
        // NavBar Options
        hideVoiceSearchButtonOption: document.getElementById('hideVoiceSearchButtonCheckBox').checked,
        hideCountrySymbolNextToLogoOption: document.getElementById('hideCountrySymbolNextToLogoCheckBox').checked,
        // Overlay Options
        hideAutoPlaySwitchOption: document.getElementById('hideAutoPlaySwitchCheckBox').checked,
        hideCaptionsButtonOption: document.getElementById('hideCaptionsButtonCheckBox').checked,
        hideInfoCardButtonOption: document.getElementById('hideInfoCardButtonCheckBox').checked,
        hideMiniplayerButtonOption: document.getElementById('hideMiniplayerButtonCheckBox').checked,
        hideTheaterModeButtonOption: document.getElementById('hideTheaterModeButtonCheckBox').checked,
        hidePreviousButtonOption: document.getElementById('hidePreviousButtonCheckBox').checked,
        hideNextButtonOption: document.getElementById('hideNextButtonCheckBox').checked
    }, function() {
        var status = document.getElementById('status');
        status.textContent = 'Options Saved';
        setTimeout(function() {
            status.textContent = '';
        }, 750);
    });
}

function restore_options() {
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
        document.getElementById('enablePictureInPictureButtonCheckBox').checked = items.enablePictureInPictureButtonOption;
        document.getElementById('disableAutoPlayCheckBox').checked = items.disableAutoPlayOption;
        document.getElementById('disableCaptionsCheckBox').checked = items.disableCaptionsOption;
        // NavBar Options
        document.getElementById('hideVoiceSearchButtonCheckBox').checked = items.hideVoiceSearchButtonOption;
        document.getElementById('hideCountrySymbolNextToLogoCheckBox').checked = items.hideCountrySymbolNextToLogoOption;
        // Overlay Options
        document.getElementById('hideAutoPlaySwitchCheckBox').checked = items.hideAutoPlaySwitchOption;
        document.getElementById('hideCaptionsButtonCheckBox').checked = items.hideCaptionsButtonOption;
        document.getElementById('hideInfoCardButtonCheckBox').checked = items.hideInfoCardButtonOption;
        document.getElementById('hideMiniplayerButtonCheckBox').checked = items.hideMiniplayerButtonOption;
        document.getElementById('hideTheaterModeButtonCheckBox').checked = items.hideTheaterModeButtonOption;
        document.getElementById('hidePreviousButtonCheckBox').checked = items.hidePreviousButtonOption;
        document.getElementById('hideNextButtonCheckBox').checked = items.hideNextButtonOption;
    });
}
  
document.addEventListener('DOMContentLoaded', restore_options);
document.getElementById('save').addEventListener('click', save_options);