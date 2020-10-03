if [ -x /usr/bin/update-desktop-database ]; then
    /usr/bin/update-desktop-database -q usr/share/applications
fi

if [ -e usr/share/icons/hicolor/icon-theme.cache ]; then
  if [ -x /usr/bin/gtk-update-icon-cache ]; then
    /usr/bin/gtk-update-icon-cache -f usr/share/icons/hicolor >/dev/null 2>&1
  fi
fi

if [ -e usr/bin/dumpcap ] && grep -q ^wireshark: etc/group; then
  /bin/chgrp wireshark usr/bin/dumpcap
  /bin/chmod 750 usr/bin/dumpcap
  /sbin/setcap cap_net_raw,cap_net_admin=eip usr/bin/dumpcap
fi
