import QtQuick
import QtQuick.Controls.Material
import QtQuick.Layouts
import Quartz

Item {
	ColumnLayout {
		anchors.fill: parent
		anchors.topMargin: 4
		spacing: 8
		Search {
			id: search
			placeholderText: "Search icons"
			width: parent.width - 16
			Layout.alignment: Qt.AlignHCenter
			focus: true
		}
		RowLayout {
			Layout.fillWidth: true
			Layout.fillHeight: true
			GroupBox {
				title: "Variable Font Settings"
				Layout.fillHeight: true
				Layout.margins: 8
				component SliderDelegate: Item {
					property alias text: label.text
					property alias slider: slider
					implicitHeight: label.implicitHeight
					RowLayout {
						anchors.fill: parent
						anchors.leftMargin: 8
						anchors.rightMargin: 8
						Label {
							id: label
						}
						Slider {
							id: slider
							Layout.fillWidth: true
							stepSize: 1
						}
					}
				}
				Column {
					width: parent.width
					CheckDelegate {
						id: filledDelegate
						width: parent.width
						text: "Filled"
					}
					SliderDelegate {
						id: weightDelegate
						width: parent.width
						text: "Weight"
						slider.value: 400
						slider.from: 100
						slider.to: 700
					}
					SliderDelegate {
						id: gradeDelegate
						width: parent.width
						text: "Grade"
						slider.value: 0
						slider.from: -25
						slider.to: 200
					}
					SliderDelegate {
						id: opticalSizeDelegate
						width: parent.width
						text: "Optical Size"
						slider.value: 24
						slider.from: 20
						slider.to: 48
					}
				}
			}
			ListView {
				Layout.fillWidth: true
				Layout.fillHeight: true
				clip: true
				ScrollBar.vertical: ScrollBar {}
				model: Codepoints.allIconNames()
				delegate: ItemDelegate {
					text: modelData
					width: parent ? parent.width : 0
					height: implicitHeight * (modelData.indexOf(search.text) != -1)
					visible: height
					Behavior on height {
						NumberAnimation {
							easing.type: Easing.OutCirc
							duration: 128
						}
					}
					onClicked: {
						Quartz.copyClipboard(modelData);
						snackbar.display("Copied \"" + modelData + "\"");
					}
					Icon {
						anchors { verticalCenter: parent.verticalCenter; right: parent.right; margins: 32 }
						name: modelData
						size: parent.height
						filled: filledDelegate.checked
						weight: weightDelegate.slider.value
						grade: gradeDelegate.slider.value
						opticalSize: opticalSizeDelegate.slider.value
					}
				}
			}
		}
	}
	Snackbar {
		id: snackbar
	}
}
