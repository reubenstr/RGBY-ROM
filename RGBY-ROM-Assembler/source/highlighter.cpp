/****************************************************************************
**
****************************************************************************/

#include "highlighter.h"

Highlighter::Highlighter(QTextDocument *parent)
    : QSyntaxHighlighter(parent)
{

}


void Highlighter::setRules(QStringList instructionKeywords, QStringList registerKeywords)
{
    HighlightingRule rule;

    // numbers
    singleLineCommentFormat.setFontWeight(QFont::Bold);
    singleLineCommentFormat.setForeground(Qt::darkYellow);
    rule.pattern = QRegularExpression("\\b(1?[0-9]{1,2}|2[0-4][0-9]|25[0-5])\\b");
    rule.format = singleLineCommentFormat;
    highlightingRules.append(rule);

    // instructions
    keywordFormat.setForeground(Qt::darkBlue);
    keywordFormat.setFontWeight(QFont::Bold);
    foreach (const QString &pattern, instructionKeywords) {
        rule.pattern = QRegularExpression(pattern);
        rule.format = keywordFormat;
        highlightingRules.append(rule);
    }

    // registers
    keywordFormat.setForeground(Qt::darkMagenta);
    keywordFormat.setFontWeight(QFont::Bold);
    foreach (const QString &pattern, registerKeywords) {
        rule.pattern = QRegularExpression(pattern);
        rule.format = keywordFormat;
        highlightingRules.append(rule);
    }

    // single line comments
    singleLineCommentFormat.setFontWeight(QFont::Bold);
    singleLineCommentFormat.setForeground(Qt::darkGreen);
    rule.pattern = QRegularExpression("#[^\n]*");
    rule.format = singleLineCommentFormat;
    highlightingRules.append(rule);

    // labels
    classFormat.setFontWeight(QFont::Bold);
    classFormat.setForeground(Qt::darkCyan);
    rule.pattern = QRegularExpression("\\bL:[A-Za-z0-9_]+\\b");
    rule.format = classFormat;
    highlightingRules.append(rule);

}

void Highlighter::highlightBlock(const QString &text)
{
    foreach (const HighlightingRule &rule, highlightingRules) {
        QRegularExpressionMatchIterator matchIterator = rule.pattern.globalMatch(text);
        while (matchIterator.hasNext()) {
            QRegularExpressionMatch match = matchIterator.next();
            setFormat(match.capturedStart(), match.capturedLength(), rule.format);
        }
    }
}
