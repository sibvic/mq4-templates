// Colored stream v1.0

class ColoredStream
{
public:
   double _clr1[];
   double _clr2[];
   double _data[];

   int RegisterStream(int id, color clr1, color clr2)
   {
      SetIndexStyle(id + 0, DRAW_LINE, STYLE_SOLID, 1, clr1);
      SetIndexBuffer(id + 0, _clr1);
      SetIndexStyle(id + 1, DRAW_LINE, STYLE_SOLID, 1, clr2);
      SetIndexBuffer(id + 1, _clr2);
      SetIndexStyle(id + 2, DRAW_NONE);
      SetIndexBuffer(id + 2, _data);
      return id + 3;
   }

   void Set(double value, int period, int colorIndex)
   {
      _data[period] = value;
      if (colorIndex == 0)
      {
         _clr1[period] = value;
         _clr2[period] = EMPTY_VALUE;
         if (_clr1[period + 1] == EMPTY_VALUE)
            _clr1[period + 1] = _clr2[period + 1];
         return;
      }
      _clr2[period] = value;
      _clr1[period] = EMPTY_VALUE;
      if (_clr2[period + 1] == EMPTY_VALUE)
         _clr2[period + 1] = _clr1[period + 1];
   }
};