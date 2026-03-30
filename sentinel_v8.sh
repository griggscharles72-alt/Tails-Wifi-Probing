#!/bin/bash

LOG="$HOME/sentinel_wifi_log.txt"
TMP="$HOME/.sentinel_scan.tmp"

echo "======================================" | tee -a $LOG
echo " SENTINEL V8 WIRELESS RECON ENGINE" | tee -a $LOG
echo "======================================" | tee -a $LOG

echo
echo "[BLOCK 1] Timestamp" | tee -a $LOG
date | tee -a $LOG

echo
echo "[BLOCK 2] Adapter status" | tee -a $LOG
nmcli device status | grep wifi | tee -a $LOG

echo
echo "[BLOCK 3] Interface addresses" | tee -a $LOG
ip -br addr | tee -a $LOG

echo
echo "[BLOCK 4] Gateway" | tee -a $LOG
ip route | grep default | tee -a $LOG

echo
echo "[BLOCK 5] Gateway MAC" | tee -a $LOG
ip neigh | grep 192.168 | tee -a $LOG

echo
echo "[BLOCK 6] Raw WiFi scan" | tee -a $LOG
nmcli -f IN-USE,SSID,BSSID,CHAN,SIGNAL,SECURITY device wifi list | tee $TMP | tee -a $LOG

echo
echo "[BLOCK 7] Hidden networks" | tee -a $LOG
grep "^--" $TMP | tee -a $LOG
HIDDEN=$(grep "^--" $TMP | wc -l)
echo "Hidden networks: $HIDDEN" | tee -a $LOG

echo
echo "[BLOCK 8] Total networks detected" | tee -a $LOG
TOTAL=$(tail -n +2 $TMP | wc -l)
echo "Networks detected: $TOTAL" | tee -a $LOG

echo
echo "[BLOCK 9] Strongest signals" | tee -a $LOG
sort -k5 -nr $TMP | head -5 | tee -a $LOG

echo
echo "[BLOCK 10] Channel congestion map" | tee -a $LOG
awk '{print $4}' $TMP | sort | uniq -c | sort -nr | tee -a $LOG

echo
echo "[BLOCK 11] Band distribution" | tee -a $LOG

LOW=0
HIGH=0

while read line
do
CH=$(echo $line | awk '{print $4}')

if [[ "$CH" =~ ^[0-9]+$ ]]; then

if [ "$CH" -le 14 ]; then
LOW=$((LOW+1))
else
HIGH=$((HIGH+1))
fi

fi

done < $TMP

echo "2.4GHz networks: $LOW" | tee -a $LOG
echo "5GHz networks: $HIGH" | tee -a $LOG

echo
echo "[BLOCK 12] Mesh / extender hints" | tee -a $LOG

cut -d: -f1-3 $TMP | sort | uniq -c | sort -nr | head | tee -a $LOG

echo
echo "[BLOCK 13] LAN devices" | tee -a $LOG
ip neigh | grep 192.168 | tee -a $LOG

echo
echo "[BLOCK 14] Possible IoT devices" | tee -a $LOG

grep -i "roku\|fire\|camera\|blink\|tv\|direct" $TMP | tee -a $LOG

echo
echo "[BLOCK 15] WEP / weak security detection" | tee -a $LOG
grep -i "WEP" $TMP | tee -a $LOG

echo
echo "[BLOCK 16] Tails isolation interfaces" | tee -a $LOG
ip link | grep veth | tee -a $LOG

echo
echo "======================================" | tee -a $LOG
echo " SENTINEL V8 SCAN COMPLETE"
echo " Log saved to: $LOG"
echo "======================================"
