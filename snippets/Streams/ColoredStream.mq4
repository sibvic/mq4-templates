// Colored stream v3.0

#ifndef ColoredStream_IMP
#define ColoredStream_IMP

class ColoredStreamData
{
public:
   double Stream[];
};

#include <AStream.mq4>

class ColoredStream : public AStream
{
public:
   ColoredStreamData _streams[];
   double _data[];

   ColoredStream(const string symbol, const ENUM_TIMEFRAMES timeframe)
      :AStream(symbol, timeframe)
   {
   }

   int RegisterInternalStream(int id)
   {
      SetIndexBuffer(id + 0, _data);
      SetIndexStyle(id + 0, DRAW_NONE);
      return id + 1;
   }

   int RegisterStream(int id, color clr, string label = "", int lineType = DRAW_LINE, ENUM_LINE_STYLE lineStyle = STYLE_SOLID, int width = 1)
   {
      int size = ArraySize(_streams);
      ArrayResize(_streams, size + 1);
      SetIndexStyle(id + 0, lineType, lineStyle, width, clr);
      SetIndexBuffer(id + 0, _streams[size].Stream);
      if (label != "")
         SetIndexLabel(id + 0, label);
      return id + 1;
   }

   int GetColorIndex(int period)
   {
      for (int i = 0; i < ArraySize(_streams); ++i)
      {
         if (_streams[i].Stream[period] != EMPTY_VALUE)
            return i;
      }
      return -1;
   }

   void Set(double value, int period, int colorIndex)
   {
      _data[period] = value;
      for (int i = 0; i < ArraySize(_streams); ++i)
      {
         if (colorIndex == i)
         {
            _streams[i].Stream[period] = value;
            if (period + 1 < iBars(_symbol, _timeframe) && _streams[i].Stream[period + 1] == EMPTY_VALUE)
               _streams[i].Stream[period + 1] = _data[period + 1];   
         }
         else
            _streams[i].Stream[period] = EMPTY_VALUE;
      }
   }

   bool GetValue(const int period, double &val)
   {
      if (period >= iBars(_symbol, _timeframe))
      {
         return false;
      }
      val = _data[period];
      return _data[period] != EMPTY_VALUE;
   }
};

#endif