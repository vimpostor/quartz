import QtQuick
import QtQuick.Controls.Material
import Quartz

Popup {
	property alias text: label.text
	property alias action: actionButton.text
	property int offset: 0
	property alias timeout: closeTimer.interval
	property alias dismissible: closeButton.visible
	signal clicked()

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
		spacing: 12
		Item {
			width: 4
			height: 48
		}
		Label {
			id: label
			anchors.verticalCenter: parent.verticalCenter
		}
		Button {
			id: actionButton
			visible: text
			Material.foreground: Material.accent
			anchors.verticalCenter: parent.verticalCenter
			flat: true
			onClicked: snackbarRoot.clicked();
		}
		Icon {
			id: closeButton
			name: "close"
			clickable: true
			anchors.verticalCenter: parent.verticalCenter
			onClicked: snackbarRoot.close();
		}
		Item {
			width: 1
			height: 1
		}
	}
	Timer {
		id: closeTimer
		interval: 3000
		running: interval > 0 && snackbarRoot.opened
		onTriggered: snackbarRoot.close();
	}
}
