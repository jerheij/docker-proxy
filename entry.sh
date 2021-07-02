#!/usr/bin/env bash

if [[ ! -z ${UUID} ]]
then
  echo
  echo "Replacing old nginx UID with ${UUID}"
  OldUID=$(getent passwd www-data | cut -d ':' -f3)
  usermod -u ${UUID} www-data
  find / -user ${OldUID} -exec chown -h www-data {} \; &> /dev/null
fi

if [[ ! -z ${GUID} ]]
then
  echo "Replacing old nginx GID with ${GUID}"
  OldGID=$(getent passwd www-data | cut -d ':' -f4)
  groupmod -g ${GUID} www-data
  find / -user ${OldGID} -exec chgrp -h www-data {} \; &> /dev/null
fi

if [[ ! -z ${TZ} ]]
then
  echo "Old time: $(date)"
  cp /usr/share/zoneinfo/${TZ} /etc/localtime
  echo ${TZ} > /etc/timezone
fi

echo "Time: $(date)"
echo "Deployment done!"
exec "$@"
