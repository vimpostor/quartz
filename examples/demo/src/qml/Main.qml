import QtQuick
import QtQuick.Controls.Material
import Quartz

ApplicationWindow {
	id: root
	visible: true
	title: "Demo"
	width: 400
	height: width
	Material.theme: Material.System
	Label {
		anchors.centerIn: parent
		text: "Hover me"
	}
	Ripple {
		anchors.fill: parent
		size: mousearea.containsMouse ? 1.0 : 0.0
		centreX: mousearea.mouseX
		centreY: mousearea.mouseY
		Card {
			width: parent.width / 2
			height: width
			anchors.centerIn: parent
			Label {
				text: "Hello"
				anchors.centerIn: parent
			}
		}
	}
	MouseArea {
		id: mousearea
		anchors.fill: parent
		hoverEnabled: true
	}
}
