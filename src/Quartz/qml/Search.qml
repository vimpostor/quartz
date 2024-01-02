import QtQuick
import QtQuick.Layouts
import QtQuick.Controls.Material
import QtQuick.Controls.Material.impl
import QtQuick.Templates as T

FocusScope {
	property alias placeholderText: placeholder.text
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
			T.TextField {
				id: search
				Layout.alignment: Qt.AlignVCenter
				Layout.fillWidth: true
				implicitHeight: contentHeight
				color: Material.foreground
				font.pointSize: 16
				focus: true
				onAccepted: searched();
				Label {
					id: placeholder
					anchors.fill: parent
					visible: !parent.length
					font.pointSize: 16
					color: Material.hintTextColor
				}
			}
			IconButton {
				ico.name: "close"
				ico.size: 24
				Layout.alignment: Qt.AlignVCenter
				visible: search.text
				onClicked: search.text = "";
			}
		}
	}
}
