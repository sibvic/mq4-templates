#include <Streams/AOnStream.mqh>

//AbsStream v1.0
class AbsStream : public AOnStream
{
public:
   AbsStream(IStream *source)
      :AOnStream(source)
   {
   }

   bool GetValue(const int period, double &val)
   {
      int size = Size();
      double price;
      if (!_source.GetValue(period, price))
      {
         return false;
      }
      val = MathAbs(price);
      return true;
   }
};
