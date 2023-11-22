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
	Drawer {
		id: pagedrawer
		width: 0.2 * parent.width
		height: parent.height
		ListView {
			anchors.fill: parent
			model: [
				"DropArea"
			]
			header: Pane {
				width: parent.width
				Label {
					width: parent.width
					text: "Demo"
				}
			}
			delegate: ItemDelegate {
				width: parent.width
				text: modelData
				onClicked: {
					pageloader.pagename = modelData;
					pagedrawer.close();
				}
			}
		}
	}
	Loader {
		property string pagename: "DropArea"
		id: pageloader
		source: "qrc:/src/qml/pages/" + pagename + "Page.qml"
	}
	DropAreaPage {}
}
