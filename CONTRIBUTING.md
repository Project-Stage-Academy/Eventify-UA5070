# Setup guide

## ASDF Installation

> [!NOTE]
> These installation steps have been tested on Ubuntu 24.04 LTS and Debian 12 (Bookworm). If you’re using another OS and run into issues, please open an issue or submit a PR with the fix or a short guide.

### 1. Requirements

ASDF installation requires installed `git` and `curl` tools.

```shell
sudo apt-get update
sudo apt-get upgrade
sudo apt-get install -y git curl
```

To build ASDF from source you also need installed Golang with version at least 1.23.4. You can download and install Golang from [here](https://go.dev/doc/install).

### 2. Download ASDF

```shell
cd ~
git clone https://github.com/asdf-vm/asdf.git ~/.asdf --branch v0.18.0
```

### 3. Build ASDF from source

```shell
cd ~/.asdf
make
cp ./asdf ~/.local/bin
```

### 4. Add ASDF to system PATH

**for bash users**

```shell
echo 'export PATH=$HOME:/usr/local/bin:$PATH' >> ~/.bashrc
echo 'export PATH="${ASDF_DATA_DIR:-$HOME/.asdf}/shims:$PATH"' >> ~/.bashrc
```

**for zsh users**

```shell
echo 'export PATH=$HOME:/usr/local/bin:$PATH' >> ~/.bashrc
echo 'export PATH="${ASDF_DATA_DIR:-$HOME/.asdf}/shims:$PATH"' >> ~/.zshrc
```

## Start working on the project

```
git clone https://github.com/Project-Stage-Academy/Eventify-UA5070.git
cd ./Eventify-UA5070
```

### Working on Rails api

In project root run:

```shell
cd ./api
asdf install
bundle install
```

### Working on React SPA

In project root run:

```shell
cd ./web
asdf install
npm install
```
