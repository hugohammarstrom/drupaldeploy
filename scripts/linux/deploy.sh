#!/bin/bash

# DEPLOY

# Clone repository if first deploy.
if [ ! -d <%= installLocation %>/current ]; then
    git clone -b master --single-branch <%= repository %> <%= installLocation %>/current
else
  sudo rm -rf <%= installLocation %>/tmp

  # Copy source files.
  cp -R <%= installLocation %>/current <%= installLocation %>/tmp

  # Pull latest changes.
  cd <%= installLocation %>/tmp
  git checkout -- .
  git pull origin master
  cd <%= installLocation %>

  # Switch versions, current => previous && tmp => current.
  rm -rf <%= installLocation %>/previous
  mv <%= installLocation %>/current <%= installLocation %>/previous
  mv <%= installLocation %>/tmp <%= installLocation %>/current
fi

# Set default permissions.
sudo chmod -R 644 <%= installLocation %>/current/<%= web %>
sudo chmod -R 640 <%= installLocation %>/current/<%= web %>/index.php
sudo chmod -R 775 <%= installLocation %>/default/files
sudo chmod 644 <%= installLocation %>/default/settings.php

# Set group.
sudo chgrp -R <%= group %> <%= installLocation %>/current/<%= web %>
sudo chgrp -R <%= group %> <%= installLocation %>/default

# Remove default settings.
rm -rf <%= installLocation %>/tmp/<%= web %>/sites/default

# Create symbolic link to settings and files.
# cd <%= installLocation %>/current/<%= web %>/sites/
rm <%= installLocation %>/current/<%= web %>/sites/default
ln -sf <%= installLocation %>/default <%= installLocation %>/current/<%= web %>/sites/default
# cd <%= installLocation %>
