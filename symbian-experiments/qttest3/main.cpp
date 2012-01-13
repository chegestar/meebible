#include <QApplication>
#include <QDeclarativeView>

int main(int argc, char *argv[])
{
    QApplication app(argc, argv);

    QDeclarativeView view;
    view.setSource(QUrl::fromLocalFile("qttest3.qml"));
    view.showFullScreen();

    return app.exec();
}
