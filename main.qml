import QtQuick 2.15
import QtQuick.Window 2.15

Window {
    id:root
    width: 640
    height: 480
    visible: true
    title: qsTr("Hello World")

    ListModel{
        id:lModel
        ListElement{
            isRead: false
            sender: "Spam1"
        }
        ListElement{
            isRead: true
            sender: "Spam2"
        }
        ListElement{
            isRead: false
            sender: "Spam3"
        }
        ListElement{
            isRead: false
            sender: "Spam4"
        }
    }

    ListView{
        anchors.fill:parent
        model: lModel
        delegate: RecyclerView{
            width: root.width
            height:  50

            onDeleteEntry: {
                console.log("Delete entry")
                lModel.remove(index)
            }

            read: isRead
            fromSender: sender

            onArchiveEntry: console.log("Archive entry")
            onMoreOptions: console.log("More options")
            onSwitchChecked: isRead = !isRead
        }
    }
}
