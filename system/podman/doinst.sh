config() {
  NEW="$1"
  OLD="$(dirname $NEW)/$(basename $NEW .new)"
  # If there's no config file by that name, mv it over:
  if [ ! -r $OLD ]; then
    mv $NEW $OLD
  elif [ "$(cat $OLD | md5sum)" = "$(cat $NEW | md5sum)" ]; then
    # toss the redundant copy
    rm $NEW
  fi
  # Otherwise, we leave the .new copy for the admin to consider...
}

<<<<<<< HEAD
config etc/containers/registries.conf.new
config etc/containers/mounts.conf.new
=======
config etc/containers/containers.conf.new
config etc/containers/registries.conf.new
config etc/containers/mounts.conf.new
## **FIXME** Remove if /usr/share/containers/seccomp.json is installed by default.
#config etc/containers/seccomp.json.new
>>>>>>> b70ec0e130 (!no-merge,fixme: system/podman: Update to version 4.6.0)
config etc/containers/policy.json.new
