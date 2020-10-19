/****************************************************************************
**
****************************************************************************/


#include "renderarea.h"
#include "mainwindow.h"

#include <QPainter>
#include <QPainterPath>
#include "QDebug"

RenderArea::RenderArea(QWidget *parent)
    : QWidget(parent)
{

}


void RenderArea::setRomData(QString binaryHex)
{
    this->hexSource = binaryHex;
}


QColor RenderArea::getColorFromDec(int dec)
{
    if (dec == 0) return Qt::red;
    else if (dec == 1) return Qt::green;
    else if (dec == 2) return Qt::blue;
    else if (dec == 3) return Qt::yellow;
    return Qt::black; // error
}


void RenderArea::paintEvent(QPaintEvent * /* event */)
{
    QPainter painter(this);

    // rectange size and padding
    int w = 25;
    int h = 25;
    int heightPadding = 8;
    int widthPadding = 8;

    QRect rect(5, 5, w, h);


    // render black background
    painter.setRenderHint(QPainter::Antialiasing, false);
    painter.setPen(palette().dark().color());
    painter.setBrush(Qt::lightGray);
    painter.drawRect(QRect(0, 0, width() - 1, height() - 1));


    if (hexSource != "")
    {
        int i = 0;
        int toggle = true;
        int dec;

        for (int y = 0; y < LINES_PER_ROM; y++) {

            for (int x = 0; x < NIBS_PER_ROW; x++) {

                // prevent overflow
                if (i > hexSource.length() - 1) break;

                // convert hex string to dec
                QString sValue = hexSource.at(i);
                bool ok = false;
                dec = sValue.toInt(&ok,16);

                // split hex value into two 2-bit values, toggle between large/small ends
                if (toggle)
                {
                    toggle = false;
                    painter.setBrush(getColorFromDec(dec >> 2)); // check only bits 3 and 2

                } else {
                    toggle = true;
                    painter.setBrush(getColorFromDec(dec & 0x03)); // check only bits 1 and 0
                    i++; // next hex value every two nibs
                }

                painter.save(); // saves original position
                painter.translate(x * (w + widthPadding), y * (h + heightPadding));
                painter.setRenderHint(QPainter::Antialiasing);
                QPainterPath path;
                path.addRect(rect);
                QPen pen(Qt::black, 1);
                painter.setPen(pen);
                painter.drawPath(path);
                painter.restore();

            }
        }
    }

    // draw border around render area
    painter.setRenderHint(QPainter::Antialiasing, false);
    painter.setPen(palette().dark().color());
    painter.setBrush(Qt::NoBrush);
    painter.drawRect(QRect(0, 0, width() - 1, height() - 1));

}
