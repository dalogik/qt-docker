#include <QCoreApplication>
#include <iostream>

int main(int argc, char *argv[])
{
    QCoreApplication app(argc, argv);

    std::cout << "Dummy App. Qt version: " << qVersion() << std::endl;

    return 0;
}
