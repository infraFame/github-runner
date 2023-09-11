# Default target
install:
	sudo snap install ngrok
	cd bin 
	curl -sL https://get.bacalhau.org/install.sh | bash
	make lily
	cd ..
	make bacalhau
	

bacalhau:
	echo "alias lilyb='bacalhau'" >> .bashrc
	# source .bashrc

lily:
	curl -sSL -O https://raw.githubusercontent.com/bacalhau-project/lilypad-modicum/main/lilypad
	chmod +x lilypad
	cp lilypad lily
	./lilypad run sdxl:v0.9-lilypad1 '{"prompt": "an astronaut riding a unicorn", "seed": 9}'
