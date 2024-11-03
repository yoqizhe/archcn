#!/bin/bash

# on enable while runtime
systemctl start haveged
systemctl enable haveged
rm -fr /etc/pacman.d/gnupg

# import cn
pacman-key --init
pacman-key --populate archlinux
pacman-key --lsign-key "farseerfc@archlinux.org"
pacman -Sy
pacman -S --noconfirm archlinuxcn-keyring