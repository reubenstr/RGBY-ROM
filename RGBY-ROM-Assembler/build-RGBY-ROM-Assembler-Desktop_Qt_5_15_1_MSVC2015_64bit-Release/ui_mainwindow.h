/********************************************************************************
** Form generated from reading UI file 'mainwindow.ui'
**
** Created by: Qt User Interface Compiler version 5.15.1
**
** WARNING! All changes made in this file will be lost when recompiling UI file!
********************************************************************************/

#ifndef UI_MAINWINDOW_H
#define UI_MAINWINDOW_H

#include <QtCore/QVariant>
#include <QtGui/QIcon>
#include <QtWidgets/QApplication>
#include <QtWidgets/QCheckBox>
#include <QtWidgets/QHeaderView>
#include <QtWidgets/QLabel>
#include <QtWidgets/QMainWindow>
#include <QtWidgets/QMenuBar>
#include <QtWidgets/QPlainTextEdit>
#include <QtWidgets/QPushButton>
#include <QtWidgets/QStatusBar>
#include <QtWidgets/QTableView>
#include <QtWidgets/QWidget>
#include "codeeditor.h"
#include "renderarea.h"

QT_BEGIN_NAMESPACE

class Ui_MainWindow
{
public:
    QWidget *centralWidget;
    QTableView *tableView_instructions;
    QTableView *tableView_registers;
    QLabel *label_2;
    QLabel *label_3;
    QPushButton *pushButton_save;
    QPushButton *pushButton_load;
    CodeEditor *plainTextEdit_program;
    QPushButton *pushButton_save_as;
    QPlainTextEdit *plainTextEdit_assembled;
    QLabel *label_4;
    RenderArea *widget;
    QLabel *label_434;
    QLabel *label_6;
    QLabel *label_maxPerRows;
    QLabel *label_maxPerRom;
    QLabel *label_11;
    QLabel *label_totalLines;
    QLabel *label_13;
    QLabel *label_totalIntructions;
    QLabel *label_43;
    QLabel *label_maxIntructions;
    QLabel *label_54;
    QLabel *label_maxNibs;
    QLabel *label_19;
    QLabel *label_totalNibs;
    QLabel *label_perInstruction;
    QLabel *label_20;
    QLabel *label_5;
    QTableView *tableView_errorColors;
    QLabel *label_7;
    QPushButton *pushButton_generateSpecialFiles;
    QLabel *label_codeStatus;
    QLabel *label_8;
    QLabel *label_9;
    QLabel *label_10;
    QPushButton *pushButton_selectSaveFolder;
    QCheckBox *checkBox;
    QStatusBar *statusBar;
    QMenuBar *menuBar;

    void setupUi(QMainWindow *MainWindow)
    {
        if (MainWindow->objectName().isEmpty())
            MainWindow->setObjectName(QString::fromUtf8("MainWindow"));
        MainWindow->resize(1597, 1156);
        QIcon icon;
        icon.addFile(QString::fromUtf8("../build-RGB-Assembler-Desktop_Qt_5_12_1_MinGW_64_bit-Release/release/appicon.png"), QSize(), QIcon::Normal, QIcon::Off);
        MainWindow->setWindowIcon(icon);
        MainWindow->setIconSize(QSize(32, 32));
        centralWidget = new QWidget(MainWindow);
        centralWidget->setObjectName(QString::fromUtf8("centralWidget"));
        tableView_instructions = new QTableView(centralWidget);
        tableView_instructions->setObjectName(QString::fromUtf8("tableView_instructions"));
        tableView_instructions->setGeometry(QRect(640, 29, 531, 451));
        tableView_registers = new QTableView(centralWidget);
        tableView_registers->setObjectName(QString::fromUtf8("tableView_registers"));
        tableView_registers->setGeometry(QRect(640, 509, 531, 451));
        label_2 = new QLabel(centralWidget);
        label_2->setObjectName(QString::fromUtf8("label_2"));
        label_2->setGeometry(QRect(640, 9, 111, 16));
        label_3 = new QLabel(centralWidget);
        label_3->setObjectName(QString::fromUtf8("label_3"));
        label_3->setGeometry(QRect(640, 489, 111, 16));
        pushButton_save = new QPushButton(centralWidget);
        pushButton_save->setObjectName(QString::fromUtf8("pushButton_save"));
        pushButton_save->setGeometry(QRect(50, 1030, 93, 28));
        pushButton_load = new QPushButton(centralWidget);
        pushButton_load->setObjectName(QString::fromUtf8("pushButton_load"));
        pushButton_load->setGeometry(QRect(290, 1030, 93, 28));
        plainTextEdit_program = new CodeEditor(centralWidget);
        plainTextEdit_program->setObjectName(QString::fromUtf8("plainTextEdit_program"));
        plainTextEdit_program->setGeometry(QRect(10, 29, 441, 991));
        plainTextEdit_program->setLineWrapMode(QPlainTextEdit::NoWrap);
        pushButton_save_as = new QPushButton(centralWidget);
        pushButton_save_as->setObjectName(QString::fromUtf8("pushButton_save_as"));
        pushButton_save_as->setGeometry(QRect(170, 1030, 93, 28));
        plainTextEdit_assembled = new QPlainTextEdit(centralWidget);
        plainTextEdit_assembled->setObjectName(QString::fromUtf8("plainTextEdit_assembled"));
        plainTextEdit_assembled->setGeometry(QRect(460, 280, 171, 201));
        label_4 = new QLabel(centralWidget);
        label_4->setObjectName(QString::fromUtf8("label_4"));
        label_4->setGeometry(QRect(460, 260, 191, 16));
        widget = new RenderArea(centralWidget);
        widget->setObjectName(QString::fromUtf8("widget"));
        widget->setEnabled(true);
        widget->setGeometry(QRect(1180, 39, 401, 1061));
        QSizePolicy sizePolicy(QSizePolicy::Ignored, QSizePolicy::Ignored);
        sizePolicy.setHorizontalStretch(0);
        sizePolicy.setVerticalStretch(0);
        sizePolicy.setHeightForWidth(widget->sizePolicy().hasHeightForWidth());
        widget->setSizePolicy(sizePolicy);
        label_434 = new QLabel(centralWidget);
        label_434->setObjectName(QString::fromUtf8("label_434"));
        label_434->setGeometry(QRect(470, 39, 121, 16));
        label_434->setAlignment(Qt::AlignRight|Qt::AlignTrailing|Qt::AlignVCenter);
        label_6 = new QLabel(centralWidget);
        label_6->setObjectName(QString::fromUtf8("label_6"));
        label_6->setGeometry(QRect(460, 59, 131, 16));
        label_6->setAlignment(Qt::AlignRight|Qt::AlignTrailing|Qt::AlignVCenter);
        label_maxPerRows = new QLabel(centralWidget);
        label_maxPerRows->setObjectName(QString::fromUtf8("label_maxPerRows"));
        label_maxPerRows->setGeometry(QRect(600, 39, 51, 16));
        label_maxPerRom = new QLabel(centralWidget);
        label_maxPerRom->setObjectName(QString::fromUtf8("label_maxPerRom"));
        label_maxPerRom->setGeometry(QRect(600, 59, 51, 16));
        label_11 = new QLabel(centralWidget);
        label_11->setObjectName(QString::fromUtf8("label_11"));
        label_11->setGeometry(QRect(460, 159, 131, 16));
        label_11->setAlignment(Qt::AlignRight|Qt::AlignTrailing|Qt::AlignVCenter);
        label_totalLines = new QLabel(centralWidget);
        label_totalLines->setObjectName(QString::fromUtf8("label_totalLines"));
        label_totalLines->setGeometry(QRect(600, 159, 51, 16));
        label_13 = new QLabel(centralWidget);
        label_13->setObjectName(QString::fromUtf8("label_13"));
        label_13->setGeometry(QRect(460, 179, 131, 16));
        label_13->setAlignment(Qt::AlignRight|Qt::AlignTrailing|Qt::AlignVCenter);
        label_totalIntructions = new QLabel(centralWidget);
        label_totalIntructions->setObjectName(QString::fromUtf8("label_totalIntructions"));
        label_totalIntructions->setGeometry(QRect(600, 179, 51, 16));
        label_43 = new QLabel(centralWidget);
        label_43->setObjectName(QString::fromUtf8("label_43"));
        label_43->setGeometry(QRect(460, 119, 131, 16));
        label_43->setAlignment(Qt::AlignRight|Qt::AlignTrailing|Qt::AlignVCenter);
        label_maxIntructions = new QLabel(centralWidget);
        label_maxIntructions->setObjectName(QString::fromUtf8("label_maxIntructions"));
        label_maxIntructions->setGeometry(QRect(600, 119, 51, 16));
        label_54 = new QLabel(centralWidget);
        label_54->setObjectName(QString::fromUtf8("label_54"));
        label_54->setGeometry(QRect(460, 79, 131, 16));
        label_54->setAlignment(Qt::AlignRight|Qt::AlignTrailing|Qt::AlignVCenter);
        label_maxNibs = new QLabel(centralWidget);
        label_maxNibs->setObjectName(QString::fromUtf8("label_maxNibs"));
        label_maxNibs->setGeometry(QRect(600, 79, 51, 16));
        label_19 = new QLabel(centralWidget);
        label_19->setObjectName(QString::fromUtf8("label_19"));
        label_19->setGeometry(QRect(460, 199, 131, 16));
        label_19->setAlignment(Qt::AlignRight|Qt::AlignTrailing|Qt::AlignVCenter);
        label_totalNibs = new QLabel(centralWidget);
        label_totalNibs->setObjectName(QString::fromUtf8("label_totalNibs"));
        label_totalNibs->setGeometry(QRect(600, 199, 51, 16));
        label_perInstruction = new QLabel(centralWidget);
        label_perInstruction->setObjectName(QString::fromUtf8("label_perInstruction"));
        label_perInstruction->setGeometry(QRect(600, 99, 51, 16));
        label_20 = new QLabel(centralWidget);
        label_20->setObjectName(QString::fromUtf8("label_20"));
        label_20->setGeometry(QRect(460, 99, 131, 16));
        label_20->setAlignment(Qt::AlignRight|Qt::AlignTrailing|Qt::AlignVCenter);
        label_5 = new QLabel(centralWidget);
        label_5->setObjectName(QString::fromUtf8("label_5"));
        label_5->setGeometry(QRect(1180, 19, 111, 16));
        tableView_errorColors = new QTableView(centralWidget);
        tableView_errorColors->setObjectName(QString::fromUtf8("tableView_errorColors"));
        tableView_errorColors->setGeometry(QRect(460, 510, 171, 151));
        label_7 = new QLabel(centralWidget);
        label_7->setObjectName(QString::fromUtf8("label_7"));
        label_7->setGeometry(QRect(460, 490, 161, 16));
        pushButton_generateSpecialFiles = new QPushButton(centralWidget);
        pushButton_generateSpecialFiles->setObjectName(QString::fromUtf8("pushButton_generateSpecialFiles"));
        pushButton_generateSpecialFiles->setGeometry(QRect(460, 750, 171, 28));
        label_codeStatus = new QLabel(centralWidget);
        label_codeStatus->setObjectName(QString::fromUtf8("label_codeStatus"));
        label_codeStatus->setGeometry(QRect(460, 721, 171, 20));
        label_codeStatus->setAlignment(Qt::AlignCenter);
        label_8 = new QLabel(centralWidget);
        label_8->setObjectName(QString::fromUtf8("label_8"));
        label_8->setGeometry(QRect(10, 10, 81, 16));
        label_9 = new QLabel(centralWidget);
        label_9->setObjectName(QString::fromUtf8("label_9"));
        label_9->setGeometry(QRect(370, 10, 81, 16));
        label_10 = new QLabel(centralWidget);
        label_10->setObjectName(QString::fromUtf8("label_10"));
        label_10->setGeometry(QRect(170, 10, 111, 16));
        pushButton_selectSaveFolder = new QPushButton(centralWidget);
        pushButton_selectSaveFolder->setObjectName(QString::fromUtf8("pushButton_selectSaveFolder"));
        pushButton_selectSaveFolder->setGeometry(QRect(460, 790, 171, 28));
        checkBox = new QCheckBox(centralWidget);
        checkBox->setObjectName(QString::fromUtf8("checkBox"));
        checkBox->setGeometry(QRect(1040, 990, 131, 20));
        MainWindow->setCentralWidget(centralWidget);
        statusBar = new QStatusBar(MainWindow);
        statusBar->setObjectName(QString::fromUtf8("statusBar"));
        MainWindow->setStatusBar(statusBar);
        menuBar = new QMenuBar(MainWindow);
        menuBar->setObjectName(QString::fromUtf8("menuBar"));
        menuBar->setGeometry(QRect(0, 0, 1597, 26));
        MainWindow->setMenuBar(menuBar);

        retranslateUi(MainWindow);

        QMetaObject::connectSlotsByName(MainWindow);
    } // setupUi

    void retranslateUi(QMainWindow *MainWindow)
    {
        MainWindow->setWindowTitle(QCoreApplication::translate("MainWindow", "RGBY-ROM Assembler", nullptr));
        label_2->setText(QCoreApplication::translate("MainWindow", "Instructions", nullptr));
        label_3->setText(QCoreApplication::translate("MainWindow", "Registers", nullptr));
        pushButton_save->setText(QCoreApplication::translate("MainWindow", "Save", nullptr));
        pushButton_load->setText(QCoreApplication::translate("MainWindow", "Load", nullptr));
        pushButton_save_as->setText(QCoreApplication::translate("MainWindow", "Save As", nullptr));
        label_4->setText(QCoreApplication::translate("MainWindow", "Assembled Program as Hex", nullptr));
        label_434->setText(QCoreApplication::translate("MainWindow", "Max Nits Per Row:", nullptr));
        label_6->setText(QCoreApplication::translate("MainWindow", "Max Lines per ROM:", nullptr));
        label_maxPerRows->setText(QCoreApplication::translate("MainWindow", "000", nullptr));
        label_maxPerRom->setText(QCoreApplication::translate("MainWindow", "000", nullptr));
        label_11->setText(QCoreApplication::translate("MainWindow", "Lines:", nullptr));
        label_totalLines->setText(QCoreApplication::translate("MainWindow", "000", nullptr));
        label_13->setText(QCoreApplication::translate("MainWindow", "Instructions:", nullptr));
        label_totalIntructions->setText(QCoreApplication::translate("MainWindow", "000", nullptr));
        label_43->setText(QCoreApplication::translate("MainWindow", "Max Instructions :", nullptr));
        label_maxIntructions->setText(QCoreApplication::translate("MainWindow", "000", nullptr));
        label_54->setText(QCoreApplication::translate("MainWindow", "Max Nits:", nullptr));
        label_maxNibs->setText(QCoreApplication::translate("MainWindow", "000", nullptr));
        label_19->setText(QCoreApplication::translate("MainWindow", "Nits:", nullptr));
        label_totalNibs->setText(QCoreApplication::translate("MainWindow", "000", nullptr));
        label_perInstruction->setText(QCoreApplication::translate("MainWindow", "000", nullptr));
        label_20->setText(QCoreApplication::translate("MainWindow", "Nits Per Instruction:", nullptr));
        label_5->setText(QCoreApplication::translate("MainWindow", "RGBYROM", nullptr));
        label_7->setText(QCoreApplication::translate("MainWindow", "Highlighted Errors Legend", nullptr));
        pushButton_generateSpecialFiles->setText(QCoreApplication::translate("MainWindow", "Generate Special Files", nullptr));
        label_codeStatus->setText(QCoreApplication::translate("MainWindow", "Status", nullptr));
        label_8->setText(QCoreApplication::translate("MainWindow", "Intruction No.", nullptr));
        label_9->setText(QCoreApplication::translate("MainWindow", "Jump Address", nullptr));
        label_10->setText(QCoreApplication::translate("MainWindow", "Program Code", nullptr));
        pushButton_selectSaveFolder->setText(QCoreApplication::translate("MainWindow", "Select Save Folder", nullptr));
        checkBox->setText(QCoreApplication::translate("MainWindow", "Mirror RGBYROM", nullptr));
    } // retranslateUi

};

namespace Ui {
    class MainWindow: public Ui_MainWindow {};
} // namespace Ui

QT_END_NAMESPACE

#endif // UI_MAINWINDOW_H
