import QtQuick
import QtQuick.Controls.Material
import QtQuick.Layouts
import Quartz

Button {
	id: root
	enum Size {
		Normal,
		Small,
		Large
	}
	property alias name: icon.name
	property int size: FloatingActionButton.Size.Normal

	leftPadding: 16
	rightPadding: 16
	implicitWidth: text ? Math.max(80, implicitContentWidth + leftPadding + rightPadding) : height
	implicitHeight: size == FloatingActionButton.Size.Normal ? 56 : size == FloatingActionButton.Size.Small ? 40 : 96
	highlighted: size != FloatingActionButton.Size.Small
	topInset: 0
	bottomInset: 0
    Material.roundedScale: size == FloatingActionButton.Size.Normal ? Material.LargeScale : size == FloatingActionButton.Size.Small ? Material.MediumScale : Material.ExtraLargeScale
	Material.elevation: 5 + (hovered || activeFocus) * 3 + down
	Behavior on Material.elevation {
		NumberAnimation { duration: 300; easing.type: Easing.OutCirc; }
	}
	contentItem: RowLayout {
		anchors.horizontalCenter: parent.horizontalCenter
		height: root.size == FloatingActionButton.Size.Normal ? 24 : root.size == FloatingActionButton.Size.Small ? 24 : 36
		spacing: 8
		Icon {
			id: icon
			Layout.fillWidth: true
			Layout.fillHeight: true
		}
		Label {
			text: root.text
			visible: root.text
			Layout.fillHeight: true
			verticalAlignment: Text.AlignVCenter
		}
	}
}
