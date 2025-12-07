import QtQuick
import QtQuick.Controls

Window {
    width: 1920
    height: 1080
    visible: true
    title: "Airline Login"

    Rectangle {
        anchors.fill: parent
        color: "#0f1419"

        Rectangle {
            anchors.centerIn: parent
            width: 600
            height: 500
            color: "#1c2128"
            radius: 12

            Column {
                anchors.centerIn: parent
                spacing: 30

                Text {
                    text: "Login Test"
                    color: "white"
                    font.pixelSize: 32
                    anchors.horizontalCenter: parent.horizontalCenter
                }

                TextField {
                    id: usernameField
                    width: 400
                    placeholderText: "Username"
                    font.pixelSize: 18
                }

                TextField {
                    id: passwordField
                    width: 400
                    placeholderText: "Password"
                    echoMode: TextInput.Password
                    font.pixelSize: 18
                }

                Button {
                    text: "Login"
                    width: 200
                    anchors.horizontalCenter: parent.horizontalCenter

                    onClicked: {
                        var result = loginHandler.attemptLogin(usernameField.text, passwordField.text)
                        statusText.text = result

                        if (result.indexOf("✓") !== -1) {
                            statusText.color = "green"
                        } else {
                            statusText.color = "red"
                        }
                    }
                }

                Text {
                    id: statusText
                    text: ""
                    color: "white"
                    font.pixelSize: 16
                    width: 400
                    wrapMode: Text.WordWrap
                    horizontalAlignment: Text.AlignHCenter
                }

                Text {
                    text: "Try: admin / admin123"
                    color: "#888"
                    font.pixelSize: 14
                    anchors.horizontalCenter: parent.horizontalCenter
                }
            }
        }
    }
}
