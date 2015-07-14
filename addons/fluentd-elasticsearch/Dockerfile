# This Dockerfile will build an image that is configured
# to run Fluentd with an Elasticsearch plug-in and the
# provided configuration file.
# TODO(satnam6502): Use a lighter base image, e.g. some form of busybox.
# The image acts as an executable for the binary /usr/sbin/td-agent.
# Note that fluentd is run with root permssion to allow access to
# log files with root only access under /var/lib/docker/containers/*
# Please see http://docs.fluentd.org/articles/install-by-deb for more
# information about installing fluentd using deb package.

FROM gcr.io/google_containers/fluentd-elasticsearch:1.6
MAINTAINER -10 "shi_hu@kindgee.com"

# Copy the Fluentd configuration file.
# fluentd
COPY td-agent.conf /etc/td-agent/td-agent.conf