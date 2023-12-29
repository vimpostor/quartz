import QtQuick
import QtQuick.Controls.Material
import QtQuick.Layouts
import Quartz

ToolButton {
	id: root
	property alias ico: ic
	padding: 0
	implicitWidth: ic.size
	implicitHeight: implicitWidth
	contentItem: RowLayout {
		Icon {
			id: ic
			Layout.fillWidth: true
			Layout.fillHeight: true
		}
		Label {
			text: root.text
			visible: root.text
			Layout.fillWidth: true
		}
	}
}
