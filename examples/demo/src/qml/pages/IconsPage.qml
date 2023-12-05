import QtQuick
import QtQuick.Controls.Material
import QtQuick.Layouts
import Qt.labs.folderlistmodel
import Quartz

Item {
	ColumnLayout {
		anchors.fill: parent
		spacing: 8
		TextField {
			id: search
			Layout.fillWidth: true
			placeholderText: "Search"
			focus: true
			Material.containerStyle: Material.Filled
		}
		ListView {
			clip: true
			Layout.fillWidth: true
			Layout.fillHeight: true
			ScrollBar.vertical: ScrollBar {}
			model: FolderListModel {
				folder: "qrc:/svg"
				showDirs: false
			}
			delegate: ItemDelegate {
				required property string fileName
				width: parent ? parent.width : 0
				icon.source: "/svg/" + text
				text: fileName
				height: implicitHeight * (fileName.indexOf(search.text) != -1)
				Behavior on height {
					NumberAnimation {
						easing.type: Easing.OutCirc
						duration: 128
					}
				}
				onClicked: {
					Quartz.copyClipboard(icon.source);
					snackbar.text = "Copied \"" + icon.source + "\"";
					snackbar.open();
				}
			}
		}
	}
	Snackbar {
		id: snackbar
	}
}
