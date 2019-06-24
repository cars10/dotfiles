-- Standard awesome library
local gears = require("gears")
local awful = require("awful")
require("awful.autofocus")
-- Widget and layout library
local wibox = require("wibox")
-- Theme handling library
local beautiful = require("beautiful")
local lain = require("lain")
local separators = lain.util.separators
-- Notification library
local naughty = require("naughty")
local menubar = require("menubar")
local hotkeys_popup = require("awful.hotkeys_popup").widget
local button_table = awful.util.table
local markup = lain.util.markup
local math = require("math")

local xf86helpers = require("xf86helpers")

-- {{{ Error handling
-- Check if awesome encountered an error during startup and fell back to
-- another config (This code will only ever execute for the fallback config)
if awesome.startup_errors then
    naughty.notify({ preset = naughty.config.presets.critical,
                     title = "Oops, there were errors during startup!",
                     text = awesome.startup_errors })
end

-- Handle runtime errors after startup
do
    local in_error = false
    awesome.connect_signal("debug::error", function (err)
        -- Make sure we don't go into an endless error loop
        if in_error then return end
        in_error = true

        naughty.notify({ preset = naughty.config.presets.critical,
                         title = "Oops, an error happened!",
                         text = tostring(err) })
        in_error = false
    end)
end
-- }}}

-- Autostart
awful.util.spawn_with_shell("~/.config/awesome/autostart.sh &")

-- {{{ Variable definitions
-- Themes define colours, icons, font and wallpapers.
beautiful.init("~/.config/awesome/custom-material/theme.lua")
local arrow_systray = separators.arrow_left(beautiful.bg_systray, "alpha")
local arrow_systray_inv = separators.arrow_left("alpha", beautiful.bg_systray)
separators.width = 12

-- This is used later as the default terminal and editor to run.
terminal = "sakura"
editor = os.getenv("EDITOR") or "vim"
editor_cmd = terminal .. " -e " .. editor
modkey = "Mod4"

-- Table of layouts to cover with awful.layout.inc, order matters.
awful.layout.layouts = {
    awful.layout.suit.tile,
    -- awful.layout.suit.tile.left,
    awful.layout.suit.tile.bottom,
    awful.layout.suit.fair,
    awful.layout.suit.floating,
    -- awful.layout.suit.tile.top,
    -- awful.layout.suit.fair.horizontal,
    -- awful.layout.suit.spiral,
    -- awful.layout.suit.spiral.dwindle,
    -- awful.layout.suit.max,
    -- awful.layout.suit.max.fullscreen,
    -- awful.layout.suit.magnifier,
    -- awful.layout.suit.corner.nw,
    -- awful.layout.suit.corner.ne,
    -- awful.layout.suit.corner.sw,
    -- awful.layout.suit.corner.se,
}
-- }}}

-- {{{ Helper functions
local function client_menu_toggle_fn()
    local instance = nil

    return function ()
        if instance and instance.wibox.visible then
            instance:hide()
            instance = nil
        else
            instance = awful.menu.clients({ theme = { width = 250 } })
        end
    end
end
-- }}}

-- {{{ Menu
-- Create a launcher widget and a main menu
myawesomemenu = {
   { "hotkeys", function() return false, hotkeys_popup.show_help end},
   { "manual", terminal .. " -e man awesome" },
   { "edit config", editor_cmd .. " " .. awesome.conffile },
   { "restart", awesome.restart },
   { "quit", function() awesome.quit() end}
}

mymainmenu = awful.menu({ items = { { "awesome", myawesomemenu, beautiful.awesome_icon },
                                    { "open terminal", terminal }
                                  }
                        })

mylauncher = awful.widget.launcher({ image = beautiful.awesome_icon,
                                     menu = mymainmenu })

-- Menubar configuration
menubar.utils.terminal = terminal -- Set the terminal for applications that require it
-- }}}

-- Create a wibox for each screen and add it
local taglist_buttons = button_table.join(
                    awful.button({ }, 1, function(t) t:view_only() end),
                    awful.button({ modkey }, 1, function(t)
                                              if client.focus then
                                                  client.focus:move_to_tag(t)
                                              end
                                          end),
                    awful.button({ }, 3, awful.tag.viewtoggle),
                    awful.button({ modkey }, 3, function(t)
                                              if client.focus then
                                                  client.focus:toggle_tag(t)
                                              end
                                          end),
                    awful.button({ }, 4, function(t) awful.tag.viewnext(t.screen) end),
                    awful.button({ }, 5, function(t) awful.tag.viewprev(t.screen) end)
                )

local tasklist_buttons = button_table.join(
                     awful.button({ }, 1, function (c)
                                              if c == client.focus then
                                                  c.minimized = true
                                              else
                                                  -- Without this, the following
                                                  -- :isvisible() makes no sense
                                                  c.minimized = false
                                                  if not c:isvisible() and c.first_tag then
                                                      c.first_tag:view_only()
                                                  end
                                                  -- This will also un-minimize
                                                  -- the client, if needed
                                                  client.focus = c
                                                  c:raise()
                                              end
                                          end),
                     awful.button({ }, 3, client_menu_toggle_fn()),
                     awful.button({ }, 4, function ()
                                              awful.client.focus.byidx(1)
                                          end),
                     awful.button({ }, 5, function ()
                                              awful.client.focus.byidx(-1)
                                          end))
--- ------- ---
--- Widgets ---
--- ------- ---

function round(what, precision)
   return math.floor(what*math.pow(10,precision)+0.5) / math.pow(10,precision)
end

-- Clock
clock_widget = wibox.widget.textclock(" %a, %d.%m.   %H:%M ")

-- MEM
local mem_icon = wibox.widget.imagebox(beautiful.mem_icon)
local mem = lain.widget.mem({
    settings = function()
        widget:set_markup(markup.font(beautiful.font, " " .. round(mem_now.used/1024, 2) .. "GB "))
    end
})

-- CPU
local cpu_icon = wibox.widget.imagebox(beautiful.cpu_icon)
local cpu = lain.widget.cpu({
    settings = function()
        widget:set_markup(markup.font(beautiful.font, " " .. cpu_now.usage .. "% "))
    end
})

-- Coretemp
local temp_icon = wibox.widget.imagebox(beautiful.temp_icon)
local temp = lain.widget.temp({
    timeout = 10,
    settings = function()
        if coretemp_now > 85 then
            widget:set_markup(markup.font(beautiful.font, markup.fg.color(beautiful.red, " " .. coretemp_now .. " °C ")))
        elseif coretemp_now > 70 then
            widget:set_markup(markup.font(beautiful.font, markup.fg.color(beautiful.orange, " " .. coretemp_now .. " °C ")))
        else
            widget:set_markup(markup.font(beautiful.font, " " .. coretemp_now .. "°C "))
        end
    end
})

-- Battery
-- battery progress bar
local batbar = wibox.widget {
    forced_width     = 40 * beautiful.scaling,
    color            = "#232323",
    background_color = "#ddd",
    paddings         = 1 * beautiful.scaling,
    widget           = wibox.widget.progressbar,
}
local batbar_bg = wibox.container.background(batbar, "#0f0", gears.shape.rectangle)
local bat_widget = wibox.container.margin(batbar_bg, 2 * beautiful.scaling, 7 * beautiful.scaling, 7 * beautiful.scaling, 6 * beautiful.scaling) -- l r t b
local bat_icon = wibox.widget.imagebox(beautiful.bat_icon)
-- Lain widget to show bat percent, also shows notifications
local bat = lain.widget.bat({
    notify = "on",
    timeout = 5,
    n_perc = {5, 10},
    settings = function()
        widget:set_markup(markup.font(beautiful.font, bat_now.perc .. "% "))
        if bat_now.perc > 80 then
            batbar:set_color(beautiful.green)
        elseif bat_now.perc <= 80 and bat_now.perc > 30 then
            batbar:set_color(beautiful.blue)
        elseif bat_now.perc <= 30 and bat_now.perc > 15 then
            batbar:set_color(beautiful.orange)
        elseif bat_now.perc <= 15 then
            batbar:set_color(beautiful.red)
        end
        batbar:set_value(bat_now.perc/100)
    end
})

-- Calendar
local calendar = lain.widget.cal({
    attach_to = { clock_widget }
})

-- Helper functions
local notification_preset = { fg = "#202020", bg = "#CDCDCD" }

local function volume_notification()
    local get_volume = [[bash -c "amixer sget Master | tail -n 1 | awk '{print $4}' | tr -d '[]' | sed 's/%//'"]]
    awful.spawn.easy_async(get_volume, function(stdout, stderr, reason, exit_code)
        naughty.notify({ title = "Volume", text = tostring(tonumber(stdout)) .. '%', preset = notification_preset })
    end)
end

local function increase_volume()
    awful.util.spawn("amixer set Master 5+")
    volume_notification()
end

local function decrease_volume()
    awful.util.spawn("amixer set Master 5-")
    volume_notification()
end

local function set_wallpaper(s)
  gears.wallpaper.maximized(beautiful.wallpaper, s, true)
end

-- Re-set wallpaper when a screen's geometry changes (e.g. different resolution)
screen.connect_signal("property::geometry", set_wallpaper)
awful.screen.connect_for_each_screen(function(s)
  -- Wallpaper
  gears.wallpaper.maximized(beautiful.wallpaper, s, true)

  -- Each screen has its own tag table.
  awful.tag({ "1", "2", "3", "4", "5", "6", "7", "8", "9" }, s, awful.layout.layouts[1])

  -- Create a promptbox for each screen
  s.mypromptbox = awful.widget.prompt()
  -- Create an imagebox widget which will contains an icon indicating which layout we're using.
  -- We need one layoutbox per screen.
  s.mylayoutbox = awful.widget.layoutbox(s)
  s.mylayoutbox:buttons(button_table.join(
                        awful.button({ }, 1, function () awful.layout.inc( 1) end),
                        awful.button({ }, 3, function () awful.layout.inc(-1) end),
                        awful.button({ }, 4, function () awful.layout.inc( 1) end),
                        awful.button({ }, 5, function () awful.layout.inc(-1) end)))
  -- Create a taglist widget
  s.mytaglist = awful.widget.taglist(s, awful.widget.taglist.filter.all, taglist_buttons)

  -- Create a tasklist widget
  s.mytasklist = awful.widget.tasklist(s, awful.widget.tasklist.filter.currenttags, tasklist_buttons)

  -- Create the wibox
  s.mywibox = awful.wibar({ position = "top", screen = s })

  -- Add widgets to the wibox
  s.mywibox:setup {
      layout = wibox.layout.align.horizontal,
      { -- Left widgets
          layout = wibox.layout.fixed.horizontal,
          mylauncher,
          s.mytaglist,
          s.mypromptbox,
      },
      s.mytasklist, -- Middle widget
      { -- Right widgets
          layout = wibox.layout.fixed.horizontal,
          arrow_systray_inv,
          wibox.widget.systray(),
          arrow_systray,
          mem_icon,
          mem,
          arrow_systray_inv,
          wibox.container.background(cpu_icon, beautiful.bg_systray),
          wibox.container.background(cpu.widget, beautiful.bg_systray),
          arrow_systray,
          temp_icon,
          temp,
          arrow_systray_inv,
          wibox.container.background(bat_icon, beautiful.bg_systray),
          wibox.container.background(bat.widget, beautiful.bg_systray),
          wibox.container.background(bat_widget, beautiful.bg_systray),
          arrow_systray,
          clock_widget,
          s.mylayoutbox,
      },
  }
end)

-- }}}

-- {{{ Mouse bindings
root.buttons(button_table.join(
    awful.button({ }, 3, function () mymainmenu:toggle() end),
    awful.button({ }, 4, awful.tag.viewnext),
    awful.button({ }, 5, awful.tag.viewprev)
))
-- }}}

-- {{{ Key bindings
globalkeys = button_table.join(
    awful.key({ modkey }, "s",      hotkeys_popup.show_help,   {description="show help", group="awesome"}),
    awful.key({ modkey }, "Left",   awful.tag.viewprev,        {description = "view previous", group = "tag"}),
    awful.key({ modkey }, "Right",  awful.tag.viewnext,        {description = "view next", group = "tag"}),
    awful.key({ modkey }, "Escape", awful.tag.history.restore, {description = "go back", group = "tag"}),
    awful.key({ modkey }, "w",      function () mymainmenu:show() end, {description = "show main menu", group = "awesome"}),
    awful.key({}, "Print", function() awful.util.spawn ("screen") end),
    awful.key({}, "XF86Calculator", function() awful.util.spawn ("copy_line_marker") end),
    awful.key({}, "Pause", function() awful.util.spawn ("screencast") end),
    awful.key({}, "XF86MonBrightnessUp", function() xf86helpers.brightness.inc() end),
    awful.key({}, "XF86MonBrightnessDown", function() xf86helpers.brightness.dec() end),
    awful.key({}, "XF86AudioRaiseVolume", function() xf86helpers.volume.inc() end),
    awful.key({}, "XF86AudioLowerVolume", function() xf86helpers.volume.dec() end),
    awful.key({}, "XF86AudioMute", function() xf86helpers.volume.mute() end),
    awful.key({}, "XF86AudioPlay", function() awful.util.spawn ("playerctl play-pause") end),
    awful.key({}, "XF86AudioNext", function() awful.util.spawn ("playerctl next") end),
    awful.key({}, "XF86AudioPrev", function() awful.util.spawn ("playerctl previous") end),
    awful.key({}, "XF86Display", function() awful.util.spawn ("arandr") end),
    awful.key({ modkey,           }, "l",      function() awful.util.spawn( "dm-tool lock" ) end),
    -- Layout manipulation
    awful.key({ modkey }, "u", awful.client.urgent.jumpto, {description = "jump to urgent client", group = "client"}),
    awful.key({ modkey }, "Tab",
        function ()
            awful.client.focus.history.previous()
            if client.focus then
                client.focus:raise()
            end
        end,
        {description = "go back", group = "client"}),

    -- Standard program
    awful.key({ modkey },            "Return", function () awful.spawn(terminal) end, {description = "open a terminal", group = "launcher"}),
    awful.key({ modkey, "Control" }, "r",      awesome.restart,                       {description = "reload awesome", group = "awesome"}),
    awful.key({ modkey, "Shift"   }, "q",      awesome.quit,                          {description = "quit awesome", group = "awesome"}),
    awful.key({ modkey,           }, "space",  function () awful.layout.inc( 1) end,  {description = "select next", group = "layout"}),
    awful.key({ modkey, "Shift"   }, "space",  function () awful.layout.inc(-1) end,  {description = "select previous", group = "layout"}),
    awful.key({ modkey },            "r",     function () awful.spawn("rofi -show drun") end,
              {description = "run rofi", group = "launcher"}),
    awful.key({ modkey },            "e",     function () awful.spawn("pcmanfm") end,
          {description = "run filemanager", group = "launcher"}),
    awful.key({ modkey        }, "c",      function() raise_conky() end, function() lower_conky() end)
)

clientkeys = button_table.join(
    awful.key({ modkey,           }, "f",
        function (c)
            c.fullscreen = not c.fullscreen
            c:raise()
        end,
        {description = "toggle fullscreen", group = "client"}),
    awful.key({ modkey, "Shift"   }, "c",      function (c) c:kill()                         end,
              {description = "close", group = "client"}),
    awful.key({ modkey, "Control" }, "space",  awful.client.floating.toggle                     ,
              {description = "toggle floating", group = "client"}),
    awful.key({ modkey,           }, "o",      function (c) c:move_to_screen()               end,
              {description = "move to screen", group = "client"}),
    awful.key({ modkey,           }, "t",      function (c) c.ontop = not c.ontop            end,
              {description = "toggle keep on top", group = "client"}),
    awful.key({ modkey,           }, "h",
        function (c)
            -- The client currently has the input focus, so it cannot be
            -- minimized, since minimized clients can't have the focus.
            c.minimized = true
        end ,
        {description = "minimize", group = "client"}),
    awful.key({ modkey,           }, "m",
        function (c)
            c.maximized = not c.maximized
            c:raise()
        end ,
        {description = "maximize", group = "client"})
)

-- Bind all key numbers to tags.
-- Be careful: we use keycodes to make it works on any keyboard layout.
-- This should map on the top row of your keyboard, usually 1 to 9.
for i = 1, 9 do
    globalkeys = button_table.join(globalkeys,
        -- View tag only.
        awful.key({ modkey }, "#" .. i + 9,
                  function ()
                        local screen = awful.screen.focused()
                        local tag = screen.tags[i]
                        if tag then
                           tag:view_only()
                        end
                  end,
                  {description = "view tag #"..i, group = "tag"}),
        -- Toggle tag display.
        awful.key({ modkey, "Control" }, "#" .. i + 9,
                  function ()
                      local screen = awful.screen.focused()
                      local tag = screen.tags[i]
                      if tag then
                         awful.tag.viewtoggle(tag)
                      end
                  end,
                  {description = "toggle tag #" .. i, group = "tag"}),
        -- Move client to tag.
        awful.key({ modkey, "Shift" }, "#" .. i + 9,
                  function ()
                      if client.focus then
                          local tag = client.focus.screen.tags[i]
                          if tag then
                              client.focus:move_to_tag(tag)
                          end
                     end
                  end,
                  {description = "move focused client to tag #"..i, group = "tag"}),
        -- Toggle tag on focused client.
        awful.key({ modkey, "Control", "Shift" }, "#" .. i + 9,
                  function ()
                      if client.focus then
                          local tag = client.focus.screen.tags[i]
                          if tag then
                              client.focus:toggle_tag(tag)
                          end
                      end
                  end,
                  {description = "toggle focused client on tag #" .. i, group = "tag"})
    )
end

clientbuttons = button_table.join(
    --awful.button({ }, 1, function (c) client.focus = c; c:raise() end),
    awful.button({ }, 1, function (c)
    if c.class == "FlowBladeWindow" then return end
      client.focus = c;
      c:raise()
    end),
    awful.button({ modkey }, 1, awful.mouse.client.move),
    awful.button({ modkey }, 3, awful.mouse.client.resize))

-- Set keys
root.keys(globalkeys)
-- }}}

-- {{{ Rules
-- Rules to apply to new clients (through the "manage" signal).
awful.rules.rules = {
    -- All clients will match this rule.
    { rule = { },
      properties = { border_width = beautiful.border_width,
                     border_color = beautiful.border_normal,
                     focus = awful.client.focus.filter,
                     raise = true,
                     keys = clientkeys,
                     buttons = clientbuttons,
                     screen = awful.screen.preferred,
                     placement = awful.placement.no_overlap+awful.placement.no_offscreen
     }
    },

    -- Floating clients.
    { rule_any = {
        instance = {
          "DTA",  -- Firefox addon DownThemAll.
          "copyq",  -- Includes session name in class.
        },
        class = {
          "Arandr",
          "Gpick",
          "Kruler",
          "MessageWin",  -- kalarm.
          "Sxiv",
          "Wpa_gui",
          "pinentry",
          "veromix",
          "xtightvncviewer",
          "Sakura",
          "RSE",
          "SeVi",
          "SeVi - Sequel Viewer",
          "TeamViewer",
          "VirtualBox",
          "Mullvad",
          "pcmanfm",
          "Pcmanfm"},
        name = {
          "Event Tester",  -- xev.
          "SeVi - Sequel Viewer"
        },
        icon_name = {
          "SeVi - Sequel Viewer",
          "SeVi",
          "RSE"
        },
        role = {
          "AlarmWindow",  -- Thunderbird's calendar.
          "pop-up",       -- e.g. Google Chrome's (detached) Developer Tools.
        }
      }, properties = { floating = true }},

    -- Add titlebars to normal clients and dialogs
    { rule_any = {type = { "normal", "dialog" }
      }, properties = { titlebars_enabled = false }
    },
    { rule = { class = "Conky" },
      properties = {
          floating = true,
          sticky = true,
          ontop = false,
          border_width = 0,
          focusable = false
      }
    },
    { rule = { class = "Plank" },
      properties = {
          border_width = 0,
          floating = true,
          sticky = true,
          ontop = false,
          focusable = false,
          below = true
      }
    },
    {
        rule = {
            class = "jetbrains-.*",
            instance = "sun-awt-X11-XWindowPeer",
            name = "win.*"
        },
        properties = {
    --        floating = true,
    --        focus = true,
    --        focusable = false,
    --        ontop = true,
    --        placement = awful.placement.restore,
    --        buttons = {}
        },
    }
}
-- }}}

-- {{{ Signals
-- Signal function to execute when a new client appears.
client.connect_signal("manage", function (c)
    -- Set the windows at the slave,
    -- i.e. put it at the end of others instead of setting it master.
    -- if not awesome.startup then awful.client.setslave(c) end

    if awesome.startup and
      not c.size_hints.user_position
      and not c.size_hints.program_position then
        -- Prevent clients from being unreachable after screen count changes.
        awful.placement.no_offscreen(c)
    end
end)

-- Add a titlebar if titlebars_enabled is set to true in the rules.
client.connect_signal("request::titlebars", function(c)
    -- buttons for the titlebar
    local buttons = button_table.join(
        awful.button({ }, 1, function()
            client.focus = c
            c:raise()
            awful.mouse.client.move(c)
        end),
        awful.button({ }, 3, function()
            client.focus = c
            c:raise()
            awful.mouse.client.resize(c)
        end)
    )

    awful.titlebar(c) : setup {
        { -- Left
            --awful.titlebar.widget.iconwidget(c),
            buttons = buttons,
            layout  = wibox.layout.fixed.horizontal
        },
        { -- Middle
            { -- Title
                align  = "center",
                widget = awful.titlebar.widget.titlewidget(c)
            },
            buttons = buttons,
            layout  = wibox.layout.flex.horizontal
        },
        { -- Right
            awful.titlebar.widget.floatingbutton (c),
            --awful.titlebar.widget.maximizedbutton(c),
            --awful.titlebar.widget.stickybutton   (c),
            --awful.titlebar.widget.ontopbutton    (c),
            awful.titlebar.widget.closebutton    (c),
            layout = wibox.layout.fixed.horizontal()
        },
        layout = wibox.layout.align.horizontal
    }
end)

-- Enable sloppy focus, so that focus follows mouse.
--client.connect_signal("mouse::enter", function(c)
--    if awful.layout.get(c.screen) ~= awful.layout.suit.magnifier
--        and awful.client.focus.filter(c) then
--        client.focus = c
--    end
--end)

-- Enable sloppy focus (without defocusing IntelliJ dialogs)
client.connect_signal("mouse::enter", function(c)
    local focused = client.focus
    if focused
        and focused.class == c.class
        and focused.instance == "sun-awt-X11-XDialogPeer"
        and c.instance == "sun-awt-X11-XFramePeer"
        then
            return
    end

    if awful.layout.get(c.screen) ~= awful.layout.suit.magnifier
        and awful.client.focus.filter(c) then
        client.focus = c
    end
end)

client.connect_signal("focus", function(c) c.border_color = beautiful.border_focus end)
client.connect_signal("unfocus", function(c) c.border_color = beautiful.border_normal end)
-- }}}


-- Conky raise
do
    local conky = nil

    function get_conky(default)
        if conky and conky.valid then
            return conky
        end

        conky = awful.client.iterate(function(c) return c.class == "Conky" end)()
        return conky or default
    end

    function raise_conky()
        get_conky({}).ontop = true
    end

    function lower_conky()
        get_conky({}).ontop = false
    end

    function toggle_conky()
        local conky = get_conky({})
        conky.ontop = not conky.ontop
    end
end

client.connect_signal("unfocus", function(c) c.border_color = beautiful.border_normal end)

