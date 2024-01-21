import QtQuick
import QtQuick.Controls.Material
import QtQuick.Layouts
import Quartz

Button {
	id: root
	property alias ico: icon
	padding: 0
	flat: true
	implicitWidth: text ? (implicitContentWidth + leftPadding + rightPadding) : height
	implicitHeight: icon.size + 24
	topInset: 0
	bottomInset: 0
	topPadding: 0
	bottomPadding: 0
	leftPadding: text ? 16 : 0
	rightPadding: leftPadding
	contentItem: RowLayout {
		spacing: 8
		anchors.verticalCenter: parent.verticalCenter
		height: icon.size
		Icon {
			id: icon
			size: 24
			Layout.fillWidth: !root.text
			Layout.fillHeight: true
		}
		Label {
			text: root.text
			visible: root.text
			Layout.fillWidth: true
			Layout.fillHeight: true
			verticalAlignment: Text.AlignVCenter
		}
	}
}
