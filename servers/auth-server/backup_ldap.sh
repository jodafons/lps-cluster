#!/bin/bash
sudo slapcat -b cn=config > config.ldif
sudo slapcat -b dc=lps,dc=ufrj,dc=br > lps.ufrj.br.ldif
#chown root:root ${BACKUP_PATH}/*
#chmod 600 ${BACKUP_PATH}/*.ldif