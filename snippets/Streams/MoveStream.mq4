// Move stream v1.1
#ifndef MoveStream_IMP
#define MoveStream_IMP
#include <IStream.mq4>
class MoveStream : public IStream
{
   string _symbol;
   ENUM_TIMEFRAMES _baseTimeframe;
   ENUM_TIMEFRAMES _moveTimeframe;
public:
   MoveStream(const string symbol, const ENUM_TIMEFRAMES baseTimeframe, const ENUM_TIMEFRAMES moveTimeframe)
   {
      _symbol = symbol;
      _baseTimeframe = baseTimeframe;
      _moveTimeframe = moveTimeframe;
   }

   virtual bool GetValue(const int period, double &val)
   {
      int startIndex = iBarShift(_symbol, _moveTimeframe, iTime(_symbol, _baseTimeframe, period));
      int endIndex = period == 0 ? 0 : iBarShift(_symbol, _moveTimeframe, iTime(_symbol, _baseTimeframe, period - 1));
      val = 0;
      for (int i = startIndex; i >= endIndex; --i)
      {
         val += MathAbs(iClose(_symbol, _moveTimeframe, i) - iOpen(_symbol, _moveTimeframe, i));
      }

      return true;
   }
};
#endif