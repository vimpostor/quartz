#!/usr/bin/env bash

set -eE

CLONE="$HOME/.cache/material-design-icons"
CMAKE="src/Quartz/CMakeLists.txt"

# takes the variant name as only parameter
function update_variant() {
	sed -i "s#set(QUARTZ_ICONS_HASH .*) \# ${*}\$#set(QUARTZ_ICONS_HASH \"$(sha256sum "$CLONE/variablefont/MaterialSymbols$*[FILL,GRAD,opsz,wght].woff2" | cut -d' ' -f1)\") \# $*#" "$CMAKE"
}

git -C "$CLONE" pull || git clone --depth 1 https://github.com/google/material-design-icons.git "$CLONE"

# update URL
sed -i "s#set(QUARTZ_ICONS_ARCHIVE .*)#set(QUARTZ_ICONS_ARCHIVE \"https://github.com/google/material-design-icons/raw/$(git -C "$CLONE" rev-parse HEAD)/variablefont\")#" "$CMAKE"
# update variant checksums
update_variant Outlined
update_variant Rounded
update_variant Sharp
# update codepoints checksum
sed -i "s#\(codepoints.*URL_HASH \"SHA256=\)[[:alnum:]]*#\1$(sha256sum "$CLONE/variablefont/MaterialSymbolsOutlined[FILL,GRAD,opsz,wght].codepoints" | cut -d' ' -f1)#" "$CMAKE"

git add "$CMAKE"
git commit -m "Update icons" -m "Update material-design-icons to $(date --iso-8601 -d "@$(git -C "$CLONE" --no-pager log -1 --format="%ct" HEAD)")."
