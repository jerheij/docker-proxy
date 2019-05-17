#!/usr/bin/env ash

if [[ ! -z ${UUID} ]]
then
  echo
  echo "Replacing old nginx UID with ${UUID}"
  OldUID=$(getent passwd nginx | cut -d ':' -f3)
  usermod -u ${UUID} nginx
  find / -user ${OldUID} -exec chown -h nginx {} \; &> /dev/null
fi

if [[ ! -z ${GUID} ]]
then
  echo "Replacing old nginx GID with ${GUID}"
  OldGID=$(getent passwd nginx | cut -d ':' -f4)
  groupmod -g ${GUID} nginx
  find / -user ${OldGID} -exec chgrp -h nginx {} \; &> /dev/null
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
