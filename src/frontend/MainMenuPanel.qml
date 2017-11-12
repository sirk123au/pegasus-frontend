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


import "menuitems"
import QtQuick 2.8


FocusScope {
    id: root

    width: rpx(350)
    height: parent.height
    visible: x < parent.width && 0 < x + width

    signal showGamepadScreen()
    signal showSettingsScreen()

    signal requestShutdown()
    signal requestReboot()
    signal requestQuit()


    Rectangle {
        color: "#333"
        anchors.fill: parent
    }

    Column {
        width: parent.width
        anchors.bottom: parent.bottom
        anchors.bottomMargin: rpx(30)

        PrimaryMenuItem {
            id: mbSettings
            text: qsTr("Settings") + pegasus.tr
            onActivated: {
                focus = true;
                root.showSettingsScreen();
            }
            selected: focus
            focus: true

            KeyNavigation.down: mbControls
        }
        PrimaryMenuItem {
            id: mbControls
            text: qsTr("Controls") + pegasus.tr
            onActivated: {
                focus = true;
                root.showGamepadScreen();
            }
            selected: focus

            KeyNavigation.down: scopeQuit
        }
        RollableMenuItem {
            id: scopeQuit
            name: qsTr("Quit") + pegasus.tr

            entries: [
                SecondaryMenuItem {
                    id: mbQuitShutdown
                    text: qsTr("Shutdown") + pegasus.tr
                    onActivated: requestShutdown()
                    focus: true

                    KeyNavigation.up: mbQuitShutdown
                    KeyNavigation.down: mbQuitReboot
                },
                SecondaryMenuItem {
                    id: mbQuitReboot
                    text: qsTr("Reboot") + pegasus.tr
                    onActivated: requestReboot()

                    KeyNavigation.down: mbQuitExit
                },
                SecondaryMenuItem {
                    id: mbQuitExit
                    text: qsTr("Exit Pegasus") + pegasus.tr
                    onActivated: requestQuit()
                }
            ]
        }
    }
}
