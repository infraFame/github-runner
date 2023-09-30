# Default target
install: 
	ln ~/.bashrc .bashrc
	sudo snap install ngrok &
	make setup-repos
	make install-lily-v2
	make install-lily 
	make bacalhau 
	# source .bashrc #FIXME: error

install-tmux:
	@tmux new-session -d -s install_session \
			"sudo snap install ngrok" \; \
			split-window -v "make lily" \; \
			split-window -h "make bacalhau" \; \
			select-layout even-horizontal \; \
			attach-session -d -t install_session
	

bacalhau:
	curl -sL https://get.bacalhau.org/install.sh | bash
	echo "alias lilyb='bacalhau'" >> .bashrc
	@WHEREIS_RESULT=$$(whereis bacalhau | cut -d ' ' -f 2); \
	if [ -n "$$WHEREIS_RESULT" ]; then \
		cp "$$WHEREIS_RESULT" ./bin/; \
		cp "$$WHEREIS_RESULT" ./bin/lilyb; \
		cp "$$WHEREIS_RESULT" ~/go/bin/lilyb; \
		cp "$$WHEREIS_RESULT" ~/go/bin/; \
		echo "bacalhau copied to ./bin/"; \
	else \
		echo "bacalhau not found."; \
	fi

install-lily:
	curl -sSL -O https://raw.githubusercontent.com/bacalhau-project/lilypad-modicum/main/lilypad
	chmod +x lilypad
	cp lilypad bin/lily
	cp lilypad ~/go/bin
	cp lilypad ~/go/bin/lily

install-lily-v2:
	curl -sSL -O https://github.com/bacalhau-project/lilypad/releases/download/v2.0.0-b7e9e04/lilypad
	# FIXME: save as lilypad2
	chmod +x lilypad
	cp lilypad bin/lily2
	cp lilypad ~/go/bin/lilypad2
	cp lilypad ~/go/bin/lily2

lily:
	./lilypad run sdxl:v0.9-lilypad1 '{"prompt": "an astronaut riding a unicorn", "seed": 9}'

setup-repos:
	gh repo clone DeCenter-AI/compute.decenter-ai decenter
	gh repo clone learnery-engine/api.creator.learnery learnery
	gh repo clone Nasfame/lilypad-modicum modicum
	


.PHONY: install lily clean bacalhau install


