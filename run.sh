#!/usr/bin/env bash

echo 'Build package'
chown -R builder .
sudo -u builder makepkg -sc --needed --noconfirm

echo 'Setup MinIO alias'
mcli alias set m "https://${MINIO_HOST}:${MINIO_PORT}" \
  "$MINIO_ACCESSKEY" "$MINIO_SECRETKEY"

mkdir repo
echo 'Copy repo db from MinIO'
mcli cp "m/${MINIO_BUCKET}/${REPO_NAME}.db*" repo
mcli cp "m/${MINIO_BUCKET}/${REPO_NAME}.files" repo

echo 'Add pkgs to repo db'
repo-add -n "repo/${REPO_NAME}.db.tar.zst" /build/*.pkg.tar.zst
mv *.pkg.tar.zst repo

echo 'Update repo to MinIO'
mcli mv repo/* "m/${MINIO_BUCKET}"
