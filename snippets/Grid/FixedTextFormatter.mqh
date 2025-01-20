// Fixed text and color formatter v3.0

#include <Grid/AValueFormatter.mqh>

#ifndef FixedTextFormatter_IMP
#define FixedTextFormatter_IMP
class FixedTextFormatter : public AValueFormatter
{
   string _text;
   color _clr;
   color _bgClr;
   string _font;
public:
   FixedTextFormatter(string text, color clr, color bgClr, string font)
   {
      _bgClr = bgClr;
      _text = text;
      _clr = clr;
      _font = font;
   }

   virtual string FormatItem(const int period, const datetime date, color& clr, color& bgColor, string& font)
   {
      clr = _clr;
      bgColor = _bgClr;
      font = _font;
      return _text;
   }
};
#endif