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

# ------- STYLE CUSTOMIZATION --------------
STYLE=$(t_option @line_style_separator 'angled')
JUSTIFY=$(t_option @line_style_justify 'left')

# ------ COLORS CONFIGURATION -------
BASE=$(t_option @line_color_base "#698DDA")
SYNC=$(t_option @line_color_sync "#e06c75")
PREFIX=$(t_option @line_color_prefix "#c678dd")
COPY=$(t_option @line_color_copy "#98c379")
STATUS_COLOR="#{?client_prefix,$PREFIX,#{?pane_in_mode,$COPY,#{?pane_synchronized,$SYNC,$BASE}}}"

FOREGROUND=$(t_option @line_color_fg "#abb2bf")
LIGHT_GREY=$(t_option @line_color_light_grey "#3e4452")
DARK_GREY=$(t_option @line_color_dark_grey "#282c34")
BACKGROUND=$(t_option @line_color_bg "default")

# ------- SPECIAL MODULES CONFIGURATION ------
DATE_FORMAT=$(t_option @tmux_power_date_format '%H:%M')
INDICATOR=$(t_option @tmux_line_indicator 'TMUX')

# ------ MODULES CONFIGURATION ------
MODULE_A=$(t_option @tmux_line_module_a 'TITLE')
MODULE_B=$(t_option @tmux_line_module_b 'USER')
MODULE_C=$(t_option @tmux_line_module_c 'SESSION')
MODULE_X=$(t_option @tmux_line_module_x 'WEATHER')
MODULE_Y=$(t_option @tmux_line_module_y 'RAM')
MODULE_Z=$(t_option @tmux_line_module_z 'TIME')

# MODULES OPTIONS
RAM="#(free -h | awk '/^Mem:/ {gsub(\"Gi\", \"GB\", \$3); gsub(\"Gi\", \"GB\", \$2); print \"RAM \" \$3 \"/\" \$2}')"
CPU="#(top -bn1 | grep \"Cpu(s)\" | awk '{printf \"CPU %04.1f%%\", \$2 + \$4}')"
GIT="#(git -C #{pane_current_path} branch --show-current  | xargs -I {} echo  {})"
SESSION="#S"
USER="#(whoami)"
WEATHER=$(curl wttr.in/?format=%l:+%t)
TITLE=$INDICATOR
TIME=$DATE_FORMAT

apply_module_conf() {
  case $2 in
    *RAM*)
      eval "$1=\$RAM"
      ;;
    *CPU*)
      eval "$1=\$CPU"
      ;;
    *GIT*)
      eval "$1=\$GIT"
      ;;
    *TIME*)
      eval "$1=\$TIME"
      ;;
    *SESSION*)
      eval "$1=\$SESSION"
      ;;
    *USER*)
      eval "$1=\$USER"
      ;;
    *TITLE*)
      eval "$1=\$TITLE"
      ;;
    *WEATHER*)
      eval "$1=\$WEATHER"
      ;;
    *NONE*)
      eval "$1="
      ;;
  esac
}

apply_module_conf MODULE_A "$MODULE_A"
apply_module_conf MODULE_B "$MODULE_B"
apply_module_conf MODULE_C "$MODULE_C"
apply_module_conf MODULE_X "$MODULE_X"
apply_module_conf MODULE_Y "$MODULE_Y"
apply_module_conf MODULE_Z "$MODULE_Z"

# -------- SEPARATOR CONFIGURATION ENGINE
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

t_set status-style "fg=$FOREGROUND,bg=$BACKGROUND"
t_set status-interval 1
t_set status-justify "$JUSTIFY"
t_set status on
t_set status-attr none

# ---------------------- LEFT SIDE OF STATUS BAR
t_set status-left-length 150

LS_A="#[fg=$DARK_GREY]#[bg=$STATUS_COLOR]#[bold] $MODULE_A #[fg=$STATUS_COLOR]"
LS_B="#[bg=$LIGHT_GREY]$R_SEP#[fg=$FOREGROUND] $MODULE_B #[fg=$LIGHT_GREY]"
LS_C="#[bg=$DARK_GREY]$R_SEP #[fg=$FOREGROUND]$MODULE_C #[fg=$DARK_GREY]"

LS_END="#[bg=$BACKGROUND]$R_SEP"

t_set status-left "$LS_A$LS_B$LS_C$LS_END"

# --------------------- RIGHT SIDE OF STATUS BAR
t_set status-right-length 150

RS_X="#[bg=$BACKGROUND]#[fg=$DARK_GREY]$L_SEP#[bg=$DARK_GREY]#[fg=$FOREGROUND] $MODULE_X "
RS_Y="#[fg=$LIGHT_GREY]$L_SEP#[fg=$FOREGROUND]#[bg=$LIGHT_GREY]#[bold] $MODULE_Y⠀"
RS_Z="#[fg=$STATUS_COLOR]$L_SEP#[fg=$DARK_GREY]#[bg=$STATUS_COLOR]#[bold] $MODULE_Z⠀"

t_set status-right "$RS_X$RS_Y$RS_Z"

# ---------------------------WINDOW STATUS FORMAT
t_set window-status-format  "#[fg=$DARK_GREY,bg=default]#[bold]$R_SEP_ALT#[fg=$FOREGROUND,bg=$DARK_GREY] #I #W #[fg=$DARK_GREY,bg=$BACKGROUND]$R_SEP"

WS="#[fg=$STATUS_COLOR]#[bg=$BACKGROUND]#[bold]$R_SEP_ALT#[fg=$DARK_GREY]#[bg=$STATUS_COLOR]#[bold] #I #W#{?window_zoomed_flag,$SEP , }#[fg=$STATUS_COLOR]#[bg=$BACKGROUND]$R_SEP"

t_set window-status-current-format "$WS"
# -----------------

# Window separator - here for fast access
t_set window-status-separator ""

# Window status style
t_set window-status-style          "fg=$STATUS_COLOR,bg=$BACKGROUND,bold"
t_set window-status-last-style     "fg=$STATUS_COLOR,bg=$BACKGROUND,none"
t_set window-status-activity-style "fg=$STATUS_COLOR,bg=$BACKGROUND,bold"

# MISCELLANEOUS SYLE
t_set pane-border-style "fg=$DARK_GREY,bg=default"
t_set pane-active-border-style "fg=$STATUS_COLOR,bg=default"
t_set display-panes-colour "$DARK_GREY"
t_set display-panes-active-colour "$STATUS_COLOR"
t_set clock-mode-colour "$STATUS_COLOR"
t_set clock-mode-style 24
t_set message-style "fg=$STATUS_COLOR,bg=$BACKGROUND"
t_set message-command-style "fg=$STATUS_COLOR,bg=$BACKGROUND"
t_set mode-style "bg=$COPY,fg=$DARK_GREY"
