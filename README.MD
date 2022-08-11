# Dotfiles
This repo includes most of the dotfiles that i use on every system.

## List of dotfiles

| Path                                                      | Software                                                                      |
| --------------------------------------------------------- | ----------------------------------------------------------------------------- |
| `.dir_colors`                                             | Set colors used by GNU `ls`                                                   |
| `.extend.bashrc`                                          | `bash` / `zsh` configuration file. Includes aliases, env variables, etc.      |
| `.Xresources`                                             | `XServer` DPI and display settings, rofi theme                                | 
| `.zshrc`                                                  | `Z shell` configuration                                                       |
| `.config/sakura/sakura.conf`                              | `sakura` terminal theme and other settings | 
| `usr/share/oh-my-zsh/themes/agnoster-custom.zsh-theme`    | `oh-my-zsh` custom theme, based on `agnoster` [oh-my-zsh](https://github.com/robbyrussell/oh-my-zsh)  | 
| `.vim/vimrc`                                              | `vim` configuration |
| `.config/awesome`                                         | `awesomewm` configuration |

## Themes
| Setting       | Theme |
| ------------- | ------ |
| Icons         | Papirus-Dark |
| Cursor        | [vimix-cursors](https://github.com/vinceliuice/Vimix-cursors) | 
| GTK 2 / 3     | Matcha-dark-azul |
| Awesome WM    | Custom theme |
| Rofi          | Custom theme |
| Sakura        | Custom theme |
| vim           | deus        |

## Fonts
| Where | Font |
| ----- | ---- |
| Terminal (`sakura`) | [Hack](https://github.com/source-foundry/Hack) | 
| IDE's, editors, etc | [Hack](https://github.com/source-foundry/Hack) | 
| GTK/QT Applications | `Noto Sans`

## Vim setup
1. Install [vim-plug](https://github.com/junegunn/vim-plug)
```
curl -fLo ~/.vim/autoload/plug.vim --create-dirs \
    https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
```
2. Copy `.vim/vimrc` to `~/.vim/vimrc` (or to `~/.vimrc`)
3. Open `vim`
4. Run `:PlugInstall`
5. Restart vim

## TODO
- Screenshot
