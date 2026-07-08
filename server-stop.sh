#!/bin/bash

RED="\e[0;91m"
GREEN="\e[0;92m"
YELLOW="\e[0;93m"
RESET="\e[0m"

echo -e "${YELLOW}"
echo "Checking Server Status..."

if ! ping -c1 -W3 192.168.1.133 >/dev/null 2>&1; then
    echo -e "${RED}"
    echo "Server OFFLINE or UNREACHABLE."
    echo ""
    exit 1
fi
echo -e "${GREEN}"
echo "Server is ONLINE"
echo -e "${RESET}"
echo "Attempting SSH connection..."

if ssh -i /home/dragos216/.ssh/id_ed25519 -o ConnectTimeout=10 dragos216@192.168.1.133 sudo shutdown -h now; then
    echo -e "${GREEN}"
    cat << "EOF"

   _____ _    _  _____ _____ ______  _____ _____ 
  / ____| |  | |/ ____/ ____|  ____|/ ____/ ____|
 | (___ | |  | | |   | |    | |__  | (___| (___  
  \___ \| |  | | |   | |    |  __|  \___ \\___ \ 
  ____) | |__| | |___| |____| |____ ____) |___) |
 |_____/ \____/ \_____\_____|______|_____/_____/ 

EOF
    echo -e "${RESET}"
    echo "Remote server stopped with no errors."
    echo ""
    echo -e "${YELLOW}"
    echo "Disconnect and disable WireGuard"
    echo ""
else
    echo -e "${RED}"
    cat << "EOF"
    


 (              (    (           (         
 )\ )    (      )\ ) )\ )        )\ )      
(()/(    )\    (()/((()/(    (  (()/( (    
 /(_))((((_)(   /(_))/(_))   )\  /(_)))\   
(_))_| )\ _ )\ (_)) (_))  _ ((_)(_)) ((_)  
| |_   (_)_\(_)|_ _|| |  | | | || _ \| __| 
| __|   / _ \   | | | |__| |_| ||   /| _|  
|_|    /_/ \_\ |___||____|\___/ |_|_\|___| 
                                            

EOF
    echo -e "${RESET}"
    echo "SSH connection or shutdown failed."
fi
