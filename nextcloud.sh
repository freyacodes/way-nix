#! /usr/bin/env sh
rsync -av --exclude=.git . nextcloud:/etc/nixos
ssh nextcloud nixos-rebuild switch
