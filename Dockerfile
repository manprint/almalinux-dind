FROM almalinux:8.6

SHELL ["/bin/bash", "-xeo", "pipefail", "-c"]

ENV container docker

LABEL mantainer="Fabio"

RUN rm -f /lib/systemd/system/multi-user.target.wants/* \
    /etc/systemd/system/*.wants/* \
    /lib/systemd/system/local-fs.target.wants/* \
    /lib/systemd/system/sockets.target.wants/*udev* \
    /lib/systemd/system/sockets.target.wants/*initctl* \
    /lib/systemd/system/basic.target.wants/* \
    /lib/systemd/system/anaconda.target.wants/*

RUN yum update -y && \
	yum install -y yum-utils epel-release procps nano sudo curl net-tools iputils && \
	yum clean all && \
	rm -rf /var/cache/yum && \
	groupadd --gid 1000 alma && \
	useradd -m -s /bin/bash -g alma -G root,wheel -u 1000 alma && \
	echo "alma ALL=(ALL) NOPASSWD: ALL" >> /etc/sudoers && \
	ln -snf /usr/share/zoneinfo/Europe/Rome /etc/localtime && \
	echo Europe/Rome > /etc/timezone

RUN yum update -y && \
	yum-config-manager --add-repo https://download.docker.com/linux/centos/docker-ce.repo && \
	yum update -y && \
	yum install -y docker-ce docker-ce-cli containerd.io docker-compose-plugin && \
	yum clean all && \
	rm -rf /var/cache/yum && \
	usermod -aG docker alma && \
	systemctl enable docker

RUN yum update -y && \
	yum-config-manager --add-repo https://rpm.releases.hashicorp.com/RHEL/hashicorp.repo && \
	yum update -y && \
	yum -y install terraform git && \
	yum clean all && \
	rm -rf /var/cache/yum && \
	usermod -aG docker alma

COPY --chown=root:root daemon.json /etc/docker/daemon.json
COPY --chown=root:root override.conf /etc/systemd/system/docker.service.d/override.conf
COPY --chown=root:root .bashrc /root/.bashrc
COPY --chown=alma:alma .bashrc /home/alma/.bashrc

WORKDIR /home/alma

VOLUME [ "/sys/fs/cgroup", "/var/lib/docker", "/home/alma" ]

CMD ["/usr/sbin/init"]
