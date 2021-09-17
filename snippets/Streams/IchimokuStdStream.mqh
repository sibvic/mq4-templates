#include <AStreamBase.mqh>
#include <IBarStream.mqh>

// Ichimoku Stream v1.0

#ifndef IchimokuStdStream_IMP
#define IchimokuStdStream_IMP

class IchimokuStdStream : public AStreamBase
{
   int _tenkan;   // Tenkan-sen
   int _kijun;   // Kijun-sen
   int _senkou;  // Senkou Span B
   int _streamIndex;
   string _symbol;
   ENUM_TIMEFRAMES _timeframe;
public:
   IchimokuStdStream(string symbol, ENUM_TIMEFRAMES timeframe, int tenkan, int kijun, int senkou, int streamIndex)
   {
      _tenkan = tenkan;
      _kijun = kijun;
      _senkou = senkou;
      _streamIndex = streamIndex;
      _symbol = symbol;
      _timeframe = timeframe;
   }

   virtual int Size()
   {
      return iBars(_symbol, _timeframe);
   }

   virtual bool GetValue(const int period, double &val)
   {
      val = iIchimoku(_symbol, _timeframe, _tenkan, _kijun, _senkou, _streamIndex, period);
      return true;
   }
};
class IchimokuStdCloudStream : public AStreamBase
{
   int _tenkan;   // Tenkan-sen
   int _kijun;   // Kijun-sen
   int _senkou;  // Senkou Span B
   bool _upper;
   string _symbol;
   ENUM_TIMEFRAMES _timeframe;
public:
   IchimokuStdCloudStream(string symbol, ENUM_TIMEFRAMES timeframe, int tenkan, int kijun, int senkou, bool upper)
   {
      _tenkan = tenkan;
      _kijun = kijun;
      _senkou = senkou;
      _upper = upper;
      _symbol = symbol;
      _timeframe = timeframe;
   }

   virtual int Size()
   {
      return iBars(_symbol, _timeframe);
   }

   virtual bool GetValue(const int period, double &val)
   {
      double saValue = iIchimoku(_symbol, _timeframe, _tenkan, _kijun, _senkou, MODE_SENKOUSPANA, period);
      double sbValue = iIchimoku(_symbol, _timeframe, _tenkan, _kijun, _senkou, MODE_SENKOUSPANB, period);
      val = _upper ? MathMax(saValue, sbValue) : MathMin(saValue, sbValue);
      return true;
   }
};

#endif