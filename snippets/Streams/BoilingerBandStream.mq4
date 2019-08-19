// Boilinger Band Stream v1.0

#ifndef BoilingerBandStream_IMP
#define BoilingerBandStream_IMP

#include <IStream.mq4>
#include <SmaOnStream.mq4>
#include <StDevStream.mq4>

class BoilingerBandStream : public IStream
{
   double _dev;
   int _references;
   IStream* _sma;
   IStream* _stdev;
   bool _up;
public:
   BoilingerBandStream(IStream* __source, int length, double dev, bool up)
   {
      _references = 1;
      _sma = new SmaOnStream(__source, length);
      _stdev = new StDevStream(__source, length);
      _dev = dev;
      _up = up;
   }

   ~BoilingerBandStream()
   {
      _sma.Release();
      _stdev.Release();
   }

   virtual bool GetValue(const int period, double &val)
   {
      double basis;
      if (!_sma.GetValue(period, basis))
         return false;
      double stdev;
      if (!_stdev.GetValue(period, stdev))
         return false;

      val = _up ? basis + _dev * stdev : basis - _dev * stdev;
      return true;
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
};

#endif