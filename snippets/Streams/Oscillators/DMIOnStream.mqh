#include <Streams/AOnStream.mqh>
#include <Streams/AStreamBase.mqh>
#include <Streams/IBarStream.mqh>
#include <Streams/Averages/TrueRangeOnStream.mqh>
#include <Streams/Averages/EMAOnStream.mqh>
#include <Streams/CustomStreamOnStream.mqh>
#include <Streams/Averages/RmaOnStream.mqh>
#include <Streams/BarStream.mqh>

// DMI stream v1.0

#ifndef DMIStream_IMP
#define DMIStream_IMP

class DMIOnStream : TIStream<double>
{
protected:
   IBarStream *_source;
   int _references;
   TrueRangeOnStream* tr;
   CustomStreamOnStream* avgPlusDM;
   CustomStreamOnStream* avgMinusDM;
   EMAOnStream* SmoothedDirectionalMovementPlus;
   EMAOnStream* SmoothedDirectionalMovementMinus;
   CustomStreamOnStream* rmaSource;
   RmaOnStream* rma;
public:
   DMIOnStream(string symbol, ENUM_TIMEFRAMES timeframe, int diLength, int adxSmoothing)
   {
      _source = new BarStream(symbol, timeframe);
      Init(diLength, adxSmoothing);
   }
   
   DMIOnStream(IBarStream* stream, int diLength, int adxSmoothing)
   {
      _source = stream;
      _source.AddRef();
      Init(diLength, adxSmoothing);
   }
   
   void Init(int diLength, int adxSmoothing)
   {
      _references = 1;
      if (_source != NULL)
      {
         _source.AddRef();
         tr = new TrueRangeOnStream(_source);
         avgPlusDM = new CustomStreamOnStream(tr);
         avgMinusDM = new CustomStreamOnStream(tr);
         SmoothedDirectionalMovementPlus = new EMAOnStream(avgPlusDM, diLength);
         SmoothedDirectionalMovementMinus = new EMAOnStream(avgMinusDM, diLength);
         rmaSource = new CustomStreamOnStream(tr);
         rma = new RmaOnStream(rmaSource, adxSmoothing);
      }
   }

   ~DMIOnStream()
   {
      _source.Release();
      tr.Release();
      avgPlusDM.Release();
      avgMinusDM.Release();
      SmoothedDirectionalMovementPlus.Release();
      SmoothedDirectionalMovementMinus.Release();
      rmaSource.Release();
      rma.Release();
   }
   
   void AddRef()
   {
      ++_references;
   }

   void Release()
   {
      --_references;
      if (_references == 0)
         delete &this;
   }

   virtual int Size()
   {
      return _source.Size();
   }
   
   virtual bool GetValue(const int period, double &val)
   {
      return false;
   }
   
   virtual bool GetValue(const int period, double &ADX, double& DIPlus, double& DIMinus)
   {
      int totalBars = _source.Size();
      double h, h1;
      if (!_source.GetHigh(period, h) || !_source.GetHigh(period + 1, h1))
      {
         return false;
      }
      double l, l1;
      if (!_source.GetLow(period, l) || !_source.GetLow(period + 1, l1))
      {
         return false;
      }
      double DirectionalMovementPlus = MathAbs(h - h1);
      double DirectionalMovementMinus = MathAbs(l - l1);
      if (DirectionalMovementPlus == DirectionalMovementMinus)
      {
         DirectionalMovementPlus = 0;
         DirectionalMovementMinus = 0;
      }
      else if (DirectionalMovementPlus < DirectionalMovementMinus)
      {
         DirectionalMovementPlus = 0;
      }
      else if (DirectionalMovementMinus < DirectionalMovementPlus)
      {
         DirectionalMovementMinus = 0;
      }
      double TR;
      if (!tr.GetValue(period, TR))
      {
         return false;
      }
      avgPlusDM.SetValue(period, TR == 0 ? 0 : 100 * DirectionalMovementPlus / TR);
      avgMinusDM.SetValue(period, TR == 0 ? 0 : 100 * DirectionalMovementMinus / TR);
      
      double str;
      if (!SmoothedDirectionalMovementPlus.GetValue(period, DIPlus) || !SmoothedDirectionalMovementMinus.GetValue(period, DIMinus))
      {
         return false;
      }
      
      double DX = (MathAbs(DIPlus - DIMinus) / (DIPlus + DIMinus)) * 100;
      rmaSource.SetValue(period, DX);
      if (!rma.GetValue(period, ADX))
      {
         return false;
      }
      return true;
   }
};

#endif