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
        res = subprocess.Popen(['curl' , '--location' , '--request' , 'GET' , 'https://lambda-smartbankapp.api.cloudtech-training.com'])
        # res = subprocess.Popen(['curl --location --request GET https://lambda-smartbankapp.api.cloudtech-training.com'],shell=True)
        # ping_address = subprocess.Popen(['nslookup' ' lambda-smartbankapp.api.cloudtech-training.com'],shell=True)
        # print(ping_address)
        if res == 0:
            print("Ping successfully done")
        elif res ==2:
            print("No Respoonse from address")
        else:
            print("Failed")



# if __name__ == "__main__":
pinging_2()