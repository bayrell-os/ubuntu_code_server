if [ ! -z $WWW_UID ]; then
	sed -i "s|:33:33:|:$WWW_UID:$WWW_GID:|g" /etc/passwd
fi
if [ ! -z $WWW_GID ]; then
	sed -i "s|:33:|:$WWW_GID:|g" /etc/group
fi