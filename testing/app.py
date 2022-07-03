import time
import requests
import os
import subprocess
def pinging_py():
    while True:
        url = "https://lambda-smartbankapp.api.cloudtech-training.com"
        payload={}
        headers = {}
        response = requests.request("GET", url, headers=headers, data=payload)
        # print(response.text)

def pinging_2():
    while True:
        res = subprocess.Popen(['curl' ,'-s', '--location' , '--request' , 'GET' , 'https://lambda-smartbankapp.api.cloudtech-training.com/'])
        # res = subprocess.Popen(['curl --location --request GET https://lambda-smartbankapp.api.cloudtech-training.com'],shell=True)
        # ping_address = subprocess.Popen(['nslookup' ' lambda-smartbankapp.api.cloudtech-training.com'],shell=True)
        # print(ping_address)



# if __name__ == "__main__":
pinging_2()
