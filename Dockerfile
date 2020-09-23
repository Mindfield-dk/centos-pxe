FROM centos:7 AS extract

COPY CentOS-7-x86_64-Minimal-1908.iso /CentOS-7-x86_64-Minimal-1908.iso

RUN mount -o loop /CentOS-7-x86_64-Minimal-1908.iso /mnt/
RUN yum -y install dhcp tftp tftp-server syslinux vsftpd xinetd

WORKDIR /mnt/

RUN cp -av * /var/ftp/pub/
RUN cp /mnt/images/pxeboot/vmlinuz /var/lib/tftpboot/networkboot/
RUN cp /mnt/images/pxeboot/initrd.img /var/lib/tftpboot/networkboot/
RUN umount /mnt/

FROM centos:7 AS server

LABEL MAINTAINER="https://github.com/mindfield/centos-pxe"

RUN yum -y install dhcp tftp tftp-server syslinux vsftpd xinetd

COPY dhcpd.conf /etc/dhcp/dhcpd.conf
COPY tftp.conf /etc/xinetd.d/tftp
COPY --from=extract /var/lib/tftpboot/networkboot /var/lib/tftpboot/networkboot
COPY --from=extract /var/ftp/pub /var/ftp/pub

RUN cp -v /usr/share/syslinux/pxelinux.0 /var/lib/tftpboot \
 && cp -v /usr/share/syslinux/menu.c32 /var/lib/tftpboot \
 && cp -v /usr/share/syslinux/memdisk /var/lib/tftpboot \
 && cp -v /usr/share/syslinux/mboot.c32 /var/lib/tftpboot \
 && cp -v /usr/share/syslinux/chain.c32 /var/lib/tftpboot \
 && mkdir /var/lib/tftpboot/pxelinux.cfg \
 && mkdir /var/lib/tftpboot/networkboot
