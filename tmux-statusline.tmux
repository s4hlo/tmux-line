#!/usr/bin/env bash
#====================
#   Author: S4hlo
#====================

t_option() {
    local value="$(tmux show -gqv "$1")"
    [ -n "$value" ] && echo "$value" || echo "$2"
}

t_set() {
    tmux set-option -gq "$1" "$2"
}

# ------- CUSTOMIZATION --------------
STYLE=$(t_option @tmux_line_style 'angled')
JUSTIFY=$(t_option @tmux_line_justify 'left')

# ------ THEME -------
BASE=$(t_option @tmux_line_color_blue "#698DDA")
SYNC=$(t_option @tmux_line_color_red "#e06c75")
PREFIX=$(t_option @tmux_line_color_purple "#c678dd")
COPY=$(t_option @tmux_line_color_copy "#98c379")

WHITE=$(t_option @tmux_line_color_white "#abb2bf")
LIGHT_GREY=$(t_option @tmux_line_color_light_grey "#3e4452")
DARK_GREY=$(t_option @tmux_line_color_dark_grey "#282c34")
NIL=$(t_option @tmux_line_color_nil "default")

DATE_FORMAT=$(t_option @tmux_power_date_format '%H:%M')

# MODULES OPTIONS
RAM="#(free -h | awk '/^Mem:/ {gsub(\"Gi\", \"GB\", \$3); gsub(\"Gi\", \"GB\", \$2); print \"RAM \" \$3 \"/\" \$2}')"
CPU="#(top -bn1 | grep \"Cpu(s)\" | awk '{printf \"CPU %04.1f%%\", \$2 + \$4}')"
GIT="#(git -C #{pane_current_path} branch --show-current  | xargs -I {} echo  {})"
TIME=$DATE_FORMAT
SESSION="#S"
USER="#(whoami)"
TITLE=$(t_option @tmux_line_indicator 'TMUX')
WEATHER=$(curl wttr.in/?format=%l:+%t)

STATUS_COLOR="#{?client_prefix,$PREFIX,#{?pane_in_mode,$COPY,#{?pane_synchronized,$SYNC,$BASE}}}"
# ---------------------------------------

MODULE_A=$TITLE
MODULE_B=$USER
MODULE_C=$SESSION

MODULE_X=$WEATHER
MODULE_Y=$RAM
MODULE_Z=$TIME

case $STYLE in
  flat)
    SEP="▕▏"
    R_SEP_ALT=''
    R_SEP=''
    L_SEP=''
    ;;
  angled)
    SEP="  "
    R_SEP_ALT=''
    R_SEP=''
    L_SEP=''
    ;;
  arrow)
    SEP="  "
    R_SEP_ALT=''
    R_SEP=''
    L_SEP=''
    ;;
  rounded)
    SEP="▕▏"
    R_SEP_ALT=' '
    R_SEP=''
    L_SEP=''
    ;;
  *)
    echo "Unknown theme: $STYLE"
    ;;
esac

# --------------------- GENERAL

# Status options
t_set status-style "fg=$WHITE,bg=$NIL"
t_set status-interval 1
t_set status-justify "$JUSTIFY"
t_set status on
t_set status-attr none

# ---------------------- LEFT SIDE OF STATUS BAR
t_set status-left-length 150

LS_A="#[fg=$DARK_GREY]#[bg=$STATUS_COLOR]#[bold] $MODULE_A #[fg=$STATUS_COLOR]"
LS_B="#[bg=$LIGHT_GREY]$R_SEP#[fg=$WHITE] $MODULE_B #[fg=$LIGHT_GREY]"
LS_C="#[bg=$DARK_GREY]$R_SEP #[fg=$WHITE]$MODULE_C #[fg=$DARK_GREY]"

LS_END="#[bg=$NIL]$R_SEP"

t_set status-left "$LS_A$LS_B$LS_C$LS_END"

# --------------------- RIGHT SIDE OF STATUS BAR
t_set status-right-length 150

RS_X="#[bg=$NIL]#[fg=$DARK_GREY]$L_SEP#[bg=$DARK_GREY]#[fg=$WHITE] $MODULE_X "
RS_Y="#[fg=$LIGHT_GREY]$L_SEP#[fg=$WHITE]#[bg=$LIGHT_GREY]#[bold] $MODULE_Y⠀"
RS_Z="#[fg=$STATUS_COLOR]$L_SEP#[fg=$DARK_GREY]#[bg=$STATUS_COLOR]#[bold] $MODULE_Z⠀"

t_set status-right "$RS_X$RS_Y$RS_Z"

# ---------------------------WINDOW STATUS FORMAT
t_set window-status-format  "#[fg=$DARK_GREY,bg=default]#[bold]$R_SEP_ALT#[fg=$WHITE,bg=$DARK_GREY] #I #W #[fg=$DARK_GREY,bg=$NIL]$R_SEP"

WS="#[fg=$STATUS_COLOR]#[bg=$NIL]#[bold]$R_SEP_ALT#[fg=$DARK_GREY]#[bg=$STATUS_COLOR]#[bold] #I #W#{?window_zoomed_flag,$SEP , }#[fg=$STATUS_COLOR]#[bg=$NIL]$R_SEP"

t_set window-status-current-format "$WS"
# -----------------

# Window separator
t_set window-status-separator ""

# Window status style
t_set window-status-style          "fg=$STATUS_COLOR,bg=$NIL,bold"
t_set window-status-last-style     "fg=$STATUS_COLOR,bg=$NIL,none"
t_set window-status-activity-style "fg=$STATUS_COLOR,bg=$NIL,bold"

# MISCELLANEOUS SYLE
t_set pane-border-style "fg=$DARK_GREY,bg=default"
t_set pane-active-border-style "fg=$STATUS_COLOR,bg=default"
t_set display-panes-colour "$DARK_GREY"
t_set display-panes-active-colour "$STATUS_COLOR"
t_set clock-mode-colour "$STATUS_COLOR"
t_set clock-mode-style 24
t_set message-style "fg=$STATUS_COLOR,bg=$NIL"
t_set message-command-style "fg=$STATUS_COLOR,bg=$NIL"
t_set mode-style "bg=$COPY,fg=$DARK_GREY"
