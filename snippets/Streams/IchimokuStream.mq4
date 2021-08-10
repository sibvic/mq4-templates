#include <AStreamBase.mq4>
#include <IBarStream.mq4>

// Ichimoku Stream v1.0

#ifndef IchimokuStream_IMP
#define IchimokuStream_IMP

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

class IchimokuTenkanSenStream : public AStreamBase
{
   IchimokuStream* _ichimoku;
public:
   IchimokuTenkanSenStream(IchimokuStream* ichomoku)
   {
      _ichimoku = ichomoku;
      _ichimoku.AddRef();
   }

   ~IchimokuStream()
   {
      _ichimoku.Release();
   }

   virtual bool GetValue(const int period, double &val)
   {
      val = _ichimoku.GetTenkanSen(period);
      return true;
   }
};
class IchimokuKijunSenStream : public AStreamBase
{
   IchimokuStream* _ichimoku;
public:
   IchimokuKijunSenStream(IchimokuStream* ichomoku)
   {
      _ichimoku = ichomoku;
      _ichimoku.AddRef();
   }

   ~IchimokuStream()
   {
      _ichimoku.Release();
   }

   virtual bool GetValue(const int period, double &val)
   {
      val = _ichimoku.GetKijunSen(period);
      return true;
   }
};
class IchimokuSpanAStream : public AStreamBase
{
   IchimokuStream* _ichimoku;
public:
   IchimokuSpanAStream(IchimokuStream* ichomoku)
   {
      _ichimoku = ichomoku;
      _ichimoku.AddRef();
   }

   ~IchimokuStream()
   {
      _ichimoku.Release();
   }

   virtual bool GetValue(const int period, double &val)
   {
      val = _ichimoku.GetSpanA(period);
      return true;
   }
};
class IchimokuSpanBStream : public AStreamBase
{
   IchimokuStream* _ichimoku;
public:
   IchimokuSpanBStream(IchimokuStream* ichomoku)
   {
      _ichimoku = ichomoku;
      _ichimoku.AddRef();
   }

   ~IchimokuStream()
   {
      _ichimoku.Release();
   }

   virtual bool GetValue(const int period, double &val)
   {
      val = _ichimoku.GetSpanB(period);
      return true;
   }
};

#endif