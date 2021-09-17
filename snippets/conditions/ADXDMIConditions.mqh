// ADX/DMI conditions v1.0

#include <ACondition.mqh>

#ifndef ADXDMIConditions_IMP
#define ADXDMIConditions_IMP

class ADXOverADXCondition : public ACondition
{
   int _adxPeriod;
   int _stream1;
   int _stream2;
public:
   ADXOverADXCondition(const string symbol, ENUM_TIMEFRAMES timeframe, int adxPeriod, int stream1, int stream2)
      :ACondition(symbol, timeframe)
   {
      _adxPeriod = adxPeriod;
      _stream1 = stream1;
      _stream2 = stream2;
   }

   bool IsPass(const int period, const datetime date)
   {
      double adx1Value0 = iADX(_symbol, _timeframe, _adxPeriod, PRICE_CLOSE, _stream1, period);
      double adx2Value0 = iADX(_symbol, _timeframe, _adxPeriod, PRICE_CLOSE, _stream2, period);
      return adx1Value0 > adx2Value0;
   }
};

class ADXUnderADXCondition : public ACondition
{
   int _adxPeriod;
   int _stream1;
   int _stream2;
public:
   ADXUnderADXCondition(const string symbol, ENUM_TIMEFRAMES timeframe, int adxPeriod, int stream1, int stream2)
      :ACondition(symbol, timeframe)
   {
      _adxPeriod = adxPeriod;
      _stream1 = stream1;
      _stream2 = stream2;
   }

   bool IsPass(const int period, const datetime date)
   {
      double adx1Value0 = iADX(_symbol, _timeframe, _adxPeriod, PRICE_CLOSE, _stream1, period);
      double adx2Value0 = iADX(_symbol, _timeframe, _adxPeriod, PRICE_CLOSE, _stream2, period);
      return adx1Value0 < adx2Value0;
   }
};

class ADXCrossOverADXCondition : public ACondition
{
   int _adxPeriod;
   int _stream1;
   int _stream2;
public:
   ADXCrossOverADXCondition(const string symbol, ENUM_TIMEFRAMES timeframe, int adxPeriod, int stream1, int stream2)
      :ACondition(symbol, timeframe)
   {
      _adxPeriod = adxPeriod;
      _stream1 = stream1;
      _stream2 = stream2;
   }

   bool IsPass(const int period, const datetime date)
   {
      double adx1Value0 = iADX(_symbol, _timeframe, _adxPeriod, PRICE_CLOSE, _stream1, period);
      double adx2Value0 = iADX(_symbol, _timeframe, _adxPeriod, PRICE_CLOSE, _stream2, period);
      double adx1Value1 = iADX(_symbol, _timeframe, _adxPeriod, PRICE_CLOSE, _stream1, period + 1);
      double adx2Value1 = iADX(_symbol, _timeframe, _adxPeriod, PRICE_CLOSE, _stream2, period + 1);
      return adx1Value0 >= adx2Value0 && adx1Value1 < adx2Value1;
   }
};

class ADXCrossUnderADXCondition : public ACondition
{
   int _adxPeriod;
   int _stream1;
   int _stream2;
public:
   ADXCrossUnderADXCondition(const string symbol, ENUM_TIMEFRAMES timeframe, int adxPeriod, int stream1, int stream2)
      :ACondition(symbol, timeframe)
   {
      _adxPeriod = adxPeriod;
      _stream1 = stream1;
      _stream2 = stream2;
   }

   bool IsPass(const int period, const datetime date)
   {
      double adx1Value0 = iADX(_symbol, _timeframe, _adxPeriod, PRICE_CLOSE, _stream1, period);
      double adx2Value0 = iADX(_symbol, _timeframe, _adxPeriod, PRICE_CLOSE, _stream2, period);
      double adx1Value1 = iADX(_symbol, _timeframe, _adxPeriod, PRICE_CLOSE, _stream1, period + 1);
      double adx2Value1 = iADX(_symbol, _timeframe, _adxPeriod, PRICE_CLOSE, _stream2, period + 1);
      return adx1Value0 <= adx2Value0 && adx1Value1 > adx2Value1;
   }
};

#endif