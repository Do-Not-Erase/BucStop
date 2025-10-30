**Configuring Git on Raspberry Pi via Linux**



**Installing and Setting Up Git**



**Using Command Line (Recommended for All Raspberry Pi OS Versions)**

&nbsp;	1. Boot your Raspberry Pi and log into the terminal (physical or SSH).

&nbsp;	2. Update the package list and upgrade existing packages: 

&nbsp;		sudo apt update \&\& sudo apt upgrade -y

&nbsp;	3. Install Git:

&nbsp;		sudo apt install git -y

&nbsp;	4. Verify Git installation:

&nbsp;		git --version



You should see output similar to **git version 2.x.x.**



**Configuring Git Identity**

&nbsp;	1. Set your username (this appears in commit history):

&nbsp;		git config --global user.name "Your Name"

&nbsp;	2. Set your email address (must match your GitHub account):

&nbsp;		git config --global user.email "youremail@example.com"

&nbsp;	3. Confirm your configuration:

&nbsp;		git config --list



**Generating and Adding SSH Keys for GitHub**

**Step 1: Generate SSH Key Pair**

&nbsp;	1. Run the following command:

&nbsp;		ssh-keygen -t ed25519 -C "youremail@example.com"

&nbsp;	2. Press Enter to accept the default file location (/home/pi/.ssh/id\_ed25519 or your username path).

&nbsp;	3. Optionally enter a passphrase for added security.



**Step 2: Start SSH Agent and Add the Key**

&nbsp;	1. Start the SSH agent:

&nbsp;		eval "$(ssh-agent -s)"

&nbsp;	2. Add your private key to the agent:

&nbsp;		ssh-add ~/.ssh/id\_ed25519



**Step 3: Retrieve the Public Key**

&nbsp;	1. Display your public key:

&nbsp;		cat ~/.ssh/id\_ed25519.pub

&nbsp;	2. Copy the entire output (starts with ssh-ed25519 and ends with your email).



**Adding SSH Key to GitHub**

&nbsp;	1. Log in to your GitHub account.

&nbsp;	2. Go to Settings ? SSH and GPG Keys ? New SSH key.

&nbsp;	3. Give the key a title (e.g., Raspberry Pi).

&nbsp;	4. Paste your copied key into the Key field.

&nbsp;	5. Click Add SSH Key to save.





**Testing the SSH Connection**

&nbsp;	1. Test your connection with GitHub:

&nbsp;		ssh -T git@github.com

&nbsp;	2. If successful, youll see:

&nbsp;		Hi <username>! You've successfully authenticated, but GitHub does not provide shell access.



**Cloning and Using Git Repositories**

&nbsp;	1. Navigate to your desired directory:

&nbsp;		cd ~/projects

&nbsp;	2. Clone your GitHub repository using SSH:

&nbsp;		git clone git@github.com:username/repository.git

&nbsp;	3. To make changes and push updates:

&nbsp;		cd repository

&nbsp;		git add .

&nbsp;		git commit -m "Your commit message"

&nbsp;		git push origin main



**Optional: Auto-Start SSH Agent on Boot**



For convenience, you can make the SSH agent start automatically:



&nbsp;	1. Edit your .bashrc file:

&nbsp;	nano ~/.bashrc

&nbsp;	2. Add the following lines at the bottom:

&nbsp;		eval "$(ssh-agent -s)" > /dev/null

&nbsp;		ssh-add ~/.ssh/id\_ed25519 2>/dev/null

&nbsp;	3. Save and exit (Ctrl + O, Enter, Ctrl + X).



**SOURCES:**

&nbsp;	\* Git Official Documentation

&nbsp;	\* GitHub Docs  Connecting to GitHub with SSH

&nbsp;	\* Raspberry Pi Documentation

&nbsp;	\* DigitalOcean  How to Set Up Git





