import QtQuick 2.15

Item {

    id: root
    clip: true;

    signal switchChecked();
    signal deleteEntry();
    signal moreOptions();
    signal archiveEntry();

    property bool read: false
    property string fromSender: ""

    Rectangle{
        z: 1
        id:topComponent
        width: root.width
        height: root.height

        color: "white"
        property point beginDrag
        property bool caught: false
        Drag.active: mouseArea.drag.active

        Text {
            anchors.left: parent.left
            anchors.verticalCenter: parent.verticalCenter
            leftPadding: height
            text: "E-Mail is read: " + read
        }

        Text {
            anchors.centerIn: parent
            text: "Content: " + fromSender
        }

        MouseArea {
            id: mouseArea
            anchors.fill: parent
            drag{
                target: parent
                axis: Drag.XAxis
            }
            onPressed: {
                topComponent.beginDrag = Qt.point(topComponent.x, topComponent.y);
            }
            onReleased: {

                //Decide operation
                if(!topComponent.caught) {
                    backAnimX.from = topComponent.x;
                    backAnimX.to = topComponent.beginDrag.x;

                    //toggle checked ?
                    if(topComponent.x > (topComponent.height) ){
                        root.switchChecked()
                    } else {
                        //In sweet spot to show all options ?
                        if(topComponent.x <= topComponent.height * -2.5 && topComponent.x >= topComponent.height * -5){
                            showOptionsAnim.from = topComponent.x
                            showOptionsAnim.start()
                            return;
                        } else if(topComponent.x < topComponent.height * -5){
                            deleteEntry()
                        }
                    }
                    //return to origin
                    backAnimX.start()
                }
            }

        }

        SpringAnimation {
            id: showOptionsAnim;
            target: topComponent;
            property: "x";
            duration: 500;
            spring: 2;
            damping: 0.2
            to: topComponent.height * - 3
        }
        SpringAnimation {
            id: backAnimX;
            target: topComponent;
            property: "x";
            duration: 500;
            spring: 2;
            damping: 0.2
        }
    }

    Item{
        id:bottomComponents
        anchors.fill: parent

        Rectangle{
            id:readCheck
            anchors{
                left: parent.left
                top: parent.top
                bottom: parent.bottom
            }
            width: height
            color: "blue"
        }

        Row{
            anchors{
                right: parent.right
                top: parent.top
                bottom: parent.bottom
            }
            width: height * 3
            spacing: 0


            Rectangle{
                id:options
                color: "yellow"
                height: parent.height
                width: height
                Text {
                    anchors.centerIn: parent
                    text: "Options"
                }

                MouseArea{
                    anchors.fill: parent
                    onClicked: {
                        root.moreOptions()
                        backAnimX.to = 0
                        backAnimX.start()
                    }
                }
            }

            Rectangle{
                id:archive
                color: "orange"
                height: parent.height
                width: height
                Text {
                    anchors.centerIn: parent
                    text: "Archive"
                }

                MouseArea{
                    anchors.fill: parent
                    onClicked: {
                        root.archiveEntry()
                        backAnimX.to = 0
                        backAnimX.start()
                    }
                }
            }

            Rectangle{
                id:del
                color: "red"
                height: parent.height
                width: height
                Text {
                    anchors.centerIn: parent
                    text: "Delete"
                }
                MouseArea{
                    anchors.fill: parent
                    onClicked: {
                        root.deleteEntry()
                        backAnimX.to = 0
                        backAnimX.start()
                    }
                }
            }
        }
    }
}
