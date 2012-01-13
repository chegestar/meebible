#include <QApplication>
#include <QPushButton>
#include <QDebug>

#include <cstdio>
void myMessageOutput(QtMsgType type, const char *msg)
{
    FILE *f = fopen("c:\\qttest2.txt", "a");
    switch (type)
    {
        case QtDebugMsg:    fprintf(f, "debug> %s\n", msg); break;
        case QtWarningMsg:  fprintf(f, "warn > %s\n", msg); break;
        case QtCriticalMsg: fprintf(f, "crit > %s\n", msg); break;
        case QtFatalMsg:    fprintf(f, "fatal> %s\n", msg); abort(); break;
    }
    fclose(f);
}


int main(int argc, char *argv[])
{
    qInstallMsgHandler(myMessageOutput);
    qDebug() << "start";

    QApplication app(argc, argv);

    QPushButton button("Click me");
    QObject::connect(&button, SIGNAL(clicked()), &app, SLOT(quit()));
    button.showFullScreen();

    int ret = app.exec();
    qDebug() << "stop";
    return ret;
}
