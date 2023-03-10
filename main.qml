import QtQuick
import QtQuick.Dialogs
import QtQuick.Controls
import QtMultimedia

ApplicationWindow {
    id: mainWindow
    visible: true
    width: 640
    height: 480
    title: "Video Player"

    function msToDuration(milliseconds) {
        var hours = Math.floor(milliseconds / (60 * 60 * 1000))
        var minutes = Math.floor((milliseconds % (60 * 60 * 1000)) / (60 * 1000))
        var seconds = Math.floor((milliseconds % (60 * 1000)) / 1000)
        return hours + ":" + minutes.toString().padStart(2, '0') + ":" + seconds.toString().padStart(2, '0')
    }

    // Video player
    MediaPlayer {
        id: mediaPlayer
        videoOutput: videoOutput
        audioOutput: AudioOutput {
            id: audioOutput
        }
        onMediaStatusChanged: console.log("Media status: " + mediaStatus)
    }

    VideoOutput {
        id: videoOutput
        anchors.fill: parent
     }

    // Open video button
    Button {
        anchors.bottom: mainWindow.top
        text: "Open Video"
        onClicked: fileDialog.open()
    }

    // Controls row (contains play button, progress slider and timing)
    Row {
        id: controlsRow
        anchors.bottom: parent.bottom
        anchors.horizontalCenter: parent.horizontalCenter
        spacing: 10

        // Play button
        Button {
            id: playButton
            text: mediaPlayer.playbackState === MediaPlayer.PlayingState ? "Pause" : "Play"

            onClicked: {
                if (mediaPlayer.playbackState === MediaPlayer.PlayingState) {
                    mediaPlayer.pause()
                } else {
                    mediaPlayer.play()
                }
            }
        }

        // Progress slider
        Slider {
            id: progressSlider
            from: 0
            to: mediaPlayer.duration > 0 ? mediaPlayer.duration : 1
            value: mediaPlayer.position
            stepSize: 1000
            onValueChanged: mediaPlayer.position = value
        }

        // Current progress
        Label {
            text: mediaPlayer.duration > 0 ? msToDuration(mediaPlayer.position) : "--:--:--"
            font.pointSize: 12
        }

        // Total Duraion
        Label {
            text: mediaPlayer.duration > 0 ? msToDuration(mediaPlayer.duration) : "--:--:--"
            font.pointSize: 12
        }

    }

    // File picker dialog
    FileDialog {
        id: fileDialog
        title: "Open Video File"
        nameFilters: ["Video Files (*.mp4 *.avi *.mkv)"]
        onAccepted: {
            mediaPlayer.source = fileDialog.selectedFile
            mediaPlayer.position = 0
            progressSlider.value = 0
            mediaPlayer.play()
            console.log(mediaPlayer.source)
        }
        onRejected: {
            mediaPlayer.source = ""
        }
    }

    // Update progress slider position and play button text when playback state changes
    Connections {
        target: mediaPlayer
        function onPlaybackStateChanged() {
            progressSlider.value = mediaPlayer.position
            playButton.text = mediaPlayer.playbackState === MediaPlayer.PlayingState ? "Pause" : "Play"
        }
    }
}
