FROM archlinux:latest

RUN pacman -Syy --noconfirm --debug
RUN pacman -S --noconfirm archlinux-keyring
RUN pacman-key --init
RUN pacman-key --populate archlinux

# prepare import cn
COPY systemctl3.py /bin/systemctl
RUN chmod a+x /bin/systemctl
# 以下两个replace-systemctl需要用到
RUN pacman -S --noconfirm python 
RUN pacman -S --noconfirm glibc
# 
RUN pacman -S --noconfirm haveged

# 运行时使用的初始化脚本
COPY initcn.sh /bin/initcn
RUN chmod a+x /bin/initcn

CMD ["/sbin/init"]
