# Docker Volume Driver for Azure File Storage

This is a Docker Volume Driver which uses [Azure Storage File Storage][afs]
to mount file shares on the cloud to Docker containers as volumes. It uses network
file sharing ([SMB/CIFS protocols][smb]) capabilities of Azure File Storage.

[![Build Status](https://travis-ci.org/jmaitrehenry/docker-azurefile-plugin.svg?branch=master)](https://travis-ci.org/jmaitrehenry/docker-azurefile-plugin)

## Why?

- You can create Docker containers that can migrate from one host to another seamlessly.
- You can share volumes among multiple containers running on different hosts.

## Usage

Before deploying this plugin, please read articles:

- [Deciding when to use Azure Blobs, Azure Files, or Azure Data Disks](https://msdn.microsoft.com/en-us/library/azure/mt617303.aspx)
- [Features Not Supported by the Azure File Service](https://msdn.microsoft.com/en-us/library/azure/dn744326.aspx)

and be aware of the limitations and what kind of applications are suitable for storing data on Azure File Service.

## Installation

> Make sure you have a Storage Account on Azure (using Azure CLI or Portal).

Docker managed plugin may be installed with following command:

```bash
$ docker plugin install jmaitrehenry/azurefile[:version] \
    AZURE_STORAGE_ACCOUNT=xxx \
    AZURE_STORAGE_ACCOUNT_KEY=yyy
```
The [:version] component in the above command is known as a Docker tag and its value follows the semantic versioning model. Omitting the version is equivalent to specifying the latest tag -- the most recent, stable version of a plug-in.

> **NOTE:** Storage account must be in the same region as virtual machine. Otherwise
> you will get an error like “Host is down”.


## Example
### Create volumes

Starting from Docker 1.9+ you can create volumes and containers as follows:

```shell
$ docker volume create --name myvolume -d jmaitrehenry/azurefile
```

This will create an Azure File Share named `myvolume` (if it does not exist).

You can specify additional volume options to customize the owner, group, and permissions for files and directories.
See the `mount.cifs(8)` man page more details on these options.

Mount Options Available:
* `uid`
* `gid`
* `filemode`
* `dirmode`
* `cache`
* `nolock`
* `nobrl`
* `remotepath`

```shell
$ docker volume create -d jmaitrehenry/azurefile \
  -o share=sharename \
  -o uid=999 \
  -o gid=999 \
  -o filemode=0600 \
  -o dirmode=0755 \
  -o nolock=true \
  -o remotepath=directory
```

### Use a volume

The following example illustrates using a volume:

```
$ docker run -i -t -v myvolume:/data busybox
```
Docker will start a container in which you can use `/data` directory to directly read/write from cloud file share location using SMB protocol.


### Remove a volume
The following example illustrates removing a volume created:

```
$ docker volume rm myvolume
```

## Changelog

```
# 1.1.0 (2018-02-04)
- Add symlink support

# 1.0.0 (2018-01-22)
- Change project name
- Add nobrl and cache option
- Add the possibility to build a selfcontain docker volume plugin
- Add default share name to volume name
- Bugfix: Change --verbose to -v and put it before -o in the mount instruction
```

## Building

If you need to use this project, please consider downloading it from “Releases”
link above. The following instructions are for compiling the project from source.

In order to compile this program, you need to have Go 1.6:

```bash
$ git clone https://github.com/jmaitrehenry/docker-azurefile-plugin jmaitrehenry/docker-azurefile-plugin
$ cd jmaitrehenry/docker-azurefile-plugin
$ go build docker-azurefile-plugin
$ ./docker-azurefile-plugin -h
```

Once you have the binary compiled you can start it as follows:

```bash
$ sudo ./docker-azurefile-plugin \
  --account-name <AzureStorageAccount> \
  --account-key  <AzureStorageAccountKey> &
```

However you’re recommended to use the managed docker plugin.

## Maintainers

* [Julien Maitrehenry](https://github.com/jmaitrehenry)

## License

This project is a fork of [Azure/azurefile-dockervolumedriver](https://github.com/Azure/azurefile-dockervolumedriver)

```
Copyright 2018 Julien Maitrehenry
Copyright 2016 Microsoft Corporation

Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.
```

[afs]: http://blogs.msdn.com/b/windowsazurestorage/archive/2014/05/12/introducing-microsoft-azure-file-service.aspx
[smb]: https://msdn.microsoft.com/en-us/library/windows/desktop/aa365233(v=vs.85).aspx
