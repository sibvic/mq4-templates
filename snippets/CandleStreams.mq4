// Candles stream v.1.2
class CandleStreams
{
public:
   double OpenStream[];
   double CloseStream[];
   double HighStream[];
   double LowStream[];

   void Clear(const int index)
   {
      OpenStream[index] = EMPTY_VALUE;
      CloseStream[index] = EMPTY_VALUE;
      HighStream[index] = EMPTY_VALUE;
      LowStream[index] = EMPTY_VALUE;
   }

   int RegisterStreams(const int id, const color clr)
   {
      SetIndexStyle(id + 0, DRAW_HISTOGRAM, STYLE_SOLID, 5, clr);
      SetIndexBuffer(id + 0, OpenStream);
      SetIndexLabel(id + 0, "Open");
      SetIndexStyle(id + 1, DRAW_HISTOGRAM, STYLE_SOLID, 5, clr);
      SetIndexBuffer(id + 1, CloseStream);
      SetIndexLabel(id + 1, "Close");
      SetIndexStyle(id + 2, DRAW_HISTOGRAM, STYLE_SOLID, 1, clr);
      SetIndexBuffer(id + 2, HighStream);
      SetIndexLabel(id + 2, "High");
      SetIndexStyle(id + 3, DRAW_HISTOGRAM, STYLE_SOLID, 1, clr);
      SetIndexBuffer(id + 3, LowStream);
      SetIndexLabel(id + 3, "Low");
      return id + 4;
   }

   void AddTick(const int index, const double val)
   {
      if (OpenStream[index] == EMPTY_VALUE)
      {
         Set(index, val, val, val, val);
         return;
      }
      HighStream[index] = MathMax(HighStream[index], val);
      LowStream[index] = MathMin(LowStream[index], val);
      CloseStream[index] = val;
   }

   void Set(const int index, const double open, const double high, const double low, const double close)
   {
      OpenStream[index] = open;
      HighStream[index] = high;
      LowStream[index] = low;
      CloseStream[index] = close;
   }
};

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