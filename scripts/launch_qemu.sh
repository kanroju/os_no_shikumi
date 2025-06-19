#!/bin/bash -e

# プロジェクトルートのパスを取得
PROJ_ROOT="$(dirname $(dirname ${BASH_SOURCE:-$0}))"
cd "$PROJ_ROOT"

# 引数でEFIファイルへのパスを受け取る
PATH_TO_EFI="$1"

# 一時マウントディレクトリの作成
rm -rf mnt
mkdir -p mnt/EFI/BOOT/

# EFIファイルを BOOTX64.EFI としてコピー
cp "$PATH_TO_EFI" mnt/EFI/BOOT/BOOTX64.EFI

# QEMUでUEFIを起動（FATドライブにマウント）
qemu-system-x86_64 \
  -m 4G \
  -bios third_party/ovmf/RELEASEX64_OVMF.fd \
  -drive format=raw,file=fat:rw:mnt \
  -device isa-debug-exit,iobase=0xf4,iosize=0x01