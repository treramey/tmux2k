#!/usr/bin/env bash

export LC_ALL=en_US.UTF-8

current_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$current_dir/lib/utils.sh"

refresh_rate=$(get_tmux_option "@tmux2k-refresh-rate" 60)
l_sep=$(get_tmux_option "@tmux2k-left-sep" )
r_sep=$(get_tmux_option "@tmux2k-right-sep" )
wl_sep=$(get_tmux_option "@tmux2k-window-list-left-sep" )
wr_sep=$(get_tmux_option "@tmux2k-window-list-right-sep" )
window_list_alignment=$(get_tmux_option "@tmux2k-window-list-alignment" 'absolute-centre')
window_list_format=$(get_tmux_option "@tmux2k-window-list-format" '#I:#W')
window_list_flags=$(get_tmux_option "@tmux2k-window-list-flags" true)
window_list_compact=$(get_tmux_option "@tmux2k-window-list-compact" false)
IFS=' ' read -r -a lplugins <<<"$(get_tmux_option '@tmux2k-left-plugins' 'session git cwd')"
IFS=' ' read -r -a rplugins <<<"$(get_tmux_option '@tmux2k-right-plugins' 'cpu ram battery network time')"
theme=$(get_tmux_option "@tmux2k-theme" 'rose-pine')
icons_only=$(get_tmux_option "@tmux2k-icons-only" false)

declare -A plugin_colors=(
    ["session"]="muted text"
    ["git"]="muted text"
    ["cpu"]="foam text"
    ["cwd"]="foam text"
    ["ram"]="gold text"
    ["gpu"]="gold text"
    ["battery"]="iris text"
    ["network"]="iris text"
    ["bandwidth"]="iris text"
    ["ping"]="iris text"
    ["weather"]="gold text"
    ["time"]="foam text"
    ["pomodoro"]="love text"
    ["window_list"]="base foam"
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
    "rose-pine"|"rosepine")
        # Rose Pine (main) - Official colors from rosepinetheme.com
        text=$(get_tmux_option "@tmux2k-text" '#e0def4')
        base=$(get_tmux_option "@tmux2k-base" '#191724')
        dawn=$(get_tmux_option "@tmux2k-dawn" '#1f1d2e')
        overlay=$(get_tmux_option "@tmux2k-overlay" '#26233a')
        muted=$(get_tmux_option "@tmux2k-muted" '#6e6a86')
        subtle=$(get_tmux_option "@tmux2k-subtle" '#908caa')
        love=$(get_tmux_option "@tmux2k-love" '#eb6f92')
        gold=$(get_tmux_option "@tmux2k-gold" '#f6c177')
        rose=$(get_tmux_option "@tmux2k-rose" '#ebbcba')
        pine=$(get_tmux_option "@tmux2k-pine" '#31748f')
        foam=$(get_tmux_option "@tmux2k-foam" '#9ccfd8')
        iris=$(get_tmux_option "@tmux2k-iris" '#c4a7e7')
        highlight_low=$(get_tmux_option "@tmux2k-highlight-low" '#21202e')
        highlight_med=$(get_tmux_option "@tmux2k-highlight-med" '#403d52')
        highlight_high=$(get_tmux_option "@tmux2k-highlight-high" '#524f67')
        ;;
    "rose-pine-moon")
        # Rose Pine Moon - Official colors from rosepinetheme.com
        text=$(get_tmux_option "@tmux2k-text" '#e0def4')
        base=$(get_tmux_option "@tmux2k-base" '#232136')
        dawn=$(get_tmux_option "@tmux2k-dawn" '#2a273f')
        overlay=$(get_tmux_option "@tmux2k-overlay" '#393552')
        muted=$(get_tmux_option "@tmux2k-muted" '#6e6a86')
        subtle=$(get_tmux_option "@tmux2k-subtle" '#908caa')
        love=$(get_tmux_option "@tmux2k-love" '#eb6f92')
        gold=$(get_tmux_option "@tmux2k-gold" '#f6c177')
        rose=$(get_tmux_option "@tmux2k-rose" '#ea9a97')
        pine=$(get_tmux_option "@tmux2k-pine" '#3e8fb0')
        foam=$(get_tmux_option "@tmux2k-foam" '#9ccfd8')
        iris=$(get_tmux_option "@tmux2k-iris" '#c4a7e7')
        highlight_low=$(get_tmux_option "@tmux2k-highlight-low" '#2a283e')
        highlight_med=$(get_tmux_option "@tmux2k-highlight-med" '#44415a')
        highlight_high=$(get_tmux_option "@tmux2k-highlight-high" '#56526e')
        ;;
    "rose-pine-dawn")
        # Rose Pine Dawn - Official colors from rosepinetheme.com
        text=$(get_tmux_option "@tmux2k-text" '#575279')
        base=$(get_tmux_option "@tmux2k-base" '#faf4ed')
        dawn=$(get_tmux_option "@tmux2k-dawn" '#fffaf3')
        overlay=$(get_tmux_option "@tmux2k-overlay" '#f2e9e1')
        muted=$(get_tmux_option "@tmux2k-muted" '#9893a5')
        subtle=$(get_tmux_option "@tmux2k-subtle" '#797593')
        love=$(get_tmux_option "@tmux2k-love" '#b4637a')
        gold=$(get_tmux_option "@tmux2k-gold" '#ea9d34')
        rose=$(get_tmux_option "@tmux2k-rose" '#d7827e')
        pine=$(get_tmux_option "@tmux2k-pine" '#286983')
        foam=$(get_tmux_option "@tmux2k-foam" '#56949f')
        iris=$(get_tmux_option "@tmux2k-iris" '#907aa9')
        highlight_low=$(get_tmux_option "@tmux2k-highlight-low" '#f4ede8')
        highlight_med=$(get_tmux_option "@tmux2k-highlight-med" '#dfdad9')
        highlight_high=$(get_tmux_option "@tmux2k-highlight-high" '#cecacd')
       ;;
    *)
        # Default to Rose Pine if unknown theme
        text=$(get_tmux_option "@tmux2k-text" '#e0def4')
        base=$(get_tmux_option "@tmux2k-base" '#191724')
        dawn=$(get_tmux_option "@tmux2k-dawn" '#1f1d2e')
        overlay=$(get_tmux_option "@tmux2k-overlay" '#26233a')
        muted=$(get_tmux_option "@tmux2k-muted" '#6e6a86')
        subtle=$(get_tmux_option "@tmux2k-subtle" '#908caa')
        love=$(get_tmux_option "@tmux2k-love" '#eb6f92')
        gold=$(get_tmux_option "@tmux2k-gold" '#f6c177')
        rose=$(get_tmux_option "@tmux2k-rose" '#ebbcba')
        pine=$(get_tmux_option "@tmux2k-pine" '#31748f')
        foam=$(get_tmux_option "@tmux2k-foam" '#9ccfd8')
        iris=$(get_tmux_option "@tmux2k-iris" '#c4a7e7')
        highlight_low=$(get_tmux_option "@tmux2k-highlight-low" '#21202e')
        highlight_med=$(get_tmux_option "@tmux2k-highlight-med" '#403d52')
        highlight_high=$(get_tmux_option "@tmux2k-highlight-high" '#524f67')
        ;;
    esac

    if $icons_only; then
        plugin_colors=(
            ["session"]="text muted"
            ["git"]="text muted"
            ["cpu"]="text muted"
            ["cwd"]="text muted"
            ["ram"]="text muted"
            ["gpu"]="text gold"
            ["battery"]="text muted"
            ["network"]="text iris"
            ["bandwidth"]="text iris"
            ["ping"]="text iris"
            ["weather"]="text gold"
            ["time"]="text muted"
            ["pomodoro"]="text love"
            ["window_list"]="text base"
        )
    fi
    
    # Set global color variables
    text=$(get_tmux_option "@tmux2k-text" "$text")
    bg_main=$(get_tmux_option "@tmux2k-bg-main" "$base")
    bg_alt=$(get_tmux_option "@tmux2k-bg-alt" "$overlay")
    message_bg=$(get_tmux_option "@tmux2k-message-bg" "$overlay")
    message_fg=$(get_tmux_option "@tmux2k-message-fg" "$text")
    pane_active_border=$(get_tmux_option "@tmux2k-pane-active-border" "$rose")
    pane_border=$(get_tmux_option "@tmux2k-pane-border" "$overlay")
    prefix_highlight=$(get_tmux_option "@tmux2k-prefix-highlight" "$foam")
}

set_options() {
    tmux set-option -g status-interval "$refresh_rate"
    tmux set-option -g status-left-length 100
    tmux set-option -g status-right-length 100
    tmux set-option -g status-left ""
    tmux set-option -g status-right ""

    tmux set-option -g pane-active-border-style "fg=${pane_active_border}"
    tmux set-option -g pane-border-style "fg=${pane_border}"
    tmux set-option -g message-style "bg=${overlay},fg=${foam}"
    tmux set-option -g status-style "bg=default,fg=${text}"
    tmux set -g status-justify left
}

start_icon() {
    tmux set-option -g status-left "#[bg=default,fg=${love}] "󰋙" #S  "
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
          tmux set-option -ga status-left "#[fg=${!colors[1]},bg=${!colors[0]}] $script "
        else
            tmux set-option -ga status-right "#[fg=${muted},bg=default] $script "
        fi
    done
}

window_list() {
    IFS=' ' read -r -a colors <<<"$(get_plugin_colors "window_list")"
    wfg=${overlay}

    spacer=" "
    if $window_list_compact; then
        spacer=""
    fi
    tmux set-window-option -g window-status-current-format "#[fg=${wfg},bg=default]${wl_sep}#[fg=${text},bg=${wfg}]${spacer}#W${spacer}#[fg=${wfg},bg=default]${wr_sep}"
    tmux set-window-option -g window-status-format "#[fg=${muted},bg=default]${spacer}#I:#W${spacer}"
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
