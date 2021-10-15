#include <Streams/AOnStream.mqh>
#include <Streams/Averages/RmaOnStream.mqh>
#include <Streams/ChangeStream.mqh>
#include <Streams/AbsStream.mqh>

//TSIOnStream v1.0
class TSIOnStream : public AOnStream
{
   double _length;
   ChangeStream* delta;
   AbsStream* absDelta;
   RmaOnStream* ema_r1;
   RmaOnStream* ema_r2;
   RmaOnStream* ema_s1;
   RmaOnStream* ema_s2;
public:
   TSIOnStream(IStream *source, const int length)
      :AOnStream(source)
   {
      _length = length;
      delta = new ChangeStream(source);
      absDelta = new AbsStream(delta);
      ema_r1 = new RmaOnStream(delta, length);
      ema_r2 = new RmaOnStream(absDelta, length);
      ema_s1 = new RmaOnStream(ema_r1, length);
      ema_s2 = new RmaOnStream(ema_r2, length);
   }

   ~TSIOnStream()
   {
      delta.Release();
      absDelta.Release();
      ema_r1.Release();
      ema_r2.Release();
      ema_s1.Release();
   }

   bool GetValue(const int period, double &val)
   {
      double s2;
      if (!ema_s2.GetValue(period, s2))
      {
         return false;
      }
      double s1;
      if (!ema_s1.GetValue(period, s1))
      {
         return false;
      }
      val = s2 == 0 ? 0 : 100 * s1 / s2;
      return true;
   }
};