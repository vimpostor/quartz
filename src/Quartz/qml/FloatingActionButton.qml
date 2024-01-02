import QtQuick.Controls.Material
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

	width: size == FloatingActionButton.Size.Normal ? 56 : size == FloatingActionButton.Size.Small ? 40 : 96
	height: width
	highlighted: true
	topInset: 0
	bottomInset: 0
    Material.roundedScale: size == FloatingActionButton.Size.Normal ? Material.LargeScale : size == FloatingActionButton.Size.Small ? Material.MediumScale : Material.ExtraLargeScale
	Icon {
		id: icon
		size: root.size == FloatingActionButton.Size.Normal ? 24 : root.size == FloatingActionButton.Size.Small ? 24 : 36
		anchors.centerIn: parent
	}
}
