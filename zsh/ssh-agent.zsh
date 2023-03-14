# -----------------------------------------------
# SSH AGENT SETUP
# -----------------------------------------------
HOSTNAME=$(hostname -s)
SSHAGENT=/usr/bin/ssh-agent
SSHAGENTARGS=""

SSHEC=$(ps ax|grep -c "[s]sh-agent")

if [ ${SSHEC} -eq 0 ]; then
  eval $(${SSHAGENT} ${SSHAGENTARGS} > ~/.ssh/agent.${HOSTNAME}.${USER})
  source ~/.ssh/agent.${HOSTNAME}.${USER}
  for i in $(ls ~/.ssh/keys/ |grep -v '.pub'); do
    ssh-add ~/.ssh/keys/${i}
  done
else
  source ~/.ssh/agent.${HOSTNAME}.${USER}
fi
