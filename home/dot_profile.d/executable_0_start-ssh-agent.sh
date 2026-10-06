#!/usr/bin/env bash

agent_env="${HOME}/.ssh/agent.env"

# ssh-add -l exits 1 for a live agent with no keys and 2 only when none answers
agent_answers() {
	ssh-add -l &>/dev/null
	[ $? -ne 2 ]
}

# Prefer an inherited agent, then the one an earlier login recorded
if ! agent_answers && [ -f "${agent_env}" ]; then
	. "${agent_env}" > /dev/null
fi

if agent_answers; then
	echo -n "Connected to Agent "
else
	( umask 077; ssh-agent -s > "${agent_env}" )
	. "${agent_env}" > /dev/null
	echo -n "Agent started with "
fi
echo PID: $SSH_AGENT_PID Socket: $SSH_AUTH_SOCK

unset -f agent_answers
unset agent_env
