# Configure a Video Control Room for the Virtual Dev Day

This [Ansible](https://www.ansible.com) playbook configures a server for use as a video control room with [OBS](https://obsproject.com).

The system is controlled remotely through [No Machine](https://www.nomachine.com).

Since our server has an IPMI KVM graphics card that is limited to 1024x768, and nobody is going to look at the screen in the datacenter anyway, we're using [Xvfb](https://www.x.org/releases/X11R7.6/doc/man/man1/Xvfb.1.xhtml) as the X Server.

Ingest RTMP sinks and preview sources are implemented through [NGINX](https://www.nginx.com) with the [nginx-rtmp-module](https://github.com/arut/nginx-rtmp-module).


## Preparing a local environment

1. Install Ruby, for example with `rvm`:
  ```
  \curl -sSL https://get.rvm.io | bash -s stable --ruby
  rvm install 2.6.3
  ```

1. Create a `~/.gemrc` with this contents:
  ```
  gem: --no-document
  ```

1. Install necessary Ruby Gems:
  ```
  bundle install
  ```
1. Install necessary Python environment:
  ```
  pipenv --python 3
  pipenv install
  ```

## Running Kitchen

```
pipenv shell
kitchen converge
kitchen verify
```

## Deploy System

```
ansible-playbook -i hosts.yml playbook.yml
```

## Manual Tasks After Deployment

Some tasks are much easier to accomplish manually than through Ansible. After (initial) deployment, the following steps need to be performed:
* In MATE, the keyboard layout seems to be US even though the German layout is selected. Add the German layout again will make it work.
* Turn off the screen saver and screen blanking (Preferences > Look and Feel > Screen Saver)
* The Mumble Super User password is in `/var/log/mumble-server/mumble-server.log`. Look for a line like `1 => Password for 'SuperUser' set to '7vXwPJcUixZE'`.
* Any OBS setup will need to be imported.

# Notes

## Correct SSH key format for No Machine authentication

The No Machine server is [configured to authenticate users through SSH keys](https://www.nomachine.com/AR02L00785).

The No Machine client does not understand private key files in the OpenSSH format, only ones in PEM format. Use the following command to create one in the correct format:

```
ssh-keygen -m PEM -b 4096 -f roles/devday-regie/files/devday
```

See https://www.nomachine.com/FR05Q03834.
