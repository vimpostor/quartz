import QtQuick
import QtQuick.Controls.Material
import Quartz

Ripple {
	id: ripple
	property alias text: label.text
	anchors { bottom: parent.bottom; horizontalCenter: parent.horizontalCenter; margins: 4 }
	width: row.implicitWidth + 16
	height: row.implicitHeight
	color: "transparent"
	Card {
		anchors.fill: parent
		Material.theme: Material.Dark
		Row {
			id: row
			anchors.fill: parent
			spacing: 8
			Label {
				id: label
				text: "Test"
				anchors.verticalCenter: parent.verticalCenter
			}
			Button {
				text: "OK"
				flat: true
				anchors.verticalCenter: parent.verticalCenter
				onClicked: ripple.size = 0;
			}
		}
	}
}
