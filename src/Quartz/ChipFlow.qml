import QtQuick
import QtQuick.Controls.Material
import Quartz

Flickable {
	id: root
	property bool wrap: true

	default property alias data: flow.data
	interactive: !wrap
	anchors.left: parent.left
	anchors.right: parent.right
	implicitHeight: contentHeight
	contentWidth: wrap ? parent.width : flow.implicitWidth
	contentHeight: flow.implicitHeight
	Flow {
		id: flow
		spacing: 8
		anchors.left: parent.left
		anchors.right: root.wrap ? parent.right : undefined
	}
}
