#include <Streams/AOnStream.mqh>

// ALMA on stream v2.0

#ifndef AlmaOnStream_IMP
#define AlmaOnStream_IMP

class ALMAOnStream : public AOnStream
{
   int _length;
   double _m;
   double _s;
   bool _floorValue;
public:
   ALMAOnStream(TIStream<double>* source, const int length, double offset, double sigma, bool floorValue = false)
      :AOnStream(source)
   {
      _length = length;
      _m = MathFloor(offset * (_length - 1));
      _s = _length / sigma;
      _floorValue = floorValue;
   }

   bool GetValue(const int period, double &val)
   {
      double sum = 0, wsum = 0;
      for (int i = 0; i < _length; i++)
      {
         double w = MathExp(-((i - _m) * (i - _m)) / (2 * _s * _s));
         wsum += w;
         double price;
         if (!_source.GetValue(period + (_length - 1 - i), price))
            return false;
         sum += price * w;
      }

      if (wsum != 0)
         val = sum / wsum;

      return true;
   }
};

#endif