#include <AStreamBase.mq4>
// Custom stream v2.0

#ifndef CustomStream_IMP
#define CustomStream_IMP

class CustomStream : public AStreamBase
{
   string _symbol;
   ENUM_TIMEFRAMES _timeframe;
   double _stream[];
public:

   CustomStream(const string symbol, const ENUM_TIMEFRAMES timeframe)
   {
      _symbol = symbol;
      _timeframe = timeframe;
   }

   virtual int Size()
   {
      return iBars(_symbol, _timeframe);
   }

   void SetValue(const int period, double value)
   {
      int totalBars = Size();
      if (ArrayRange(_stream, 0) != totalBars) 
      {
         ArrayResize(_stream, totalBars);
      }
      _stream[period] = value;
   }

   bool GetValue(const int period, double &val)
   {
      int totalBars = Size();
      if (ArrayRange(_stream, 0) != totalBars) 
      {
         ArrayResize(_stream, totalBars);
      }
      val = _stream[period];
      return _stream[period] != EMPTY_VALUE;
   }
};

#endif