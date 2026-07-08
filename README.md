#PI Keeper

A Raspberry Pi that remotely wakes up a bigger server on demand, instead of leaving it running 24/7. This way I'm cutting electricity costs from about 15 Euros/month down to 1-2 Euros/month.

Demo

https://www.youtube.com/watch?v=MNQya4osDNU

Setup


Raspberry Pi 4B (Raspberry Pi OS Lite) - always-on, low-power controller.
Dell OptiPlex (Ubuntu LTS 24) - the actual server, only powered on when needed. Runs a Minecraft server.
The Pi wakes the Dell via Wake-on-LAN and can shut it down remotely over SSH using key-based authentication.


Networking & Security


WireGuard runs on the Pi, so I can SSH into it remotely through the VPN instead of exposing SSH to the internet.
Port forwarding is configured on both the router and the Pi itself (via UFW).
Only two ports are open to the outside: 25565 (Minecraft) and the WireGuard port.
SSH (port 22) is internal-only, no external access, reachable only once connected through the VPN.
On boot, the minecraft service is enabled on the Dell, so the server comes up automatically once the machine powers on.


Scripts

Two Bash scripts live in the Pi's $USER directory:


Wake script - sends a Wake-on-LAN packet to power on the Dell.
Shutdown script - connects over SSH (key-based auth) and shuts the Dell down cleanly.

Setup script - I made this in case I need to reinstall the os on the Raspberry Pi. Wich I need to do from time to time because usb sticks and micro-sd cards can't run an os for too long. The script updates and upgrades the script. It also fully installs and sets up Wireguard, UFW, Etherwake etc.


Tech Stack

Raspberry Pi OS Lite, Ubuntu LTS 24
WireGuard, UFW, OpenSSH, Etherwake (key-based auth)
Wake-on-LAN enabled in BIOS
Bash


Challenges

First I tried setting up Wireguard manually. I somehow made it work, but I only had access to the local network through the VPN. I couldn't access the internet. Then I found angristan's setup on github wich is plug and play more or less.
