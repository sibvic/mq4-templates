#include <Grid/ACell.mqh>

// Label cell v4.0

#ifndef LabelCell_IMP
#define LabelCell_IMP

class LabelCell : public ACell
{
   string _id;
   string _text; 
   ENUM_BASE_CORNER _corner;
   int _fontSize;
   color _color;
   int _windowNumber;
public:
   LabelCell(const string id, const string text, ENUM_BASE_CORNER corner, int fontSize, color clr, int windowNumber)
   { 
      _corner = corner;
      _id = id; 
      _text = text;
      _fontSize = fontSize;
      _color = clr;
      _windowNumber = windowNumber;
   }

   virtual void Measure(int& width, int& height)
   {
      Measure(_text, "Arial", _fontSize, width, height);
   }

   virtual void Draw(int x, int y) 
   { 
      ObjectMakeLabel(_id, x, y, _text, _color, _corner, _windowNumber, "Arial", _fontSize); 
   }

   virtual void HandleButtonClicks()
   {
      
   }
   
   bool SetColor(color clr)
   {
      if (_color == clr)
      {
         return false;
      }
      _color = clr;
      ObjectSetInteger(0, _id, OBJPROP_COLOR, clr);
      return true;
   }
   
   bool SetText(string text)
   {
      if (_text == text)
      {
         return false;
      }
      _text = text;
      ObjectSetString(0, _id, OBJPROP_TEXT, text);
      return true;
   }
};

#endif