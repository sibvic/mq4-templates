// Fixed text and color formatter v1.0

#include <AValueFormatter.mq4>

#ifndef FixedTextFormatter_IMP
#define FixedTextFormatter_IMP
class FixedTextFormatter : public AValueFormatter
{
   string _text;
   color _clr;
public:
   FixedTextFormatter(string text, color clr)
   {
      _text = text;
      _clr = clr;
   }

   virtual string FormatItem(const int period, const datetime date, color& clr)
   {
      clr = _clr;
      return _text;
   }
};
#endif