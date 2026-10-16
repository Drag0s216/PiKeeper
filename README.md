# 🥧 PI Keeper

A low-power Raspberry Pi setup designed to remotely wake up a heavier server on demand, cutting electricity costs from ~15€/month down to 1–2€/month.

---

## 📹 Demo

[![Watch Demo](https://img.shields.io/badge/YouTube-Watch%20Demo-red?style=for-the-badge&logo=youtube)](https://www.youtube.com/watch?v=MNQya4osDNU)

---

## 🛠️ Hardware & OS Setup

| Component / Device | OS / Role |
| :--- | :--- |
| **Raspberry Pi 4B** | Raspberry Pi OS Lite — *Always-on, low-power controller* |
| **Dell OptiPlex** | Ubuntu LTS 24 — *Main server (runs a Minecraft server, powered on only when needed)* |

* **Functionality:** The Pi wakes up the Dell via **Wake-on-LAN** and shuts it down remotely over **SSH** using key-based authentication.

---

## 🔒 Networking & Security

* **VPN Access:** WireGuard runs on the Pi, allowing secure remote SSH access without exposing SSH directly to the internet.
* **Port Forwarding & Firewall:** Configured on both the router and the Pi (via UFW).
* **Open Ports (External):** Only **25565** (Minecraft) and the **WireGuard** port.
* **Internal Security:** SSH (port 22) is internal-only and accessible exclusively through the VPN.
* **Automation:** The Minecraft service is enabled on boot on the Dell, starting automatically once powered on.

---

## 📜 Automation & Scripts

Two main Bash scripts live in the Pi's `$USER` directory:
* **Wake script:** Sends a Wake-on-LAN packet to power on the Dell.
* **Shutdown script:** Connects over SSH (key-based auth) and shuts down the Dell cleanly.

### 🔄 Setup Script
Created to handle OS reinstalls (due to micro-SD/USB wear over time). 
* Automatically updates/upgrades the system.
* Fully installs and sets up **WireGuard**, **UFW**, **Etherwake**, etc.

---

## ⚠️ Challenges & Learnings

* **Initial WireGuard hurdle:** Manually setting up WireGuard initially gave me local network access through the VPN, but cut off internet routing. 
* **Solution:** Switched to **angristan's setup script on GitHub**, which provided a reliable, plug-and-play configuration.

---

## 🧰 Tech Stack

![Raspberry Pi](https://img.shields.io/badge/Raspberry%2520Pi-C51A4A?style=for-the-badge&logo=Raspberry-Pi&logoColor=white)
![Ubuntu](https://img.shields.io/badge/Ubuntu-E95420?style=for-the-badge&logo=ubuntu&logoColor=white)
![WireGuard](https://img.shields.io/badge/WireGuard-88171A?style=for-the-badge&logo=wireguard&logoColor=white)
![Linux](https://img.shields.io/badge/Linux-FCC624?style=for-the-badge&logo=linux&logoColor=black)
![Bash](https://img.shields.io/badge/Bash-4EAA25?style=for-the-badge&logo=gnu-bash&logoColor=white)
