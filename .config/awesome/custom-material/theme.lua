-----------------------------------
-- custom-material awesome theme --
-----------------------------------
local gears = require("gears")
local awful = require("awful")
local wibox = require("wibox")
local lain = require("lain")

local theme = {}
local button_table = awful.util.table

theme.scaling = 1.75

theme_path = "~/.config/awesome/custom-material/"
default_color = "#282A30"
default_focus_color = "#555555"

theme.font          = "Cantarell 10"

-- Recurring colors
theme.orange = "#fc7440"
theme.green = "#a0d468"
theme.blue = "#4fc0e9"
theme.red = "#f00"

theme.bg_normal     = default_color
theme.bg_focus      = default_color
theme.titlebar_bg_focus = default_color
theme.taglist_bg_focus = "#555555"
theme.bg_urgent     = theme.orange
theme.bg_minimize   = "#3c5a6b"
theme.bg_systray    = default_focus_color

theme.fg_normal     = "#cccccc"
theme.fg_focus      = "#ffffff"
theme.fg_urgent     = "#ffffff"
theme.fg_minimize   = "#ffffff"

theme.useless_gap   = 4 * theme.scaling
theme.gap_single_client = false
theme.border_width  = 2 * theme.scaling
theme.border_normal = "#242424"
theme.border_focus  = "#555555"
theme.border_marked = "#242424"

-- Display the taglist squares
theme.taglist_squares_sel   = theme_path .. "taglist/bar_active.png"
theme.taglist_squares_unsel = theme_path .. "taglist/bar_inactive.png"

-- Layouts
theme.layout_tile = theme_path .."/layouts/tilew.png"
theme.layout_floating  = theme_path .."/layouts/floatingw.png"
theme.layout_fairv = theme_path .."/layouts/fairvw.png"
theme.layout_tilebottom = theme_path .."/layouts/tilebottomw.png"

-- Variables set for theming the menu:
theme.menu_submenu_icon = theme_path .. "submenu.png"
theme.menu_height = 20 * theme.scaling
theme.menu_width  = 150 * theme.scaling

-- Icons
theme.icon_theme = Numix
theme.tasklist_disable_icon = true

theme.mem_icon = theme_path .. "icons/mem_icon_v2.png"
theme.cpu_icon = theme_path .. "icons/cpu_icon_v2.png"
theme.temp_icon = theme_path .. "icons/temp_icon_v2.png"
theme.bat_icon = theme_path .. "icons/bat_icon.png"
theme.awesome_icon = theme_path .. "awesome32.png"

theme.wallpaper = theme_path .. "/wallpaper/wall.png"

theme.wibar_height = 26 * theme.scaling

return theme
