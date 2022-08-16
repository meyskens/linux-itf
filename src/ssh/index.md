# Remote access via SSH

When we perform work on a server in practice, we will rarely, if ever, have physical access to our server.
It may be located in a data room far away in a building or even on the other side of the world.
Since most companies use the cloud, there is little even known where this server is running.

In short, we need a secure way to configure and manage our servers. From the networking classes you probably already know Telnet and SSH. In the Linux world SSH is mostly used exclusively. SSH has gained popularity mainly because of the good security of the protocol. But it also offers useful functions such as: sending files, forwarding network traffic and more.

If you run a server in the cloud then you will usually get an SSH login to further set up the server.

## Setting up SSH

### Installation

::: warning note
Most Linux servers already have an SSH server installed. This is the case for our VMs. The following instructions are for your information, or if you want to use SSH on an Ubuntu Desktop.
:::

We inset our SSH server via `apt`

```bash
apt install ssh openssh-server # Install SSH via apt
systemctl status ssh # check the status of ssh
```

### SSH clients

Now that we have an SSH server we will also need an SSH client

#### Windows

In the past, [PuTTY](https://www.chiark.greenend.org.uk/~sgtatham/putty/download.html) was the best option for SSH on Windows.
However, since recent versions of Windows 10, Microsoft has also built in an SSH client! You can green it with the `ssh` command in PowerShell or CMD.

However, we recommend the new [Microsoft Terminal](https://www.microsoft.com/en-us/p/windows-terminal/9n0dx20hk701#activetab=pivot:overviewtab). This Terminal allows you (after 20 years finally) to use the different Windows command line interfaces together and to adapt them to your own preferences! And is therefore much more user friendly than PowerShell alone. You can even use it in combination with Git Bash to have a Bash shell on Windows, which will be very convenient for our purposes.

[Windows Terminal](./terminal.png)

#### macOS

macOS has an SSH client built in. You can use it by just opening the Terminal app.

#### Linux

First of all congratualations on your choice of desktop OS! Most Linux installations come with an SSH client by default. If you don't have this command available, you can download it from your package manager. The example below is for Ubuntu:

```bash
apt update
apt install ssh
```

### Connecting to your server

The SSH command has a simple structure:

```
ssh [options] [user@]hostname
```

First the word `ssh` followed by any options, we are hardly going to use these. Then comes the user name and hostname.

For example, we want to log on with the user `ubuntu` to the server `10.0.0.1`.

```bash
ssh ubuntu@10.0.0.1
```

We try this out with our own server. Immediately after this we get a question

```
The authenticity of host '10.0.0.1 (10.0.0.1)' can't be established.
ED25519 key fingerprint is SHA256:pc8xxMRaW8kmA/p+GUXoi1dR2CQBlGpUfIXT2Ypde0I.
Are you sure you want to continue connecting (yes/no/[fingerprint])?
```

The first time you connect to a server you are asked if you trust this server.
We type `yes` followed by enter. This succeeds in capturing the fingerprint of our SSH server's key. This way we know for sure that the next time we connect we are talking to the same server!

::: warning note
If you reinstall your server or change the IP you may get the following message. If you are sure you have changed your server's SSH keys you may follow the remove instructions that will remove the fingerprint from your trust store.

```
@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
@ WARNING: REMOTE HOST IDENTIFICATION HAS CHANGED! @
@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
IT IS POSSIBLE THAT SOMEONE IS DOING SOMETHING NASTY!
Someone could be eavesdropping on you right now (man-in-the-middle attack)!
It is also possible that a host key has just been changed.
The fingerprint for the ED25519 key sent by the remote host is
SHA256:pc8xxMRaW8kmA/p+GUXoi1dR2CQBlGpUfIXT2Ypde0I.
Please contact your system administrator.
Add correct host key in /home/maartje/.ssh/known_hosts to get rid of this message.
Offending ED25519 key in /home/maartje/.ssh/known_hosts:503
remove with:
ssh-keygen -f "/home/maartje/.ssh/known_hosts" -R "10.0.0.1"
ED25519 host key for 10.0.0.1 has changed and you have requested strict checking.
Host key verification failed.
```

:::

Next, your server is going to ask for your password:

```
$ ssh ubuntu@10.0.0.1
ubuntu@10.0.0.1's password:

```

Enter this. Note that SSH cares about your security and doesn't even show asterisks for the password, so if you don't see anything it's normal! Then press enter and you are now connected to the server! After this you can work as usual on a Linux machine! You can also copy-paste between the machines (very convenient, isn't it?).

### Security

SSH is a non-encrypted protocol, which ensures that all data including passwords is encrypted over the network. Access to our server is password protected. But is a password such a good idea?

We put an SSH server on the public Internet with password access for 5 minutes to demonstrate:

```
Disconnected from invalid user ki 165.227.163.85 port 42826 [preauth]
Disconnected from invalid user 212.83.34.253 46.101.18.46 port 60404 [preauth]
Disconnected from invalid user 212.109.218.126 46.101.18.46 port 57008 [preauth]
Disconnected from invalid user nazrul 189.112.196.1 port 43620 [preauth]
Disconnected from invalid user qs 189.203.72.138 port 54980 [preauth]
Disconnected from invalid user carmita 40.73.67.85 port 54654 [preauth]
Disconnected from invalid user ih 106.52.69.233 port 48708 [preauth]
Disconnected from invalid user cpanelphppgadmin 175.193.13.3 port 51698 [preauth]
Disconnected from invalid user sherlock 81.68.216.148 port 49656 [preauth]
Disconnected from invalid user huang 106.12.102.54 port 37918 [preauth]
Disconnected from invalid user 212.32.236.145 46.101.18.46 port 44656 [preauth]
Disconnected from invalid user 212.83.56.230 46.101.18.46 port 41260 [preauth]
Disconnected from invalid user 212.227.164.149 46.101.18.46 port 37866 [preauth]
Disconnected from invalid user ubuntu 222.191.234.30 port 52560 [preauth]
Disconnected from invalid user 212.50.10.86 46.101.18.46 port 34490 [preauth]
Disconnected from invalid user 212.47.245.76 46.101.18.46 port 59314 [preauth]
Disconnected from invalid user blitzklo 81.68.234.113 port 46332 [preauth]
Disconnected from invalid user alex 139.155.17.74 port 48812 [preauth]
Disconnected from invalid user zhonghaoxi 111.229.48.141 port 33242 [preauth]
Disconnected from invalid user mssql 118.126.90.104 port 54764 [preauth]
Disconnected from invalid user hanji 142.93.103.141 port 37194 [preauth]
Disconnected from invalid user y 49.233.204.226 port 60976 [preauth]
Disconnected from invalid user yw 200.73.132.237 port 46766 [preauth]
Disconnected from invalid user postgres 112.78.3.39 port 49906 [preauth]
Disconnected from invalid user mapred 152.182.83.182 port 52084 [preauth]
Connection closed by invalid user user 87.251.77.206 port 23028 [preauth]
Connection closed by invalid user 87.251.77.206 port 22948 [preauth]
Connection closed by invalid user admin 87.251.77.206 port 23012 [preauth]
Disconnected from invalid user postgres 45.43.62.224 port 43358 [preauth]
Disconnected from invalid user azureuser 47.74.44.224 port 38802 [preauth]
Disconnected from invalid user svnuser 46.101.245.176 port 49294 [preauth]
Disconnected from invalid user 212.19.110.50 46.101.18.46 port 50360 [preauth]
Disconnected from invalid user 212.112.252.10 46.101.18.46 port 46924 [preauth]
Disconnected from invalid user 212.227.72.105 46.101.18.46 port 43518 [preauth]
Disconnected from invalid user 212.227.254.56 46.101.18.46 port 40090 [preauth]
Disconnected from invalid user 212.114.109.186 46.101.18.46 port 36686 [preauth]
Disconnected from invalid user 212.57.32.29 46.101.18.46 port 37644 [preauth]
Disconnected from invalid user 212.35.202.82 46.101.18.46 port 34252 [preauth]
Disconnected from invalid user 212.47.239.116 46.101.18.46 port 59110 [preauth]
Disconnected from invalid user 212.22.77.69 46.101.18.46 port 55718 [preauth]
Connection closed by invalid user admin 185.156.74.65 port 18857 [preauth]
Connection closed by invalid user admin 185.156.74.65 port 19119 [preauth]
Disconnected from invalid user 212.48.103.101 46.101.18.46 port 52266 [preauth]
Disconnected from invalid user erobertparker 123.122.161.237 port 38390 [preauth]
Disconnected from invalid user 212.48.103.33 46.101.18.46 port 53274 [preauth]
Disconnected from invalid user 212.227.165.193 46.101.18.46 port 49854 [preauth]
Disconnected from invalid user 212.71.254.250 46.101.18.46 port 46474 [preauth]
Disconnected from invalid user 212.44.102.72 46.101.18.46 port 43046 [preauth]
Disconnected from invalid user 212.227.198.22 46.101.18.46 port 39616 [preauth]
Disconnected from invalid user df 106.55.26.195 port 41548 [preauth]
Disconnected from invalid user rj 51.91.77.103 port 37476 [preauth]
Disconnected from invalid user bob 121.204.153.151 port 54550 [preauth]
Disconnected from invalid user daisy 87.103.126.98 port 60432 [preauth]
Disconnected from invalid user 212.91.190.199 46.101.18.46 port 37216 [preauth]
Disconnected from invalid user 212.97.58.191 46.101.18.46 port 33810 [preauth]
Disconnected from invalid user 212.47.228.156 46.101.18.46 port 58644 [preauth]
Disconnected from invalid user mf 178.128.111.172 port 40014 [preauth]
Disconnected from invalid user 212.237.35.145 46.101.18.46 port 55228 [preauth]
Disconnected from invalid user wayne 216.24.178.253 port 51760 [preauth]
Disconnected from invalid user qdgw 103.205.7.84 port 54228 [preauth]
Disconnected from invalid user 212.114.34.165 46.101.18.46 port 51818 [preauth]
Disconnected from invalid user admin 45.155.205.86 port 46523 [preauth]
Disconnected from invalid user 212.8.99.46 46.101.18.46 port 52806 [preauth]
Disconnected from invalid user 212.48.80.201 46.101.18.46 port 49412 [preauth]
Disconnected from invalid user 212.51.150.247 46.101.18.46 port 45990 [preauth]
Disconnected from invalid user 212.237.46.25 46.101.18.46 port 42550 [preauth]
Disconnected from invalid user 212.109.195.227 46.101.18.46 port 39144 [preauth]
Disconnected from invalid user jezebel 106.52.9.154 port 48232 [preauth]
Disconnected from invalid user nx 152.32.212.62 port 43808 [preauth]
Disconnected from invalid user gaochangfeng 49.235.252.236 port 55946 [preauth]
Disconnected from invalid user 212.64.77.213 46.101.18.46 port 40076 [preauth]
Disconnected from invalid user 212.59.77.214 46.101.18.46 port 36678 [preauth]
Disconnected from invalid user 212.129.53.204 46.101.18.46 port 33266 [preauth]
Disconnected from invalid user cr 111.20.195.30 port 60020 [preauth]
Disconnected from invalid user rsync 159.203.63.125 port 35736 [preauth]
Disconnected from invalid user 212.237.21.219 46.101.18.46 port 58106 [preauth]
Disconnected from invalid user 212.189.205.163 46.101.18.46 port 54680 [preauth]
Disconnected from invalid user avatar 106.75.156.212 port 49438 [preauth]
Disconnected from invalid user cr 222.173.82.126 port 2316 [preauth]
Disconnected from invalid user 212.248.42.179 46.101.18.46 port 55548 [preauth]
Disconnected from invalid user ql 107.182.191.188 port 54336 [preauth]
Disconnected from invalid user 212.237.17.240 46.101.18.46 port 52156 [preauth]
Disconnected from invalid user 212.71.255.91 46.101.18.46 port 48750 [preauth]
Disconnected from invalid user 212.0.159.180 46.101.18.46 port 45336 [preauth]
Disconnected from invalid user 212.83.56.135 46.101.18.46 port 41944 [preauth]
Disconnected from invalid user jira 42.194.132.178 port 42890 [preauth]
Disconnected from invalid user 212.103.62.233 46.101.18.46 port 42914 [preauth]
Disconnected from invalid user shonta 177.184.75.130 port 45296 [preauth]
Connection closed by invalid user admin 87.251.77.206 port 54638 [preauth]
Connection closed by invalid user 87.251.77.206 port 54518 [preauth]
Connection closed by invalid user user 87.251.77.206 port 54642 [preauth]
Disconnected from invalid user 212.34.129.107 46.101.18.46 port 39548 [preauth]
Disconnected from invalid user 212.95.141.233 46.101.18.46 port 36104 [preauth]
Disconnected from invalid user 212.227.255.176 46.101.18.46 port 60906 [preauth]
Disconnected from invalid user 212.224.112.20 46.101.18.46 port 57450 [preauth]
Disconnected from invalid user janne 109.80.128.210 port 34773 [preauth]
Disconnected from invalid user user 157.230.224.52 port 44888 [preauth]
Disconnected from invalid user dale 167.172.38.238 port 49386 [preauth]
Disconnected from invalid user shalene 132.232.47.59 port 58536 [preauth]
Disconnected from invalid user 212.64.72.99 46.101.18.46 port 33514 [preauth]
Disconnected from invalid user uc 106.53.150.113 port 52105 [preauth]
Disconnected from invalid user 212.214.101.152 46.101.18.46 port 58338 [preauth]
Disconnected from invalid user 212.64.69.31 46.101.18.46 port 54890 [preauth]
Disconnected from invalid user vpn 178.128.150.146 port 60730 [preauth]
Disconnected from invalid user 212.129.38.200 46.101.18.46 port 51484 [preauth]
Disconnected from invalid user hp 203.177.71.254 port 36212 [preauth]
Disconnected from invalid user 212.64.48.90 46.101.18.46 port 48062 [preauth]
Disconnected from invalid user mia 46.101.164.5 port 50818 [preauth]
Disconnected from invalid user 212.116.121.128 46.101.18.46 port 52338 [preauth]
Disconnected from invalid user 212.162.14.14 46.101.18.46 port 48904 [preauth]
Disconnected from invalid user 212.227.63.117 46.101.18.46 port 45476 [preauth]
Disconnected from invalid user 212.111.216.11 46.101.18.46 port 42050 [preauth]
Disconnected from invalid user 212.218.192.60 46.101.18.46 port 38622 [preauth]
Disconnected from invalid user neel 80.240.138.115 port 38554 [preauth]
Disconnected from invalid user verity 134.175.219.148 port 59880 [preauth]
Disconnected from invalid user charles 106.13.75.187 port 38448 [preauth]
Disconnected from invalid user emia 186.151.197.189 port 59182 [preauth]
Disconnected from invalid user janne 111.229.235.119 port 57154 [preauth]
```

Botnets are constantly scanning for SSH servers to test out every possible password. Why are they likely to get in? [We'll look at this in the Password Security chapter](/security/passwords)

So how do we get an SSH server secure on the Internet? We're going to use [SSH Keys](/security/ssh-keys).

## The next generation: MOSH

[MOSH](https://mosh.org/) (mobile shell) is seen as a successor to SSH. MOSH mainly comes from the problem of SSH connections on connections which can break (read: 4G connection on the train, walking around between different AP points or very dynamic IP addresses). An SSH connection will also break if your IP changes.

Advantages of MOSH over SSH are:

- Does not run as privileged user
- Designed for UTF-8 character set
- Builds on SSH Security
- Uses UDP with its own packet-loss detection
- Can be resumed indefinitely
