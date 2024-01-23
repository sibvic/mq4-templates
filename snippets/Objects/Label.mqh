// Label v1.0

#ifndef Label_IMPL
#define Label_IMPL

class Label
{
   color _color;
   string _text;
   string _labelId;
   datetime _x;
   double _y;
   string _font;
   string _style;
public:
   Label(datetime x, double y, string labelId)
   {
      _x = x;
      _y = y;
      _labelId = labelId;
      _font = "Arial";
   }
   
   string GetId()
   {
      return _labelId;
   }
   
   Label* SetColor(color clr)
   {
      _color = clr;
      return &this;
   }
   
   static void SetStyle(Label* label, string style)
   {
      if (label == NULL)
      {
         return;
      }
      label.SetStyle(style);
   }
   Label* SetStyle(string style)
   {
      _style = style;
      return &this;
   }
   
   Label* SetText(string text)
   {
      _text = text;
      if (_text == "")
      {
         _font = "Wingdings";
      }
      else
      {
         _font = "Arial";
      }
      return &this;
   }

   void Redraw()
   {
      string usedText = _text;
      if (usedText == "")
      {
         if (_style == "up")
         {
            usedText = "\217";
         }
         else if (_style == "down")
         {
            usedText = "\218";
         }
      }
      ResetLastError();
      if (ObjectFind(0, _labelId) == -1 && ObjectCreate(0, _labelId, OBJ_TEXT, 0, _x, _y))
      {
         ObjectSetString(0, _labelId, OBJPROP_FONT, _font);
         ObjectSetInteger(0, _labelId, OBJPROP_FONTSIZE, 12);
         ObjectSetInteger(0, _labelId, OBJPROP_COLOR, _color);
      }
      ObjectSetInteger(0, _labelId, OBJPROP_TIME, _x);
      ObjectSetDouble(0, _labelId, OBJPROP_PRICE1, _y);
      ObjectSetString(0, _labelId, OBJPROP_TEXT, usedText);
   }
};
#endif