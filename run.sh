#!/usr/bin/env bash

echo 'Build package'
chown -R builder .
sudo -u builder makepkg -sc --needed --noconfirm

echo 'Setup minio alias'
mcli alias set m "http://${MINIO_HOST}:${MINIO_PORT}" \
  "$MINIO_ACCESSKEY" "$MINIO_SECRETKEY"

mkdir repo
echo 'Copy repo db from minio'
mcli cp "m/${MINIO_BUCKET}/${REPO_NAME}.db*" repo
mcli cp "m/${MINIO_BUCKET}/${REPO_NAME}.files" repo

echo 'Add pkgs to repo db'
repo-add -n "repo/${REPO_NAME}.db.tar.zst" /build/*.pkg.tar.zst
mv /build/*.pkg.tar.zst repo

echo 'Update repo to minio'
mcli mv repo/* "m/${MINIO_BUCKET}"
