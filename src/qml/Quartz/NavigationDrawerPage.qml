import QtQuick
import QtQuick.Layouts
import QtQuick.Controls.Material
import Quartz

StackLayout {
	property alias model: nav.model
	property alias navIndex: nav.currentIndex

	currentIndex: nav.currentIndex
	anchors.fill: parent
	NavigationDrawer {
		id: nav
	}
}
