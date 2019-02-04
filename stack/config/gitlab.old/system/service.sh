#!/bin/bash

command=$1

function start() {
    echo -e "Starting Gitlab server...";
#     It looks like GitLab has not been configured yet; skipping the upgrade script.
# tput: No value for $TERM and no -T specified
# GitLab was unable to detect a valid hostname for your instance.
# Please configure a URL for your GitLab instance by setting `external_url`
# configuration in /etc/gitlab/gitlab.rb file.
# Then, you can start your GitLab instance by running the following command:
#   sudo gitlab-ctl reconfigure

# For a comprehensive list of configuration options please see the Omnibus GitLab readme
# https://gitlab.com/gitlab-org/omnibus-gitlab/blob/master/README.md
    ${GITLAB_HOME}/bin/git run
}

function stop() {
    echo -e "Stop experimental implementation ...";
    ${GITLAB_HOME}/bin/nexus stop
}

function usage() {
    echo -e "$0 start|stop"
}

case ${command} in
    start) start ;;
    stop) stop ;;
    *) usage ;;
esac
