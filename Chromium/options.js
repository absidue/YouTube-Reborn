function save_options() {
    // NavBar Options
    var hideVoiceSearchButtonOption = document.getElementById('hideVoiceSearchButtonCheckBox').checked;
    // Overlay Options
    var hideAutoPlaySwitchOption = document.getElementById('hideAutoPlaySwitchCheckBox').checked;
    var hideInfoCardButtonOption = document.getElementById('hideInfoCardButtonCheckBox').checked;
    chrome.storage.sync.set({
        hideVoiceSearchButtonOption: hideVoiceSearchButtonOption,
        hideAutoPlaySwitchOption: hideAutoPlaySwitchOption,
        hideInfoCardButtonOption: hideInfoCardButtonOption
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
        hideVoiceSearchButtonOption: false,
        hideAutoPlaySwitchOption: false,
        hideInfoCardButtonOption: false
    }, function(items) {
        document.getElementById('hideVoiceSearchButtonCheckBox').checked = items.hideVoiceSearchButtonOption;
        document.getElementById('hideAutoPlaySwitchCheckBox').checked = items.hideAutoPlaySwitchOption;
        document.getElementById('hideInfoCardButtonCheckBox').checked = items.hideInfoCardButtonOption;
    });
}
  
document.addEventListener('DOMContentLoaded', restore_options);
document.getElementById('save').addEventListener('click', save_options);