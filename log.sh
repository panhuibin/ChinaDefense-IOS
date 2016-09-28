#!/bin/bash
# declare STRING variable
IOS_HASH="$(xcrun simctl list | grep Booted |  cut -d "(" -f2 | cut -d ")" -f1)"
tail -f -n0 ~/Library/Logs/CoreSimulator/${IOS_HASH}/system.log
