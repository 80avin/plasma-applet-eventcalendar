// Version 6

import QtQuick 2.0
import QtQuick.Controls 1.2
import QtQuick.Layouts 1.0

import org.kde.plasma.core 2.0 as PlasmaCore

// Origionally from digitalclock's configTimeZones.qml
// Recoloured with Bootstrap color scheme
Rectangle {
	id: messageWidget

	Layout.fillWidth: true

	property alias text: label.text
	property alias wrapMode: label.wrapMode
	property alias closeButtonVisible: closeButton.visible
	property alias animate: visibleAnimation.enabled
	property int iconSize: units.iconSizes.large

	// enum MessageType {
	// 	Positive, // 0
	// 	Information, // 1
	// 	Warning, // 2
	// 	Error // 3
	// }
	property int messageType: 2

	clip: true
	radius: 5
	border.width: 1

	property var icon: {
		if (messageType == 1) {
			return "dialog-information"
		} else if (messageType == 2) {
			return "dialog-warning"
		} else if (messageType == 3) {
			return "dialog-error"
		} else { // positive
			return "dialog-ok"
		}
	}

	property color gradBaseColor: {
		if (messageType == 1) {
			// return theme.highlightColor
			return "#d9edf7" // Bootstrap
		} else if (messageType == 2) {
			// return Qt.rgba(176/255, 128/255, 0, 1) // KMessageWidget
			// return "#EAC360" // DigitalClock
			return "#fcf8e3" // Bootstrap
		} else if (messageType == 3) {
			// return Qt.rgba(191/255, 3/255, 3/255, 1)
			return "#f2dede" // Bootstrap
		} else { // positive
			// return Qt.rgba(0, 110/255, 40/255, 1)
			return "#dff0d8" // Bootstrap
		}
	}

	border.color: {
		if (messageType == 1) {
			// return theme.highlightColor
			return "#bcdff1" // Bootstrap
		} else if (messageType == 2) {
			// return "#79735B" // DigitalClock
			return "#faf2cc" // Bootstrap
		} else if (messageType == 3) {
			return "#ebcccc" // Bootstrap
		} else { // positive
			return "#d0e9c6" // Bootstrap
		}
	}

	property color labelColor: {
		// return PlasmaCore.ColorScope.textColor
		if (messageType == 1) {
			return "#31708f" // Bootstrap
		} else if (messageType == 2) {
			return "#8a6d3b" // Bootstrap
		} else if (messageType == 3) {
			return "#a94442" // Bootstrap
		} else { // positive
			return "#3c763d" // Bootstrap
		}
	}

	function show(message, messageType) {
		if (typeof messageType !== "undefined") {
			messageWidget.messageType = messageType
		}
		text = message
		visible = true
	}

	function success(message) {
		show(message, 0)
	}

	function info(message) {
		show(message, 1)
	}

	function warn(message) {
		show(message, 2)
	}

	function err(message) {
		show(message, 3)
	}

	function close() {
		visible = false
	}

	gradient: Gradient {
		GradientStop { position: 0.0; color: Qt.lighter(messageWidget.gradBaseColor, 1.1) }
		GradientStop { position: 0.1; color: messageWidget.gradBaseColor }
		GradientStop { position: 1.0; color: Qt.darker(messageWidget.gradBaseColor, 1.1) }
	}

	readonly property int expandedHeight: layout.implicitHeight + (2 * layout.anchors.margins)
	
	visible: text
	opacity: visible ? 1.0 : 0
	implicitHeight: visible ? messageWidget.expandedHeight : 0

	Component.onCompleted: {
		// Remove bindings
		visible = visible
		opacity = opacity
		if (visible) {
			implicitHeight = Qt.binding(function(){ return messageWidget.expandedHeight })
		} else {
			implicitHeight = 0
		}
	}

	Behavior on visible {
		id: visibleAnimation

		ParallelAnimation {
			PropertyAnimation {
				target: messageWidget
				property: "opacity"
				to: messageWidget.visible ? 0 : 1.0
				easing.type: Easing.Linear
			}
			PropertyAnimation {
				target: messageWidget
				property: "implicitHeight"
				to: messageWidget.visible ? 0 : messageWidget.expandedHeight
				easing.type: Easing.Linear
			}
		}
	}

	RowLayout {
		id: layout
		anchors.fill: parent
		anchors.margins: units.smallSpacing
		spacing: units.smallSpacing

		PlasmaCore.IconItem {
			id: iconItem
			Layout.alignment: Qt.AlignVCenter
			implicitHeight: messageWidget.iconSize
			implicitWidth: messageWidget.iconSize
			source: messageWidget.icon
		}

		Label {
			id: label
			Layout.alignment: Qt.AlignVCenter
			Layout.fillWidth: true
			verticalAlignment: Text.AlignVCenter
			wrapMode: Text.WordWrap
			color: messageWidget.labelColor
		}

		ToolButton {
			id: closeButton
			Layout.alignment: Qt.AlignVCenter
			iconName: "dialog-close"

			onClicked: {
				messageWidget.close()
			}
		}
	}
}
