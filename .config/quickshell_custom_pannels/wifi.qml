import QtQuick
import QtQuick.Layouts
import QtQuick.Controls
import Quickshell
import Quickshell.Io

ShellRoot {
  FloatingWindow {
    id: window
    visible: true
    implicitWidth: 380
    implicitHeight: 520
    color: "transparent"

    // ── Close process when window is closed (Super+Q, etc.) ─
    onClosed: Qt.quit()

    // ── State ──────────────────────────────────────────────
    property bool wifiEnabled: true
    property var networks: []
    property bool scanning: false
    property bool connecting: false
    property string connectingSsid: ""
    property string errorText: ""
    property var savedConnections: []
    property string lastScanText: ""

    // ── Process: check wifi radio state ────────────────────
    Process {
      id: radioChecker
      command: ["nmcli", "-t", "radio", "wifi"]
      running: false

      stdout: StdioCollector {
        id: radioOut
        waitForEnd: true
      }

      onExited: function(exitCode) {
        if (exitCode === 0)
          window.wifiEnabled = radioOut.text.trim() === "enabled"
      }
    }

    // ── Process: toggle wifi radio ─────────────────────────
    Process {
      id: radioToggler
      command: []
      running: false

      stdout: StdioCollector { waitForEnd: true }

      onExited: function() { radioChecker.running = true }
    }

    // ── Process: scan networks ─────────────────────────────
    Process {
      id: scanner
      command: ["nmcli", "-t", "-f", "SSID,SIGNAL,SECURITY,IN-USE", "device", "wifi", "list"]
      running: false

      stdout: StdioCollector {
        id: scanOut
        waitForEnd: true
      }

      onExited: function(exitCode) {
        window.scanning = false
        if (exitCode === 0) {
          window.lastScanText = scanOut.text
          window.networks = window.parseNetworks(scanOut.text, window.savedConnections)
        }
        savedConnChecker.running = true
      }
    }

    // ── Process: connect / disconnect ──────────────────────
    Process {
      id: connector
      command: []
      running: false

      stdout: StdioCollector { waitForEnd: true }
      stderr: StdioCollector {
        id: connectErr
        waitForEnd: true
      }

      onExited: function(exitCode) {
        window.connecting = false
        window.connectingSsid = ""
        if (exitCode === 0) {
          window.errorText = ""
          window.startScan()
        } else {
          window.errorText = connectErr.text.trim()
        }
        savedConnChecker.running = true
      }
    }

    // ── Process: check saved connection profiles ───────────
    Process {
      id: savedConnChecker
      command: ["nmcli", "-t", "-f", "NAME", "connection", "show"]
      running: false

      stdout: StdioCollector {
        id: savedOut
        waitForEnd: true
      }

      onExited: function(exitCode) {
        if (exitCode !== 0) return
        var names = savedOut.text.split("\n")
        var list = []
        for (var i = 0; i < names.length; i++) {
          var n = names[i].trim()
          if (n !== "") list.push(n)
        }
        window.savedConnections = list
        if (window.lastScanText !== "")
          window.networks = window.parseNetworks(window.lastScanText, list)
      }
    }

    // ── Functions ──────────────────────────────────────────
    function startScan() {
      if (!window.wifiEnabled || window.scanning || window.connecting) return
      window.scanning = true
      scanner.running = true
    }

    function connectNetwork(ssid, psk) {
      if (window.connecting) return
      window.connecting = true
      window.connectingSsid = ssid
      window.errorText = ""
      if (psk && psk.length > 0) {
        connector.command = ["nmcli", "device", "wifi", "connect", ssid, "password", psk]
      } else {
        connector.command = ["nmcli", "device", "wifi", "connect", ssid]
      }
      connector.running = true
    }

    function disconnectNetwork(ssid) {
      if (window.connecting) return
      window.connecting = true
      window.connectingSsid = ssid
      connector.command = ["nmcli", "connection", "down", ssid]
      connector.running = true
    }

    function toggleWifi() {
      if (radioToggler.running || radioChecker.running) return
      radioToggler.command = ["nmcli", "radio", "wifi", window.wifiEnabled ? "off" : "on"]
      radioToggler.running = true
    }

    function parseNetworks(text, savedConns) {
      var lines = text.split("\n")
      var map = {}
      for (var i = 0; i < lines.length; i++) {
        var line = lines[i].trim()
        if (line === "") continue

        var fields = []
        var cur = ""
        for (var j = 0; j < line.length; j++) {
          if (line[j] === "\\" && j + 1 < line.length && line[j + 1] === ":") {
            cur += ":"
            j++
          } else if (line[j] === ":") {
            fields.push(cur)
            cur = ""
          } else {
            cur += line[j]
          }
        }
        fields.push(cur)

        if (fields.length < 4) continue
        var ssid = fields[0].trim()
        if (ssid === "") continue

        var signal = parseInt(fields[1]) || 0
        var security = fields[2].trim()
        var inUse = fields[3].trim() === "*"

        var existing = map[ssid]
        if (!existing) {
          map[ssid] = {
            ssid: ssid,
            signal: signal,
            security: security,
            inUse: inUse,
            known: savedConns.indexOf(ssid) >= 0
          }
        } else if (inUse || (!existing.inUse && signal > existing.signal)) {
          map[ssid] = {
            ssid: ssid,
            signal: signal,
            security: security,
            inUse: inUse,
            known: savedConns.indexOf(ssid) >= 0
          }
        }
      }

      var result = []
      for (var key in map)
        result.push(map[key])
      result.sort(function(a, b) {
        if (a.inUse && !b.inUse) return -1
        if (!a.inUse && b.inUse) return 1
        return b.signal - a.signal
      })
      return result
    }

    function signalLevel(s) {
      if (s >= 80) return 5
      if (s >= 60) return 4
      if (s >= 40) return 3
      if (s >= 20) return 2
      return 1
    }

    // ── Periodic scan timer ────────────────────────────────
    Timer {
      interval: 5000
      running: window.wifiEnabled
      onTriggered: window.startScan()
    }

    Component.onCompleted: {
      radioChecker.running = true
      savedConnChecker.running = true
      window.startScan()
    }

    // ── UI ─────────────────────────────────────────────────
    Rectangle {
      anchors.fill: parent
      radius: 8
      color: "#1a1b26"
      border.color: "#3b4261"
      border.width: 1
      clip: true

      Item {
        anchors.fill: parent
        focus: true
        Keys.onEscapePressed: Qt.quit()

        ColumnLayout {
          anchors.fill: parent
          spacing: 0

          // ── Header ────────────────────────────────────────
          Rectangle {
            Layout.fillWidth: true
            implicitHeight: 48
            color: "#24283b"

            Rectangle {
              anchors { left: parent.left; right: parent.right; bottom: parent.bottom }
              height: 1
              color: "#3b4261"
            }

            RowLayout {
              anchors { left: parent.left; right: parent.right; leftMargin: 14; rightMargin: 14; verticalCenter: parent.verticalCenter }
              spacing: 8

              Text {
                text: "  Wi-Fi"
                color: "#c0caf5"
                font.pixelSize: 14
                font.weight: Font.Medium
              }

              Item { Layout.fillWidth: true }

              Text {
                text: window.scanning ? "Scanning…" : ""
                color: "#565f89"
                font.pixelSize: 11
                visible: window.scanning
              }

              Rectangle {
                width: 44
                height: 22
                radius: 11
                color: window.wifiEnabled ? "#7aa2f7" : "#3b4261"

                Rectangle {
                  width: 18
                  height: 18
                  radius: 9
                  color: "#c0caf5"
                  x: window.wifiEnabled ? parent.width - width - 2 : 2
                  y: (parent.height - height) / 2
                  Behavior on x { NumberAnimation { duration: 120 } }
                }

                MouseArea {
                  anchors.fill: parent
                  cursorShape: Qt.PointingHandCursor
                  onClicked: window.toggleWifi()
                }
              }
            }
          }

          // ── Network list ──────────────────────────────────
          Item {
            Layout.fillWidth: true
            Layout.fillHeight: true
            clip: true

            ListView {
              id: networkList
              anchors.fill: parent
              anchors.margins: 8
              spacing: 4
              model: window.networks
              reuseItems: false

              delegate: Rectangle {
                required property var modelData
                required property int index

                width: networkList.width - 16
                implicitHeight: column.implicitHeight
                radius: 6
                color: mouseHover.containsMouse ? "#2f3347" : "transparent"

                property bool showPassword: false

                ColumnLayout {
                  id: column
                  anchors.fill: parent
                  anchors.leftMargin: 10
                  anchors.rightMargin: 10
                  spacing: 0

                  // ── Main content row ──────────────────────
                  RowLayout {
                    Layout.fillWidth: true
                    Layout.minimumHeight: 44
                    spacing: 8

                    // Signal bars (5 bars, bottom-aligned)
                    Rectangle {
                      width: 28
                      height: 22
                      color: "transparent"

                      Row {
                        anchors.centerIn: parent
                        spacing: 2
                        bottomPadding: 2

                        Repeater {
                          model: 5
                          Rectangle {
                            y: parent.height - height
                            width: 4
                            height: [4, 7, 10, 13, 16][index]
                            radius: 1
                            color: index < window.signalLevel(modelData.signal) ? "#7aa2f7" : "#3b4261"
                          }
                        }
                      }
                    }

                    // SSID + security/saved label
                    ColumnLayout {
                      Layout.fillWidth: true
                      spacing: 0

                      Text {
                        text: modelData.ssid
                        color: "#c0caf5"
                        font.pixelSize: 12
                        elide: Text.ElideRight
                        Layout.fillWidth: true
                      }

                      Text {
                        text: {
                          if (modelData.security === "") return ""
                          return modelData.known ? "  Saved" : "  Secured"
                        }
                        color: modelData.known ? "#9ece6a" : "#565f89"
                        font.pixelSize: 9
                        visible: modelData.security !== ""
                      }
                    }

                    // Right side: connected badge or connect button
                    Rectangle {
                      id: rightAction
                      visible: true
                      width: modelData.inUse ? 80 : (showPassword ? 60 : 60)
                      height: 24
                      radius: 4
                      color: modelData.inUse
                        ? (disconnectMouse.containsMouse ? "#f7768e" : "#9ece6a")
                        : (actionMouse.containsMouse ? "#3b4261" : "#24283b")
                      border.color: modelData.inUse
                        ? (disconnectMouse.containsMouse ? "#f7768e" : "#9ece6a")
                        : "#3b4261"
                      border.width: 1

                      Text {
                        anchors.centerIn: parent
                        text: modelData.inUse
                          ? (disconnectMouse.containsMouse ? "Disconnect" : "Connected")
                          : (showPassword ? "Join" : "Connect")
                        color: modelData.inUse
                          ? (disconnectMouse.containsMouse ? "#1a1b26" : "#1a1b26")
                          : "#a9b1d6"
                        font.pixelSize: 10
                      }

                      MouseArea {
                        id: actionMouse
                        anchors.fill: parent
                        cursorShape: Qt.PointingHandCursor
                        hoverEnabled: true
                        visible: !modelData.inUse
                        onClicked: {
                          if (showPassword) {
                            var pwd = passwordField.text
                            if (pwd.length > 0)
                              window.connectNetwork(modelData.ssid, pwd)
                          } else if (modelData.security !== "" && !modelData.known) {
                            showPassword = true
                            passwordField.forceActiveFocus()
                          } else {
                            window.connectNetwork(modelData.ssid, "")
                          }
                        }
                      }

                      MouseArea {
                        id: disconnectMouse
                        anchors.fill: parent
                        cursorShape: Qt.PointingHandCursor
                        hoverEnabled: true
                        visible: modelData.inUse
                        onClicked: window.disconnectNetwork(modelData.ssid)
                      }
                    }
                  }

                  // ── Inline password row (below main row) ──
                  Rectangle {
                    Layout.fillWidth: true
                    Layout.preferredHeight: visible ? 32 : 0
                    Layout.topMargin: -1
                    visible: showPassword
                    color: "#1e2030"

                    RowLayout {
                      anchors.fill: parent
                      anchors.margins: 4
                      spacing: 4

                      TextField {
                        id: passwordField
                        Layout.fillWidth: true
                        height: 24
                        echoMode: TextInput.Password
                        placeholderText: "Enter password"
                        color: "#c0caf5"
                        placeholderTextColor: "#565f89"

                        background: Rectangle {
                          radius: 4
                          color: "#24283b"
                          border.color: "#3b4261"
                          border.width: 1
                        }

                        Keys.onReturnPressed: {
                          if (text.length > 0)
                            window.connectNetwork(modelData.ssid, text)
                        }

                        Keys.onEscapePressed: showPassword = false
                      }

                      Rectangle {
                        width: 24
                        height: 24
                        radius: 4
                        color: "#f7768e"

                        Text {
                          anchors.centerIn: parent
                          text: ""
                          color: "#1a1b26"
                          font.pixelSize: 10
                        }

                        MouseArea {
                          anchors.fill: parent
                          cursorShape: Qt.PointingHandCursor
                          onClicked: showPassword = false
                        }
                      }
                    }
                  }
                }

                MouseArea {
                  id: mouseHover
                  anchors.fill: parent
                  acceptedButtons: Qt.NoButton
                  hoverEnabled: true
                  cursorShape: Qt.PointingHandCursor
                }
              }

              // Empty state text
              Text {
                anchors.centerIn: parent
                text: !window.wifiEnabled ? "Wi-Fi is off"
                                   : window.scanning ? "Scanning..."
                                   : window.networks.length === 0 ? "No networks found"
                                   : ""
                color: "#565f89"
                font.pixelSize: 12
                visible: !networkList.count || window.scanning || !window.wifiEnabled
              }
            }
          }

          // ── Error bar ─────────────────────────────────────
          Rectangle {
            Layout.fillWidth: true
            height: window.errorText !== "" ? 28 : 0
            color: "#2f1e1e"
            visible: window.errorText !== ""

            Text {
              anchors.centerIn: parent
              text: window.errorText
              color: "#f7768e"
              font.pixelSize: 10
              elide: Text.ElideRight
              maximumLineCount: 1
            }

            MouseArea {
              anchors.fill: parent
              cursorShape: Qt.PointingHandCursor
              onClicked: window.errorText = ""
            }
          }
        }
      }
    }
  }
}
