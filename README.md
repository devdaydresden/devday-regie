# Configure a Video Control Room for the Virtual Dev Day

This [Ansible](https://www.ansible.com) playbook configures a server for use as a video control room with [OBS](https://obsproject.com).

The system is controlled remotely through [No Machine](https://www.nomachine.com).

Since our server has an IPMI KVM graphics card that is limited to 1024x768, and nobody is going to look at the screen in the datacenter anyway, we're using [Xvfb](https://www.x.org/releases/X11R7.6/doc/man/man1/Xvfb.1.xhtml) as the X Server.

Ingest RTMP sinks and preview sources are implemented through [NGINX](https://www.nginx.com) with the [nginx-rtmp-module](https://github.com/arut/nginx-rtmp-module).

We're using [CodiMD](https://github.com/hackmdio/codimd) as a pad software:
* To allow participants ask questions about a talk. We felt this is much easier to manage than a live chat stream.
* Curate some additional information for participants.
* As an internal tool for organizing the event.
* For producing the intermission slide show. CodiMD allows you to create a document that can be shown as a slide show, including background images. The intermission slides were created this way, including the "up next" slide, which we edited during the event. In OBS, we added this as a browser source together with some music.


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
* Make sure Alt Left Click is not bound by the window manager: go to Preferences > Look and Feel > Windows, Behaviour, Movement Key: Select Super. If the window manager take alt-click, you won't be able to adjust the crop of video sources by alt-dragging. You need to restart OBS for it to start receiving these events.
* The Mumble Super User password is in `/var/log/mumble-server/mumble-server.log`. Look for a line like `1 => Password for 'SuperUser' set to '7vXwPJcUixZE'`.
* Any OBS setup will need to be imported.
* CodiMD users need to be created. CodiMD is configured to not allow self-registration, and the default rights are set so that only users can create new notes (pads). Use `docker-compose exec codimd bin/manage_users` to create users and set their initial password.

# Notes

## Notes for Directors

The [REGIE.md](./REGIE.md) document (German) has some notes the directors used during the event.


## Correct SSH key format for No Machine authentication

The No Machine server is [configured to authenticate users through SSH keys](https://www.nomachine.com/AR02L00785).

The No Machine client does not understand private key files in the OpenSSH format, only ones in PEM format. Use the following command to create one in the correct format:

```
ssh-keygen -m PEM -b 4096 -f roles/devday-regie/files/devday
```

See https://www.nomachine.com/FR05Q03834.


## nginx-rtmp Version

We've had problems with the RTMP streams: sometimes the OBS-builtin VLC RTMP client would have trouble re-establishing the stream after it was stopped; this included no stream at all, or garbled or missing video.

It seems that [nginx-rtmp-module](https://github.com/arut/nginx-rtmp-module) is not maintained anymore; there are close to 3000 forks of that repo. Some research into a better maintained version likely would be helpful with this.


## No Audio Monitoring For Preview in OBS

In one instance, the speaker was not sending audio with his stream. We were receiving his video, and he confirmed that his OBS audio meter was showing a signal, but he had played with the advanced audio settings and has disabled sending his audio to the stream. In OBS, you get to see the next scene in the preview, but there doesn't seem to be a way to get any information about audio until it's part of the program output. If we'd do this again, we would try to get a (separate) RTMP viewer up and running alongside OBS that would show us the ingest video and allow monitoring the audio. Alternatively, if OBS could be extended to also show audio sources for the preview in the audio meter section, that would be super helpful.

## Docker Compose Setup

The Docker Compose configuration in `roles/devday-regie/files/compose/docker-compose.yml` uses a Traefik config with a domain name of `127.0.0.1.nip.io`. This allows you to run a test setup right out of that directy. On deployment to the production host with Ansible, the domain is replaced with the production value. The kitchen setup replaces the domain with one that can be reached from the host machine.
