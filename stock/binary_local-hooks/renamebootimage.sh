#!/bin/sh

set -e

DIR="binary/live"
mv "${DIR}"/vmlinuz-*    "${DIR}"/vmlinuz
mv "${DIR}"/initrd.img-* "${DIR}"/initrd.img

