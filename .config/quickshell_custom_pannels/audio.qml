import QtQuick
import QtQuick.Layouts
import QtQuick.Controls
import Quickshell
import Quickshell.Services.Pipewire

ShellRoot {
  FloatingWindow {
    id: window
    visible: true
    implicitWidth: 320
    implicitHeight: 160
    color: "transparent"

    onClosed: Qt.quit()

    property var sink: Pipewire.defaultAudioSink

    PwObjectTracker {
        objects: [window.sink]
    }

    Rectangle {
      anchors.fill: parent
      radius: 8
      color: "#1a1b26"
      border.color: "#3b4261"
      border.width: 1

      Item {
        anchors.fill: parent
        focus: true
        Keys.onEscapePressed: Qt.quit()

        ColumnLayout {
          anchors {
            fill: parent
            margins: 16
          }
          spacing: 12

          Text {
            text: {
              if (!Pipewire.ready) return "Loading..."
              if (!window.sink) return "No sink"
              if (!window.sink.ready) return "Not ready"
              return window.sink.description || window.sink.nickname || window.sink.name || "Unknown"
            }
            color: "#c0caf5"
            font.pixelSize: 13
            font.weight: Font.Medium
            elide: Text.ElideRight
            Layout.fillWidth: true
          }

          RowLayout {
            Layout.fillWidth: true
            spacing: 10

            Text {
              text: ""
              color: "#7aa2f7"
              font.pixelSize: 16
            }

            Slider {
              id: volumeSlider
              Layout.fillWidth: true
              from: 0.0
              to: 1.0
              stepSize: 0.01

              Binding {
                target: volumeSlider
                property: "value"
                value: window.sink?.ready ? window.sink.audio.volume : 0
                when: !volumeSlider.pressed
              }

              background: Rectangle {
                x: volumeSlider.leftPadding
                y: volumeSlider.topPadding + volumeSlider.availableHeight / 2 - height / 2
                width: volumeSlider.availableWidth
                height: 4
                radius: 2
                color: "#3b4261"

                Rectangle {
                  width: volumeSlider.visualPosition * parent.width
                  height: parent.height
                  radius: 2
                  color: "#7aa2f7"
                }
              }

              handle: Rectangle {
                x: volumeSlider.leftPadding + volumeSlider.visualPosition * (volumeSlider.availableWidth - width)
                y: volumeSlider.topPadding + volumeSlider.availableHeight / 2 - height / 2
                width: 14
                height: 14
                radius: 7
                color: volumeSlider.pressed ? "#89b4fa" : "#c0caf5"
                border.color: "#7aa2f7"
                border.width: 2
              }

              onMoved: {
                if (window.sink?.ready) window.sink.audio.volume = value
              }
            }

            Text {
              text: Math.round(volumeSlider.value * 100) + "%"
              color: "#a9b1d6"
              font.pixelSize: 12
              font.family: "monospace"
              Layout.minimumWidth: 36
              horizontalAlignment: Text.AlignRight
            }
          }

          RowLayout {
            Layout.fillWidth: true
            spacing: 8

            Rectangle {
              id: muteButton
              Layout.fillWidth: true
              height: 32
              radius: 6
              color: window.sink?.ready && window.sink.audio.muted ? "#f7768e" : "#24283b"
              border.color: "#3b4261"
              border.width: 1

              Text {
                anchors.centerIn: parent
                text: window.sink?.ready && window.sink.audio.muted ? "  Muted" : "  Mute"
                color: window.sink?.ready && window.sink.audio.muted ? "#1a1b26" : "#a9b1d6"
                font.pixelSize: 12
              }

              MouseArea {
                anchors.fill: parent
                cursorShape: Qt.PointingHandCursor
                onClicked: {
                  if (window.sink?.ready) window.sink.audio.muted = !window.sink.audio.muted
                }
              }
            }
          }
        }
      }
    }
  }
}
