# wsl.kickstart
if you work with windows sybsystem for linux and simple shell script that installs neovim + kickstarter ,  sdkman , java , gradle , kotlin  , zsh  + starship, rust

Install Power Shell ( as Admin ) 

```
winget install --id Microsoft.Powershell --source winget

``` 
Install wsl 

```
wsl --install -d Ubuntu-24.04
```

clone the repo into wsl 

```
git clone https://github.com/WOCOMLABS/wsl.kickstart ~/.config/wsl && \
cd ~/.config/wsl && \
chmod +x init.sh init_jvm.sh init_js.sh && \
./init.sh
```



