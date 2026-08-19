function sendSlackAlert(message) {
    return new Promise((resolve) => {
        const webhookUrl = info?.config?.plugin?.['custom-data-type-gnd']?.config?.slack_channel?.slack_webhook_url;

        if (!webhookUrl || !webhookUrl.startsWith('https://')) {
            console.error('Keine gültige GND-Slack Webhook URL gesetzt. GND-Slack-Alert wird nicht gesendet.');
            return resolve();
        }

        // spam protection: check if the last alert was sent less than slack_cooldown_minutes ago
        let lastAlert = 0;
        if (fs.existsSync(slack_alert_cachefile)) {
            try {
                const cache = JSON.parse(fs.readFileSync(slack_alert_cachefile, 'utf8'));
                lastAlert = cache.timestamp || 0;
            } catch (e) { }
        }

        const now = Date.now();

        console.error("slack_cooldown_minutes: " + slack_cooldown_minutes);

        if(now - lastAlert < slack_cooldown_minutes * 60 * 1000) {
            console.error('GND-Slack-Alert gedrosselt. Sende nicht den Fehler');
            return resolve();
        }

        // timestamp for the next alert is written to the cache file, even if the Slack request fails, to avoid spamming in case of repeated errors
        try {
            fs.writeFileSync(slack_alert_cachefile, JSON.stringify({ timestamp: now, lastMessage: message }));
        } catch (e) {
            console.error('Konnte Cache-Datei für GND-Slack-Alerts nicht schreiben.');
        }

        const payload = JSON.stringify({
            text: `*GND-Updater Fehler in fylr:*\n\`\`\`${message}\`\`\``
        });

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
                        console.error("Slack-Alert erfolgreich gesendet! Antwort:", body);
                    } else {
                        console.error(`Slack Webhook HTTP Fehler: ${res.statusCode}, Body: ${body}`);
                    }
                    resolve();
                });
            });

            req.on('error', (err) => {
                console.error('Fehler beim Senden des Slack Webhooks:', err.message);
                resolve();
            });

            req.on('timeout', () => {
                req.destroy();
                console.error('Slack Webhook Timeout nach 5s');
                resolve();
            });

            req.write(payload);
            req.end();

        } catch (err) {
            console.error('Ungültige Slack Webhook URL:', err.message);
            resolve();
        }
    });
}