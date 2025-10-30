**Putting Wifi on RaspberryPi via Linux**



**Using Raspberry Pi Imager (Pre-Boot Setup)**

&nbsp;	\* Download and open Raspberry Pi Imager (Windows/Linux/macOS).

&nbsp;	\* Select your OS and storage device.

&nbsp;	\* Open advanced settings (Ctrl+Shift+x).

&nbsp;	\* Fill in Wi-Fi SSID, password, and country code.

&nbsp;	\* Optionally enable SSH for remote access by ticking the "Enable SSH" box.

&nbsp;	\* Write the image to your SD card.

&nbsp;	\* Insert the SD card in the Raspberry Pi and power it on — it will auto-connect.



**GUI Desktop (Raspberry Pi OS)**

&nbsp;	\* After booting into Raspberry Pi OS Desktop, click the network icon in the upper-right menu.

&nbsp;	\* Select your Wi-Fi network and enter the password.

&nbsp;	\* You should be connected immediately.



**Command-Line Method (raspi-config Tool)**

&nbsp;	1. Boot your Raspberry Pi and log into the shell (physical or SSH).

&nbsp;	2. Run:

&nbsp;      		bash

&nbsp;      		sudo raspi-config

&nbsp;	3. Navigate to Network Options ? Wi-Fi (or System Options > Wireless LAN in new versions).

&nbsp;	4. Enter your Wi-Fi SSID and password.

&nbsp;	5. Save and exit; your Pi will connect automatically.



**Command-Line Method (Network Manager / nmtui – Pi OS Bookworm or later)**

&nbsp;	1. Run the following command:

&nbsp;      		bash

&nbsp;      		sudo nmtui

&nbsp;      

&nbsp;	2. Select "Activate a connection" and pick your Wi-Fi SSID.

&nbsp;	3. Enter your password.

&nbsp;	4. You will be connected when you see an asterisk next to the network.



**Headless Setup (No Monitor or Keyboard Required)**



For Raspberry Pi OS Bullseye or older:

&nbsp;	\* Insert the SD card into your computer.

&nbsp;	\* Create a file named wpa\_supplicant.conf with these contents:



&nbsp;	text



&nbsp;	country=US

&nbsp;	ctrl\_interface=DIR=/var/run/wpa\_supplicant GROUP=netdev

&nbsp;	update\_config=1

&nbsp;	network={

&nbsp;   	  ssid="YOURSSID"

&nbsp;   	  scan\_ssid=1

&nbsp; 	  psk="YOURPASSWORD"

&nbsp; 	  key\_mgmt=WPA-PSK

&nbsp;	}



&nbsp;	\* Place this file in the root of the SD card's boot partition.

&nbsp;	\* To enable SSH (optional), create an empty file named ssh (no extension) in the boot partition.

&nbsp;	\* Boot the Raspberry Pi; it connects to Wi-Fi and allows SSH remote access.



For Raspberry Pi OS Bookworm or newer:

&nbsp;	\* Use Raspberry Pi Imager's configuration options as described above or configure Wi-Fi via sudo 	nmtui after first boot.



&nbsp;	\* Manual configuration with wpa\_supplicant.conf is not supported on Bookworm and later — Network Manager 	must be used.



**Manual Advanced Configuration (Directly Editing Files)**

&nbsp;	\* Edit /etc/wpa\_supplicant/wpa\_supplicant.conf on a running system for persistent Wi-Fi changes.

&nbsp;	\* For Network Manager, connections are managed under /etc/NetworkManager/system-connections/ (advanced 	users).





**SOURCES:**



https://raspberrytips.com/raspberry-pi-wifi-setup/

https://linuxconfig.org/connecting-your-raspberry-pi-to-wi-fi-a-how-to

https://umatechnology.org/how-to-setup-wi-fi-on-your-raspberry-pi-via-the-command-line/   (via command line)

https://thelinuxcode.com/setup-wifi-raspberry-pi/

https://www.raspberrypi.com/documentation/computers/getting-started.html







