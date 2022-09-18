SHELL=/bin/bash

install-python:
	apt install -y python3 python3-pip python3-venv rsync sshpass

env:
	@echo -e "${Blue}==> Setup local environment${Color_Off}"

	@[ -d "${PWD}/.direnv" ] || (echo "Venv not found: ${PWD}/.direnv" && exit 1)
	@pip3 install -U pip wheel setuptools --no-cache-dir && \
	echo "[  OK  ] PIP + WHEEL + SETUPTOOLS" || \
	echo "[FAILED] PIP + WHEEL + SETUPTOOLS"

	@pip3 install -U --no-cache-dir -r "${PWD}/requirements.txt" && \
	echo "[  OK  ] PIP REQUIREMENTS" || \
	echo "[FAILED] PIP REQUIREMENTS"

	@ansible-galaxy install -fr ${PWD}/requirements.yml && \
	echo "[  OK  ] ANSIBLE-GALAXY REQUIREMENTS" || \
	echo "[FAILED] ANSIBLE-GALAXY REQUIREMENTS"

.PHONY: header
header:
	@	echo "**************************** SYSTEM BASE MAKEFILE ******************************"
	@	echo "HOSTNAME	`uname -n`"
	@	echo "KERNEL RELEASE `uname -r`"
	@	echo "KERNEL VERSION `uname -v`"
	@	echo "PROCESSOR	`uname -m`"
	@	echo "********************************************************************************"

##
## —————————————— PPROD_CORE_LXD ——————————————————————————————————————————————————————————————
##

# create-server
.PHONY: pprod-core-lxd-terraform-servers
pprod-core-lxd-terraform-servers: header
	export PROJECT_ENVIRONMENT="pprod" &&\
	ansible-playbook playbooks/00_core_lxd_servers.yml -e "tf_action=apply"

.PHONY: pprod-core-lxd-terraform-servers
pprod-core-lxd-terraform-servers-destroy: header
	export PROJECT_ENVIRONMENT="pprod" &&\
	ansible-playbook playbooks/00_core_lxd_servers.yml -e "tf_action=destroy" -e "project_environment=pprod"

# setup-server
.PHONY: pprod-setup-lxd-terraform-servers
pprod-setup-lxd-terraform-servers: header
	export PROJECT_ENVIRONMENT="pprod" &&\
	ansible-playbook playbooks/01_setup_lxd_servers.yml -e "tf_action=apply"

.PHONY: pprod-core-lxd
pprod-core-lxd: pprod-core-lxd-terraform-servers pprod-setup-lxd-terraform-servers

.PHONY: pprod-core-lxd-destroy
pprod-core-lxd-destroy: pprod-core-lxd-terraform-servers-destroy

##
## —————————————— CLEAN ——————————————————————————————————————————————————————————————
##
.PHONY: clean
clean: 
	rm -rf pprod
	rm -rf group_vars
	rm -rf roles/ansible-role-mariadb
	rm -rf secrets/pprod
	rm -rf ssh.cfg 
	rm -rf hosts
