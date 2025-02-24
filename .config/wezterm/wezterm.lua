-- Intro
-- https://alexplescan.com/posts/2024/08/10/wezterm/
-- Import the wezterm module
local wezterm = require 'wezterm'
-- Creates a config object which we will be adding our config to
local config = wezterm.config_builder()

-- How many lines of scrollback you want to retain per tab
config.scrollback_lines = 10000

config.hide_tab_bar_if_only_one_tab = false

-- wezterm.log_info("hello world! my name is " .. wezterm.hostname())

-- Use SUPER intead of SHIFT to bypass application mouse reporting
config.bypass_mouse_reporting_modifiers = 'SUPER'

-- Pick a colour scheme. WezTerm ships with more than 1,000!
-- Find them here: https://wezfurlong.org/wezterm/colorschemes/index.html
config.color_scheme = 'tokyonight-storm'

-- Colors should override colorscheme
-- https://wezfurlong.org/wezterm/config/appearance.html#precedence-of-colors-vs-color_schemes
config.colors = {
  -- The default text color
  -- foreground = '#f5f5f5',
  -- iterm?
  foreground = '#efefeb',
  -- The default background color
  background = '#292A31',
  -- tokyo moon default
  -- ansi = {
  --   '#1b1d2b',  -- grey
  --   '#ff757f',  -- red
  --   '#c3e88d',  -- lime
  --   '#ffc777',  -- yellow
  --   '#82aaff',  -- blue
  --   '#c099ff',  -- fuchsi
  --   '#86e1fc',  -- aqua
  --   '#828bb8',  -- white
  -- },
  ansi = {
    '#1b1d2b',  -- grey
    '#ff757f',  -- red
    '#c3e88d',  -- lime
    '#ffc777',  -- yellow
    '#82aaff',  -- blue
    '#c099ff',  -- fuchsi
    '#86e1fc',  -- aqua
    '#efefeb',  -- Override white
  },

}

config.harfbuzz_features = { 'calt=0', 'clig=0', 'liga=0' }
-- config.color_scheme = 'tokyonight_moon'
-- Choose your favourite font, make sure it's installed on your machine
-- config.font = wezterm.font({ family = 'JetBrainsMono Nerd Font' })
config.font = wezterm.font({ family = 'Hack Nerd Font Mono' })
config.font_size = 12

-- Slightly transparent and blurred background
-- Removes the title bar, leaving only the tab bar. Keeps
-- the ability to resize by dragging the window's edges.
-- On macOS, 'RESIZE|INTEGRATED_BUTTONS' also looks nice if
-- you want to keep the window controls visible and integrate
-- them into the tab bar.
config.window_decorations = 'RESIZE|INTEGRATED_BUTTONS'

-- If you're using emacs you probably wanna choose a different leader here,
-- since we're gonna be making it a bit harder to CTRL + A for jumping to
-- the start of a line
-- config.leader = { key = 'f', mods = 'CTRL', timeout_milliseconds = 1000 }

-- keys from iterm
-- http://files.asktherelic.com/Screen-Shot-2024-08-12-09-43-11.86-eQ3hfJXi.png
config.set_environment_variables = {
  PATH = '/opt/homebrew/bin:' .. os.getenv('PATH')
}
-- Table mapping keypresses to actions
local act = wezterm.action
local function bind_pane(key)
  return {
    key = key,
    mods = 'SUPER',
    action = act.Multiple {
        act.SendKey { key = 'f', mods = 'CTRL', },
        act.SendKey { key = key },
    },
  }
end
config.keys = {
    -- {
    --     key = 'f',
    --     -- When we're in leader mode _and_ CTRL + A is pressed...
    --     mods = 'LEADER|CTRL',
    --     -- Actually send CTRL + A key to the terminal
    --     action = wezterm.action.SendKey { key = 'f', mods = 'CTRL' },
    -- },

    -- Rebind CMD + N to tmux panes
    bind_pane('1'),
    bind_pane('2'),
    bind_pane('3'),
    bind_pane('4'),
    bind_pane('5'),
    bind_pane('6'),
    bind_pane('7'),
    bind_pane('8'),
    bind_pane('9'),
    -- tmux prev pane; my personal binding in .tmux.conf
    {
        key = '[',
        mods = 'SUPER',
        action = act.Multiple {
            act.SendKey { key = 'f', mods = 'CTRL', },
            act.SendKey { key = 'h', mods = 'CTRL', },
        },
    },
    -- tmux next pane
    {
        key = ']',
        mods = 'SUPER',
        action = act.Multiple {
            act.SendKey { key = 'f', mods = 'CTRL', },
            act.SendKey { key = 'n' },
        },
    },

    {
        key = ',',
        mods = 'SUPER',
        action = wezterm.action.SpawnCommandInNewTab {
            cwd = wezterm.home_dir,
            args = { 'nvim', wezterm.config_file },
        },
    },
    -- Rebind search to not retain search selection
    {
        key = 'f',
        mods = 'SUPER',
        action = wezterm.action_callback(function(window, pane)
            window:perform_action(act.Search 'CurrentSelectionOrEmptyString', pane)
            window:perform_action(act.CopyMode 'ClearPattern', pane)
        end),
    },
}

-- Returns our config to be evaluated. We must always do this at the bottom of this file
return config
