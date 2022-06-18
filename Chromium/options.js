function save_options() {
    // Video Options
    var enablePictureInPictureButtonOption = document.getElementById('enablePictureInPictureButtonCheckBox').checked;
    var disableAutoPlayOption = document.getElementById('disableAutoPlayCheckBox').checked;
    var disableCaptionsOption = document.getElementById('disableCaptionsCheckBox').checked;
    // NavBar Options
    var hideVoiceSearchButtonOption = document.getElementById('hideVoiceSearchButtonCheckBox').checked;
    var hideCountrySymbolNextToLogoOption = document.getElementById('hideCountrySymbolNextToLogoCheckBox').checked;
    // Overlay Options
    var hideAutoPlaySwitchOption = document.getElementById('hideAutoPlaySwitchCheckBox').checked;
    var hideCaptionsButtonOption = document.getElementById('hideCaptionsButtonCheckBox').checked;
    var hideInfoCardButtonOption = document.getElementById('hideInfoCardButtonCheckBox').checked;
    var hideMiniplayerButtonOption = document.getElementById('hideMiniplayerButtonCheckBox').checked;
    var hideTheaterModeButtonOption = document.getElementById('hideTheaterModeButtonCheckBox').checked;
    var hidePreviousButtonOption = document.getElementById('hidePreviousButtonCheckBox').checked;
    var hideNextButtonOption = document.getElementById('hideNextButtonCheckBox').checked;
    chrome.storage.sync.set({
        // Video Options
        enablePictureInPictureButtonOption: enablePictureInPictureButtonOption,
        disableAutoPlayOption: disableAutoPlayOption,
        disableCaptionsOption: disableCaptionsOption,
        // NavBar Options
        hideVoiceSearchButtonOption: hideVoiceSearchButtonOption,
        hideCountrySymbolNextToLogoOption: hideCountrySymbolNextToLogoOption,
        // Overlay Options
        hideAutoPlaySwitchOption: hideAutoPlaySwitchOption,
        hideCaptionsButtonOption: hideCaptionsButtonOption,
        hideInfoCardButtonOption: hideInfoCardButtonOption,
        hideMiniplayerButtonOption: hideMiniplayerButtonOption,
        hideTheaterModeButtonOption: hideTheaterModeButtonOption,
        hidePreviousButtonOption: hidePreviousButtonOption,
        hideNextButtonOption: hideNextButtonOption
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