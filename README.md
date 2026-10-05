# MacSpoof GitHub Build

Theos project for jailbroken iOS 16. Push this folder to GitHub and run the workflow to build the `.deb` artifact.

The tweak listens for `com.amywhile.macspoof.randomize` and randomizes configured per-SSID private MAC values.

`reset-wifi.sh` is a separate root helper that backs up selected Wi-Fi plist files, removes them, and restarts `wifid`.
