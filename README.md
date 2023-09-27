# Amsi-shell
Amsi_bypass with meterpreter shell. (Working on columnar transposition encoding).

Also generates a base64 payload that works with powershell -enc


## Usage

On kali:

pwsh ./Invoke-Amsi-shell.ps1 [payload] [listen ip] [port] [webserver_port]

![image](https://github.com/wlfrag/Amsi-shell/assets/43529877/1714e5d4-5218-40b2-b8e9-fad5a639b1dc)



[Files]

test.ps1 - contains the initial bypass 

1.txt - contains the payload.


[Victim]

![image](https://github.com/wlfrag/Amsi-shell/assets/43529877/72ad64f4-66ab-43c4-a021-63191338dc6a)

Downloads the initial AMSI_Bypass(test.ps1)

Executes in memory.

Downloads the payload "1.txt"


[Kali]

![image](https://github.com/wlfrag/Amsi-shell/assets/43529877/64a8f8aa-1418-4f30-9c9e-0de1c43fe6c7)




[Kali]

![image](https://github.com/wlfrag/Amsi-shell/assets/43529877/71631d3d-9a01-49a3-ac80-2473bd8f0b9b)




