// Line object v1.0

class Line
{
   string _id;
   datetime _x1;
   double _y1;
   datetime _x2;
   double _y2;
   color _clr;
   int _width;
public:
   Line(datetime x1, double y1, datetime x2, double y2, string id)
   {
      _x1 = x1;
      _x2 = x2;
      _y1 = y1;
      _y2 = y2;
      _id = id;
   }

   string GetId()
   {
      return _id;
   }

   Line* SetColor(color clr)
   {
      _clr = clr;
      return &this;
   }

   Line* SetWidth(int width)
   {
      _width = width;
      return &this;
   }

   void Redraw()
   {
      if (ObjectFind(0, _id) == -1 && ObjectCreate(0, _id, OBJ_TREND, 0, _x1, _y1, _x2, _y2))
      {
         ObjectSetInteger(0, _id, OBJPROP_COLOR, _clr);
         ObjectSetInteger(0, _id, OBJPROP_STYLE, STYLE_SOLID);
         ObjectSetInteger(0, _id, OBJPROP_WIDTH, _width);
         ObjectSetInteger(0, _id, OBJPROP_RAY_RIGHT, false);
      }
      ObjectSetDouble(0, _id, OBJPROP_PRICE1, _y1);
      ObjectSetDouble(0, _id, OBJPROP_PRICE2, _y2);
      ObjectSetInteger(0, _id, OBJPROP_TIME1, _x1);
      ObjectSetInteger(0, _id, OBJPROP_TIME2, _x2);
   }
};