# Dotfiles
This repo includes most of the dotfiles that i use on every system.

## List of dotfiles

| Path                                                      | Software                                                                      |
| --------------------------------------------------------- | ----------------------------------------------------------------------------- |
| `.dir_colors`                                             | Set colors used by GNU `ls`                                                   |
| `.extend.bashrc`                                          | `bash` / `zsh` configuration file. Includes aliases, env variables, etc.      |
| `.gtkrc-2.0`                                              | `GTK 2` theme configuration                                                   |
| `.nanorc`                                                 | `nano` syntax highlighting                                                    | 
| `.Xresources`                                             | `XServer` DPI and display settings, rofi theme                                | 
| `.yaourtrc`                                               | `yaourt` aur helper configuration                                             | 
| `.zshrc`                                                  | `Z shell` configuration                                                       |
| `.config/blender/../userpref.blend`                       | `blender` 3D software configuration                                           | 
| `.config/Code/User/keybindings.json`                      | `Visual Studio Code` keybindings - [Visual Studio Code](https://code.visualstudio.com/) |
| `.config/Code/User/settings.json`                         | `Visual Studio Code` theme and misc settings - [Visual Studio Code](https://code.visualstudio.com/)
| `.config/gtk-3.0/settings.ini`                            | `GTK 3` theme configuration | 
| `.config/qt5ct/qt5ct.conf`                                | `QT5` Theme configuration |
| `.config/sakura/sakura.conf`                              | `sakura` terminal theme and other settings | 
| `.config/spotify/User/../prefs`                           | `Spotify` configuration | 
| `.config/compton.conf`                                    | `compton` composite manager configuration | 
| `.config/Trolltech.conf`                                  | `QT4` theme configuration | 
| `usr/share/oh-my-zsh/themes/agnoster-custom.zsh-theme`    | `oh-my-zsh` custom theme, based on `agnoster` [oh-my-zsh](https://github.com/robbyrussell/oh-my-zsh)  | 
| `.vim/vimrc`                                              | `vim` configuration | 

## Themes
| Setting       | Theme |
| ------------- | ------ |
| Icons         | [Numix](https://github.com/numixproject/numix-icon-theme)
| Cursor        | `vimix-cursors` | 
| GTK 2 / 3     | [VimixDark-Laptop-Beryl](https://github.com/vinceliuice/vimix-gtk-themes) |
| QT 4 / 5      | Style is set to `GTK` |
| Awesome WM    | Custom theme |
| Rofi          | Custom theme |
| Sakura        | Custom theme |
| vim           | Delek        |

## Fonts
| Where | Font |
| ----- | ---- |
| Terminal (`sakura`) | [Droid Sans Mono for Powerline 11](https://github.com/powerline/fonts) | 
| IDE's, editors, etc | [Source Code Pro](https://github.com/adobe-fonts/source-code-pro) | 
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
- Awesome config
