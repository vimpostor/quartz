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
	Material.theme: Material.System
	FolderListModel {
		id: pagesmodel
		folder: "qrc:/qt/qml/Demo/pages"
		showDirs: false
		nameFilters: ["*Page.qml"]
		onStatusChanged: {
			if (status == FolderListModel.Ready) {
				tabbar.currentIndex = settings.currentTab;
			}
		}
	}
	TabBar {
		id: tabbar
		width: parent.width
		Repeater {
			model: pagesmodel
			TabButton {
				required property string fileName
				text: fileName.slice(0, -8)
			}
		}
		Component.onDestruction: settings.currentTab = currentIndex;
	}
	Loader {
		id: pageloader
		focus: true
		anchors { top: tabbar.bottom; left: parent.left; right: parent.right; bottom: parent.bottom }
		source: pagesmodel.status == FolderListModel.Ready ? "pages/" + pagesmodel.get(tabbar.currentIndex, "fileName") : ""
	}
	Settings {
		id: settings
		property int currentTab: 0
	}
}
