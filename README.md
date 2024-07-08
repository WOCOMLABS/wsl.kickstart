# wsl.kickstart
if you work with windows sybsystem for linux and simple shell script that installs neovim + kickstarter ,  sdkman , java , gradle , kotlin  , zsh  + starship, rust

Install Power Shell ( as Admin ) 

```bash
winget install --id Microsoft.Powershell --source winget

```

List available distros 

```bash
wsl --list --online
```

Install wsl 

```bash
wsl --install -d Ubuntu-24.04
```

setup your git ( Optional )
```bash
git config --global user.name "Jonh Doe" && \
git config --global user. Email john.doe@domain.com && \
git config --global --unset credential.helper && \
git config --global credential.helper store

```

clone the repo into wsl 

```bash
git clone https://github.com/WOCOMLABS/wsl.kickstart ~/.config/wsl && \
cd ~/.config/wsl && \
chmod u+x init.sh init_jvm.sh init_js.sh && \
./init.sh
```



