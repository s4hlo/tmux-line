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
FLOAT=$(t_option @line_style_float false)

# ------ COLORS CONFIGURATION -------
BASE=$(t_option @line_color_base "#61afef")
SYNC=$(t_option @line_color_sync "#e06c75")
PREFIX=$(t_option @line_color_prefix "#c678dd")
COPY=$(t_option @line_color_copy "#98c379")

FOREGROUND=$(t_option @line_color_fg "#abb2bf")
LIGHT=$(t_option @line_color_light "#3e4452")
DARK=$(t_option @line_color_dark "#282c34")
BACKGROUND=$(t_option @line_color_bg "default")

STATUS_COLOR="#{?client_prefix,$PREFIX,#{?pane_in_mode,$COPY,#{?pane_synchronized,$SYNC,$BASE}}}"

# ------- SPECIAL MODULES CONFIGURATION ------
DATE_FORMAT=$(t_option @line_date_format '%H:%M')
INDICATOR=$(t_option @line_indicator 'TMUX')

# ------ MODULES CONFIGURATION ------
MODULE_A=$(t_option @line_module_a 'title')
MODULE_B=$(t_option @line_module_b 'user')
MODULE_C=$(t_option @line_module_c 'session')
MODULE_X=$(t_option @line_module_x 'weather')
MODULE_Y=$(t_option @line_module_y 'ram')
MODULE_Z=$(t_option @line_module_z 'time')



############# ENGINES #############



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
    *ram*)
      eval "$1=\$RAM"
      ;;
    *cpu*)
      eval "$1=\$CPU"
      ;;
    *git*)
      eval "$1=\$GIT"
      ;;
    *time*)
      eval "$1=\$TIME"
      ;;
    *session*)
      eval "$1=\$SESSION"
      ;;
    *user*)
      eval "$1=\$USER"
      ;;
    *title*)
      eval "$1=\$TITLE"
      ;;
    *weather*)
      eval "$1=\$WEATHER"
      ;;
    *none*)
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


if [ -z "$MODULE_A" ]; then
    LS_A="#[fg=$DARK]#[bg=$STATUS_COLOR]#[bold] #[fg=$STATUS_COLOR]"
else
    LS_A="#[fg=$DARK]#[bg=$STATUS_COLOR]#[bold] $MODULE_A #[fg=$STATUS_COLOR]"
fi

if [ -z "$MODULE_B" ]; then
    LS_B=""
else
    LS_B="#[bg=$LIGHT]$R_SEP#[fg=$FOREGROUND] $MODULE_B #[fg=$LIGHT]"
fi

if [ -z "$MODULE_C" ]; then
    LS_C=""
else
    LS_C="#[bg=$DARK]$R_SEP #[fg=$FOREGROUND]$MODULE_C #[fg=$DARK]"
fi
# STATUS_COLOR="#{?client_prefix,$PREFIX,#{?pane_in_mode,$COPY,#{?pane_synchronized,$SYNC,$BASE}}}"

LS_END="#[bg=$BACKGROUND]$R_SEP"


if $FLOAT; then
   L_FLOAT=" #[fg=$STATUS_COLOR]#[bg=$BACKGROUND]$L_SEP"
fi

t_set status-left "$L_FLOAT$LS_A$LS_B$LS_C$LS_END"

# --------------------- RIGHT SIDE OF STATUS BAR
t_set status-right-length 150

if [ -z "$MODULE_X" ]; then
    RS_X=""
else
    RS_X="#[bg=$BACKGROUND]#[fg=$DARK]$L_SEP#[bg=$DARK]#[fg=$FOREGROUND] $MODULE_X "
fi

if [ -z "$MODULE_Y" ]; then
    RS_Y=""
else
    RS_Y="#[fg=$LIGHT]$L_SEP#[fg=$FOREGROUND]#[bg=$LIGHT]#[bold] $MODULE_Y⠀"
fi

if [ -z "$MODULE_Z" ]; then
    RS_Z=""
else
    RS_Z="#[fg=$STATUS_COLOR]$L_SEP#[fg=$DARK]#[bg=$STATUS_COLOR]#[bold] $MODULE_Z⠀"
fi

if $FLOAT; then
   R_FLOAT="#[fg=$STATUS_COLOR]#[bg=$BACKGROUND]$R_SEP "
fi

t_set status-right "$RS_X$RS_Y$RS_Z$R_FLOAT"


# ---------------------------WINDOW STATUS FORMAT
t_set window-status-format  "#[fg=$DARK,bg=default]#[bold]$R_SEP_ALT#[fg=$FOREGROUND,bg=$DARK] #I #W #[fg=$DARK,bg=$BACKGROUND]$R_SEP"

WS="#[fg=$STATUS_COLOR]#[bg=$BACKGROUND]#[bold]$R_SEP_ALT#[fg=$DARK]#[bg=$STATUS_COLOR]#[bold] #I #W#{?window_zoomed_flag,$SEP , }#[fg=$STATUS_COLOR]#[bg=$BACKGROUND]$R_SEP"

t_set window-status-current-format "$WS"
# -----------------

# Window separator - here for fast access
t_set window-status-separator ""

# Window status style
t_set window-status-style          "fg=$STATUS_COLOR,bg=$BACKGROUND,bold"
t_set window-status-last-style     "fg=$STATUS_COLOR,bg=$BACKGROUND,none"
t_set window-status-activity-style "fg=$STATUS_COLOR,bg=$BACKGROUND,bold"

# MISCELLANEOUS SYLE
t_set pane-border-style "fg=$DARK,bg=default"
t_set pane-active-border-style "fg=$STATUS_COLOR,bg=default"
t_set display-panes-colour "$DARK"
t_set display-panes-active-colour "$STATUS_COLOR"
t_set clock-mode-colour "$STATUS_COLOR"
t_set clock-mode-style 24
t_set message-style "fg=$STATUS_COLOR,bg=$BACKGROUND"
t_set message-command-style "fg=$STATUS_COLOR,bg=$BACKGROUND"
t_set mode-style "bg=$COPY,fg=$DARK"
