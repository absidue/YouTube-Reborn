function save_options() {
    // Video Options
    var enablePictureInPictureButtonOption = document.getElementById('enablePictureInPictureButtonCheckBox').checked;
    // NavBar Options
    var hideVoiceSearchButtonOption = document.getElementById('hideVoiceSearchButtonCheckBox').checked;
    // Overlay Options
    var hideAutoPlaySwitchOption = document.getElementById('hideAutoPlaySwitchCheckBox').checked;
    var hideCaptionsButtonOption = document.getElementById('hideCaptionsButtonCheckBox').checked;
    var hideInfoCardButtonOption = document.getElementById('hideInfoCardButtonCheckBox').checked;
    var hideMiniplayerButtonOption = document.getElementById('hideMiniplayerButtonCheckBox').checked;
    var hideTheaterModeButtonOption = document.getElementById('hideTheaterModeButtonCheckBox').checked;
    chrome.storage.sync.set({
        enablePictureInPictureButtonOption: enablePictureInPictureButtonOption,
        hideVoiceSearchButtonOption: hideVoiceSearchButtonOption,
        hideAutoPlaySwitchOption: hideAutoPlaySwitchOption,
        hideCaptionsButtonOption: hideCaptionsButtonOption,
        hideInfoCardButtonOption: hideInfoCardButtonOption,
        hideMiniplayerButtonOption: hideMiniplayerButtonOption,
        hideTheaterModeButtonOption: hideTheaterModeButtonOption
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
        enablePictureInPictureButtonOption: true,
        hideVoiceSearchButtonOption: false,
        hideAutoPlaySwitchOption: false,
        hideCaptionsButtonOption: false,
        hideInfoCardButtonOption: false,
        hideMiniplayerButtonOption: false,
        hideTheaterModeButtonOption: false
    }, function(items) {
        document.getElementById('enablePictureInPictureButtonCheckBox').checked = items.enablePictureInPictureButtonOption;
        document.getElementById('hideVoiceSearchButtonCheckBox').checked = items.hideVoiceSearchButtonOption;
        document.getElementById('hideAutoPlaySwitchCheckBox').checked = items.hideAutoPlaySwitchOption;
        document.getElementById('hideCaptionsButtonCheckBox').checked = items.hideCaptionsButtonOption;
        document.getElementById('hideInfoCardButtonCheckBox').checked = items.hideInfoCardButtonOption;
        document.getElementById('hideMiniplayerButtonCheckBox').checked = items.hideMiniplayerButtonOption;
        document.getElementById('hideTheaterModeButtonCheckBox').checked = items.hideTheaterModeButtonOption;
    });
}
  
document.addEventListener('DOMContentLoaded', restore_options);
document.getElementById('save').addEventListener('click', save_options);