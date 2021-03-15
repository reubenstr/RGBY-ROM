/*
	RGBY-ROM Assembler
	Reuben Strangelove
	03/19/2019
	
	Visual assembler for RGBY-ROM assembly code programs.
	
	Project details: https://github.com/reubenstr/RGBY-ROM
*/

#include "mainwindow.h"
#include <QApplication>

int main(int argc, char *argv[])
{
    QApplication a(argc, argv);
    MainWindow w;
    w.show();

    return a.exec();
}
