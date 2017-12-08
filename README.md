# Google Cloud DNS updater for systemd

### Setup
* Install gcloud (https://cloud.google.com/sdk/docs/quickstarts)
* Configure gcloud to hook into your Google Cloud setup
* Copy *gdns.service* to */etc/systemd/system/*.
  Change *YOURUSER* to the user where gcloud finds *~/.config/glcoud/*.
  Run `systemctl enable gdns`
* Copy *gdns.sh* to */usr/local/bin/* and change *project*, *zoneid*, *zone*, and *arec* variables to reflect your setup

_Written for Debian Buster. Should work on all Ubuntu/Debian/Arch distros as well as all other systemd based distros._
