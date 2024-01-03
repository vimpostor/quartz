import QtQuick
import QtQuick.Controls.Material
import Quartz

Item {
	Card {
		anchors.centerIn: parent
		width: parent.width / 2
		height: width
		Label {
			text: "Hello world!"
			anchors.centerIn: parent
		}
	}
	FloatingActionButton {
		anchors { right: parent.right; bottom: parent.bottom; margins: 16 }
		name: "add"
	}
}
