// Grid text cell v2.0

#ifndef GridTextCell_IMP
#define GridTextCell_IMP

class GridTextCell
{
   string _text;
   color _clr;
   uint _width;
   uint _height;
   string _id;
   string _fontName;
   int _fontSize;
public:
   GridTextCell(string id, string fontName, int fontSize)
   {
      _fontName = fontName;
      _fontSize = fontSize;
      _id = id;
   }

   void SetData(string text, color clr)
   {
      TextSetFont(_fontName, _fontSize * (-10));
      TextGetSize(text, _width, _height);
      _text = text;
      _clr = clr;
   }

   void Draw(int __x, int __y)
   {
      ResetLastError();
      string id = _id;
      if (ObjectFind(0, id) == -1)
      {
         if (!ObjectCreate(0, id, OBJ_LABEL, 0, 0, 0))
         {
            Print(__FUNCTION__, ". Error: ", GetLastError());
            return ;
         }
         ObjectSetInteger(0, id, OBJPROP_CORNER, CORNER_LEFT_UPPER);
         ObjectSetString(0, id, OBJPROP_FONT, _fontName);
         ObjectSetInteger(0, id, OBJPROP_FONTSIZE, _fontSize);
         ObjectSetInteger(0, id, OBJPROP_ANCHOR, ANCHOR_LEFT_UPPER);
      }
      ObjectSetInteger(0, id, OBJPROP_XDISTANCE, __x);
      ObjectSetInteger(0, id, OBJPROP_YDISTANCE, __y);
      ObjectSetInteger(0, id, OBJPROP_COLOR, _clr);
      ObjectSetString(0, id, OBJPROP_TEXT, _text);
   }

   int GetWidth()
   {
      return (int)_width;
   }

   int GetHeight()
   {
      return (int)_height;
   }
};

#endif