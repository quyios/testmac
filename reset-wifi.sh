#!/var/jb/usr/bin/sh
set -eu
PATH=/var/jb/usr/bin:/var/jb/bin:/usr/bin:/bin
STAMP=$(date +%s); BACKUP=/var/mobile/Media/1ferver/macspoof-reset-$STAMP; mkdir -p "$BACKUP"
for f in /private/var/preferences/SystemConfiguration/com.apple.wifi.plist /private/var/preferences/SystemConfiguration/com.apple.wifi-private-mac-networks.plist /private/var/preferences/com.apple.wifi.known-networks.plist /var/mobile/Library/Preferences/com.apple.networkserviceproxy.plist; do
  if [ -f "$f" ]; then cp -p "$f" "$BACKUP/$(echo "$f" | tr / _)"; rm -f "$f"; fi
done
launchctl kickstart -k system/com.apple.wifid
echo "$BACKUP"
