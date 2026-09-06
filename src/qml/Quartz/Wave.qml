import QtQuick
import QtQuick.Controls.Material

Ripple {
	property alias color: rect.color
	Rectangle {
		id: rect
		anchors.fill: parent
		color: Material.accent
	}
}
