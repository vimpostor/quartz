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
	Wave {
		anchors.fill: parent
		size: mousearea.containsMouse ? 1.0 : 0.0
		centreX: mousearea.mouseX
		centreY: mousearea.mouseY
	}
	MouseArea {
		id: mousearea
		anchors.fill: parent
		hoverEnabled: true
	}
}
