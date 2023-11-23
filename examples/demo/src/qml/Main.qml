import QtQuick
import QtQuick.Controls.Material
import Qt.labs.folderlistmodel
import Quartz
import Demo

ApplicationWindow {
	id: root
	visible: true
	title: "Demo"
	width: 800
	height: 600
	Material.theme: Material.System
	TabBar {
		id: tabbar
		width: parent.width
		Repeater {
			id: repeater
			model: [
				"DropArea"
			]
			TabButton {
				text: modelData
			}
		}
	}
	Loader {
		id: pageloader
		anchors { top: tabbar.bottom; left: parent.left; right: parent.right; bottom: parent.bottom }
		source: "qrc:/src/qml/pages/" + tabbar.currentItem.text + "Page.qml"
	}
}
