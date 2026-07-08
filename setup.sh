#!/bin/bash

sudo apt update -y
sudo apt install etherwake ufw -y

sudo ufw allow 22
sudo ufw allow 51821
sudo ufw enable -y

cat > server-start.sh << 'SCRIPT1_EOF'
#!/bin/bash

RED="\e[0;91m"
GREEN="\e[0;92m"
YELLOW="\e[0;93m"
RESET="\e[0m"

echo -e "${YELLOW}"
echo "Checking Host Status..."

if ping -c 1 -W 3 192.168.1.133 > /dev/null 2>&1; then
    echo -e "${GREEN}"
    echo "Host is ONLINE"
    echo -e "${RESET}"
    exit 1
fi
echo -e "${RED}"
echo "Host Offline"
echo -e "${YELLOW}"

sudo etherwake -i wlan0 E4:B9:7A:FA:14:4F
echo "Booting up, please wait..."

TOTAL=60        
ELAPSED=0
PERCENT=0
UPDATES=6       
SLEEP_MIN=3
SLEEP_MAX=9

while [ $ELAPSED -lt $TOTAL ] && [ $PERCENT -lt 100 ]; do
    REMAINING_PERCENT=$((100 - PERCENT))
    REMAINING_UPDATES=$((UPDATES - 1))
    
    if [ $REMAINING_UPDATES -le 0 ]; then
        MAX_INC=$REMAINING_PERCENT
    else
        MAX_INC=$((REMAINING_PERCENT / REMAINING_UPDATES))
        if [ $MAX_INC -lt 5 ]; then
            MAX_INC=5
        fi
    fi
    
    INC=$((RANDOM % (MAX_INC - 4) + 5))
    PERCENT=$((PERCENT + INC))
    
    if [ $PERCENT -gt 100 ]; then
        PERCENT=100
    fi
    
    echo -e "${RESET}"
    echo "Boot progress: $PERCENT%"
    
    SLEEP=$((RANDOM % (SLEEP_MAX - SLEEP_MIN + 1) + SLEEP_MIN))
    
    REMAINING_TIME=$((TOTAL - ELAPSED))
    if [ $SLEEP -gt $REMAINING_TIME ]; then
        SLEEP=$REMAINING_TIME
    fi
    
    sleep ${SLEEP}s
    ELAPSED=$((ELAPSED + SLEEP))
done


if [ $PERCENT -lt 100 ]; then
    echo "Boot progress: 100%"
fi

echo ""
echo "Attempting connection..."



if ssh -i /home/dragos216/.ssh/id_ed25519 -o ConnectTimeout=10 dragos216@192.168.1.133 exit; then
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
    echo "Remote server started successfully."
    echo ""

    echo -e "${YELLOW}"
    echo "Disconnect and disable WireGuard"
    echo -e "${RED}"
    echo ""
    
    echo "REMEMBER TO SHUT DOWN!!!"
    echo -e "${RESET}"
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
    echo "SSH connection or boot up failed."
fi

SCRIPT1_EOF

cat > server-stop.sh << "SCRIPT2_EOF"
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
SCRIPT2_EOF

chmod +x server-start.sh
chmod +x server-stop.sh

curl -O https://raw.githubusercontent.com/angristan/wireguard-install/master/wireguard-install.sh
chmod +x wireguard-install.sh

sudo bash wireguard-install.sh <<EOF
[NETWORK IP]



51821


 


Dragos-PC


EOF

sudo apt upgrade -y
sudo reboot