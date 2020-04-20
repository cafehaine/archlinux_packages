#!/bin/bash
set -o errexit

query="country=all&protocol=https&ip_version=4&ip_version=6&use_mirror_status=on"
rank_n_servers=10
final_server_count=5
server_timeout=5

rm -f /tmp/mirrorlist

echo "Fetching new mirrorlist…"
curl -s "https://www.archlinux.org/mirrorlist/?$query" -o /tmp/mirrorlist

echo "Cleaning up mirrorlist…"
sed -i -e 's/^#Server/Server/' -e '/^#/d' -e '/^$/d' /tmp/mirrorlist
sed -i -n '1,$p;'$rank_n_servers'q' /tmp/mirrorlist

echo "Ranking the mirrors…"
rankmirrors -n $final_server_count --max-time $server_timeout /tmp/mirrorlist \
	> /etc/pacman.d/mirrorlist

echo "Cleaning up…"
rm /tmp/mirrorlist

echo "Done."
