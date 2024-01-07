import QtQuick
import QtQuick.Controls.Material
import Quartz

Item {
	Column {
		anchors.fill: parent
		IconButton {
			ico.name: "info"
		}
		IconButton {
			ico.name: "delete"
			width: parent.width
		}
		IconButton {
			ico.name: "robot"
			text: "Implicit width"
		}
		IconButton {
			ico.name: "list"
			text: "Full width"
			width: parent.width
		}
	}
	FloatingActionButton {
		id: fab
		anchors { right: parent.right; bottom: parent.bottom; margins: 16 }
		name: "add"
	}
	FloatingActionButton {
		anchors { bottom: fab.top; horizontalCenter: fab.horizontalCenter; margins: 16 }
		size: FloatingActionButton.Size.Small
		name: "post_add"
	}
}
