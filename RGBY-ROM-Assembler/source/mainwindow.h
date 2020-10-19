#ifndef MAINWINDOW_H
#define MAINWINDOW_H

#include <QMainWindow>
#include <QObject>
#include <QPlainTextEdit>

#define EXPECTED_CSV_COLS 4

#define NIBS_PER_ROW 12
#define LINES_PER_ROM 36
#define BITS_PER_NIB 2
#define BITS_PER_INSTRUCTION 12
#define NIBS_PER_INSTRUCTION BITS_PER_INSTRUCTION / BITS_PER_NIB
#define MAX_INSTRUCTIONS (NIBS_PER_ROW * LINES_PER_ROM) / (BITS_PER_INSTRUCTION / BITS_PER_NIB)

#define DIV_ROUND_CLOSEST(n, d) ((((n) < 0) ^ ((d) < 0)) ? (((n) - (d)/2)/(d)) : (((n) + (d)/2)/(d)))


QT_BEGIN_NAMESPACE
class QPaintEvent;
class QResizeEvent;
class QSize;
class QWidget;
QT_END_NAMESPACE

namespace Ui {
class MainWindow;
}

class MainWindow : public QMainWindow
{
    Q_OBJECT

public:
    explicit MainWindow(QWidget *parent = nullptr);
    ~MainWindow();
    QTimer *timer;
    QTimer *timerUi;

    struct CpuObject
    {
        QString mnemonic;
        QString name;
        QString type;
        QString hex;
        QString binary;
    };

    QList<CpuObject> instructions;
    QList<CpuObject> registers;

    const QString ERROR_STRING = "error_string";
    const QString EMPTY_STRING = "empty_string";
    const QString ERROR_DUPLICATE_LABEL = "error_duplicate_label";
    const QString ERROR_LABEL_NOT_FOUND = "error_label_not_found";

    const QColor ERROR_STRING_COLOR = QColor(Qt::red).lighter(160);
    const QColor EMPTY_STRING_COLOR = QColor(Qt::white);
    const QColor ERROR_DUPLICATE_LABEL_COLOR = QColor(Qt::yellow).lighter(160);
    const QColor ERROR_LABEL_NOT_FOUND_COLOR = QColor(Qt::magenta).lighter(160);

public slots:
    void updateUi();
    void parseSourceCode();

private slots:
    void on_pushButton_load_clicked();
    void on_pushButton_save_clicked();
    void on_pushButton_save_as_clicked();
    void undo();
    void on_pushButton_generateSpecialFiles_clicked();

private:
    Ui::MainWindow *ui;

    QString hexSource;
    QString filename;

    bool readCsv();
    QString parseLine(QString line, int lineNum);
    QString getRegisterHex(QString reg);
    void openFile(QString filename);
    void saveFile(QString filename);
    QString findLabelLine(QString label);

    int linesWithErrors;

    const QString regFileName = "insAndRegs.csv";
};

#endif // MAINWINDOW_H
