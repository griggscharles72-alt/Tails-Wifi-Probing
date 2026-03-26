# Sentinel Investigation README

**Host:** `amnesia@amnesia`
**OS:** Tails
**Tool:** Sentinel (continuous network logging loop)
**Investigation Type:** Suspicious network / Wi-Fi activity

---

## 1. Timeline of Suspicious Activity

### [2026-03-26 01:22:45 UTC]

**Observation:** External TCP connection outside Tor network
**Evidence:**

* Local: `192.168.1.13:39194`
* Remote: `162.19.244.234:443`
* Protocol: TCP, ESTABLISHED, Recv-Q: 1586
  **Context:** Connection bypasses Tor virtual interfaces (`veth-tbb`, etc.)
  **Affected Component:** Clearnet interface `wlan0`
  **Implication:** Possible direct data leak or unintended external connection

---

### [2026-03-26 04:14:11 UTC]

**Observation:** Additional external endpoints
**Evidence:**

1. `46.22.165.111:9001` – TCP, ESTABLISHED
2. `51.195.118.232:9000` – TCP, ESTABLISHED
3. Public IP seen: `192.42.116.12`
   **Context:** External endpoints repeating across snapshots
   **Affected Component:** Non-Tor connections via `wlan0` and `wlan1`
   **Implication:** Persistent clearnet connections could correlate with device fingerprinting or unexpected exposure

---

### Local Anomalies

**Listening Services:**

* Port `951` bound to `0.0.0.0` (all interfaces)

**Active Interfaces:**

* `wlan0 → 192.168.1.13`
* `wlan1 → 192.168.1.145`

**Tor Virtual Interfaces:**

* `veth-tbb 10.200.1.0/30`
* `veth-onioncircs 10.200.1.4/30`
* `veth-tca 10.200.1.8/30`
* `veth-onionshare 10.200.1.12/30`
* `veth-clearnet 10.200.1.16/30`

**Implication:** Multiple interfaces + listening on all interfaces could allow routing leaks or tracking exposures.

---

## 2. Repo Investigation: `Tails-Wifi-Probing`

**Topic:** Wi-Fi probe request experimentation on Tails

**Suspicious Aspects:**

1. **Exploits a known weakness in Tails anonymity**

   * Active Wi-Fi probes can reveal prior networks despite MAC randomization
   * Device can broadcast SSIDs like `"HOME_WIFI"` or `"Starbucks_123"`
   * Risk: device fingerprinting and correlation of past locations

2. **Probe monitoring can enable tracking**

   * Captures SSIDs, MAC prefixes, signal strength
   * Maps devices to locations and reconstructs movement patterns

3. **Repo sits in a gray area**

   * Could be privacy research or a surveillance/tracking tool
   * Falls under wireless reconnaissance or pentesting tools

4. **Probe-based tracking works even with randomized MACs**

   * Leaks: preferred networks, vendor IDs, signal patterns, timing fingerprints

**Implication for Sentinel Project:**

* Your network logging loop (`ss`, `ip a`, `ip route`, `ip neigh`) **cannot see probe-level activity**
* Wi-Fi probing occurs below the network layer, in 802.11 management frames
* Tools required: `tcpdump -i wlan0`, `airodump-ng`, `kismet`

---

## 3. Correlation

* Multiple external endpoints bypass Tor → suspicious network leaks
* Port 951 listening on all interfaces → potential unintended exposure
* Repo topic + probe-level risk → device could be fingerprinted locally even if Tor is enforced
* Phantom or unexpected network activity could also be explained by Tails + NetworkManager + Tor interacting with Wi-Fi scanning

---

## 4. Next Suggested Steps

1. **Verify port 951 usage** – determine which process is listening
2. **Monitor external connections** – trace repeated endpoints
3. **Wi-Fi probe capture** – use monitor-mode tools to see if device broadcasts identifiable SSIDs
4. **Correlate Tor enforcement** – confirm all traffic is routed through virtual interfaces
5. **Document findings for each snapshot** – maintain timeline and logs for forensic record

---

This README keeps **everything suspicious**, links **network and Wi-Fi risks**, and leaves out all noise. It’s ready for use as a formal investigation document.

---

If you want, I can **merge all your historical Sentinel loop logs and Tor logs into this README**, IP by IP, timestamp by timestamp, to create a **fully chronological, forensic-grade artifact log**. That way you’d have **one single document with every suspicious element tracked and explained**.

Do you want me to do that next?
