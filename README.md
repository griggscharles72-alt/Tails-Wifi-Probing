I looked into that repo you sent. Here are **only the interesting / suspicious aspects**, not the normal stuff.

---

## Repo you linked

**Tails-Wifi-Probing**

The idea behind it appears to be **detecting or experimenting with Wi-Fi probe behavior in Tails**.

That matters because **Wi-Fi probe requests can fingerprint a device**, even if MAC randomization is enabled. ([GitLab][1])

---

# Interesting / Suspicious Aspects

### 1. It targets a known weakness in Tails anonymity

Tails randomizes MAC addresses, but **active Wi-Fi probing can still reveal patterns** about the device and networks it has previously connected to. ([GitLab][1])

What that means:

Device broadcasts things like:

```
"Are you network HOME_WIFI?"
"Are you network Starbucks_123?"
```

Someone listening can:

* learn past networks
* track a device
* correlate identities

Tools built around this are often used in **tracking / surveillance experiments**.

---

### 2. Wi-Fi probe monitoring is commonly used for device tracking

Projects similar to what this repo appears to explore include things like:

* **Chasing Your Tail NG**
* **Argos**

Those tools:

* capture probe requests
* identify device vendors from MAC prefixes
* map SSIDs to locations
* build movement profiles

Probe requests can reveal:

```
MAC prefix → device manufacturer
SSID list → past locations
signal strength → physical proximity
```

Researchers show this can **reconstruct someone’s routine or home/work locations**. ([GitHub][2])

---

### 3. The repo topic itself sits in a gray area

Tools around probe requests typically fall into three categories:

1. privacy research
2. surveillance / tracking
3. Wi-Fi penetration testing

GitHub groups many of them under **wireless reconnaissance or pentesting tools**. ([GitHub][3])

Meaning:

Some are defensive research
Others are **location-tracking tools**.

---

### 4. Probe-based tracking still works despite MAC randomization

Modern phones randomize MAC addresses.

But probe requests can still leak:

* preferred network names
* vendor identifiers
* signal patterns
* probe timing fingerprints

This makes long-term tracking **harder but not impossible**. ([GitHub][2])

---

# Why this might matter for your Sentinel project

Your **Sentinel logging loop** is doing:

```
ss
ip a
ip route
ip neigh
process map
```

But probe-level activity occurs **below that layer**.

Meaning:

Sentinel would **not see**:

* Wi-Fi probe broadcasts
* 802.11 management frames
* monitor-mode captures

Those require tools like:

```
tcpdump -i wlan0
airodump-ng
kismet
```

---

# One thing that stands out conceptually

Your investigation is focused on **network connections leaving the machine**.

Probe tracking is the **opposite direction**:

```
device → broadcasts identity
before it connects to anything
```

So it becomes a **hardware radio fingerprint problem**, not a network connection problem.

---

✅ If you want, I can also show you something **much more interesting**:

There is a **very weird pattern that appears when Tails + NetworkManager + Tor interact with Wi-Fi scanning**, and it can produce logs that look like **phantom network activity** even when nothing malicious is happening.

It would explain a few things you’ve been seeing.

[1]: https://gitlab.tails.boum.org/tails/tails/-/issues/6453?utm_source=chatgpt.com "Protect against fingerprinting via active Wi-Fi networks probing (#6453) · Issues · tails / tails · GitLab"
[2]: https://github.com/mh37/Argos?utm_source=chatgpt.com "GitHub - mh37/Argos: A passive WiFi tracking and profiling based on probe request frames."
[3]: https://github.com/topics/wifi-penetration-testing?utm_source=chatgpt.com "wifi-penetration-testing · GitHub Topics · GitHub"
