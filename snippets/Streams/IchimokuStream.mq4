#include <AStreamBase.mq4>

// Ichimoku Stream v1.0

#ifndef IchimokuStream_IMP
#define IchimokuStream_IMP

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

class IchimokuStream : public AStreamBase
{
   int _tenkan;   // Tenkan-sen
   int _kijun;   // Kijun-sen
   int _senkou;  // Senkou Span B
   IBarStream* _source;
   double tenkanSen[];
   double kijunSen[];
   double spanA[];
   double ExtSpanA_Buffer[];
   double spanB[];
public:
   IchimokuStream(int tenkan, int kijun, int senkou, IBarStream* source)
   {
      _tenkan = tenkan;
      _kijun = kijun;
      _senkou = senkou;
      _source = source;
      _source.AddRef();
   }

   ~IchimokuStream()
   {
      _source.Release();
   }

   virtual int Size()
   {
      return _source.Size();
   }

   double GetTenkanSen(const int period)
   {
      return tenkanSen[Size() - period - 1];
   }
   double GetKijunSen(const int period)
   {
      return kijunSen[Size() - period - 1];
   }
   double GetSpanA(const int period)
   {
      return spanA[Size() - period - 1];
   }
   double GetSpanB(const int period)
   {
      return spanB[Size() - period - 1];
   }

   void Calculate(int period)
   {
      int size = Size();
      if (ArraySize(tenkanSen) < size)
      {
         ArrayResize(tenkanSen, size);
         ArrayResize(kijunSen, size);
         ArrayResize(spanA, size);
         ArrayResize(spanB, size);
      }
      int index = size - period - 1;
      double high, low;
      if (!_source.GetHighLow(period, high, low))
      {
         return;
      }
      double high_value = high;
      double low_value = low;
      for (int k = 0; k <= _tenkan; ++k)
      {
         if (!_source.GetHighLow(period + k, high, low))
         {
            return;
         }
         if (high_value < high)
            high_value = high;
         if(low_value > low)
            low_value = low;
      }
      tenkanSen[index] = (high_value + low_value) / 2;

      if (!_source.GetHighLow(period, high, low))
      {
         return;
      }
      high_value = high;
      low_value = low;
      for (int k = 0; k <= _kijun; ++k)
      {
         if (!_source.GetHighLow(period + k, high, low))
         {
            return;
         }
         if (high_value < high)
            high_value = high;
         if (low_value > low)
            low_value = low;
      }
      kijunSen[index] = (high_value + low_value) / 2;

      spanA[index] = (kijunSen[index] + tenkanSen[index]) / 2;

      high_value = high;
      low_value = low;
      for (int k = 0; k <= _senkou; ++k)
      {
         if (!_source.GetHighLow(period + k, high, low))
         {
            return;
         }
         if (high_value < high)
            high_value = high;
         if (low_value > low)
            low_value = low;
      }
      spanB[index] = (high_value + low_value) / 2;
   }

   virtual bool GetValue(const int period, double &val)
   {
      return true;
   }
};

#endif