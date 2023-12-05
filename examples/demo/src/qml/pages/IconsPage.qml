import QtQuick
import QtQuick.Controls.Material
import QtQuick.Layouts
import Qt.labs.folderlistmodel
import Quartz

Item {
	component CategoryModel: FolderListModel {
		required property string category
		folder: "qrc:/" + category
		showDirs: false
		onCountChanged: iconModel.apply();
	}
	Instantiator {
		id: modelInstantiator
		model: [ "action", "alert", "av", "communication", "content", "device", "editor", "file", "hardware", "home", "image", "maps", "navigation", "notification", "places", "social", "toggle" ]
		CategoryModel {
			required property string modelData
			category: modelData
		}
	}
	ColumnLayout {
		anchors.fill: parent
		spacing: 8
		TextField {
			id: search
			Layout.fillWidth: true
			placeholderText: "Search..."
		}
		ListView {
			clip: true
			Layout.fillWidth: true
			Layout.fillHeight: true
			Component {
				id: iconDelegate
				ItemDelegate {
					width: parent ? parent.width : 0
					icon.source: "/" + text
					text: category + "/" + name
					visible: name.indexOf(search.text) != -1
					height: visible * implicitHeight
					onClicked: {
						Quartz.copyClipboard(text);
						snackbar.text = "Copied \"" + text + "\"";
						snackbar.open();
					}
				}
			}
			model: ListModel {
				id: iconModel
				function apply() {
					clear();
					for (var i = 0; i < modelInstantiator.count; i++) {
						var m = modelInstantiator.objectAt(i);
						for (var j = 0; j < m.count; j++) {
							append({"name": m.get(j, "fileName"), "category": m.category});
						}
					}
				}
			}
			delegate: iconDelegate
		}
	}
	Snackbar {
		id: snackbar
	}
}
