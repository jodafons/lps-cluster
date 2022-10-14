#!/bin/bash
slapcat -b cn=config > config.ldif
slapcat -b dc=example,dc=com > lps.ufrj.br.ldif
#chown root:root ${BACKUP_PATH}/*
#chmod 600 ${BACKUP_PATH}/*.ldif