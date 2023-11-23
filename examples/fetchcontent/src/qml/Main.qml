import QtQuick
import QtQuick.Controls.Material
import Quartz

ApplicationWindow {
	id: root
	visible: true
	title: "FetchContent"
	width: 400
	height: width
	Material.theme: Material.System
	Card {
		width: parent.width / 2
		height: width
		anchors.centerIn: parent
		Label {
			text: "Hello world!"
			anchors.centerIn: parent
		}
	}
}
