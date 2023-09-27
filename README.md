# Amsi-shell
Amsi_bypass with meterpreter shell. (Working on columnar transposition encoding).

Also generates a base64 payload that works with powershell -enc


## Usage

On kali:

pwsh ./Invoke-Amsi-shell.ps1 [payload] [listen ip] [port] [webserver_port]

![image](https://github.com/wlfrag/Amsi-shell/assets/43529877/047ace71-6a80-400b-bd08-6e584509a0d1)

[Files]

test.ps1 - contains the initial bypass 

1.txt - contains the payload.


[Victim]

![image](https://github.com/wlfrag/Amsi-shell/assets/43529877/531c9c73-a4da-4f6f-b333-5c30bdb402e7)


Downloads the initial AMSI_Bypass(test.ps1)

Executes in memory.

Downloads the payload "1.txt"


[Kali]

![image](https://github.com/wlfrag/Amsi-shell/assets/43529877/9a07e9ed-03e8-42e5-8022-3394fc900db7)


[Kali]

![image](https://github.com/wlfrag/Amsi-shell/assets/43529877/c7bda651-3587-4dd5-8bbc-eddbd7c465bc)



