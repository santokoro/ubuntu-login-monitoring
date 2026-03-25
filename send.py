#!/usr/bin/env python3
import sys
import requests

TOKEN = "8360024858:AAGEFi0BwpRDbKWMhAgGPrbHC5Swq7GlqxQ"
CHAT_ID = "6535291803"

message = " ".join(sys.argv[1:])

url = f"https://api.telegram.org/bot{TOKEN}/sendMessage"
data = {"chat_id": CHAT_ID, "text": message}

requests.post(url, data=data)

