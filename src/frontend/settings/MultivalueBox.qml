// Pegasus Frontend
// Copyright (C) 2017  Mátyás Mustoha
//
// This program is free software: you can redistribute it and/or modify
// it under the terms of the GNU General Public License as published by
// the Free Software Foundation, either version 3 of the License, or
// (at your option) any later version.
//
// This program is distributed in the hope that it will be useful,
// but WITHOUT ANY WARRANTY; without even the implied warranty of
// MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
// GNU General Public License for more details.
//
// You should have received a copy of the GNU General Public License
// along with this program. If not, see <http://www.gnu.org/licenses/>.


import QtGraphicalEffects 1.0
import QtQuick 2.7


FocusScope {
    id: root

    property alias model: list.model
    property alias index: list.currentIndex
    // seems like I can't disconnect anonymous functions from signals,
    // so I'm using some old-fashioned callbacks here -- it just works
    property var onChangeCallback: function(){}

    signal closed()

    width: rpx(280)
    height: parent.height

    anchors.left: parent.right
    anchors.rightMargin: height * 0.04
    visible: x < parent.width

    Keys.onEscapePressed: closed()
    Keys.onReturnPressed: { onChangeCallback(); closed(); }
    Keys.onEnterPressed: { onChangeCallback(); closed(); }


    property real textSize: rpx(22)
    property real itemHeight: 2.25 * textSize

    // center the list on the initially selected item
    onIndexChanged: {
        if (index > 0) {
            list.positionViewAtIndex(index, ListView.Center);
        }
    }

    // to make the list items visible during the transition,
    // this is called at the animation's end only
    function reset() {
        if (!visible) {
            model = undefined;
            index = -1;
            onChangeCallback = function(){}
        }
    }


    Rectangle {
        id: listContainer
        color: "#eee"

        width: parent.width
        height: parent.height * 0.84
        anchors.centerIn: parent

        visible: false

        ListView {
            id: list

            focus: true

            width: parent.width
            height: Math.min(count * itemHeight, parent.height)
            anchors.centerIn: parent

            delegate: listItem
            snapMode: ListView.SnapOneItem
            highlightMoveDuration: 175
        }
    }


    Component {
        id: listItem

        Rectangle {
            width: ListView.view.width
            height: root.itemHeight
            color: ListView.isCurrentItem ? "#dedede" : "#eee"

            Text {
                id: label

                anchors.right: parent.right
                anchors.rightMargin: rpx(24)
                anchors.verticalCenter: parent.verticalCenter

                text: modelData.name
                color: "#444"
                font.pixelSize: root.textSize
                font.family: uiFont.name
                horizontalAlignment: Text.AlignRight
            }
        }
    }

    Rectangle {
        id: boxMask

        radius: rpx(8)
        anchors.fill: listContainer

        visible: false
    }

    OpacityMask {
        id: opacityMask

        anchors.fill: listContainer
        source: listContainer
        maskSource: boxMask
        cached: true
    }

    states: State {
        name: "open"
        when: root.activeFocus
        AnchorChanges {
            target: root
            anchors.left: undefined
            anchors.right: root.parent.right
        }
    }

    readonly property var bezierDecelerate: [ 0,0, 0.2,1, 1,1 ]
    readonly property var bezierSharp: [ 0.4,0, 0.6,1, 1,1 ]

    transitions: [
        Transition {
            from: ""; to: "open"
            AnchorAnimation {
                duration: 175
                easing { type: Easing.Bezier; bezierCurve: bezierDecelerate }
            }
        },
        Transition {
            from: "open"; to: ""
            AnchorAnimation {
                duration: 150
                easing { type: Easing.Bezier; bezierCurve: bezierSharp }
            }

            onRunningChanged: if (!running) reset()
        }
    ]
}
