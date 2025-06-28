import QtQuick
import QtQuick.Controls.Material
import QtQuick.Layouts
import QtQuick.Effects
import Quartz

Button {
	id: root
	enum Type {
		Assist,
		Filter,
		Input,
		Suggestion
	}
	property int type: Chip.Type.Assist
	property alias leftIco: leftIcon
	property alias rightIco: rightIcon.ico
	property alias imageSource: img.source
	signal rightIconClicked()

	height: 32
	Material.roundedScale: Material.SmallScale
	Material.accent: Material.Grey
	flat: true
	highlighted: true
	topInset: 0
	bottomInset: 0
	leftPadding: type == Chip.Type.Input ? 4 : 8
	rightPadding: 8
	topPadding: 0
	bottomPadding: 0
	spacing: 0
	Behavior on implicitWidth {
		NumberAnimation { duration: 300; easing.type: Easing.OutCirc; }
	}
	contentItem: RowLayout {
		anchors.top: parent.top
		anchors.bottom: parent.bottom
		spacing: 0
		Icon {
			id: leftIcon
			size: 18
			Layout.alignment: Qt.AlignVCenter
		}
		Image {
			id: img
			visible: status == Image.Ready
			sourceSize.width: 24
			sourceSize.height: 24
			Layout.alignment: Qt.AlignVCenter
			layer.enabled: visible
			layer.effect: MultiEffect {
				maskEnabled: true
				maskThresholdMin: 0.5
				maskSpreadAtMin: 1.0
				maskSource: ShaderEffectSource {
					sourceItem: Rectangle {
						width: 24
						height: 24
						radius: 12
					}
				}
			}
		}
		Spacer {
			implicitWidth: 8
		}
		Label {
			text: root.text
			Layout.alignment: Qt.AlignVCenter
		}
		Spacer {
			implicitWidth: 8
		}
		IconButton {
			id: rightIcon
			visible: ico.name.length
			ico.size: 18
			Layout.fillHeight: true
			Layout.alignment: Qt.AlignVCenter
			onClicked: root.rightIconClicked();
		}
	}
}
