import QtQuick
import QtQuick.Layouts
import QtQuick.Controls.Material
import QtQuick.Controls.Material.impl

FocusScope {
	property alias placeholderText: search.placeholderText
	property alias text: search.text
	signal searched()

	height: 56
	Rectangle {
		anchors.fill: parent
		radius: 16
		color: Material.color(Material.Grey, Material.theme == Material.Light ? Material.Shade100 : Material.Shade800)
		layer.enabled: true
		layer.effect: RoundedElevationEffect {
			elevation: 3
		}
		RowLayout {
			anchors { fill: parent; leftMargin: 16; rightMargin: 16 }
			IconButton {
				ico.name: "search"
				ico.size: 24
				Layout.alignment: Qt.AlignVCenter
				onClicked: searched();
			}
			TextField {
				id: search
				Layout.alignment: Qt.AlignVCenter
				Layout.fillWidth: true
				font.pointSize: 16
				background: Item {}
				focus: true
				onAccepted: searched();
			}
		}
	}
}
