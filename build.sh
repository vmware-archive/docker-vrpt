#!/bin/sh
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
#==============================================================================

echo "Starting build at: $(date +%Y%m%d)"

user=vmware
group=vmware
if [ -n "${1}" ]; then
	user="${1}"
	shift
fi
if [ -n "${1}" ]; then
	user="${1}"
	shift
fi

generate_init_script() {
	cat >99-fixperms <<-EOF
		#!/bin/bash
		chown -R vmware:vmware /opt/vmware

		grep "^JAVA_HOME=" /home/vmware/.bashrc >/dev/null 2>&1
		if [ \$? -ne 0 ]; then
			 echo '# --- SETUP VI \$0'
			 echo 'JAVA_HOME=/opt/jdk'  >>/home/vmware/.bashrc
			 echo 'PATH=\${PATH}:\${JAVA_HOME}/bin' >>/home/vmware/.bashrc
		fi
	EOF
}

#
cd $(dirname $0)
generate_init_script ${user} ${group}
#docker build --rm=true -t openedge/vrpt .

echo "Completed build at: $(date +%Y%m%d)"
