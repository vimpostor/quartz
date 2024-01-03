import QtQuick
import QtQuick.Controls.Material
import Quartz

Item {
	Card {
		width: parent.width / 4
		height: width
		anchors { margins: 16; left: parent.left; verticalCenter: parent.verticalCenter }
		Label {
			text: "Item below"
			anchors.centerIn: parent
		}
	}
	Wave {
		anchors.fill: parent
		centreX: mousearea.mouseX
		centreY: mousearea.mouseY
		SequentialAnimation on size {
			loops: Animation.Infinite
			NumberAnimation { to: 1; duration: 3000; easing.type: Easing.OutCirc }
			NumberAnimation { to: 0; duration: 3000; easing.type: Easing.OutCirc }
		}
		Card {
			width: parent.width / 4
			height: width
			anchors { centerIn: parent; }
			Label {
				text: "Item inside"
				anchors.centerIn: parent
			}
		}
	}
	Card {
		width: parent.width / 4
		height: width
		anchors { margins: 16; right: parent.right; verticalCenter: parent.verticalCenter }
		Label {
			text: "Item always on top"
			anchors.centerIn: parent
		}
	}
	MouseArea {
		id: mousearea
		anchors.fill: parent
		hoverEnabled: true
	}
}
