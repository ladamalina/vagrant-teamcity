## What's inside

* CentOS 7 [vagrant box](https://atlas.hashicorp.com/puppetlabs/boxes/centos-7.0-64-puppet)

* Two VMs provisioned by Puppet:

	* CI server [TeamCity 9](https://www.jetbrains.com/teamcity/)

	* "Production" server for app deployment

## Installation

```bash
$ vagrant up # installs both machines
```

## SSH Connection

```bash
$ vagrant ssh ci # app is machine name, ip 192.168.19.101
```

```bash
$ vagrant ssh app # app is machine name, ip 192.168.19.102
```

## Usage

TeamCity http interface **http://192.168.19.101:8111/**

Login: vagrant

Password: vagrant
