# Usage

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
