# SSH Keys

SSH Keys are a replacement for passwords in SSH. SSH are based on RSA cryptography. You get two keys, a public and a private key. A public key can be shared with the whole world. A private key remains secret.

You can compare it to a door with a lock and the key to that lock. You can give the box to anyone you want to communicate with. This person then puts a message in the box and closes the lock. After this, the sender and anyone without the key cannot read the message.
Only you with the key can read it. That's a simple explanation for public-private or asymmetric cryptography.

:::warning reading tip
HTTPS also uses RSA keys in most cases! The website [how https works](https://howhttps.works/) shows this mechanism in a nice comic strip.
:::

These keys are at least 2048 bits long, and take millions of years to brute force. Even in the worst case scenario that someone could build a good quantum computer, it would still take 24 hours (probably...).

## SSH Key auth setup

We are now going to generate an SSH key and use it as a trusted key on our server.

### Review keys

As a first step, we are going to see if we already have an SSH key. On our **client** see if we have an SSH key

```bash
ls ~/.ssh/
```

Here are all our SSH keys, they usually start with the prefix `id_`.

### Create key

We are going to create a key here, we do this with `ssh-keygen`. We will also use `-b` to change the key size from the default 2048 to 4096 bits in order to be more secure. With `-C` we will give our own piece of comment to recognize the key, with our email for example.

```bash
ssh-keygen -t rsa -b 4096 -C your_email@domain.com
```

We follow the instructions, all questions can be left blank.

```
Generating public/private rsa key pair.
Enter file in which to save the key (/home/march/.ssh/id_rsa):
Enter passphrase (empty for no passphrase):
Enter same passphrase again:
Your identification has been saved in /home/maartje/.ssh/id_rsa
Your public key has been saved in /home/maartje/.ssh/id_rsa.pub
The key fingerprint is:
SHA256:hTRTicdLJzAUOczBxNKA9Zqx8u4HDMttCSOqeFnJw5I your_email@domain.com
The key's randomart image is:
+---[RSA 4096]----+
| ooX@O..     |
| . .oX=* .    |
| ..o+.+ |
| . + = ..      |
| . *.O+.S |.
|. E Oo* |.
|o + o..         |
|o o .        |
| . .o. |
+----[SHA256]-----+
```

The output now gives us the path of our public and private key. We also get a fingerprint of the key and this fingerprint also displayed in "art" format. So you can start comparing keys visually.

:::warning note
We don't enter a passphrase in this example, a passphrase will give your SSH key a password. This password will be needed to use your private key. Most security protocols will also require this in case someone can steal your laptop or exfiltrate files. In this course we skip this for ease of use.
:::

Doing another `ls` we are now going to see the keys!

```bash
ls ~/.ssh/
```

output:

```
id_rsa id_rsa.pub
```

We now view the id_rsa.pub with notepad, you get a text starting with `ssh-rsa`. We copy this text because we are going to need it in a moment!

### Set keys on server

Now we SSH to our server and set the keys to our user.

```bash
ssh ubuntu@[ip]
```

We now create the `.ssh` folder and open the file `authorized_keys` in this folder.

```bash
mkdir ~/.ssh
nano ~/.ssh/authorized_keys
```

Paste your public key here. This file can contain several SSH keys, one per line. All of these will then have access to your user on the server.

Save and close the file.
Now we change the permissions correctly for extra security.

```bash
chmod 700 ~/.ssh
chmod 644 ~/.ssh/authorized_keys
```

### Testing keys

To test the keys, we first exit the SSH session.

```bash
exit
```

And we SSH again.

```bash
ssh ubuntu@[ip]
```

Now if you don't get a password prompt everything worked out!

## Passwords disable

:::warning note
Only do these steps if you know your SSH keys are working, don't lock yourself out!
:::

We have already seen that passwords are not that secure so we better always disable them too!

We do this in the `/etc/ssh/sshd_config` file.

```bash
sudo nano /etc/ssh/sshd_config
```

:::warning note
Do not confuse this file with `/etc/ssh/ssh_config`! This is 1 letter difference, the `sshd` is for our server, the `ssh` is for the client.
:::

We now want to turn off the `PasswordAuthentication` option. While we're at it we'll also immediately disable the login with the user `root`.

Find and replace the following lines, if you do not find them add them at the bottom:

```
PasswordAuthentication no
PermitRootLogin no
```

Save the file and close it.

Now we restart the SSH server to load the new configuration:

```bash
sudo systemctl restart sshd
```

### Testing

We can also quickly test this for secure configuration by SSHing from the server to the server itself. After all, the server does not know your private key so would not be able to log in by itself.

```bash
ssh ubuntu@localhost
```
