**Installing Docker**



**Step 1: Update your system**

Run these commands to make sure all your packages are current:



&nbsp;	sudo apt update

&nbsp;	sudo apt upgrade -y



**Step 2: Install required dependencies**

Docker requires a few helper packages for HTTPS and repository management:



&nbsp;	sudo apt install -y ca-certificates curl gnupg lsb-release



**Step 3: Add Docker’s official GPG key**

Add the Docker GPG key to verify package signatures:



&nbsp;	sudo mkdir -p /etc/apt/keyrings

&nbsp;	curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /etc/apt/keyrings/docker.gpg



**Step 4: Add the Docker repository**

Add the stable Docker repository for your Ubuntu version and update your package list:



&nbsp;	echo \\

&nbsp; 	  "deb \[arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] \\



&nbsp; 	https://download.docker.com/linux/ubuntu \\



&nbsp; 	$(lsb\_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null



&nbsp;	sudo apt update



**Step 5: Install Docker Engine and tools**

Install the latest Docker Engine, CLI, and plugins:



&nbsp;	sudo apt install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin



**Step 6: Verify Docker installation**

Check the version to confirm it installed correctly:



&nbsp;	docker --version

&nbsp;	docker version





