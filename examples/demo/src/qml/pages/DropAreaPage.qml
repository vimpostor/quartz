import QtQuick
import QtQuick.Controls.Material
import Quartz

DropArea {
	anchors.fill: parent
	onDropped: (drop) => {
		console.log(drop.urls);
	}
}
