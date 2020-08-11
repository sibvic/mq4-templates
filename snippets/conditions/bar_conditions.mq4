#include <ACondition.mq4>
#include <../Streams/IBarStream.mq4>

// Bar condnitions v2.3

#ifndef BarConditions_IMP
#define BarConditions_IMP

class BarAscendingCondition : public AConditionBase
{
   IBarStream* _stream;
   int _periodShift;
public:
   BarAscendingCondition(IBarStream* stream)
   {
      _periodShift = 0;
      _stream = stream;
      _stream.AddRef();
   }

   ~BarAscendingCondition()
   {
      _stream.Release();
   }

   void SetPeriodShift(int shift)
   {
      _periodShift = shift;
   }

   virtual bool IsPass(const int period, const datetime date)
   {
      int streamPeriod;
      if (!_stream.FindDatePeriod(date, streamPeriod))
      {
         return false;
      }
      double open, close;
      return _stream.GetOpenClose(streamPeriod + _periodShift, open, close) && open < close;
   }

   virtual string GetLogMessage(const int period, const datetime date)
   {
      bool result = IsPass(period, date);
      return _stream.GetName() + " Bar ascending: " + (result ? "true" : "false");
   }
};

class BarDescendingCondition : public AConditionBase
{
   IBarStream* _stream;
   int _periodShift;
public:
   BarDescendingCondition(IBarStream* stream)
   {
      _periodShift = 0;
      _stream = stream;
      _stream.AddRef();
   }

   ~BarDescendingCondition()
   {
      _stream.Release();
   }

   void SetPeriodShift(int shift)
   {
      _periodShift = shift;
   }

   virtual bool IsPass(const int period, const datetime date)
   {
      int streamPeriod;
      if (!_stream.FindDatePeriod(date, streamPeriod))
      {
         return false;
      }
      double open, close;
      return _stream.GetOpenClose(streamPeriod + _periodShift, open, close) && open > close;
   }

   virtual string GetLogMessage(const int period, const datetime date)
   {
      bool result = IsPass(period, date);
      return _stream.GetName() + " Bar descending: " + (result ? "true" : "false");
   }
};

class MinBodySizeCondition : public ACondition
{
   double _minSize;
public:
   MinBodySizeCondition(const string symbol, ENUM_TIMEFRAMES timeframe, double minSize)
      :ACondition(symbol, timeframe)
   {
      _minSize = minSize;
   }

   virtual bool IsPass(const int period, const datetime date)
   {
      double body = MathAbs(iOpen(_symbol, _timeframe, period) - iClose(_symbol, _timeframe, period));
      double candle = iHigh(_symbol, _timeframe, period) - iLow(_symbol, _timeframe, period);
      return candle == 0 ? (_minSize == 0) : (body / candle >= _minSize / 100.0);
   }

   virtual string GetLogMessage(const int period, const datetime date)
   {
      bool result = IsPass(period, date);
      return "Min body size: " + (result ? "true" : "false");
   }
};
#endif