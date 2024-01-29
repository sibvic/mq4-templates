// Line object v1.1

class Line
{
   string _id;
   int _x1;
   double _y1;
   int _x2;
   double _y2;
   color _clr;
   int _width;
   ENUM_TIMEFRAMES _timeframe;
public:
   Line(int x1, double y1, int x2, double y2, string id)
   {
      _x1 = x1;
      _x2 = x2;
      _y1 = y1;
      _y2 = y2;
      _id = id;
      _clr = Blue;
      _timeframe = (ENUM_TIMEFRAMES)_Period;
   }

   string GetId()
   {
      return _id;
   }

   void SetX1(int x)
   {
      _x1 = x;
   }
   static void SetX1(Line* line, int x)
   {
      if (line == NULL)
      {
         return;
      }
      line.SetX1(x);
   }
   void SetX2(int x)
   {
      _x2 = x;
   }
   static void SetX2(Line* line, int x)
   {
      if (line == NULL)
      {
         return;
      }
      line.SetX2(x);
   }
   void SetY1(double y)
   {
      _y1 = y;
   }
   static void SetY1(Line* line, double y)
   {
      if (line == NULL)
      {
         return;
      }
      line.SetY1(y);
   }
   void SetY2(double y)
   {
      _y2 = y;
   }
   static void SetY2(Line* line, double y)
   {
      if (line == NULL)
      {
         return;
      }
      line.SetY2(y);
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
      int pos1 = iBars(_Symbol, _timeframe) - _x1 - 1;
      datetime x1 = iTime(_Symbol, _timeframe, pos1);
      int pos2 = iBars(_Symbol, _timeframe) - _x2 - 1;
      datetime x2 = iTime(_Symbol, _timeframe, pos2);
      if (ObjectFind(0, _id) == -1 && ObjectCreate(0, _id, OBJ_TREND, 0, x1, _y1, x2, _y2))
      {
         ObjectSetInteger(0, _id, OBJPROP_COLOR, _clr);
         ObjectSetInteger(0, _id, OBJPROP_STYLE, STYLE_SOLID);
         ObjectSetInteger(0, _id, OBJPROP_WIDTH, _width);
         ObjectSetInteger(0, _id, OBJPROP_RAY_RIGHT, false);
      }
      ObjectSetDouble(0, _id, OBJPROP_PRICE1, _y1);
      ObjectSetDouble(0, _id, OBJPROP_PRICE2, _y2);
      ObjectSetInteger(0, _id, OBJPROP_TIME1, x1);
      ObjectSetInteger(0, _id, OBJPROP_TIME2, x2);
   }
};