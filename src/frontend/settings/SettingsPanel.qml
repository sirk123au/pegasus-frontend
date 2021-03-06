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


import QtQuick 2.8


FocusScope {
    id: root

    signal screenClosed()

    width: parent.width
    height: parent.height
    visible: false

    Keys.onEscapePressed: screenClosed()


    Rectangle {
        // background
        anchors.fill: parent
        color: "#222"
    }

    Item {
        id: header

        width: parent.width
        height: rpx(80)

        Text {
            id: title

            text: qsTr("Settings") + pegasus.tr
            color: "#eee"
            font.pixelSize: rpx(40)
            font.family: uiFont.name

            anchors.left: parent.horizontalCenter
            anchors.leftMargin: parent.width * -0.4
            anchors.bottom: parent.bottom
            anchors.bottomMargin: rpx(10)
        }

        Rectangle {
            width: parent.width * 0.97
            height: rpx(1)
            color: "#555"

            anchors.bottom: parent.bottom
            anchors.horizontalCenter: parent.horizontalCenter
        }
    }

    FocusScope {
        id: content

        focus: true

        anchors.top: header.bottom
        anchors.topMargin: rpx(30)
        anchors.horizontalCenter: parent.horizontalCenter
        width: parent.width * 0.7

        Column {
            anchors.fill: parent
            spacing: rpx(5)

            MultivalueOption {
                id: optLanguage

                focus: true

                label: qsTr("Language") + pegasus.tr
                value: pegasus.settings.locales.current.name

                onActivate: {
                    multivalbox.model = pegasus.settings.locales.model;
                    multivalbox.index = pegasus.settings.locales.index;
                    multivalbox.onChangeCallback = function() {
                        pegasus.settings.locales.index = multivalbox.index;
                    };

                    content.enabled = false;
                    multivalbox.focus = true;
                }

                KeyNavigation.down: optTheme
            }

            MultivalueOption {
                id: optTheme

                label: qsTr("Theme") + pegasus.tr
                value: pegasus.settings.themes.current.name

                onActivate: {
                    multivalbox.model = pegasus.settings.themes.model;
                    multivalbox.index = pegasus.settings.themes.index;
                    multivalbox.onChangeCallback = function() {
                        pegasus.settings.themes.index = multivalbox.index;
                    };

                    content.enabled = false;
                    multivalbox.focus = true;
                }

                KeyNavigation.down: optFullscreen
            }

            ToggleOption {
                id: optFullscreen

                label: qsTr("Fullscreen mode") + pegasus.tr
                note: qsTr("On some platforms this setting may have no effect") + pegasus.tr

                checked: pegasus.settings.fullscreen
                onCheckedChanged: pegasus.settings.fullscreen = checked
            }
        }
    }


    Rectangle {
        // shade for MultivalueBox

        anchors.fill: parent
        color: "#000"

        opacity: multivalbox.visible ? 0.3 : 0.0
        visible: opacity > 0.0

        Behavior on opacity { PropertyAnimation { duration: 150 } }
    }

    MultivalueBox {
        id: multivalbox

        onClosed: {
            content.enabled = true;
            content.focus = true;
        }
    }
}
