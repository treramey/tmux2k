#!/usr/bin/env bash

export LC_ALL=en_US.UTF-8

current_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$current_dir/lib/utils.sh"

refresh_rate=$(get_tmux_option "@tmux2k-refresh-rate" 60)
show_powerline=$(get_tmux_option "@tmux2k-show-powerline" true)
l_sep=$(get_tmux_option "@tmux2k-left-sep" )
r_sep=$(get_tmux_option "@tmux2k-right-sep" )
wl_sep=$(get_tmux_option "@tmux2k-window-list-left-sep" )
wr_sep=$(get_tmux_option "@tmux2k-window-list-right-sep" )
window_list_alignment=$(get_tmux_option "@tmux2k-window-list-alignment" 'absolute-centre')
window_list_format=$(get_tmux_option "@tmux2k-window-list-format" '#I:#W')
window_list_flags=$(get_tmux_option "@tmux2k-window-list-flags" true)
window_list_compact=$(get_tmux_option "@tmux2k-window-list-compact" false)
IFS=' ' read -r -a lplugins <<<"$(get_tmux_option '@tmux2k-left-plugins' 'session git cwd')"
IFS=' ' read -r -a rplugins <<<"$(get_tmux_option '@tmux2k-right-plugins' 'cpu ram battery network time')"
theme=$(get_tmux_option "@tmux2k-theme" 'default')
icons_only=$(get_tmux_option "@tmux2k-icons-only" false)

text=$(get_tmux_option "@tmux2k-text" '#282a36')
bg_main=$(get_tmux_option "@tmux2k-bg-main" '#000000')
bg_alt=$(get_tmux_option "@tmux2k-bg-alt" '#1f1f1f')
black=$(get_tmux_option "@tmux2k-black" '#0a0a0f')
white=$(get_tmux_option "@tmux2k-white" '#FAF4ED')
gray=$(get_tmux_option "@tmux2k-gray" '#666787')
red=$(get_tmux_option "@tmux2k-red" '#ff001f')
light_red=$(get_tmux_option "@tmux2k-light-red" '#ff0055')
green=$(get_tmux_option "@tmux2k-green" '#3dd50a')
light_green=$(get_tmux_option "@tmux2k-light-green" '#ccffcc')
blue=$(get_tmux_option "@tmux2k-blue" '#5FF1FF')
light_blue=$(get_tmux_option "@tmux2k-light-blue" '#5FF1FF')
yellow=$(get_tmux_option "@tmux2k-yellow" '#ffb86c')
light_yellow=$(get_tmux_option "@tmux2k-light-yellow" '#ffd21a')
purple=$(get_tmux_option "@tmux2k-purple" '#bf58ff')
light_purple=$(get_tmux_option "@tmux2k-light-purple" '#ff65c6')

declare -A plugin_colors=(
    ["session"]="gray text"
    ["git"]="gray text"
    ["cpu"]="blue text"
    ["cwd"]="blue text"
    ["ram"]="light_yellow text"
    ["gpu"]="yellow text"
    ["battery"]="light_purple text"
    ["network"]="purple text"
    ["bandwidth"]="purple text"
    ["ping"]="purple text"
    ["weather"]="yellow text"
    ["time"]="light_blue text"
    ["pomodoro"]="red text"
    ["window_list"]="bg_main blue"
)

get_plugin_colors() {
    local plugin_name="$1"
    local default_colors="${plugin_colors[$plugin_name]}"
    get_tmux_option "@tmux2k-${plugin_name}-colors" "$default_colors"
}

get_plugin_bg() {
    IFS=' ' read -r -a colors <<<"$(get_plugin_colors "$1")"
    return "${colors[0]}"
}

set_theme() {
    case $theme in
    "catppuccin")
        bg_main=$(get_tmux_option "@tmux2k-bg-main" '#24273a')
        bg_alt=$(get_tmux_option "@tmux2k-bg-alt" '#363a4f')
        black=$(get_tmux_option "@tmux2k-black" '#1e2030')
        white=$(get_tmux_option "@tmux2k-white" '#ffffff')
        red=$(get_tmux_option "@tmux2k-red" '#ed8796')
        light_red=$(get_tmux_option "@tmux2k-light-red" '#ee99a0')
        green=$(get_tmux_option "@tmux2k-green" '#a6da95')
        light_green=$(get_tmux_option "@tmux2k-light-green" '#8bd5ca')
        blue=$(get_tmux_option "@tmux2k-blue" '#8aadf4')
        light_blue=$(get_tmux_option "@tmux2k-light-blue" '#91d7e3')
        yellow=$(get_tmux_option "@tmux2k-yellow" '#f5a97f')
        light_yellow=$(get_tmux_option "@tmux2k-light-yellow" '#eed49f')
        purple=$(get_tmux_option "@tmux2k-purple" '#b6a0fe')
        light_purple=$(get_tmux_option "@tmux2k-light-purple" '#f5bde6')
        ;;
    "duo")
        duo_bg=$(get_tmux_option "@tmux2k-duo-bg" '#000000')
        duo_fg=$(get_tmux_option "@tmux2k-duo-fg" '#ffffff')
        text=$(get_tmux_option "@tmux2k-white" "$duo_bg")
        bg_main=$(get_tmux_option "@tmux2k-bg-main" "$duo_bg")
        bg_alt=$(get_tmux_option "@tmux2k-bg-alt" "$duo_bg")
        black=$(get_tmux_option "@tmux2k-black" "$duo_bg")
        white=$(get_tmux_option "@tmux2k-white" "$duo_fg")
        red=$(get_tmux_option "@tmux2k-red" "$duo_fg")
        light_red=$(get_tmux_option "@tmux2k-light-red" "$duo_fg")
        green=$(get_tmux_option "@tmux2k-green" "$duo_fg")
        light_green=$(get_tmux_option "@tmux2k-light-green" "$duo_fg")
        blue=$(get_tmux_option "@tmux2k-blue" "$duo_fg")
        light_blue=$(get_tmux_option "@tmux2k-light-blue" "$duo_fg")
        yellow=$(get_tmux_option "@tmux2k-yellow" "$duo_fg")
        light_yellow=$(get_tmux_option "@tmux2k-light-yellow" "$duo_fg")
        purple=$(get_tmux_option "@tmux2k-purple" "$duo_fg")
        light_purple=$(get_tmux_option "@tmux2k-light-purple" "$duo_fg")
        ;;
    "gruvbox")
        bg_main=$(get_tmux_option "@tmux2k-bg-main" '#282828')
        bg_alt=$(get_tmux_option "@tmux2k-bg-alt" '#3c3836')
        black=$(get_tmux_option "@tmux2k-black" '#282828')
        white=$(get_tmux_option "@tmux2k-white" '#ebdbb2')
        red=$(get_tmux_option "@tmux2k-red" '#cc241d')
        light_red=$(get_tmux_option "@tmux2k-light-red" '#fb4934')
        green=$(get_tmux_option "@tmux2k-green" '#98971a')
        light_green=$(get_tmux_option "@tmux2k-light-green" '#b8bb26')
        blue=$(get_tmux_option "@tmux2k-blue" '#458588')
        light_blue=$(get_tmux_option "@tmux2k-light-blue" '#83a598')
        yellow=$(get_tmux_option "@tmux2k-yellow" '#d79921')
        light_yellow=$(get_tmux_option "@tmux2k-light-yellow" '#fabd2f')
        purple=$(get_tmux_option "@tmux2k-purple" '#b162d6')
        light_purple=$(get_tmux_option "@tmux2k-light-purple" '#f386cb')
        ;;
    "monokai")
        bg_main=$(get_tmux_option "@tmux2k-bg-main" '#272822')
        bg_alt=$(get_tmux_option "@tmux2k-bg-alt" '#3e3d32')
        black=$(get_tmux_option "@tmux2k-black" '#272822')
        white=$(get_tmux_option "@tmux2k-white" '#f8f8f2')
        red=$(get_tmux_option "@tmux2k-red" '#f92672')
        light_red=$(get_tmux_option "@tmux2k-light-red" '#ff6188')
        green=$(get_tmux_option "@tmux2k-green" '#a6e22e')
        light_green=$(get_tmux_option "@tmux2k-light-green" '#a6e22e')
        blue=$(get_tmux_option "@tmux2k-blue" '#66d9ef')
        light_blue=$(get_tmux_option "@tmux2k-light-blue" '#66d9ef')
        yellow=$(get_tmux_option "@tmux2k-yellow" '#e6db74')
        light_yellow=$(get_tmux_option "@tmux2k-light-yellow" '#e6db74')
        purple=$(get_tmux_option "@tmux2k-purple" '#ae81ff')
        light_purple=$(get_tmux_option "@tmux2k-light-purple" '#fe81ff')
        ;;
    "onedark")
        bg_main=$(get_tmux_option "@tmux2k-bg-main" '#282c34')
        bg_alt=$(get_tmux_option "@tmux2k-bg-alt" '#353b45')
        black=$(get_tmux_option "@tmux2k-black" '#2d3139')
        white=$(get_tmux_option "@tmux2k-white" '#abb2bf')
        red=$(get_tmux_option "@tmux2k-red" '#e06c75')
        light_red=$(get_tmux_option "@tmux2k-light-red" '#e06c75')
        green=$(get_tmux_option "@tmux2k-green" '#98c379')
        light_green=$(get_tmux_option "@tmux2k-light-green" '#98c379')
        blue=$(get_tmux_option "@tmux2k-blue" '#61afef')
        light_blue=$(get_tmux_option "@tmux2k-light-blue" '#61afef')
        yellow=$(get_tmux_option "@tmux2k-yellow" '#e5c07b')
        light_yellow=$(get_tmux_option "@tmux2k-light-yellow" '#e5c07b')
        purple=$(get_tmux_option "@tmux2k-purple" '#c678fd')
        light_purple=$(get_tmux_option "@tmux2k-light-purple" '#f678cd')
        ;;
    "rosepine")
        text=$(get_tmux_option "@tmux2k-text" '#e0def4')
        bg_main=$(get_tmux_option "@tmux2k-bg-main" '#191724')
        bg_alt=$(get_tmux_option "@tmux2k-bg-alt" '#1f1d2e')
        black=$(get_tmux_option "@tmux2k-black" '#191724')
        white=$(get_tmux_option "@tmux2k-white" '#e0def4')
        gray=$(get_tmux_option "@tmux2k-gray" '#6e6a86')
        red=$(get_tmux_option "@tmux2k-red" '#eb6f92')
        light_red=$(get_tmux_option "@tmux2k-light-red" '#ebbcba')
        green=$(get_tmux_option "@tmux2k-green" '#31748f')
        light_green=$(get_tmux_option "@tmux2k-light-green" '#9ccfd8')
        blue=$(get_tmux_option "@tmux2k-blue" '#31748f')
        light_blue=$(get_tmux_option "@tmux2k-light-blue" '#9ccfd8')
        yellow=$(get_tmux_option "@tmux2k-yellow" '#f6c177')
        light_yellow=$(get_tmux_option "@tmux2k-light-yellow" '#f6c177')
        purple=$(get_tmux_option "@tmux2k-purple" '#c4a7e7')
        light_purple=$(get_tmux_option "@tmux2k-light-purple" '#c4a7e7')
        ;;
    esac

    if $icons_only; then
        show_powerline=false
        text=$bg_main
        plugin_colors=(
            ["session"]="text gray"
            ["git"]="text gray"
            ["cpu"]="text gray"
            ["cwd"]="text gay"
            ["ram"]="text gray"
            ["gpu"]="text yellow"
            ["battery"]="text gray"
            ["network"]="text purple"
            ["bandwidth"]="text purple"
            ["ping"]="text purple"
            ["weather"]="text yellow"
            ["time"]="text gray"
            ["pomodoro"]="text red"
            ["window_list"]="white bg_main"
        )
    fi
}

set_options() {
    tmux set-option -g status-interval "$refresh_rate"
    tmux set-option -g status-left-length 100
    tmux set-option -g status-right-length 100
    tmux set-option -g status-left ""
    tmux set-option -g status-right ""

    tmux set-option -g pane-active-border-style "fg=${blue}"
    tmux set-option -g pane-border-style "fg=${bg_main}"
    tmux set-option -g message-style "bg=${bg_main},fg=${blue}"
    tmux set-option -g status-style "bg=${bg_main},fg=${white}"
    tmux set -g status-justify left
}


start_icon() {
    tmux set-option -g status-left "#[bg=default,fg=${blue}] "󰋙" #S  "
}

status_bar() {
    side=$1
    if [ "$side" == "left" ]; then
        plugins=("${lplugins[@]}")
    else
        plugins=("${rplugins[@]}")
    fi

    for plugin_index in "${!plugins[@]}"; do
        plugin="${plugins[$plugin_index]}"
        if [ -z "${plugin_colors[$plugin]}" ]; then
            continue
        fi

        IFS=' ' read -r -a colors <<<"$(get_plugin_colors "$plugin")"
        script="#($current_dir/plugins/$plugin.sh)"

        if [ "$side" == "left" ]; then
            if $show_powerline; then
                next_plugin=${plugins[$((plugin_index + 1))]}
                IFS=' ' read -r -a next_colors <<<"$(get_plugin_colors "$next_plugin")"
                pl_bg=${!next_colors[0]:-$bg_main}
                tmux set-option -ga status-left \
                    "#[fg=${!colors[1]},bg=${!colors[0]}] $script #[fg=${!colors[0]},bg=${pl_bg},nobold,nounderscore,noitalics]${l_sep}"
                pl_bg=${bg_main}
            else
                tmux set-option -ga status-left "#[fg=${!colors[1]},bg=${!colors[0]}] $script "
            fi
        else
            if $show_powerline; then
                tmux set-option -ga status-right \
                    "#[fg=${!colors[0]},bg=${pl_bg},nobold,nounderscore,noitalics]${r_sep}#[fg=${!colors[1]},bg=${!colors[0]}] $script "
                pl_bg=${!colors[0]}
            else
                tmux set-option -ga status-right "#[fg=${gray},bg=${bg_main}] $script "
            fi
        fi
    done
}

window_list() {
    IFS=' ' read -r -a colors <<<"$(get_plugin_colors "window_list")"
    wbg=${gray}
    wfg=${!colors[1]}

    spacer=" "
    if $window_list_compact; then
        spacer=""
    fi

    if $window_list_flags; then
        flags="#{?window_flags,#[fg=${light_red}]#{window_flags},}"
        current_flags="#{?window_flags,#[fg=${light_green}]#{window_flags},}"
    fi

    if $show_powerline; then
        tmux set-window-option -g window-status-current-format \
            "#[fg=${wfg},bg=${wbg}]${wl_sep}#[bg=${wfg}]${current_flags}#[fg=${wbg}]${spacer}${window_list_format}${spacer}#[fg=${wfg},bg=${wbg}]${wr_sep}"
        tmux set-window-option -g window-status-format \
            "#[fg=${bg_alt},bg=${wbg}]${wl_sep}#[bg=${bg_alt}]${flags}#[fg=${white}]${spacer}${window_list_format}${spacer}#[fg=${bg_alt},bg=${wbg}]${wr_sep}"
    else
        tmux set-window-option -g window-status-current-format "#[fg=${wbg},bg=${wfg}] ${window_list_format}${spacer}${current_flags} "
        tmux set-window-option -g window-status-format "#[fg=${white},bg=${bg_alt}] ${window_list_format}${spacer}${flags} "
    fi

    if $icons_only; then
        tmux set-window-option -g window-status-current-format "#[fg=${white},bg=${wfg}]${spacer}#W"
        tmux set-window-option -g window-status-format "#[fg=${wbg},bg=${wfg}]${spacer}#I:#W"
    fi
}

main() {
    set_theme
    set_options
    start_icon
    status_bar "left"
    window_list
    status_bar "right"
}

main
