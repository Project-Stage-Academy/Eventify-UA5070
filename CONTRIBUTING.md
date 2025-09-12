# Setup guide

## Ruby

### rbenv install

##### 1. Install build tools and libraries

```shell
sudo apt-get update
sudo apt-get upgrade
sudo apt-get install -y git curl build-essential libssl-dev \
libreadline-dev zlib1g-dev libyaml-dev libffi-dev libgdbm-dev \
libdb-dev uuid-dev
```

##### 2. Install rbenv

**for bash users**

```shell
cd ~
git clone https://github.com/rbenv/rbenv.git ~/.rbenv
echo 'export PATH="$HOME/.rbenv/bin:$PATH"' >> ~/.bashrc
echo 'eval "$(rbenv init - bash)"' >> ~/.bashrc
exec $SHELL -l
```

**for zsh users**

```shell
cd ~
git clone https://github.com/rbenv/rbenv.git ~/.rbenv
echo 'export PATH="$HOME/.rbenv/bin:$PATH"' >> ~/.zshrc
echo 'eval "$(rbenv init - bash)"' >> ~/.zshrc
exec $SHELL -l
```

##### 3. Install ruby-build

```shell
mkdir -p "$(rbenv root)"/plugins
git clone https://github.com/rbenv/ruby-build.git "$(rbenv root)"/plugins/ruby-build
```

##### 4. Install Ruby

```shell
rbenv install 3.4.5
rbenv global 3.4.5
rbenv rehash
```

##### 5. Install Bundler

```shell
gem install bundler
rbenv rehash
```

### API gems install

```shell
git clone https://github.com/Project-Stage-Academy/Eventify-UA5070.git
cd ./Eventify-UA5070/api
bundle install
```

## React

### npm install

##### 1. Install nvm via curl

```shell
curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.40.3/install.sh | bash
```

##### 2. Install Node

```shell
nvm install 22
```

### Install React project deps

```shell
git clone https://github.com/Project-Stage-Academy/Eventify-UA5070.git
cd ./Eventify-UA5070/web
npm install
```
