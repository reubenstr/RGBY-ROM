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

public slots:

protected:

    void paintEvent(QPaintEvent *event) override;

private:

    QString hexSource;

};

#endif // RENDERAREA_H
