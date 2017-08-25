function findKeyInData(data)  {
    var apiKey = $(data).find('#user_api_key').attr('value');
    if (apiKey == '') {
        setTimeout(function() {
                   $("button[name='commit']")[2].click();
                   }, 1000);
    }
    return apiKey;
}

function findKey()  {
    var apiKey = $('#user_api_key').attr('value');
    if (apiKey == '') {
        setTimeout(function() {
                   $("button[name='commit']")[2].click();
                   }, 1000);
    }
    return apiKey;
}

function openSettings() {
    window.location.href = '/settings/account';
}

function generateNewKey() {
    setTimeout(function() {
               $("button[name='commit']").click();
               }, 1000);
}

function registerToGrabCredentials() {
    
    var submitButton = document.getElementsByClassName('button')[0];
    
    if(submitButton.type == 'submit') {
        
        submitButton.onclick = function(e) {
            
            var usr = document.getElementById('user_login').value;
            var psw = document.getElementById('user_password').value;
            var rememberMe = document.getElementById('user_remember_me');
            rememberMe.checked = true;
            
            window.webkit.messageHandlers.username.postMessage(usr)
            window.webkit.messageHandlers.password.postMessage(psw)
        };
    }
}

function loginIfNeeded(usr, psw) {
    
    var invalid = checkIfInvalidCredentials();
    if (invalid == true) {
        return;
    }
    
    var usrField = document.getElementById('user_login');
    var pswField = document.getElementById('user_password');
    var rememberMe = document.getElementById('user_remember_me');
    
    if (usrField != null, pswField != null, rememberMe != null) {
        rememberMe.checked = false;
        usrField.value = usr;
        pswField.value = psw;
        
        var submitButton = document.getElementsByClassName('button')[0];
        submitButton.click();
    }
}

function checkIfInvalidCredentials() {
    if($("*:contains('Invalid')").length > 0) {
        webkit.messageHandlers.invalidCredentials.postMessage('invalidCredentials');
        return true;
    }
    return false;
}
