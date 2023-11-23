import QtCore
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
	property var pages: [
		"Card",
		"Ripple",
		"DropArea",
	]
	Material.theme: Material.System
	TabBar {
		id: tabbar
		width: parent.width
		Repeater {
			model: pages
			TabButton {
				text: modelData
			}
		}
	}
	Loader {
		id: pageloader
		anchors { top: tabbar.bottom; left: parent.left; right: parent.right; bottom: parent.bottom }
		source: "qrc:/src/qml/pages/" + root.pages[tabbar.currentIndex] + "Page.qml"
	}
	Settings {
		property alias currentTab: tabbar.currentIndex
	}
}
