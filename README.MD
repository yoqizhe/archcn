# 概述

官方archlinux镜像的pacman默认软件源在国外，国内使用网络比较慢甚至卡住。
该镜像在archlinux官方镜像的基础上为pacman包管理工具配置了中国镜像源。

[官方镜像dockerhub](https://hub.docker.com/_/archlinux)

[当前镜像dockerhub](https://hub.docker.com/r/yoqizhe/archcn)

# 运行镜像

```shell
docker pull yoqizhe/archcn && docker run -itd --name archcn yoqizhe/archcn /bin/bash
```

# 自行构建镜像

一般情况下从dockerhub拉取直接使用即可，若您想做一些定制的操作如修改镜像源也可自行构建，以下是自行构建的说明。

因为构建需要使用到systemd，而systemd只能在容器运行时使用，所以构建需要分为两步。
1. dockerfile构建基础镜像
2. 运行基础镜像，在容器执行初始化脚本，然后导出容器为镜像

**第一步：dockerfile构建**

在`Dockerfile`所在目录执行命令
```shell
docker build -t cn/prearch .
```

**第二步：进入容器执行初始化脚本**

构建完成后，运行示例
```shell
docker run -itd --name prearch cn/prearch /bin/bash
```

进入容器
```shell
docker exec -it 容器id /bin/bash
```

配置中国软件源
```shell
echo -e '[archlinuxcn]\nServer = https://repo.archlinuxcn.org/$arch' >> /etc/pacman.conf
```

执行脚本
```shell
/bin/initcn
```

脚本执行完成后，至此，容器的pacman软件源已修改。可以更新一下最新软件
```shell
pacman -Syyu --noconfirm --needed --verbose
```

退出容器，将当前容器导出为镜像。
```shell
docker commit 容器id cn/archcn
```

# 拓展

## pacman的初始化和国内源的步骤

[pacman初始化与国内源](https://www.chlmrh.top/2024/11/03/202411/pacman-init/)

## 为何使用archlinuxcn后不用`pacman-key --populate archlinux-cn`

因为archlinux-cn通过本地导入了的密钥环
```
pacman-key --lsign-key "farseerfc@archlinux.org
```

## docker-systemctl-replacement

在初始化脚本中使用到了systemd启动haveged服务，这里的systemd不是默认的systemd。

[为何不用默认的systemd](https://ehds.github.io/2021/01/21/docker_systemctl/)

[github: docker-systemctl-replacement](https://github.com/gdraheim/docker-systemctl-replacement)

## haveged是什么

[haveged介绍](https://www.archlinuxcn.org/gnupg-2-1-and-the-pacman-keyring/)