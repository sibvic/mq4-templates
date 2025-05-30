#ifndef CorrelationStream_IMP
#define CorrelationStream_IMP
// Correlation stream v2.0

#include <Streams/AOnStream.mqh>
#include <Streams/Averages/SMAOnStream.mqh>

class CorrelationStream : public AOnStream
{
   SmaOnStream *xx_ma;
   SmaOnStream *yy_ma;
   TIStream<double> *_source2;
   int _length;
public:
   CorrelationStream(TIStream<double> *source1, TIStream<double> *source2, int length)
      :AOnStream(source1)
   {
      xx_ma = new SmaOnStream(source1, length);
      yy_ma = new SmaOnStream(source2, length);
      _length = length;
      _source2 = source2;
      _source2.AddRef();
   }
   
   ~CorrelationStream()
   {
      _source2.Release();
      xx_ma.Release();
      yy_ma.Release();
   }

   bool GetValue(const int period, double &val)
   {
      double xx_ma_val;
      if (!xx_ma.GetValue(period, xx_ma_val))
      {
         return false;
      }
      double yy_ma_val;
      if (!yy_ma.GetValue(period, yy_ma_val))
      {
         return false;
      }
      double xx = 0;
      double yy = 0;
      double xy = 0;
      for (int i = 0; i < _length; ++i)
      {
         double value1;
         if (!_source.GetValue(period + i, value1))
         {
            continue;
         }
         double value2;
         if (!_source2.GetValue(period + i, value2))
         {
            continue;
         }
         xx += MathPow(value1 - xx_ma_val, 2);
         yy += MathPow(value2 - yy_ma_val, 2);
         xy += (value1 - xx_ma_val) * (value2 - yy_ma_val);
      }
      double xx_yy_sqrt = MathSqrt(xx * yy);
      if (xx_yy_sqrt == 0)
      {
         return 0;
      }
      val = xy / xx_yy_sqrt;

      return true;
   }
};

#endif