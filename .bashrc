# .bashrc

# Source global definitions
if [ -f /etc/bashrc ]; then
	. /etc/bashrc
fi
[ -f ~/.kubectl_aliases ] && source ~/.kubectl_aliases


PATH=$PATH:$HOME/bin:/usr/sbin

# User specific aliases and functions

alias a=ansible
alias ap=ansible-playbook

alias r-oe='kubectl config use-context oe-prod.rr'
alias r-dev='kubectl config use-context dev-k2s0.rr'

#alias rm='rm -i'
alias rr='rm -rf'
# Or at least --preserve=all to preserve extended attributes:
alias cp='cp -a'
#alias mv='mv -i'

alias ts='ts "%H:%M:%.S"'

alias ndrpm='rpm -Uhv --excludedocs'
alias rf='rpm -qf'
alias rq='rpm -q'
alias rep='createrepo_c -d --update --general-compress-type=xz .'

alias g='LANG=en_US.utf8 git'
# Provide also completions like in git
# http://stackoverflow.com/questions/342969/how-do-i-get-bash-completion-to-work-with-aliases
. /usr/share/bash-completion/completions/git
__git_complete g __git_main
alias b='source ~/.bashrc'

alias ctop='docker run --rm -ti --name=ctop -v /var/run/docker.sock:/var/run/docker.sock quay.io/vektorlab/ctop:latest'

alias c='sudo docker-compose'
alias d='sudo docker'
alias de='sudo docker exec -it'
# https://github.com/moby/moby/issues/7477:
alias dps='sudo docker ps --format "table {{.Names}}\t{{.Status}}\t{{.RunningFor}}\t{{.Image}}\t{{.Ports}}"'
alias drm='sudo docker run -it --rm'

alias df='df -h -x tmpfs -x devtmpfs'

alias e=mcedit
alias en='export LANG=en_US.utf8'

alias fly='gradle -b standalone.gradle flywayRepair ; gradle -b standalone.gradle flywayMigrate -i | /usr/bin/ts "%H:%M:%.S"'
alias fpaste='fpaste -n Hubbitus'

alias flink=/opt/flink/flink-1.5.1/bin/flink

alias gw='PATH=$PATH:.:..:../..:../../.. gradlew'

alias grep='grep --color'
alias egrep='egrep --color'
alias fgrep='fgrep --color'

alias idea=/opt/idea/bin/idea.sh

#alias jiracli="/home/pasha/imus/imus-tools.GIT/JiraCli/jira-cli-3.7.0/jira.sh --server http://serverprog:1090/ --user p.alexeev --password $(cat /home/pasha/imus/imus-tools.GIT/JiraCli/.password)"

# https://github.com/kubernetes/kubectl/issues/120
. /usr/share/bash-completion/completions/kubectl
alias k=kubectl
complete -o default -F __start_kubectl k

function kns(){
	if [ -n "$1" ]; then
		kubectl config set-context $( kubectl config current-context ) --namespace="$1"
	else
		kubectl config get-contexts
		kubectl get namespaces
		echo "To make some namespase *default* call: 'kns <namespace>'"
	fi
}

function kc(){
	if [ -n "$1" ]; then
		kubectl config use-context "$1"
	else
		echo "To change current context call: 'kc <context-name>'"
	fi
	kubectl config get-contexts
}

alias l='ln -s'
alias ll='ls -l --color=auto'

# https://habrahabr.ru/post/316806/
alias mount='mount -o intr'
# List real mounted filesystems
alias mnt='findmnt -t notmpfs,nodevtmpfs,nosysfs,nocgroup,noconfigfs,noproc,nosecurityfs,nopstore,noselinuxfs,nodebugfs,nonfsd,nodevpts,nomqueue,nohugetlbfs,norpc_pipefs,noautofs,nocgroup2,noefivarfs,nobpf,nofusectl,nonsfs,nofuse.vmware-vmblock'

alias mplayer='mplayer -framedrop -zoom -fs'
alias gmplayer='gmplayer -framedrop -zoom'

# It like alias, but function to allow precess paarmeters before pipe
function r(){
	cd "/mnt/remote/$1"
}
rpmbuild (){
	ionice -c3 nice -n18 /usr/bin/rpmbuild "$@" | egrep '°¿¸°½:|Wrote:' | cut -d' ' -f2 | xargs -rI{} sh -c 'F="{}"; echo "rpmlint of: $F"; rpmlint "$F"'
}
alias rtorrent='ionice -c3 nice -n17 rtorrent'


alias s=sleep
# Allow user aliases in sudo http://askubuntu.com/questions/22037/aliases-not-available-when-using-sudo
alias sudo='sudo '

alias yum='nice -n19 yum'

alias xattr='getfattr --encoding=text --absolute-names'

# Function instead of alias to behave identically on remote and local execution
# http://www.thelinuxlink.net/pipermail/lvlug/2005-July/014629.html
function screen(){
	/usr/bin/screen -OaUx Main $@ || /usr/bin/screen -OaU -S Main $@
}
function screen-remote(){
	/usr/bin/screen -OaUx Remote || /usr/bin/screen -OaU -S Remote -c ~/.screenrc-remote
}
function screen-rgc(){
	/usr/bin/screen -OaUx Rgc || /usr/bin/screen -OaU -S Rgc -c ~/.screenrc-rgc
}
function screen-egais(){
	/usr/bin/screen -OaUx Egais || /usr/bin/screen -OaU -S Rgc -c ~/.screenrc-egais
}
function screen-rlh(){
	/usr/bin/screen -OaUx Rlh || /usr/bin/screen -OaU -S Rlh -c ~/.screenrc-rlh
}
# http://stackoverflow.com/questions/6064548/send-commands-to-a-gnu-screen
# http://stackoverflow.com/questions/6510673/in-screen-how-do-i-send-a-command-to-all-virtual-terminal-windows-within-a-sing
function rgc-screen-all-command(){
	/usr/bin/screen -S Rgc -X at '#' stuff "$@
"
}

alias ssh-agent='eval `SSH_AGENT_REUSE_MUST_BE_SOURCED='' /home/pasha/bin/ssh-agent-reENV.bash`'

alias sus="su -l -c 'screen -x || screen'"

alias rsync_s='source ~/.rsync_shared_options ; ionice -c3 nice -n19 rsync $RSYNC_SHARED_OPTIONS'

alias grin='grin --force-color'

alias ²=cd

# Nice to long time test: gotar, modarcon16*, modarin256* (with root), nicedark, xoria256 + transparent background in ini
# Until https://bugzilla.redhat.com/show_bug.cgi?id=1288446 resolved it can't be 256 color
#alias mc='TERM=xterm-256color mc -x --skin=gotar'
alias mc='TERM=screen-256color mc -x --skin=modarcon16'

alias yakuake='yakuake.start.dbus'

# On my note disk is very slow and multitread java very overload it
alias java='nice -n19 ionice -c3 java'

alias svn='ionice -c3 colorsvn'

#function svn(){
#	colorsvn "$@" | colordiff
#}

alias t='cd ~/temp'

# Idea diff and merge  http://www.jetbrains.com/idea/webhelp/running-intellij-idea-as-a-diff-or-merge-command-line-tool.html
alias idiff='/opt/idea/bin/idea.sh diff'
alias imerge='/opt/idea/bin/idea.sh merge'

# If at that moment yakuake active and NOT start from | (to allow manually name it later) - set it title to first argument of ssh* command (user@host assummed)
function setYakuakeTabName(){

local sessionId="$( qdbus org.kde.yakuake /yakuake/sessions activeSessionId )"

	[ 'true' == "$( qdbus org.kde.yakuake /yakuake/MainWindow_1 org.qtproject.Qt.QWidget.isActiveWindow )" ] && \
		[ '|' != "$( qdbus org.kde.yakuake /yakuake/tabs tabTitle $sessionId | cut -c1 )" ] && \
			qdbus org.kde.yakuake /yakuake/tabs setTabTitle $sessionId "$1"
}

function ssh(){
	setYakuakeTabName "$1"
	/usr/bin/ssh $@
}

function sshs(){
	ssh $@ -t 'screen -x || screen'
}

# while.cmd from https://github.com/Hubbitus/shell.scripts
function whilessh(){
	WHILE_CMD_PRE_EXECUTE="setYakuakeTabName $1" while.cmd /usr/bin/ssh $@
}

# while.cmd from https://github.com/Hubbitus/shell.scripts
#No NOT jjust "alias whilesshs='while.cmd sshs'" because it will call tab name set on each try!
function whilesshs(){
	WHILE_CMD_PRE_EXECUTE="setYakuakeTabName $1" while.cmd /usr/bin/ssh $@ -t 'screen -x || screen'
}

complete -W "$( grep -hoP '(?<=^Include ).+' ~/.ssh/config <( echo 'Include $HOME/.ssh/config' ) | xargs -I{} sh -c 'F="{}"; [ ! -f "$F" ] && F="$HOME/.ssh/$F" ; grep -oP "(?<=^Host ).+" "$F"' )" ssh
complete -W "$( grep -hoP '(?<=^Include ).+' ~/.ssh/config <( echo 'Include $HOME/.ssh/config' ) | xargs -I{} sh -c 'F="{}"; [ ! -f "$F" ] && F="$HOME/.ssh/$F" ; grep -oP "(?<=^Host ).+" "$F"' )" sshs
complete -W "$( grep -hoP '(?<=^Include ).+' ~/.ssh/config <( echo 'Include $HOME/.ssh/config' ) | xargs -I{} sh -c 'F="{}"; [ ! -f "$F" ] && F="$HOME/.ssh/$F" ; grep -oP "(?<=^Host ).+" "$F"' )" whilessh
complete -W "$( grep -hoP '(?<=^Include ).+' ~/.ssh/config <( echo 'Include $HOME/.ssh/config' ) | xargs -I{} sh -c 'F="{}"; [ ! -f "$F" ] && F="$HOME/.ssh/$F" ; grep -oP "(?<=^Host ).+" "$F"' )" whilesshs

#http://rusmafia.org/linux/node/21
shopt -s cdspell

#+3 http://tigro.info/blog/index.php?id=418
shopt -s histappend
#PROMPT_COMMAND='history -a'

#http://stasikos.livejournal.com/tag/mc Remove trash from MC
#export HISTCONTROL="ignoredups"
export HISTCONTROL=ignoreboth

#Auto start ssh-agent. http://rusmafia.org/linux/ssh-agent-shell-startup
##[ ! -S ~/.ssh/ssh-agent ] && eval `/usr/bin/ssh-agent -a ~/.ssh/ssh-agent`
##[ -z $SSH_AUTH_SOCK ] && export SSH_AUTH_SOCK=~/.ssh/ssh-agent
## Auto start now performed by local alias with reusing existence socket!

#ssh-agent #just execute, alias redefined before.
	# On my home machine alias before defined (znd alias show it properly), but in this line (or file?)
	# call by it is not worked :( See example ~/bin/SHARED/examples/bash-alias.test
	# So, directly get and exec value:
	[ alias ssh-agent &>/dev/null ] && $( alias ssh-agent | sed -r "s/^alias ttt='(.*)'/\1/" )
	# '

# http://wiki.clug.org.za/wiki/Colour_on_the_command_line#Colourful_manpages_.28RedHat_style.29
# For colourful man pages (CLUG-Wiki style)
export LESS_TERMCAP_mb=$'\E[01;31m'
export LESS_TERMCAP_md=$'\E[01;31m'
export LESS_TERMCAP_me=$'\E[0m'
export LESS_TERMCAP_se=$'\E[0m'
export LESS_TERMCAP_so=$'\E[01;44;33m'
export LESS_TERMCAP_ue=$'\E[0m'
export LESS_TERMCAP_us=$'\E[01;32m'

SVN='svn+ssh://x-www.info/mnt/sgtBarracuda/SVN_test/svn/repositories/'

export EDITOR=mcedit

# For Grails
#export JAVA_HOME=/usr/lib/jvm/jre-1.7.0-openjdk.x86_64/
#?export JAVA_HOME=/usr/java/latest/
# With unset does not works mvn!!!
#??unset JAVA_HOME
export GRAILS_HOME=/opt/grails/
[ -f /opt/grails/grails_autocomplete ] && . /opt/grails/grails_autocomplete


# http://openite.com/ru/Development/2013/01/08/ispravlenie-otobrazheniya-shriftov-v-produktah-jetbrains.html
# http://pgserious.blogspot.ru/2012/10/java-linux.html
#export _JAVA_OPTIONS='-Dawt.useSystemAAFontSettings=on -Dswing.aatext=true -Dswing.defaultlaf=com.sun.java.swing.plaf.gtk.GTKLookAndFeel'
# -Dsun.java2d.pmoffscreen=false, -XX:+UseCompressedOops from http://devnet.jetbrains.com/docs/DOC-192
#export _JAVA_OPTIONS='-Dawt.useSystemAAFontSettings=on -Dswing.aatext=true -Dsun.java2d.pmoffscreen=false -XX:+UseCompressedOops'
# http://habrahabr.ru/post/160049/ add -XX:+DoEscapeAnalysis, -XX:+AggressiveOpts, -XX:+UseCompressedStrings (tried: OpenJDK 64-Bit Server VM warning: ignoring option UseCompressedStrings; support was removed in 7.0) -XX:+UseStringCache -XX:+EliminateLocks
# dropped: -XX:+UseStringCache because: OpenJDK 64-Bit Server VM warning: ignoring option UseStringCache; support was removed in 8.0
#export _JAVA_OPTIONS='-Dawt.useSystemAAFontSettings=on -Dswing.aatext=true -Dsun.java2d.pmoffscreen=false -XX:+UseCompressedOops -XX:+DoEscapeAnalysis -XX:+AggressiveOpts -XX:+EliminateLocks'
# Try enable -XX:+UseParallelGC -XX:+UseNUMA and -XX:+TieredCompilation by http://docs.oracle.com/javase/7/docs/technotes/guides/vm/performance-enhancements-7.html#compressedOop
#export _JAVA_OPTIONS='-Dawt.useSystemAAFontSettings=on -Dswing.aatext=true -Dsun.java2d.pmoffscreen=false -XX:+UseCompressedOops -XX:+DoEscapeAnalysis -XX:+AggressiveOpts -XX:+EliminateLocks -XX:+UseParallelGC -XX:+UseNUMA -XX:+TieredCompilation'
export _JAVA_OPTIONS='-Dawt.useSystemAAFontSettings=on -Dswing.aatext=true -Dsun.java2d.pmoffscreen=false -XX:+UseCompressedOops -XX:+DoEscapeAnalysis -XX:+AggressiveOpts -XX:+EliminateLocks -XX:+UseNUMA -XX:+TieredCompilation'
# @TODO try: -XX:+UseG1GC -XX:+UseStringDeduplication http://javapoint.ru/presentations/jpoint-April2015-string-catechism.pdf (http://javapoint.ru/materials/)

# Force debugging:
#export _JAVA_OPTIONS='-Dawt.useSystemAAFontSettings=on -Dswing.aatext=true -agentlib:jdwp=transport=dt_socket,server=y,suspend=y,address=5007'
#export _JAVA_OPTIONS='-Dawt.useSystemAAFontSettings=on -Xdebug -Xrunjdwp:transport=dt_socket,server=y,suspend=y,address=5007'


# For run groovy scripts and load classes from current directory
# http://testinfected.blogspot.ru/2008/01/dry-groovy-how-to-get-groovy-to-import.html
export CLASSPATH=$CLASSPATH:.

# Do not auto update screen titles!
export PROMPT_COMMAND=''

source /home/pasha/@Projects/_Outer/kube-ps1/kube-ps1.sh
PS1='[\u@\h \W $(kube_ps1)]\$ '

export ELMON=cmMvtanld


#? [ -f ~/.bashrc.PS1 ] && source ~/.bashrc.PS1

source ~/bin/transfer.sh 2>/dev/null


export ANSIBLE_VAULT_PASSWORD_FILE=inventory/.vault.pass.secret
export ANSIBLE_SSH_OPERATOR_USER=pavel.alexeev
# https://github.com/ansible/ansible/issues/27078#issuecomment-364560173
export ANSIBLE_STDOUT_CALLBACK=debug
export PATH="/home/pasha/@Projects/@RLH/portal.java10/portal-ui/build/Sencha/Cmd:$PATH"

# Add RVM to PATH for scripting. Make sure this is the last PATH variable change.
export PATH="$PATH:$HOME/.rvm/bin"

export HELM_HOME=~/.helm

# Default for trans
export TARGET_LANG=ru
