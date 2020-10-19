/****************************************************************************
**
****************************************************************************/

// TODO: offset column width and scroll bar compensation is a bit slapped together
// a programic approach will have better results

#include <QtWidgets>
#include "QDebug"

#include "codeeditor.h"

CodeEditor::CodeEditor(QWidget *parent) : QPlainTextEdit(parent)
{
    lineNumberArea = new LineNumberArea(this);
    offsetNumberArea = new OffsetNumberArea(this);

    connect(this, SIGNAL(blockCountChanged(int)), this, SLOT(updateLineNumberAreaWidth(int)));
    connect(this, SIGNAL(updateRequest(QRect,int)), this, SLOT(updateLineNumberArea(QRect,int)));

    updateLineNumberAreaWidth(0);
}


int CodeEditor::lineNumberAreaWidth()
{
    int digits = 1;
    int max = qMax(1, blockCount());
    while (max >= 10) {
        max /= 10;
        ++digits;
    }

    int space = 3 + fontMetrics().horizontalAdvance(QLatin1Char('9')) * digits;
    return space;
}


void CodeEditor::updateLineNumberAreaWidth(int /* newBlockCount */)
{  
    int offsetSpace = 3 + fontMetrics().horizontalAdvance(QLatin1Char('9')) * 3;
    setViewportMargins(lineNumberAreaWidth(), 0, offsetSpace - 5, 0);
}


// widget was scrolled
void CodeEditor::updateLineNumberArea(const QRect &rect, int dy)
{
    if (dy)
        lineNumberArea->scroll(0, dy);
    else
        lineNumberArea->update(0, rect.y(), lineNumberArea->width(), rect.height());

    if (rect.contains(viewport()->rect())) updateLineNumberAreaWidth(0);

    if (dy)
        offsetNumberArea->scroll(0, dy);
    else
        offsetNumberArea->update(0, rect.y(), offsetNumberArea->width(), rect.height());
}


void CodeEditor::resizeEvent(QResizeEvent *e)
{
    QPlainTextEdit::resizeEvent(e);

    QRect cr = contentsRect();
    lineNumberArea->setGeometry(QRect(cr.left(), cr.top(), lineNumberAreaWidth(), cr.height()));


    int fontSize = 3 + fontMetrics().horizontalAdvance(QLatin1Char('9'));
    int space = fontSize * 4;

    offsetNumberArea->setGeometry(QRect(cr.left() + cr.width() - space,  cr.top(),
                                        space, cr.height()));

}


void CodeEditor::lineNumberAreaPaintEvent(QPaintEvent *event)
{

    QPainter painter(lineNumberArea);

    painter.fillRect(event->rect(), QColor(Qt::lightGray).lighter(80));

    QTextBlock block = firstVisibleBlock();
    int blockNumber = block.blockNumber();
    int top = (int) blockBoundingGeometry(block).translated(contentOffset()).top();
    int bottom = top + (int) blockBoundingRect(block).height();

    while (block.isValid() && top <= event->rect().bottom()) {
        if (block.isVisible() && bottom >= event->rect().top()) {

            //QString number = QString::number(blockNumber);
            QString number;

           if (lineOfCodeToInstructionNumber.contains(blockNumber))
               number = QString::number(lineOfCodeToInstructionNumber.value(blockNumber));
            else number = "";


            painter.setPen(Qt::black);
            painter.drawText(0, top, lineNumberArea->width(), fontMetrics().height(), Qt::AlignRight, number);
        }

        block = block.next();
        top = bottom;
        bottom = top + (int) blockBoundingRect(block).height();
        ++blockNumber;
    }
}


void CodeEditor::offsetNumberAreaPaintEvent(QPaintEvent *event)
{
    QPainter painter(offsetNumberArea);

    painter.fillRect(event->rect(), QColor(Qt::lightGray).lighter(80));

    QTextBlock block = firstVisibleBlock();
    int blockNumber = block.blockNumber();
    int top = (int) blockBoundingGeometry(block).translated(contentOffset()).top();
    int bottom = top + (int) blockBoundingRect(block).height();

    while (block.isValid() && top <= event->rect().bottom()) {
        if (block.isVisible() && bottom >= event->rect().top()) {
            QString number = QString::number(blockNumber);
            painter.setPen(Qt::black);
            if (jumpAbsoluteAddress.contains(blockNumber))
            {
                QString offsetString = QString::number(jumpAbsoluteAddress.value(blockNumber));
                painter.drawText(0, top, offsetNumberArea->width() - 26, fontMetrics().height(), Qt::AlignRight, offsetString);
            }
        }
        block = block.next();
        top = bottom;
        bottom = top + (int) blockBoundingRect(block).height();
        ++blockNumber;
    }
}
