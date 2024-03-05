#  ______            _      _
# |  ____|          (_)    | |
# | |__  __ _  _ __  _   __| |
# |  __|/ _` || '__|| | / _` |
# | |  | (_| || |   | || (_| |
# |_|   \__,_||_|   |_| \__,_|

### VirtualBox ###
function server() {
  ##################
  # Control server #
  ##################

  # Start VM
  if [[ "$2" == "on" ]]; then
    VBoxManage startvm "$1" --type headless
  # Power off VM
  elif [[ "$2" == "off" ]]; then
    VBoxManage controlvm "$1" poweroff
  # Shutdown
  elif [[ "$2" == "shutdown" ]]; then
    VBoxManage controlvm "$1" acpipowerbutton

  #############
  # Snapshots #
  #############

  # Lists
  elif [[ "$2" = "snapshots" ]]; then
    VBoxManage snapshot "$1" list
  # Take
  elif [[ "$2" = "save" ]]; then
    VBoxManage snapshot "$1" take $3
  # Take with live VM
  elif [[ "$2" = "save-live" ]]; then
    VBoxManage snapshot "$1" take $3 --live
  # Restore
  elif [[ "$2" = "restore" ]]; then
    VBoxManage snapshot "$1" restore $3
  # Delete
  elif [[ "$2" = "delete" ]]; then
    VBoxManage snapshot "$1" delete $3

  #################
  # Connect to VM #
  #################
  elif [[ "$1" == "connect1" ]]; then
    # $2 == Port | $3 == user@ip
    ssh -p $2 $3

  #################
  # List commands #
  #################
  elif [[ "$1" = "-l" ]]; then
    echo "on                         :Start VM"
    echo "off                        :Poweroff VM"
    echo "snapshots                  :List snapshots"
    echo "save \"[snap-name]\"         :Save snapshot"
    echo "restore \"[snap-name]\"      :Restore snapshot"
    echo "delete \"[snap-name]\"       :Delete snapshot"
    echo "connect                    :Connect with SSH"
  else
    echo "Not command found"
  fi
}

# Retrieve user installed packages
function pkgs() {
  if [ $# -eq 0 ];then
    (zcat $(ls -tr /var/log/apt/history.log*.gz); cat /var/log/apt/history.log) 2>/dev/null | egrep '^(Commandline:)' | egrep 'apt|apt-get' | sed '1,5d'
  elif [ $# -eq 1 ];then
    (zcat $(ls -tr /var/log/apt/history.log*.gz); cat /var/log/apt/history.log) 2>/dev/null | egrep '^(Commandline:)' | egrep 'apt|apt-get' | sed '1,5d' > $(readlink -f $1)
  else
    echo 'Please, just use 0 or 1 argument (Output file)'
  fi
}

# Swap files
function swap() {
    local tmp_file=tmp.$$
    mv "$1" $tmp_file && mv "$2" "$1" && mv $tmp_file "$2"
}

# Swap git profiles
function swap_git() {
  # TODO
}
