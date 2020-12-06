#include "mainwindow.h"
#include "ui_mainwindow.h"
#include "codeeditor.h"
#include "highlighter.h"
#include "renderarea.h"

#include "QTimer"
#include "QFile"
#include "QDebug"
#include "QStandardItemModel"
#include "QTextCursor"
#include "QTextBlock"
#include "QFileDialog"
#include "QSettings"
#include "QShortcut"
#include "QMessageBox"
#include "QDateTime"


MainWindow::MainWindow(QWidget *parent) :
    QMainWindow(parent),
    ui(new Ui::MainWindow)
{
    ui->setupUi(this);

    // parse code timer
    timer = new QTimer(this);
    connect(timer, SIGNAL(timeout()), this, SLOT(parseSourceCode()));
    timer->start(100);

    // UI update timer
    timerUi = new QTimer(this);
    connect(timerUi, SIGNAL(timeout()), this, SLOT(updateUi()));
    timerUi->start(100);

    // read instructions and registers from the CSV
    if (!readCsv())
    {
        exit(1);
    }

    // setup instructions table
    QStandardItemModel *model_errorColors;
    model_errorColors = new QStandardItemModel(0,1,this);
    ui->tableView_errorColors->setModel(model_errorColors);
    model_errorColors->setHeaderData(0, Qt::Horizontal, QObject::tr("Error / Color"));
    ui->tableView_errorColors->verticalHeader()->setVisible(false);
    ui->tableView_errorColors->setStyleSheet("QHeaderView::section { background-color: lightgrey}");
    ui->tableView_errorColors->setSelectionMode(QAbstractItemView::NoSelection);
    ui->tableView_errorColors->setEditTriggers(QAbstractItemView::NoEditTriggers);
    ui->tableView_errorColors->horizontalHeader()->setStretchLastSection(true);

    QStandardItem *a = new QStandardItem("Unknown parameter");
    a->setBackground(QBrush(ERROR_STRING_COLOR));
    model_errorColors->appendRow(a);
    QStandardItem *b = new QStandardItem("Label not found");
    b->setBackground(QBrush(ERROR_LABEL_NOT_FOUND_COLOR));
    model_errorColors->appendRow(b);
    QStandardItem *c = new QStandardItem("Duplicate label");
    c->setBackground(QBrush(ERROR_DUPLICATE_LABEL_COLOR));
    model_errorColors->appendRow(c);


    // setup instructions table
    QStandardItemModel *model_instructions;
    model_instructions = new QStandardItemModel(0,7,this);
    ui->tableView_instructions->setModel(model_instructions);
    model_instructions->setHeaderData(0, Qt::Horizontal, QObject::tr("Mnemonic"));
    model_instructions->setHeaderData(1, Qt::Horizontal, QObject::tr("Name"));
    model_instructions->setHeaderData(2, Qt::Horizontal, QObject::tr("Type"));
    model_instructions->setHeaderData(3, Qt::Horizontal, QObject::tr("Hex"));
    model_instructions->setHeaderData(4, Qt::Horizontal, QObject::tr("Binary"));
    model_instructions->setHeaderData(5, Qt::Horizontal, QObject::tr("A"));
    model_instructions->setHeaderData(6, Qt::Horizontal, QObject::tr("B"));
    ui->tableView_instructions->setColumnWidth(0, 80);
    ui->tableView_instructions->setColumnWidth(1, 170);
    ui->tableView_instructions->setColumnWidth(2, 80);
    ui->tableView_instructions->setColumnWidth(3, 30);
    ui->tableView_instructions->setColumnWidth(4, 50);
    ui->tableView_instructions->setColumnWidth(5, 10);
    ui->tableView_instructions->setColumnWidth(6, 10);
    ui->tableView_instructions->verticalHeader()->setVisible(false);
    ui->tableView_instructions->setStyleSheet("QHeaderView::section { background-color: lightgrey}");
    ui->tableView_instructions->setSelectionMode(QAbstractItemView::NoSelection);
    ui->tableView_instructions->verticalHeader()->setDefaultSectionSize(10);
    ui->tableView_instructions->setEditTriggers(QAbstractItemView::NoEditTriggers);


    for(int row = 0; row < instructions.length(); row++)
    {
        QList<QStandardItem*> rowData;
        //rowData.clear();
        rowData << new QStandardItem(instructions.at(row).mnemonic);
        rowData << new QStandardItem(instructions.at(row).name);
        rowData << new QStandardItem(instructions.at(row).type);
        rowData << new QStandardItem(instructions.at(row).hex);
        rowData << new QStandardItem(instructions.at(row).binary);
        bool ok = false;
        QStandardItem *a = new QStandardItem(" ");
        a->setBackground(QBrush(ui->widget->getColorFromDec(registers.at(row).hex.toUInt(&ok,16) >> 2)));
        rowData <<  a;
        QStandardItem *b = new QStandardItem(" ");
        b->setBackground(QBrush(ui->widget->getColorFromDec(registers.at(row).hex.toUInt(&ok,16) & 0x03)));
        rowData <<  b;
        model_instructions->appendRow(rowData);
    }

    // setup register table
    QStandardItemModel *model_registers;
    model_registers = new QStandardItemModel(0,7,this);
    ui->tableView_registers->setModel(model_registers);
    model_registers->setHeaderData(0, Qt::Horizontal, QObject::tr("Mnemonic"));
    model_registers->setHeaderData(1, Qt::Horizontal, QObject::tr("Name"));
    model_registers->setHeaderData(2, Qt::Horizontal, QObject::tr("Type"));
    model_registers->setHeaderData(3, Qt::Horizontal, QObject::tr("Hex"));
    model_registers->setHeaderData(4, Qt::Horizontal, QObject::tr("Binary"));
    model_registers->setHeaderData(5, Qt::Horizontal, QObject::tr("A"));
    model_registers->setHeaderData(6, Qt::Horizontal, QObject::tr("B"));
    ui->tableView_registers->setColumnWidth(0, 80);
    ui->tableView_registers->setColumnWidth(1, 170);
    ui->tableView_registers->setColumnWidth(2, 80);
    ui->tableView_registers->setColumnWidth(3, 30);
    ui->tableView_registers->setColumnWidth(4, 50);
    ui->tableView_registers->setColumnWidth(5, 10);
    ui->tableView_registers->setColumnWidth(6, 10);
    ui->tableView_registers->verticalHeader()->setVisible(false);
    ui->tableView_registers->setStyleSheet("QHeaderView::section { background-color: lightgrey}");
    ui->tableView_registers->setSelectionMode(QAbstractItemView::NoSelection);
    ui->tableView_registers->verticalHeader()->setDefaultSectionSize(10);
    ui->tableView_registers->setEditTriggers(QAbstractItemView::NoEditTriggers);

    for(int row = 0; row < registers.length(); row++)
    {
        QList<QStandardItem*> rowData;
        //rowData.clear();
        rowData << new QStandardItem(registers.at(row).mnemonic);
        rowData << new QStandardItem(registers.at(row).name);
        rowData << new QStandardItem(registers.at(row).type);
        rowData << new QStandardItem(registers.at(row).hex);
        rowData << new QStandardItem(registers.at(row).binary);
        bool ok = false;
        QStandardItem *a = new QStandardItem(" ");
        a->setBackground(QBrush(ui->widget->getColorFromDec(registers.at(row).hex.toUInt(&ok,16) >> 2)));
        rowData <<  a;
        QStandardItem *b = new QStandardItem(" ");
        b->setBackground(QBrush(ui->widget->getColorFromDec(registers.at(row).hex.toUInt(&ok,16) & 0x03)));
        rowData <<  b;
        model_registers->appendRow(rowData);
    }

    // open last loaded file
    QSettings appSettings("RGBY-ROM Assembler", "RGBY-ROM Assembler");
    filename = appSettings.value("filename").toString();
    openFile(filename);

    // setup text paramters of text area
    QFont font;
    font.setFamily("Courier");
    font.setFixedPitch(true);
    font.setPointSize(12);
    ui->plainTextEdit_program->setFont(font);

    // add custom highlighter to text area
    Highlighter *highlighter;
    highlighter = new Highlighter(ui->plainTextEdit_program->document());

    // init the highlighter and add instructions and registers
    QStringList instructionKeywords, registerKeywords;
    for (int i = 0; i < instructions.length(); i++)
        instructionKeywords << tr("\\b%1\\b").arg(instructions.at(i).mnemonic);
    for (int i = 0; i < registers.length(); i++)
        registerKeywords << tr("\\b%1\\b").arg(registers.at(i).mnemonic);
    highlighter->setRules(instructionKeywords, registerKeywords);

    // keyboard shortcuts
    new QShortcut(QKeySequence(Qt::CTRL + Qt::Key_S), this, SLOT(on_pushButton_save_clicked()));
    new QShortcut(QKeySequence(Qt::CTRL + Qt::Key_Z), this, SLOT(undo()));

    ui->plainTextEdit_program->setUndoRedoEnabled(true);
}

MainWindow::~MainWindow()
{
    delete ui;
}

void MainWindow::undo()
{
    ui->plainTextEdit_program->undo();

    qDebug() << "undo;";
}

void MainWindow::updateUi()
{
    ui->widget->repaint();

    if (filename.isEmpty()) ui->statusBar->showMessage("Working File: none");
    else  ui->statusBar->showMessage(tr("Working File: %1").arg(filename));

    ui->label_maxPerRows->setText(QString::number(NIBS_PER_ROW));
    ui->label_maxPerRom->setText(QString::number(LINES_PER_ROM));
    ui->label_maxNibs->setText(QString::number(NIBS_PER_ROW * LINES_PER_ROM));
    ui->label_perInstruction->setText(QString::number(NIBS_PER_INSTRUCTION));
    ui->label_maxIntructions->setText(QString::number(MAX_INSTRUCTIONS));

    // 4 = bits per hex
    int totalLines = hexSource.length() * 4 / (NIBS_PER_ROW * BITS_PER_NIB);
    if ((hexSource.length() * 4) % (NIBS_PER_ROW * BITS_PER_NIB)) totalLines++;

    ui->label_totalLines->setText(QString::number(totalLines));
    ui->label_totalIntructions->setText(QString::number(hexSource.length() * 4 /*bits per hex*/ / BITS_PER_INSTRUCTION));

    int totalNibs = hexSource.length() * 4 /*bits per hex*/ / BITS_PER_NIB;
    ui->label_totalNibs->setText(QString::number(totalNibs));

    if (totalNibs > NIBS_PER_ROW * LINES_PER_ROM)
    ui->label_totalNibs->setStyleSheet("QLabel { background-color : red; color : black; }");
    else
    ui->label_totalNibs->setStyleSheet("QLabel { background-color : green; color : black; }");

    if (linesWithErrors == 0)
    {
        ui->label_codeStatus->setStyleSheet("QLabel {background-color : green; font : bold 16px; color : white}");
        ui->label_codeStatus->setText("Ready!");
    } else {
        ui->label_codeStatus->setStyleSheet("QLabel {background-color : red; font : bold 16px; color : black}");
        ui->label_codeStatus->setText("Error!");
    }
}


void MainWindow::parseSourceCode()
{
    // reset assembled code data
    hexSource = "";
    ui->plainTextEdit_program->lineOfCodeToInstructionNumber.clear();
    ui->plainTextEdit_program->jumpAbsoluteAddress.clear();
    linesWithErrors = 0;

    // get text, split by new lines for iteration
    QString plainTextEditContents = ui->plainTextEdit_program->toPlainText();
    QStringList lines = plainTextEditContents.split("\n");

    // make a copy of the cursor, move it to the begining of the text
    QTextCursor cursor = ui->plainTextEdit_program->textCursor();
    cursor.movePosition(QTextCursor::Start);

    // parse each line, returns either an error code or assembled hex
    int instructionNumber = 0;
    for (int i = 0; i < lines.length(); i++)
    {

        QString checkRet = parseLine(lines.at(i), i);
        QTextBlockFormat format;

        if (checkRet == ERROR_STRING)
        {
            format.setBackground(ERROR_STRING_COLOR);
            linesWithErrors++;
        }
        else if (checkRet == ERROR_DUPLICATE_LABEL)
        {
            format.setBackground(ERROR_DUPLICATE_LABEL_COLOR);
            linesWithErrors++;
        }
        else if (checkRet == ERROR_LABEL_NOT_FOUND)
        {
            format.setBackground(ERROR_LABEL_NOT_FOUND_COLOR);
            linesWithErrors++;
        } else {

            format.setBackground(EMPTY_STRING_COLOR); // clear error colors

            if (checkRet != EMPTY_STRING)
            {
                // add assembled line to master hexSource
                hexSource.append(checkRet);

                // add instruction number for later render
                ui->plainTextEdit_program->lineOfCodeToInstructionNumber.insert(i, instructionNumber);
                instructionNumber++;
            }
        }

        cursor.setBlockFormat(format);
        cursor.movePosition(QTextCursor::Down, QTextCursor::MoveAnchor, 1);

    }

    // update source code textbox display
    if (ui->plainTextEdit_assembled->hasFocus() == false)
    {
        ui->plainTextEdit_assembled->clear();
        ui->plainTextEdit_assembled->appendPlainText(hexSource);
    }

    // update renderArea with new source code
    ui->widget->setRomData(hexSource);
}


QString MainWindow::parseLine(QString line, int lineNum)
{
    QString hexString = "";
    QString instructionType;
    QString instruction;
    QString instructionHex;
    QString regA;
    QString regB;

    // strip comments
    if  (line.contains('#')) line = line.split('#').at(0);

    // check for blank line
    if (line == "") return EMPTY_STRING;

    // check if line is a label, check for errors
    if (line.split(':').length() == 2 && line.split(':').at(0) == 'L')
    {
        QString offset = findLabelLine(line);
        if (offset == ERROR_DUPLICATE_LABEL) return ERROR_DUPLICATE_LABEL;
        if (offset == ERROR_LABEL_NOT_FOUND) return ERROR_LABEL_NOT_FOUND;
        return EMPTY_STRING;
    }

    int splitCount = line.split(',').length();
    instruction = line.split(',').at(0).simplified();
    instructionType = "false";

    // search for instruction match
    for(int i = 0; i < instructions.length(); i++)
    {
        if (instructions.at(i).mnemonic == instruction)
        {
            instructionType = instructions.at(i).type;
            instructionHex = instructions.at(i).hex;
        }
    }

    // parse instruction by instruction type
    if (instructionType == "register")
    {
        if (splitCount != 3) return ERROR_STRING;

        // get hex value of registers if exists
        regA = getRegisterHex(line.split(',').at(1).simplified());
        regB = getRegisterHex(line.split(',').at(2).simplified());

        if (regA == ERROR_STRING || regB == ERROR_STRING)  return ERROR_STRING;

        // append instruction
        hexString.append(instructionHex);
        hexString.append(regA);
        hexString.append(regB);

    }
    else if (instructionType == "immediate")
    {
        if (splitCount != 2) return ERROR_STRING;

        // check if parameter is an immediate and is a number that falls within range
        bool ok;
        int dec = line.split(',').at(1).simplified().toInt(&ok, 10);
        if (ok == false) return ERROR_STRING;
        if (dec < 0 || dec > 255) return ERROR_STRING;

        // append instruction
        hexString.append(instructionHex);
        hexString.append(QString("%1").arg(dec, 2, 16, QChar('0')).toUpper());

    }
    else if (instructionType == "jump")
    {

        if (splitCount != 2) return ERROR_STRING;

        // capture expected label
        QString label = line.split(',').at(1).simplified();

        // check for valid label
        if (label.split(':').length() != 2 && label.split(':').at(0) != 'L')  return ERROR_STRING;

        // get offset, check for error
        QString labelLine = findLabelLine(label);
        if (labelLine == ERROR_DUPLICATE_LABEL) return ERROR_DUPLICATE_LABEL;
        if (labelLine == ERROR_LABEL_NOT_FOUND) return ERROR_LABEL_NOT_FOUND;

        // convert label line number to relative offset
        bool ok;
        int offset = labelLine.toInt(&ok,10); // - lineNum; // use absolute value

        // store offset for displaying offset in plaintextedit
        ui->plainTextEdit_program->jumpAbsoluteAddress.insert(lineNum, offset);

        // append instruction
        hexString.append(instructionHex);
        hexString.append(QString("%1").arg(QString::number(offset).toInt(), 2, 16, QChar('0')).toUpper()); // convert to hex with leading zeros

    }
    else
    {
        return ERROR_STRING;
    }

    return hexString;
}


// find the instruction number the label points
QString MainWindow::findLabelLine(QString label)
{
    // get text, split by new lines for iteration
    QString plainTextEditContents = ui->plainTextEdit_program->toPlainText();
    QStringList lines = plainTextEditContents.split("\n");

    // find label destination in program
    int lineNum = 0;
    int labelFoundFlag = false;
    int instructionNumber = 0;
    for (int i = 0; i < lines.length(); i++)
    {
        QString line = lines.at(i);

        // strip comments
        if  (line.contains('#')) line = line.split('#').at(0);

        // check for blank line
        if (line == "") continue;

        // check the line for the label of interest
        if (line.simplified() == label)
        {
            if (labelFoundFlag) return ERROR_DUPLICATE_LABEL;
            labelFoundFlag = true;
            lineNum = instructionNumber;
        }
        else
        {
            // check if line is a label
            if (line.split(':').length() == 2 && line.split(':').at(0) == 'L') continue;

            // only increment on actual  instructions
            instructionNumber++;
        }
    }

    if (labelFoundFlag == false) return ERROR_LABEL_NOT_FOUND;
    return QString::number(lineNum);
}


QString MainWindow::getRegisterHex(QString reg)
{
    // search for register match
    for(int i = 0; i < registers.length(); i++)
    {
        if (registers.at(i).mnemonic == reg) return registers.at(i).hex;
    }

    return ERROR_STRING;
}


bool MainWindow::readCsv()
{
    int index = 0;
    bool ok;
    CpuObject objectToAppend;
    int instructionCount = 0;
    int registerCount = 0;

    QFile file(regFileName);
    if (!file.open(QIODevice::ReadOnly))
    {
        qDebug() << file.errorString();

        QMessageBox msgBox;
        msgBox.setText("Register description file not found: " + regFileName + "\n\nFile must be placed in same directory as program executable.\n\nExecutable path: " +  QDir::currentPath());
        msgBox.exec();
        return false;
    }

    file.readLine(); // skip first row
    while (!file.atEnd())
    {
        QByteArray line = file.readLine();

        line = line.simplified(); // strip \n, \r

        if (line.split(',').length() != EXPECTED_CSV_COLS)
        {
            qDebug() << "Error: expected " << EXPECTED_CSV_COLS << " columns in CSV.";
            // TODO: exit application
            return false;
        }
        if (line.split(',').at(0) == "instruction")
        {
            objectToAppend.mnemonic = line.split(',').at(1);
            objectToAppend.name = line.split(',').at(2);
            objectToAppend.type = line.split(',').at(3);
            objectToAppend.hex = QString::number(instructionCount, 16).toUpper();
            objectToAppend.binary = QString("%1").arg(QString::number(instructionCount).toULongLong(&ok, 10), 4, 2, QChar('0'));
            instructions.append(objectToAppend);
            instructionCount++;
        } else if (line.split(',').at(0) == "register")
        {
            objectToAppend.mnemonic = line.split(',').at(1);
            objectToAppend.name = line.split(',').at(2);
            objectToAppend.type = line.split(',').at(3);
            objectToAppend.hex = QString::number(registerCount, 16).toUpper();
            objectToAppend.binary = QString("%1").arg(QString::number(registerCount).toULongLong(&ok, 10), 4, 2, QChar('0'));
            registers.append(objectToAppend);
            registerCount++;
        }
        index++;
    }

    return true;
}


void MainWindow::on_pushButton_save_clicked()
{
    if (filename == "") on_pushButton_save_as_clicked();

    saveFile(filename);
}


void MainWindow::on_pushButton_save_as_clicked()
{
    // prompt user to select file
    filename = QFileDialog::getSaveFileName(
                this,
                "Open Source Code",
                QDir::currentPath(),
                "ASM files (*.asm);; TXT files (*.txt);; All files (*.*)");

    if( !filename.isNull() )
    {
        qDebug() << "selected file path : " << filename.toUtf8();
        saveFile(filename);
    }
}


void MainWindow::on_pushButton_load_clicked()
{
    // prompt user to select file
    filename = QFileDialog::getOpenFileName(
                this,
                "Open Source Code",
                QDir::currentPath(),
                "ASM files (*.asm);; TXT files (*.txt);; All files (*.*)");

    if( !filename.isNull() )
    {
        qDebug() << "selected file path : " << filename.toUtf8();
    }

    openFile(filename);
}


void MainWindow::saveFile(QString filename)
{
    // open/create file, delete contents, and write text
    QFile outFile(filename);
    if(outFile.open(QFile::WriteOnly | QFile::Text | QIODevice::Truncate)) {
        QTextStream out(&outFile);

        QString plainTextEditContents = ui->plainTextEdit_program->toPlainText();
        QStringList lines = plainTextEditContents.split("\n");
        for (int i = 0; i < lines.length(); i++)
        {
            out << lines.at(i) << "\n";
        }

        outFile.close();

        // save file name for later use
        QSettings appSettings("RGBY-ROM Assembler", "RGBY-ROM Assembler");
        appSettings.setValue("filename", filename);
    }
}


void MainWindow::openFile(QString filename)
{
    // read file, update text in GUI
    QFile inputFile(filename);
    if (inputFile.open(QIODevice::ReadOnly))
    {

        ui->plainTextEdit_program->clear();

        QTextStream in(&inputFile);
        while (!in.atEnd())
        {
            QString line = in.readLine();
            ui->plainTextEdit_program->appendPlainText(line);
        }
        inputFile.close();
    } else {
        qDebug() << "Error: unable to open file: " << filename;
    }
}


void MainWindow::on_pushButton_selectSaveFolder_clicked()
{
    QSettings appSettings("RGBY-ROM Assembler", "RGBY-ROM Assembler");
    QString folderLocation = appSettings.value("specialFolderLocation").toString();

    QString dir = QFileDialog::getExistingDirectory(this, tr("Open Directory"),
                                                    folderLocation,
                                                    QFileDialog::ShowDirsOnly
                                                    | QFileDialog::DontResolveSymlinks);

    appSettings.setValue("specialFolderLocation", dir);
}


// Special file for FPGA source code, generates hardcoded ram of program for development purposes.
void MainWindow::on_pushButton_generateSpecialFiles_clicked()
{

    QSettings appSettings("RGBY-ROM Assembler", "RGBY-ROM Assembler");
    QString folderLocation = appSettings.value("specialFolderLocation").toString();

    qDebug() << "Saving files to folder: " + folderLocation;

    // open/create file, delete contents, and write text
    QFile outFile(QDir(folderLocation).filePath("defines.v"));
    if(outFile.open(QFile::WriteOnly | QFile::Text | QIODevice::Truncate)) {
        QTextStream out(&outFile);

        out << "// #defines used to match assembler and FPGA\n";
        out << "// instruction and registor addresses.\n";
        out <<  "\n";
        out << "// Instruction opcodes generated by RGBY-ROM Assembler\n";

        for (int i = 0; i < instructions.length(); i++)
        {
            out << "`define OPCODE_" << instructions.at(i).mnemonic.toUpper()
                << " 4'h" << instructions.at(i).hex << "\n";
        }

        out << "\n";
        out << "// Registers generated by RGBY-ROM Assembler\n";
        for (int i = 0; i < registers.length(); i++)
        {
            out << "`define REG_" << registers.at(i).mnemonic.toUpper()
                << " 4'h" << registers.at(i).hex << "\n";
        }
    }


    // open/create file, delete contents, and write text
    QFile ramOutFile(QDir(folderLocation).filePath("ramHardcoded.v"));
    if(ramOutFile.open(QFile::WriteOnly | QFile::Text | QIODevice::Truncate)) {
        QTextStream out(&ramOutFile);

        hexSource.append("0000"); // TEMP append, append real number to equal max characters

        out << "// Hard coded RAM containing program for development purposes\n";
        out << "// " + QDateTime::currentDateTime().toString(Qt::ISODate) + "\n";
        out <<  "   module ramHardcoded (din, addr, write_en, clk, dout);" << "\n";
        out <<  "   parameter addr_width = 8;" << "\n";
        out <<  "   parameter data_width = 12;" << "\n";
        out <<  "   input [addr_width-1:0] addr;" << "\n";
        out <<  "   input [data_width-1:0] din;" << "\n";
        out <<  "   input write_en, clk;" << "\n";
        out <<  "   output [data_width-1:0] dout;" << "\n";
        out <<  "   reg [data_width-1:0] mem [(1<<addr_width)-1:0];" << "\n";
        out <<  "   // Define RAM as an indexed memory array." << "\n";
        out <<  "\n";
        out <<  "   always @(posedge clk) // Control with a clock edge." << "\n";
        out <<  "     begin" << "\n";
        out <<  "       if (write_en) begin// And control with a write enable." << "\n";
        out <<  "         mem[(addr)] <= din;" << "\n";
        out <<  "     end" << "\n";
        out <<  "     end" << "\n";
        out <<  "\n";
        out << "assign dout = \n";

        int counter = 0;
        for (int i = 0; i < hexSource.length(); i = i + 3)
        {
            out << " (addr == " << counter << ") ? 12'h" << hexSource.mid(i,3) << " :\n";
            counter++;
        }
        out << "\t0;\n";
        out <<  "endmodule" << "\n";

        ramOutFile.close();
    }
}

void MainWindow::on_checkBox_clicked()
{
    ui->widget->setMirror(ui->checkBox->isChecked());
}
