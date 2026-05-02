import QtQuick
import QtQuick.Controls.Material

Drawer {
	id: root
	property alias model: listview.model
	property int currentIndex: model.count ? 0 : -1

	height: parent.height
	ListView {
		id: listview
		anchors.fill: parent
		delegate: ItemDelegate {
			text: modelData
			width: parent.width
			onClicked: {
				root.currentIndex = index;
				root.close();
			}
		}
	}
}
