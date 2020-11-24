/****************************************************************************
**
****************************************************************************/


#ifndef RENDERAREA_H
#define RENDERAREA_H

#include <QBrush>
#include <QPen>
#include <QPixmap>
#include <QWidget>

class RenderArea : public QWidget
{
    Q_OBJECT

public:

    RenderArea(QWidget *parent = 0);
    void setRomData(QString hexSource);
    QColor getColorFromDec(int dec);
    void setMirror(bool flag);

public slots:

protected:

    void paintEvent(QPaintEvent *event) override;

private:

    QString hexSource;
    bool mirrorFlag = false;

};

#endif // RENDERAREA_H
