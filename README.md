# Dankoy Collection Ansible Project

## Included content/ Directory Structure

The directory structure follows best practices recommended by the Ansible
community. Feel free to customize this template according to your specific
project requirements.

```shell
 ansible-project/
 |── .devcontainer/
 |    └── docker/
 |        └── devcontainer.json
 |    └── podman/
 |        └── devcontainer.json
 |    └── devcontainer.json
 |── .github/
 |    └── workflows/
 |        └── tests.yml
 |    └── ansible-code-bot.yml
 |── .vscode/
 |    └── extensions.json
 |── collections/
 |   └── requirements.yml
 |   └── ansible_collections/
 |       └── project_org/
 |           └── project_repo/
 |               └── README.md
 |               └── roles/sample_role/
 |                         └── README.md
 |                         └── tasks/main.yml
 |── inventory/
 |   |── hosts.yml
 |   |── argspec_validation_inventory.yml
 |   └── groups_vars/
 |   └── host_vars/
 |── ansible-navigator.yml
 |── ansible.cfg
 |── devfile.yaml
 |── linux_playbook.yml
 |── network_playbook.yml
 |── README.md
 |── site.yml
```

## Compatible with Ansible-lint

Tested with ansible-lint >=24.2.0 releases and the current development version
of ansible-core.

## Usage

> [!NOTE]
> These collections was not pushed to galaxy

1) Install requirements 

```shell
ansible-galaxy install -r collections/requirements.yml
```

2) Add file with vault password into some directory.
3) Run role

```shell
ansible-playbook playbook.yml -i hosts/orange_armbian.yml -t docker  --vault-password-file=./vault/pass
```

## Collections

This repo contains collections of ansible roles
1) jforwarder - for jforwarder project
2) linux_utils - for linux administration
3) nagios - for nagios client and server monitoring tasks

