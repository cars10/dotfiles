# Dotfiles

This repo includes most of the dotfiles that i use on every system.

## Wayland setup (niri + Dux Shell)

niri (scrollable tiling, per-monitor workspaces) + Dux Shell / DMS (bar, launcher, notifications,
lock screen, idle) + dux-greeter on greetd. Fresh machine from an old river/LightDM setup:

```bash
# 1. Packages
sudo pacman -S --needed niri xwayland-satellite dux-shell quickshell dux-gop matugen cliphist \
  wl-clipboard cava qt6-multimedia greetd xdg-desktop-portal-gnome xdg-desktop-portal-gtk foot \
  adw-gtk-theme kimageformats   # adw-gtk-theme: needed for DMS "Apply GTK colors" (Qt follows via gtk3 passthrough)
yay -S dux-greeter-bin dux-search-bin
# desktop only, optional: external monitor brightness via DDC in DMS
# sudo pacman -S i2c-tools && echo i2c-dev | sudo tee /etc/modules-load.d/i2c-dev.conf
# laptop only, fingerprint (Synaptics 06cb:009a needs python-validity, never install with fprintd):
# yay -S python-validity open-fprintd fprintd-clients-git

# 2. Configs (link per file; DMS writes its own fragments into ~/.config/niri/dms/)
mkdir -p ~/.config/niri/dms ~/.config/foot ~/.config/dms
# niri and foot refuse to start if an included file is missing; DMS fills these later
touch ~/.config/niri/dms/{colors,layout,alttab,cursor,windowrules,outputs,binds,input}.kdl
touch ~/.config/foot/dank-colors.ini
ln -s ~/Projects/dotfiles/.config/niri/config.kdl ~/.config/niri/config.kdl
ln -s ~/Projects/dotfiles/.config/niri/hosts ~/.config/niri/hosts
ln -s hosts/desktop.kdl ~/.config/niri/host.kdl          # laptop: hosts/laptop.kdl
ln -sf ~/Projects/dotfiles/.config/foot/foot.ini ~/.config/foot/foot.ini
niri validate
# DMS settings: copy, don't link (DMS rewrites them, the greeter reads them via ACLs)
cp ~/Projects/dotfiles/.config/dms/{settings.json,plugin_settings.json} ~/.config/dms/
# old Arc theme symlinks block DMS GTK4 colors
[ -L ~/.config/gtk-4.0/gtk.css ] && rm ~/.config/gtk-4.0/gtk.css ~/.config/gtk-4.0/gtk-dark.css
systemctl --user daemon-reload
dms systemd enable --compositor niri

# 3. Test from a TTY first (Ctrl+Alt+F2, log in), LightDM keeps running
niri-session
#   inside: niri msg outputs  -> fix names/modes in hosts/desktop.kdl if they differ
#           dms doctor
#           dms plugins restore ~/Projects/dotfiles/.config/dms/plugins.lock.json
#           DMS Settings -> Theme & Colors: re-apply GTK colors once

# 4. Login manager: copy, don't symlink (root-owned PAM/greetd files)
sudo cp ~/Projects/dotfiles/etc/greetd/config.toml /etc/greetd/config.toml
sudo cp ~/Projects/dotfiles/etc/pam.d/greetd /etc/pam.d/greetd   # adds gnome-keyring unlock
dms-greeter sync                     # then log out/in once (greeter group)
sudo systemctl disable lightdm
sudo systemctl enable greetd
reboot
# rollback from Ctrl+Alt+F2: sudo systemctl disable greetd && sudo systemctl enable lightdm && reboot

# 5. Remove the old stack (check pacman's list before confirming; skip what isn't installed)
sudo pacman -Rsn river-classic waybar mako fuzzel wbg pamixer libinput-gestures xdotool \
  awesome lain-git rofi rofi-emoji dmenu sakura arandr lxappearance numlockx xorg-xinit dunst \
  lightdm lightdm-slick-greeter eos-lightdm-slick-theme \
  xfce4-notifyd xfce4-power-manager polkit-gnome network-manager-applet blueberry-wayland pasystray
rm -f ~/.config/autostart/libinput-gestures.desktop
rm -rf ~/.config/{river,waybar,fuzzel,mako,awesome,i3,rofi,sakura,dunst}
```

Fingerprint (laptop): `fprintd-enroll`, `fprintd-verify`, then DMS Settings -> Lock Screen.
`etc/pam.d/fingerprint.snippet` has the optional sudo/polkit line. Login stays password-only so the keyring unlocks.

## List of dotfiles

| Path                                                   | Software                                                                                             |
| ------------------------------------------------------ | ---------------------------------------------------------------------------------------------------- |
| `.extend.bashrc`                                       | `bash` / `zsh` configuration file. Includes aliases, env variables, etc.                             |
| `.zshrc`                                               | `Z shell` configuration                                                                              |
| `usr/share/oh-my-zsh/themes/agnoster-custom.zsh-theme` | `oh-my-zsh` custom theme, based on `agnoster` [oh-my-zsh](https://github.com/robbyrussell/oh-my-zsh) |
| `.config/niri`                                         | `niri` config, machine-specific outputs in `hosts/`                                                  |
| `.config/foot/foot.ini`                                | `foot` terminal (includes DMS-generated colors)                                                      |
| `.config/dms`                                          | DMS settings snapshot, copy (not link); refresh with `cp ~/.config/dms/{settings,plugin_settings,plugins.lock}.json .config/dms/` |
| `etc/`                                                 | greetd + PAM files, copy to `/etc`                                                                   |
| `.vim/vimrc`                                           | `vim` configuration                                                                                  |

## Themes

| Setting    | Theme                                                         |
| ---------- | ------------------------------------------------------------- |
| Icons      | Papirus-Dark                                                  |
| Cursor     | [vimix-cursors](https://github.com/vinceliuice/Vimix-cursors) |
| GTK 2 / 3  | Matcha-dark-azul                                              |
| vim        | deus                                                          |

## Fonts

| Where               | Font                                           |
| ------------------- | ---------------------------------------------- |
| Terminal (`foot`)   | [Hack](https://github.com/source-foundry/Hack) |
| IDE's, editors, etc | [Hack](https://github.com/source-foundry/Hack) |
| GTK/QT Applications | `Noto Sans`                                    |

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
