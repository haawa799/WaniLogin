$.get('/settings/account').done(function(data, textStatus, jqXHR) {
                       var apiKey = findKeyInData(data);
                       webkit.messageHandlers.apikey.postMessage(apiKey);
                       });
