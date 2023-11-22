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
	DropArea {
		anchors.fill: parent
		onDropped: (drop) => {
			console.log(drop.urls);
		}
	}
}
