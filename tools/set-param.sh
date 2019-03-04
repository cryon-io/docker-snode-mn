#!/bin/sh

#  SNODE Masternode docker template
#  Copyright © 2019 cryon.io
#
#  This program is free software: you can redistribute it and/or modify
#  it under the terms of the GNU Affero General Public License as published
#  by the Free Software Foundation, either version 3 of the License, or
#  (at your option) any later version.
#
#  This program is distributed in the hope that it will be useful,
#  but WITHOUT ANY WARRANTY; without even the implied warranty of
#  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
#  GNU Affero General Public License for more details.
#
#  You should have received a copy of the GNU Affero General Public License
#  along with this program.  If not, see <https://www.gnu.org/licenses/>.
#
#  Contact: cryi@tutanota.com

BASEDIR=$(dirname "$0")

PARAM=$(echo "$1" | sed "s/=.*//")
VALUE=$(echo "$1" | sed "s/[^>]*=//")

case $PARAM in
    ip)
        PORT=$(grep "externalip=" "$BASEDIR/../data/snodecoin.conf" | sed 's/externalip=//g' | sed 's/^.*://g')
        TEMP=$(sed "s/externalip=.*/externalip=$VALUE:$PORT/g" "$BASEDIR/../data/snodecoin.conf")
        printf "%s" "$TEMP" > "$BASEDIR/../data/snodecoin.conf"
    ;;
    port)
        ADDR=$(grep "externalip=" "$BASEDIR/../data/snodecoin.conf" | sed 's/externalip=//g')
        PORT=$(printf "%s" "$ADDR" | sed 's/^.*://g')
        IP=$(printf "%s" "$ADDR" | sed "s/:$PORT$//g")

        TEMP=$(sed "s/externalip=.*/externalip=$IP:$VALUE/g" "$BASEDIR/../data/snodecoin.conf")
        # TEMP=$(printf "%s" "$TEMP" | sed "s/port=.*/port=$VALUE/g")
        printf "%s" "$TEMP" > "$BASEDIR/../data/snodecoin.conf"

        NEW_COMPOSE=$(sed "s/- \".*:8175\"/- \"$VALUE:8175\"/g" "$BASEDIR/../docker-compose.yml")
        printf "%s" "$NEW_COMPOSE" > "$BASEDIR/../data/docker-compose.yml"
    ;;
    nodeprivkey)
        TEMP=$(sed "s/masternodeprivkey=.*/masternodeprivkey=$VALUE/g" "$BASEDIR/../data/snodecoin.conf")
        printf "%s" "$TEMP" > "$BASEDIR/../data/snodecoin.conf"
    ;;
    NODE_VERSION) 
        if grep "NODE_VERSION=" "$BASEDIR/../containers/limits.conf"; then
            TEMP=$(sed "s/NODE_VERSION=.*/NODE_VERSION=$VALUE/g" "$BASEDIR/../containers/limits.conf")
            printf "%s" "$TEMP" > "$BASEDIR/../containers/limits.conf"
        else 
            printf "NODE_VERSION=%s" "$VALUE" >> "$BASEDIR/../containers/limits.conf"
        fi
    ;;
    PROJECT)
        printf "PROJECT=%s" "$VALUE" >  "$BASEDIR/../project_id"
    ;;
esac