import QtQuick
import QtQuick.Controls.Material
import Quartz

Popup {
	property alias text: label.text
	property int offset: 0
	property alias timeout: closeTimer.interval

	id: snackbarRoot
	parent: Overlay.overlay
	x: (parent.width - width) / 2
	y: parent.height - offset
	z: 1
	padding: 0
	closePolicy: Popup.NoAutoClose
	Material.theme: Material.Dark
	modal: false
	enter: Transition {
		NumberAnimation {
			property: "offset"
			duration: 200
			easing.type: Easing.OutCirc
			from: 0
			to: implicitHeight + 16
		}
	}
	exit: Transition {
		NumberAnimation {
			property: "offset"
			duration: 200
			easing.type: Easing.OutCirc
			to: 0
		}
	}
	Behavior on width {
		NumberAnimation {
			easing.type: Easing.OutCirc
			duration: 64
		}
	}
	width: implicitWidth
	Row {
		spacing: 8
		Item {
			width: 1
			height: 1
		}
		Icon {
			name: "info"
			highlighted: true
			anchors.verticalCenter: parent.verticalCenter
		}
		Label {
			id: label
			anchors.verticalCenter: parent.verticalCenter
		}
		Button {
			text: "OK"
			anchors.verticalCenter: parent.verticalCenter
			flat: true
			onClicked: snackbarRoot.close();
		}
		Item {
			width: 1
			height: 1
		}
	}
	Timer {
		id: closeTimer
		interval: 2000
		running: interval > 0 && snackbarRoot.opened
		onTriggered: snackbarRoot.close();
	}
}
