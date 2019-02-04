FROM centos

LABEL Author="Francis Ouellet <fouellet@dminc.com>"
LABEL Description="Base on Centos 7"

ENV container docker
ENV CONTAINER_NAME gitlab
ENV CONTAINER_IMAGE ghandalf/gitlab:${CONTAINERS_VERSION}
ENV CONTAINER_VERSION ${CONTAINERS_VERSION}
ENV APP_USER gitlab
ENV APP_GROUP ggroup
ENV APP_HOME /usr/share/gitlab

ENV GITLAB_HOME ${APP_HOME}
ENV GITLAB_PORT_HTTP 32184
ENV GITLAB_PORT_SSH 32122
ENV GITLAB_PORT_HTTPS 32143

ENV HOSTNAME gitlab.cfna.com
ENV EXTERNAL_URL="http://${HOSTNAME}"

# Error when the udapte is done:
#     Failed to get D-Bus connection: Operation not permitted
#   Keep in mind we are in a container and we building it, it is a normal behavior
RUN yum -y update
RUN yum --security check-update
RUN yum --security update
RUN yum install -y systemd firewalld \
    tree net-tools bind bind-utils \
    wget curl policycoreutils-python openssh-server postfix 
RUN yum clean all

RUN mkdir -p ${APP_HOME}
RUN systemctl enable sshd
        # systemctl start sshd
        # firewall-cmd --permanent --add-service=http
        # systemctl reload firewalld

RUN systemctl enable postfix

# Installation of repo
RUN curl https://packages.gitlab.com/install/repositories/gitlab/gitlab-ce/script.rpm.sh | bash
# Installation of repo done

# Installation with yum 
RUN yum install -y gitlab-ce
    # The above installation is mutch to slow, use the one below
# Installation with yum -done

# Installation with rpm give this error: error: open of gitlab-ce-11.7.3-ce.0.el7.x86_64.rpm failed: No such file or directory
    # RUN wget https://packages.gitlab.com/gitlab/gitlab-ce/packages/el/7/gitlab-ce-11.7.3-ce.0.el7.x86_64.rpm -P ${APP_HOME}/
    # RUN cd ${APP_HOME} && ls -la
    # RUN rpm -Uvh gitlab-ce-11.7.3-ce.0.el7.x86_64.rpm
# Installation with rpm done


EXPOSE ${GITLAB_PORT_HTTP}
EXPOSE ${GITLAB_PORT_SSH}
EXPOSE ${GITLAB_PORT_HTTPS}

ENTRYPOINT [ "/bin/sh" ]

# ++++++++++++++++++++++++++++++++++++++++++++++++



# Git client installation
# RUN yum groupinstall -y "Development Tools"
# RUN yum install -y gettext-devel openssl-devel perl-CPAN perl-devel zlib-devel wget curl-devel
# RUN mkdir -p ${APP_HOME} \
#     && cd ${APP_HOME} \
#     && wget https://github.com/git/git/archive/v2.20.1.tar.gz \
#     && tar xvf v2.20.1.tar.gz \
#     && cd git-* \
#     && make configure \
#     && ./configure --prefix=/usr/local \
#     && make install \
#     && git --version
# Git client installation -done

# TEST::: Run the script may not need it
    # COPY ./config/gitlab/system/systemd.cleanup.sh ${APP_HOME}/
    # RUN chmod 0750 ${APP_HOME}/systemd.cleanup.sh \
    #     && ./${APP_HOME}/systemd.cleanup.sh
    # VOLUME [ “/sys/fs/cgroup” ]
# TEST::: End running script

# Work: Failed to get D-Bus connection: Operation not permitted
# RUN /usr/sbin/firewalld -k start
# RUN systemctl status firewalld
# RUN systemctl enable sshd \
#     && /usr/sbin/sshd start &
# RUN systemctl enable firewalld
# RUN systemctl start firewalld

#  \
#     && systemctl enabled firewalld
# RUN firewall-cmd --permanent --add-service=http \
#     && systemctl reload firewalld
# RUN systemctl enable postfix \
#     && /usr/sbin/postfix start &

# Gitlab server repository installation: https://about.gitlab.com/install/#centos-7
# ALL the call below are to slow
# Will create /etc/yum.repos.d/gitlab_gitlab_ce.repo
# RUN curl https://packages.gitlab.com/install/repositories/gitlab/gitlab-ce/script.rpm.sh | bash
# RUN echo "HOSTNAME::::: $(hostname)";
# RUN export EXTERNAL_URL="http://localhost" && yum install -y gitlab-ce
# RUN Above is mutch to slow
# https://packages.gitlab.com/gitlab/gitlab-ce/packages/el/7/gitlab-ce-11.7.3-ce.0.el7.x86_64.rpm
# RUN yum install -y gitlab-ce

# Copy from local file and install the rpm
# https://packages.gitlab.com/gitlab/gitlab-ce/packages/el/7/gitlab-ce-11.7.3-ce.0.el7.x86_64.rpm

# COPY ./config/gitlab/system/usr/bin/systemctl3.py /usr/bin/systemctl3.py
# RUN chmod 0750 /usr/bin/systemctl3.py

# RUN yum install -y https://centos7.iuscommunity.org/ius-release.rpm
# RUN yum -y update
# RUN yum install -y python36u python36u-libs python36u-devel python36u-pip
# RUN yum install -y curl policycoreutils-python openssh-server postfix
# RUN cd /usr/bin/ && ln -s python3.6 python3 && cd -

# RUN systemctl enable sshd
# Activate the line below give us: sshd.service: Could not load host key: /etc/ssh/ssh_host_rsa_key
# RUN /usr/bin/systemctl3.py start sshd

# RUN firewall-cmd --permanent --add-service=http \
#     && systemctl reload firewalld

# RUN /usr/bin/systemctl3.py enable postfix
# RUN yum -y update
# RUN yum install -y curl policycoreutils-python openssh-server postfix
# RUN yum clean all

# RUN curl https://packages.gitlab.com/install/repositories/gitlab/gitlab-ce/script.rpm.sh | bash
# COPY ./config/gitlab/system/rpm/*.rpm ${APP_HOME}/
# RUN rpm -Uvh ${APP_HOME}/*.rpm
# EXPOSE ${GITLAB_PORT_HTTP}
# EXPOSE ${GITLAB_PORT_SSH}
# EXPOSE ${GITLAB_PORT_HTTPS}
# ENTRYPOINT [ "/bin/sh" ]
# ENTRYPOINT [ "gitlab-ctl", "start" ]

# ENTRYPOINT ["hostnamectl", "set-hostname", "gitlab.cfna.com" \
#             "&&", "firewall-cmd", "--permanent", "--add-service=http", \
#             "&&", "systemctl", "reload", "firewalld", \
#             "&&", "/bin/sh"]

# COPY ./config/gitlab/system/rpm/*.rpm ${APP_HOME}/
# RUN wget https://packages.gitlab.com/gpg.key -P ${APP_HOME}/
# RUN gpg --no-default-keyring --keyring ${APP_HOME}/gpg.key --verify ${APP_HOME}/*.rpm
# RUN rpm -qpR ${APP_HOME}/*.rpm
# RUN rpm -Uvh ${APP_HOME}/*.rpm
# create hostname, add this name in gitlab.rb file external_url="http://gitlab.ghandalf.ca"
# RUN hostnamectl set-hostname gitlab.cfna.com
# COPY ./config/gitlab/system/etc/gitlab/gitlab.rb /etc/gitlab/gitlab.rb
# RUN cat /etc/gitlab/gitlab.rb
# Configure and run
# RUN service gitlab restart
# Gitlab server repository installation -done

# Group and User configuration
# RUN mkdir -p ${APP_HOME}/data
# RUN groupadd -g 1002 ${APP_GROUP} \
#     && useradd -r -u 1002 -M -b ${APP_HOME}} -g ${APP_GROUP} ${APP_USER} \
#     && usermod -s /sbin/nologin ${APP_USER} \
#     && chown -R ${APP_USER}:${APP_GROUP} ${APP_HOME}
# Group and User configuration done

# EXPOSE ${GITLAB_PORT_HTTP}
# EXPOSE ${GITLAB_PORT_SSH}
# EXPOSE ${GITLAB_PORT_HTTPS}
# USER ${APP_USER}
# ENTRYPOINT [ "/bin/sh" ]
# ENTRYPOINT [ "gitlab-ctl", "start" ]
