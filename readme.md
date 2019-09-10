# Windows Server 2019 Packer Template

<!-- TOC depthFrom:2 -->

- [Windows Server 2019 Packer Template](#windows-server-2019-packer-template)
  - [Introduction](#introduction)
    - [Supported Builders](#supported-builders)
  - [Prepare your system to run Packer](#prepare-your-system-to-run-packer)
    - [Windows](#windows)
      - [Hyper-V](#hyper-v)
      - [VirtualBox](#virtualbox)
  - [Running the Build Script](#running-the-build-script)
    - [Building Hyper-V Images](#building-hyper-v-images)
    - [Building VirtualBox Images](#building-virtualbox-images)
  - [Using the Vagrant Images](#using-the-vagrant-images)

<!-- /TOC -->

## Introduction

This repository contains build scripts to create golden images using [Packer](https://www.packer.io/).

For more information about and how to use Packer please review the [documentation](https://www.packer.io/docs/index.html) on the products website.  This will provide you with the information you need to modify this repository to meet you specific needs.

### Supported Builders

- Hyper-V
- VirtualBox

## Prepare your system to run Packer

### Windows

> ✅ Tested on Windows 10 Pro and Enterprise

To simplify installing the required tools for building the packer images it is suggested to use [Chocolatey](https://chocolatey.org/install#installing-chocolatey)  for installing Packer and Vagrant.  The commands to installeach peace of software are below.

**Chocolatey**:
```powershell
Set-ExecutionPolicy Bypass -Scope Process -Force; iex ((New-Object System.Net.WebClient).DownloadString('https://chocolatey.org/install.ps1'))
```

**Packer**:
```cmd
choco install packer
```

**Vagrant**:
```cmd
choco install vagrant
```

#### Hyper-V

If you are going to build using *Hyper-V* please make sure you have it enabled on your system.  The commands below should help you do this.

```powershell
# Set PowerShell Execution Policy
Set-ExecutionPolicy RemoteSigned -Force

# Install Hyper-V
Enable-WindowsOptionalFeature -Online -FeatureName Microsoft-Hyper-V -All

# Create an external Hyper-V Switch
# Commands may vary depending on your system.
Get-NetAdapter

# Find the name of the network adapter (make sure its status is also not disconnected)

# Create a new VM Switch using the name of the network adapter
New-VMSwitch -Name "External VM Switch" -AllowManagementOS $true -NetAdapterName "<Your Adapter Name Here>"
```

#### VirtualBox

If you are going to build using *VirtualBox* please make sure it is installed on you system.  The command below should help you do this.

**VirtualBox**:
```cmd
choco install virtualbox
```

## Running the Build Script

If you choose to use the `build.ps1` file to create your images it will output a `*.box` file.  The box file is used by **[Vagrant](https://www.vagrantup.com/)** to quickly spin up VM's for testing.  To run the `build.ps1` script you will need the following information.

* Target hypervisor (HyperV or VirtualBox)
* Iso Uri (URL or File path to windows iso)
* Iso Checksum
* Iso Checksum type (MD5, Sha256, etc..)

> To get a files checksum in windows use the Get-FileHash command.  By default it will use the sha256 algorithm, to change the algorithm type use the `-Algorithm` parameter. an example is below.
> ```powershell
> Get-FileHash .\build.ps1 -Algorithm MD5
> ```

### Building Hyper-V Images

Below is an example of using the build script to build an image using **Hyper-V**

```powershell
.\build.ps1 -Target HyperV -IsoUri \\path\to\file\ISO.iso -IsoChecksum "0307D30C9C9A09F88DE5F1D6EDEC3267" -ChecksumType "MD5"
```

> the `IsoUri` can be either a file path or web address.

### Building VirtualBox Images

Below is an example of using the build script to build an image using **VirtualBox**

*Building an image using VirtualBox*
```powershell
.\build.ps1 -Target VirtualBox -IsoUri https://web.address.example/ISO.iso -IsoChecksum "0307D30C9C9A09F88DE5F1D6EDEC3267" -ChecksumType "MD5"
```

> the `IsoUri` can be either a file path or web address.

## Using the Vagrant Images

The generated box files include a Vagrantfile template that is suitable for use
with Vagrant 1.7.4+, but the latest version is always recommended.

Example Steps for VirtualBox:

```
vagrant box add Windows_Server_2019 windows_2019_virtualbox.box
vagrant init Windows_Server_2019
vagrant up --provider virtualbox
```

Example Steps for Hyper-V:

```
vagrant box add Windows_Server_2019 windows_2019_hyperv.box
vagrant init Windows_Server_2019
vagrant up --provider hyperv
```
