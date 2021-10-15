#include <Streams/AOnStream.mqh>
//LinearRegressionOnStream v1.0

class LinearRegressionOnStream : public AOnStream
{
   double _length;
   double _buffer[];
public:
   LinearRegressionOnStream(IStream *source, const int length)
      :AOnStream(source)
   {
      _length = length;
   }

   bool GetValue(const int period, double &val)
   {
      int size = Size();
      int index = size - 1 - period;
      if (ArrayRange(_buffer, 0) < size)
      {
         ArrayResize(_buffer, size);
      }

      double price;
      if (!_source.GetValue(period, price))
      {
         return false;
      }
      if (index < _length)
      {
         _buffer[index] = price;
         return false;
      }

      double lwmw = _length;
      double lwma = lwmw * price;
      double sma  = price;
      for (int i = 0; i < _length; ++i)
      {
         double weight = _length - i;
         lwmw += weight;
         lwma += weight * _buffer[index - i];  
         sma += _buffer[index - i];
      }
      _buffer[index] = (3.0 * lwma / lwmw - 2.0 * sma / _length);
      val = _buffer[index];
      return true;
   }
};