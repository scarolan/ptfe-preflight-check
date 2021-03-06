# PTFE Preflight Check Inspec Profile
This repository contains an InSpec (www.inspec.io) profile for checking
pre-installation requirements for Private Terraform Enterprise. It has been
tested on RHEL 7.5.

## Usage Instructions
Install InSpec on your Linux instance or on your local workstation. The easiest 
way to go about this is by installing the Chef Development Kit. You can do that 
with this one-liner. If you are unable to install the ChefDK on your Linux
server, you can still scan the server via SSH from your local machine. Simply 
download and install the ChefDK onto your laptop to use the SSH method.

```
curl https://omnitruck.chef.io/install.sh | sudo bash -s -- -c current -P chefdk
```

Once you have InSpec installed on the system you can clone this repo:

```
git clone https://github.com/scarolan/ptfe-preflight-check
```

Next edit the `controls/network.rb` file and change these variables to match 
your environment. The VCS url is your Version Control System, such as GitHub 
or BitBucket Server. Uncomment the proxy_url variable and set that as well if your
server is behind a corporate web proxy.

```
vcs_url = 'https://www.github.com'
#proxy_url = 'http://corp.proxy.server:3128'
```

## Run the tests

### Option 1 - From the Linux server itself:
```
sudo inspec exec ptfe-preflight-check
```

### Option 2 - From your local workstation:
When you use this option, you do *not* have to install InSpec on the Linux server.
```
inspec exec ptfe-preflight-check -t ssh://ec2-user@52.39.28.189 -i ~/.ssh/id_dsa --sudo
```

## Results
The test output will look something like this:

```
Profile: Private Terraform Enterprise Pre-Installation Checks (ptfe-preflight-checks)
Version: 1.0.0
Target:  local://

  ✔  os-release: 7.5
     ✔  7.5 should cmp >= 7.2
  ✔  docker-daemon: Service docker
     ✔  Service docker should be installed
     ✔  Service docker should be running
  ✔  docker-version: #<Hashie::Mash Client=#<Hashie::Mash ApiVersion="1.26" Arch="amd64" BuildTime="Mon Apr 30 15:45:42 2018" GitCommit="94f4240/1.13.1" GoVersion="go1.9.2" Os="linux" PkgVersion="docker-1.13.1-63.git94f4240.el7.x86_64" Version="1.13.1"> Server=#<Hashie::Mash ApiVersion="1.26" Arch="amd64" BuildTime="Mon Apr 30 15:45:42 2018" GitCommit="94f4240/1.13.1" GoVersion="go1.9.2" KernelVersion="3.10.0-862.el7.x86_64" MinAPIVersion="1.12" Os="linux" PkgVersion="docker-1.13.1-63.git94f4240.el7.x86_64" Version="1.13.1">>
     ✔  #<Hashie::Mash Client=#<Hashie::Mash ApiVersion="1.26" Arch="amd64" BuildTime="Mon Apr 30 15:45:42 2018" GitCommit="94f4240/1.13.1" GoVersion="go1.9.2" Os="linux" PkgVersion="docker-1.13.1-63.git94f4240.el7.x86_64" Version="1.13.1"> Server=#<Hashie::Mash ApiVersion="1.26" Arch="amd64" BuildTime="Mon Apr 30 15:45:42 2018" GitCommit="94f4240/1.13.1" GoVersion="go1.9.2" KernelVersion="3.10.0-862.el7.x86_64" MinAPIVersion="1.12" Os="linux" PkgVersion="docker-1.13.1-63.git94f4240.el7.x86_64"
Version="1.13.1">> Server.Version should cmp >= "1.13"
  ✔  docker-config: File /usr/lib/systemd/system/docker.service
     ✔  File /usr/lib/systemd/system/docker.service content should not include "--authorization-plugin=rhel-push-plugin"
     ✔  Command docker info 2> /dev/null | grep Authorization exit_status should eq 1
  ✔  storage-config: Command uname -r
     ✔  Command uname -r stdout should cmp > "3.10.0-693"
     ✔  Mount / should be mounted
     ✔  Mount / type should eq "xfs"
     ✔  Command xfs_info / stdout should include "ftype=1"
     ✔  Filesystem / size should be >= 41943040
  ✔  network_checks: Command curl https://www.google.com
     ✔  Command curl https://www.github.com exit_status should eq 0
     ✔  Command curl https://ec2.amazonaws.com exit_status should eq 0
     ✔  Command curl https://management.azure.com exit_status should eq 0
```
