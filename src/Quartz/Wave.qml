import QtQuick
import QtQuick.Controls.Material
import QtQuick.Effects

Rectangle {
	id: ripple
	property real size: 0.0
	property int centreX: width / 2
	property int centreY: height / 2
	color: Material.accent
	visible: size > 0.0
	Behavior on size {
		NumberAnimation { duration: 300; easing.type: Easing.OutCirc; }
	}
	layer.enabled: visible
	layer.effect: MultiEffect {
		maskEnabled: true
		maskSource: ShaderEffectSource {
			sourceItem: Item {
				width: ripple.width
				height: ripple.height
				Rectangle {
					radius: Math.ceil(Math.sqrt(Math.pow(ripple.width / 2 + Math.abs(ripple.centreX - ripple.width / 2), 2) + Math.pow(ripple.height / 2 + Math.abs(ripple.centreY - ripple.height / 2), 2)))
					width: ripple.size * 2 * radius
					height: width
					x: ripple.centreX - width / 2
					y: ripple.centreY - height / 2
				}
			}
		}
	}
}
