#!/usr/bin/env bash

#trizen -Sy &
trizen_pid=$!

function check_updates() {
  kitty --title "System Update" --start-as=fullscreen ~/.scripts/show_message.sh "Checking for updates..." &
  display_pid=$!
  wait $trizen_pid
  due_updates="$(trizen -Qu | wc -l)"
  kill $display_pid

  if [ "$due_updates" -gt "0" ]; then
    kitty --title "System Update" --start-as=fullscreen ~/.scripts/ask_and_run_updates.sh "$due_updates"
  fi
  echo "Executing: systemctl $1"
  systemctl $1
}


# Alle moeglichen Optionen definieren
read -r -d '\n' options <<EOF
Lock
Logout
Reboot
Shutdown
EOF

# Nutzer Input abfragen und in $selected speichern
selected=$(echo "$options" | ~/.cargo/bin/aphorme --select-from-stdin)

# Mit nem switch-statement checken, welche Aktion ausgefuehrt werden soll
case "$selected" in
  Shutdown)
    echo "Shutting down..."
    #check_updates poweroff
    systemctl poweroff
    ;;
  Reboot)
    echo "Rebooting..."
    #check_updates reboot
    systemctl reboot
    ;;
  Logout)
    echo "Logging out..."
    hyprctl dispatch exit
    ;;
  Lock)
    echo "Locking"
    swaylock --image /home/toxotes/.config/hypr/starfleet_intelligence.png --indicator-radius 230 --indicator-x-position 1262 --indicator-y-position 410 --indicator-thickness 7  --ring-color 005500 --key-hl-color 880033 --line-color 00000000 --inside-color 00000088 --separator-color 00000000
    # swaylock --screenshots --clock --indicator --indicator-radius 100 --indicator-thickness 7 --effect-blur 7x5 --effect-vignette 0.5:0.5 --ring-color 005500 --key-hl-color 880033 --line-color 00000000 --inside-color 00000088 --separator-color 00000000 --grace 2 --fade-in 0.2
    ;;
  *)
    echo "Error: Unknown selection: $selected !"
    exit 1
esac

# vim: ts=2:et:sw=2:sts=2:noai
