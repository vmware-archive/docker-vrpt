#
#  Copyright 2015 VMware, Inc.
#
#  Licensed under the Apache License, Version 2.0 (the "License");
#  you may not use this file except in compliance with the License.
#  You may obtain a copy of the License at
#
#      http://www.apache.org/licenses/LICENSE-2.0
#
#  Unless required by applicable law or agreed to in writing, software
#  distributed under the License is distributed on an "AS IS" BASIS,
#  WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
#  See the License for the specific language governing permissions and
#  limitations under the License.
#

FROM registry.cloudbuilders.vmware.local:5000/openedge/chaperone-lxde
MAINTAINER Tom Hite <thite@vmware.com>

# Set environment for JAVA
ENV JAVA_VERSION_MAJOR=8
ENV JAVA_VERSION_MINOR=66
ENV JAVA_VERSION_BUILD=17
ENV JAVA_PACKAGE=jdk
ENV JAVA_HOME=/opt/jdk

# create the necessary directory for vRTP
RUN mkdir -p /opt/vmware

# download JDK-8 and link it to JAVA_HOME
# Credits: https://github.com/anapsix/docker-alpine-java/blob/master/8/jdk/Dockerfile
RUN curl -jksSLH "Cookie: oraclelicense=accept-securebackup-cookie"\
  http://download.oracle.com/otn-pub/java/jdk/${JAVA_VERSION_MAJOR}u${JAVA_VERSION_MINOR}-b${JAVA_VERSION_BUILD}/${JAVA_PACKAGE}-${JAVA_VERSION_MAJOR}u${JAVA_VERSION_MINOR}-linux-x64.tar.gz | tar -xzf - -C /opt
RUN ln -s /opt/jdk1.${JAVA_VERSION_MAJOR}.0_${JAVA_VERSION_MINOR} ${JAVA_HOME}

# download vRTP
RUN curl -o /opt/vmware/vrealize-productiontest-1.2.0.jar http://build-squid.eng.vmware.com/build/mts/release/bora-3190618/publish/vrealize-productiontest-1.2.0.jar

# Setup user environment
ENV PATH=${PATH}:${JAVA_HOME}/bin

# setup permissions setting scirpt
ADD ./99-fixperms /etc/supervisord/init.d/99-fixperms
RUN chmod +x /etc/supervisord/init.d/99-fixperms
