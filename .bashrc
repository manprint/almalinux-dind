# .bashrc

# Source global definitions
if [ -f /etc/bashrc ]; then
	. /etc/bashrc
fi

# User specific environment
if ! [[ "$PATH" =~ "$HOME/.local/bin:$HOME/bin:" ]]
then
    PATH="$HOME/.local/bin:$HOME/bin:$PATH"
fi
export PATH

# Uncomment the following line if you don't like systemctl's auto-paging feature:
# export SYSTEMD_PAGER=

# User specific aliases and functions
alias ll="ls -alFh --color=always | awk '{k=0;for(i=0;i<=8;i++)k+=((substr(\$1,i+2,1)~/[rwx]/)*2^(8-i));if(k)printf(\" %0o \",k);print}'"
alias la='ls -A'
alias l='ls -CF'

# Function for formatting docker images (alias)
function i() {
	docker images
}

# Function for formatting docker system df -v (alias)
function s() {
	docker system df -v
}

# Function for formatting docker ps -a
function c() {
	docker ps -a --format "table {{ .ID }}\t{{.Names}}\t{{.RunningFor}}\t{{ .Image }}\t{{.Status}}\t{{.Ports}}" | while read line; do
		if `echo $line | grep -q 'CONTAINER ID'`; then
			echo -e "CNT_ADDRESS\t$line"
		else
			CID=$(echo $line | awk '{print $1}');
			IP=$(docker inspect -f '{{range .NetworkSettings.Networks}}{{.IPAddress}}{{end}}' $CID);
			printf "${IP}\t${line}\n"
		fi
	done
}

# Docker Log Alias
alias dlog='docker logs -f -n 100 -t'

# Docker pretty
dp() {
    docker run -it --rm -v /var/run/docker.sock:/var/run/docker.sock quay.io/devopsita/docker-pretty-ps:latest docker-pretty-ps $@
}
