// include in main file!

//const fs = require('fs');
//const https = require('https');
//const path = require('path');

function sendSlackAlert({
    message,
    webhookUrl,
    pluginName,
    bufferEnabled = true,
    cooldownMinutes = 60
}) {
    return new Promise((resolve) => {
        if (!webhookUrl || typeof webhookUrl !== 'string' || !webhookUrl.startsWith('https://')) {
            console.error('[' + pluginName + '] Keine gültige Slack Webhook URL übergeben.');
            return resolve();
        }

        const now = Date.now();
        const currentTimeString = new Date().toISOString().substring(11, 19);
        const sanitizedPluginName = pluginName.toLowerCase().replace(/[^a-z0-9_-]/g, '_');
        const bufferFile = path.join('/tmp', 'slack_buffer_' + sanitizedPluginName + '.json');

        let bufferData = { lastAlert: 0, messages: [] };

        if (fs.existsSync(bufferFile)) {
            try {
                bufferData = JSON.parse(fs.readFileSync(bufferFile, 'utf8'));
                if (!Array.isArray(bufferData.messages)) bufferData.messages = [];
            } catch (e) {
                console.error('[' + pluginName + '] Fehler beim Lesen der Cooldown-Datei: ' + e.message);
            }
        }

        const cooldownMs = cooldownMinutes * 60 * 1000;
        const timeSinceLastAlert = now - (bufferData.lastAlert || 0);
        const isCooldownActive = cooldownMinutes > 0 && bufferData.lastAlert > 0 && timeSinceLastAlert < cooldownMs;

        // Buffer deactivated?
        if (!bufferEnabled) {
            // if cooldown active --> no message
            if (isCooldownActive) {
                console.error('[' + pluginName + '] Nachricht verworfen (Puffer aus, Cooldown aktiv).');
                return resolve();
            }
            // if no cooldown -> prepare message
            console.error('[' + pluginName + '] Puffer deaktiviert. Sende Direkt-Alert...');
            payloadText = '*' + pluginName + ' Fehler-Report (Sofortbenachrichtigung):*\n```\n[' + currentTimeString + '] ' + message + '\n```';
        } 
        
        // Buffer activated?
        else {
            if (!bufferData.lastAlert) {
                bufferData.lastAlert = now;
            }

            // create new message for buffer
            if (message) {
                bufferData.messages.push({
                    time: currentTimeString,
                    text: message
                });
            }

            // max 50 messages for buffer
            if (bufferData.messages.length > 50) {
                bufferData.messages = bufferData.messages.slice(-50);
            }

            // if buffer active AND cooldown: add message to buffer and resolve
            if (isCooldownActive) {
                try {
                    fs.writeFileSync(bufferFile, JSON.stringify(bufferData, null, 2));
                    console.error('[' + pluginName + '] Nachricht gepuffert (' + bufferData.messages.length + ' im Puffer, Cooldown aktiv).');
                } catch (e) {
                    console.error('[' + pluginName + '] Fehler beim Schreiben des Puffers: ' + e.message);
                }
                return resolve();
            }

            if (bufferData.messages.length === 0) {
                return resolve();
            }

            const totalMessages = bufferData.messages.length;
            const eventWord = totalMessages > 1 ? 'se' : '';
            payloadText = '*' + pluginName + ' Fehler-Report (' + totalMessages + ' Ereignis' + eventWord + '):*\n```';
            bufferData.messages.forEach(item => {
                payloadText += '\n[' + item.time + '] ' + item.text;
            });
            payloadText += '\n```';
        }

        // char-limitation for slack messages
        if (payloadText.length > 3500) {
            payloadText = payloadText.substring(0, 3400) + '\n... [Nachricht gekürzt, zu lang für Slack. Bitte Logs prüfen.]```';
        }

        const payload = JSON.stringify({ text: payloadText });

        try {
            const urlObj = new URL(webhookUrl);
            const options = {
                hostname: urlObj.hostname,
                path: urlObj.pathname + urlObj.search,
                method: 'POST',
                headers: {
                    'Content-Type': 'application/json',
                    'Content-Length': Buffer.byteLength(payload)
                },
                timeout: 5000
            };

            const req = https.request(options, (res) => {
                let body = '';
                res.on('data', chunk => body += chunk);
                res.on('end', () => {
                    if (res.statusCode === 200) {
                        console.error('[' + pluginName + '] Slack-Alert erfolgreich gesendet!');
                        try {
                            // reset buffer
                            fs.writeFileSync(bufferFile, JSON.stringify({ lastAlert: now, messages: [] }));
                        } catch (e) {
                            console.error('[' + pluginName + '] Fehler beim Aktualisieren der Status-Datei: ' + e.message);
                        }
                    } else {
                        console.error('[' + pluginName + '] Slack Webhook HTTP-Fehler: ' + res.statusCode + ', Body: ' + body);
                    }
                    resolve();
                });
            });

            req.on('error', (err) => {
                console.error('[' + pluginName + '] Fehler beim Senden des Slack Webhooks: ' + err.message);
                resolve();
            });

            req.on('timeout', () => {
                req.destroy();
                console.error('[' + pluginName + '] Slack Webhook Timeout nach 5s');
                resolve();
            });

            req.write(payload);
            req.end();

        } catch (err) {
            console.error('[' + pluginName + '] Ungültige Slack Webhook URL: ' + err.message);
            resolve();
        }
    });
}

module.exports = { sendSlackAlert };