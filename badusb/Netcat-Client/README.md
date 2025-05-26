
<h2 align="center"> Simple Netcat Client </h2>

SYNOPSIS

Opens a netcat connection to a Windows machine in Powershell

USAGE

1. Download Ncat For windows. https://nmap.org/download#windows
2. Change "YOUR IP HERE" to the attacker machine's ipv4 address (find using ipconfig on windows)
3. Open a terminal on the attacker machine and type "nc -lvp 4444"
4. Run this script on the client machine.

NOTE

The PORT number is 4444