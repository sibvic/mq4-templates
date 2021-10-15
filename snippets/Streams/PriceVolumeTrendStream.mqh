#include <Streams/AStream.mqh>
#include <Streams/CustomStream.mqh>
#include <Streams/CumOnStream.mqh>

// Price-volume trend stream v1.0

class PriceVolumeTrendStream : public AStream
{
   CustomStream* _src;
   CumOnStream* _cum;
public:
   PriceVolumeTrendStream(const string symbol, ENUM_TIMEFRAMES timeframe)
      :AStream(symbol, timeframe)
   {
      _src = new CustomStream(symbol, timeframe);
      _cum = new CumOnStream(_src);
   }
   ~PriceVolumeTrendStream()
   {
      _src.Release();
      _cum.Release();
   }

   bool GetValue(const int period, double &val)
   {
      int pos = Size() - period - 1;
      double prev = iClose(_symbol, _timeframe, period + 1);
      if (prev == 0)
      {
         return false;
      }
      double volume = iVolume(_symbol, _timeframe, period);
      _src.SetValue(pos, ((iClose(_symbol, _timeframe, period) - prev) / prev) * volume);
      return _cum.GetValue(period, val);
   }
};