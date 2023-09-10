#!/bin/sh
set -e

echo "Activating feature 'op-cli-persistence'"
echo "User: ${_REMOTE_USER}     User home: ${_REMOTE_USER_HOME}"

if [  -z "$_REMOTE_USER" ] || [ -z "$_REMOTE_USER_HOME" ]; then
  echo "***********************************************************************************"
  echo "*** Require _REMOTE_USER and _REMOTE_USER_HOME to be set (by dev container CLI) ***"
  echo "***********************************************************************************"
  exit 1
fi

# make /dc/op-cli folder if doesn't exist
mkdir -p "/dc/op-cli"

# as to why we move around the folder, check `github-cli-persistence/install.sh`
if [ -e "$_REMOTE_USER_HOME/.config/op" ]; then
  echo "Moving existing .op folder to .op-old"
  mv "$_REMOTE_USER_HOME/.config/op" "$_REMOTE_USER_HOME/.config/op-old"
fi

ln -s /dc/op-cli "$_REMOTE_USER_HOME/.config/op"
# chown .op folder
chown -R "${_REMOTE_USER}:${_REMOTE_USER}" "$_REMOTE_USER_HOME/.config/op"

# chown mount (only attached on startup)
cat << EOF >> "$_REMOTE_USER_HOME/.zshrc"
sudo chown -R "${_REMOTE_USER}:${_REMOTE_USER}" /dc/op-cli
EOF
chown -R $_REMOTE_USER $_REMOTE_USER_HOME/.zshrc