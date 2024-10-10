#!/usr/bin/env bash


new=${1:-4000}
current=$(busctl --user get-property rs.wl-gammarelay / rs.wl.gammarelay Temperature | awk '{print $2}')

echo current
echo $current

if [ "$current" -ne "$new" ]; then
    busctl --user set-property rs.wl-gammarelay / rs.wl.gammarelay Temperature q $new
else
    busctl --user set-property rs.wl-gammarelay / rs.wl.gammarelay Temperature q 6500
fi

