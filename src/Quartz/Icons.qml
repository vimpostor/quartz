pragma Singleton

import QtQuick

FontLoader {
	id: root
	// convenience alias
	readonly property alias family: root.font.family

	source: "/MaterialSymbols.woff2"
}
