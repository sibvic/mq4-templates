#include <Conditions/ACondition.mqh>
#include <streams/IStream.mqh>
#include <streams/IBarStream.mqh>
#include <enums/TwoStreamsConditionType.mqh>

// Stream-value condition v1.0

class StreamValueCondition : public ACondition
{
   IStream* _stream1;
   int _periodShift1;
   string _name1;
   TwoStreamsConditionType _condition;
   double _value;
public:
   StreamValueCondition(const string symbol, 
      ENUM_TIMEFRAMES timeframe, 
      TwoStreamsConditionType condition,
      IStream* stream1,
      double value,
      string name1,
      int streamPeriodShift1 = 0)
      :ACondition(symbol, timeframe)
   {
      _name1 = name1;
      _stream1 = stream1;
      _stream1.AddRef();
      _condition = condition;
      _periodShift1 = streamPeriodShift1;
      _value = value;
   }

   ~StreamValueCondition()
   {
      _stream1.Release();
   }

   virtual string GetLogMessage(const int period, const datetime date)
   {
      bool result = IsPass(period, date);
      switch (_condition)
      {
         case FirstAboveSecond:
            return _name1 + " > " + DoubleToString(_value) + ": " + (result ? "true" : "false");
         case FirstBelowSecond:
            return _name1 + " < " + DoubleToString(_value) + ": " + (result ? "true" : "false");
         case FirstCrossOverSecond:
            return _name1 + " co " + DoubleToString(_value) + ": " + (result ? "true" : "false");
         case FirstCrossUnderSecond:
            return _name1 + " cu " + DoubleToString(_value) + ": " + (result ? "true" : "false");
         case FirstEqualsSecond:
            return _name1 + " = " + DoubleToString(_value) + ": " + (result ? "true" : "false");
      }
      return _name1 + "-" + DoubleToString(_value) + ": " + (result ? "true" : "false");
   }
   
   bool IsPass(const int period, const datetime date)
   {
      double value10, value11;
      if (!_stream1.GetValue(period + _periodShift1, value10) || !_stream1.GetValue(period + _periodShift1 + 1, value11))
      {
         return false;
      }
      switch (_condition)
      {
         case FirstAboveSecond:
            return value10 > _value;
         case FirstBelowSecond:
            return value10 < _value;
         case FirstEqualsSecond:
            return value10 == _value;
         case FirstCrossOverSecond:
            return value10 >= _value && value11 < _value;
         case FirstCrossUnderSecond:
            return value10 <= _value && value11 > _value;
      }
      return value10 >= _value && value11 < _value;
   }
};