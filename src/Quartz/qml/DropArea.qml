import QtQuick
import QtQuick.Controls.Material
import Quartz

DropArea {
	property int mouseX: 0
	property int mouseY: 0
	anchors.fill: parent
	onPositionChanged: (drag) => {
		mouseX = drag.x;
		mouseY = drag.y;
	}
	Ripple {
		anchors.fill: parent
		size: parent.containsDrag
		centreX: parent.mouseX
		centreY: parent.mouseY
		Label {
			text: "Drop files here"
			anchors.centerIn: parent
		}
	}
}
