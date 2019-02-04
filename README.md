# README

Main container, of my CI/CD Pipeline. This project goal is to provide containers linked which created our Pipeline. Those docker containers will be apply On premise or Cloud, this page is to explain how we prepare the On Premise VM or the Cloud deployement.

## This repository

 *ci-cd-pipeline* Entry point of the project, On Premise or Cloud deployment
 *stack*: Sub project with docker container

### Set up VirtualBox

You need to install VirtualBox on your local machine, follow this [link](https://www.virtualbox.org/wiki/Downloads) to do so.

### Set up Centos 7 Guest on VirtualBox

We will use Centos 7 server, it is the open source of Redhat 7 (RHEL):

```bash
1. Download Centos 7 Minimal choose the nearest mirror from this [list](http://isoredirect.centos.org/centos/7/isos/x86_64/CentOS-7-x86_64-Minimal-1810.iso);
2. Start Virtualbox, click on new button and follow the instructions;
3. Once the VM is created before you start it, increase the display: click on settings under Screen tab increase the Scale Factor to 150%. We will not install Virtualbox Guests Additions, a server don\'t need any User Interface.
4. Proceed with a normal installation as root for now.
5. Create a user:
    - useradd "username"
    - passwd "username"
    - usermod -aG whell "username"
    - exit
6. From now on we will use this user for our installation. This is a best practice, we want to avoid doing "sudo su -" command. We want to be able to trace who does changes on the server. Later in time, we will configure root user to avoid ssh connection from anywhere.
```

Configure Network between Guest and Host, we want to use a DNS name instead of ip address.

```bash
1. Log with the new user on the guest Centos 7, we will proceed to our installation.
2. Activate external access:
    as root:
    nmcli d
      enp0s3 etherner disconnected
    nmtui
      Edit a connection
        Ethernet
          enp0s3
            Edit Enter
            [X] Automatically connect
    service network restart
3. sudo hostnamectl set-hostname devops.um.com
4. sudo shutdown now
4. From Virtualbox click on the Centos 7 VM, click on Settings button
    - Click on "Network"
    - Click on "Adapter 1" tab
    - Make sure you have  attached to: "NAT"
    - Click on "Adapter 2" tab
    - Click on "Enable Network Adapter"
    - Choose Attached to: "Host-only Adapter"
    - save
5. Start the Centos 7 guest
   Todo: Configure ip static ! inside guest or tru DHCP in Virtualbox host
    Static Ip
     1. Edit hosts file and add this following line at the end
         - sudo vi /etc/hosts
         - At the end of the line beginning by 127.0.0.1 for ip 4 and ::1 for ip 6 add "devops devops.um.com"
        - Save and exit the file. The command ping devops or devops.um.com should return localhost 127.0.0.1
     2. Shutdown the server: sudo shutdown now
6. Set hostname
    sudo hostnamectl set-hostname devops.um.com
    /etc/resolv.con add those values
    nameserver 8.8.8.8
    nameserver 192.168.56.1
7. Important part, we want our host to have access to the same DNS name as the Guest, because we don\'t control the DNS server, here is what we need to do:
    - On the Host machine (the machine where Virtualbox was installed)
    - Open on any linux like machine, /etc/hosts file, on Windows the file is under
      C:\Windows\System32\drivers\etc\hosts
        Add "192.168.56.102 devops devops.um.com" at the end of the file
    - Save the file
```

### Set up Docker installation

Docker will be used instead of multiple VMs.

```bash
1. Log as super user in Centos 7 guest
2. sudo yum install -y yum-utils device-mapper-persistent-data lvm2
3. sudo yum-config-manager --add-repo https://download.docker.com/linux/centos/docker-ce.repo
4. sudo yum install -y docker-ce
5. sudo usermod -aG docker $(whoami) // Add power user to docker group created by the installation above.
6. sudo systemctl enable docker.service // Start docker at boot time
7. sudo sustemctl start docker.service or sudo service docker start
8. sudo yum install -y epel-release
9. sudo yum install -y python-pip // Dependencies
10. sudo pip install docker-compose // Python installator
11. sudo yum upgrade python* // Will upgrade python-perf libraries in Python 8.1.2
12. docker-compose -version // check if we can run docker-compose
13. sudo yum clean all
```

### Set up Svn and Git client on the server to retrieve um-pipeline project

um-Pipeline is the project that contain the Pipeline stack [Gitlab, Jenkins and Nexus]. We also have the Application to experiment deployement process.

```bash
1. Log as super user
2. sudo vi /etc/yum.repos.d/Wandisco-svn.repo
    _Copy this text in the file_:
    [WandiscoSVN]
    name=Wandisco SVN Repo
    baseurl=http://opensource.wandisco.com/centos/$releasever/svn-1.8/RPMS/$basearch/
    enabled=1
    gpgcheck=0
3. save the file by executing this command in the editor: ESC : wq!
4. sudo yum remove subversion // In case we have an old version
5. sudo yum clean all
6. sudo yum install -y subversion
7. svn --version // check the installation
8. sudo vi /etc/yum.repos.d/Wandisco-git.repo
    -Copy this text in the file_:
    [WandiscoGit]
    name=Wandisco GIT Repository
    baseurl=http://opensource.wandisco.com/centos/7/git/$basearch/
    enabled=1
    gpgcheck=1
    gpgkey=http://opensource.wandisco.com/RPM-GPG-KEY-WANdisco
9. save the file by executing this command in the editor: ESC : wq!
10. sudo yum remove git // In case we have an old version
11. sudo yum clean all
12. sudo yum install -y git
13. git --version // check the installation
```

### Retrieve um-pipeline project and the services

This project we use to generate and deploy on this server all the stack. To execute those commands you will need to activate your VPN connection to Rackspace in your Host machine (Your Windows machine).

```bash
1. Log as super user
2. sudo vi /etc/hosts
    Add the following at the end of the file:

3. save the file by executing this command in the editor: ESC : wq!
4. mkdir -p workspace/um/um-pipeline // Create a workspace in your account
5. cd workspace/um // move under the workspace/um directory
6. It will ask for: Store password unencrypted (yes/no)? no // Best practice will say avoid unencrypted password
7. cd um-pipeline/stack
8. Make sure that in docker-compose.yml the services you need are uncommented.
9. ./service.sh build jenkins // Remember you must be in docker group
10. docker images 
     You should see something like:
     REPOSITORY             TAG                 IMAGE ID        CREATED             SIZE
     ghandalf/jenkins     0.0.1-SNAPSHOT      8eef010d326d    About a minute ago  2.96GB
     ghandalf/jenkins     latest              8eef010d326d    About a minute ago  2.96GB
     centos               latest              1e1148e4cc2c    7 weeks ago         202MB
11. ./service.sh build nexus
12. docker images
     You should see something like: // Don\'t worry the Snapshot is a pointer to latest
     REPOSITORY             TAG                 IMAGE ID        CREATED             SIZE
     ghandalf/jenkins     0.0.1-SNAPSHOT      8eef010d326d    About a minute ago  2.96GB
     ghandalf/jenkins     latest              8eef010d326d    About a minute ago  2.96GB
     ghandalf/nexus       0.0.1-SNAPSHOT      8eef010d326d    About a minute ago  2.96GB
     ghandalf/nexus       latest              8eef010d326d    About a minute ago  2.96GB
     centos               latest              1e1148e4cc2c    7 weeks ago         202MB
```

### Startup all containers

The container must be build and deploy locally. We will have to provice a hub to keep those containers versions.

./service.sh start

Keep an eye on the stack trace it is where you will be able to retrieve the password for Jenkins.
You may have the well know problem that have Jenkins, white screen after the first login or after the first configuration. To solve it stop the stack and restart it.

1. sudo yum install pangox-compat pangox-compat-devel

2. sudo yum install -y openvpn easy-rsa
3. sudo cp /usr/share/doc/openvpn-*/sample/sample-config-files/server.conf /etc/openvpn/ // Copy template
4. sudo chown root:openvpn /etc/openvpn/server.conf
5. sudo vi /etc/openvpn/server.conf // We may need to change the DNS access
    push "dhcp-option DNS 8.8.8.8"
    push "dhcp-option DNS 8.8.4.4"
6. sudo mkdir -p /etc/openvpn/easy-rsa/keys
7. sudo cp -rf /usr/share/easy-rsa/3.0.3/* /etc/openvpn/easy-rsa/
8. sudo chown -R root:openvpn /etc/openvpn/
9. sudo vi /etc/openvpn/easy-rsa/vars

### Installing diagnostic tools on guest

1. Log as super user
2. sudo yum install epel-release // Already installed
3. sudo

### Contribution guidelines

* Code review
* Other guidelines

### Technical advice

* Use https://cloud.google.com/knative/, could be very nice to have.

### Resources

* Repo owner: Francis Ouellet, <fouellet@dminc.com>
* Community: um team - Internal project only.
