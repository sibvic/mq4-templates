// Boilinger Band Stream v2.0

#ifndef BoilingerBandStream_IMP
#define BoilingerBandStream_IMP

#include <IStream.mqh>
#include <SmaOnStream.mqh>
#include <StDevStream.mqh>

class BoilingerBandStream : public IStream
{
   double _dev;
   int _references;
   TIStream<double>* _sma;
   TIStream<double>* _stdev;
   bool _up;
public:
   BoilingerBandStream(TIStream<double>* __source, int length, double dev, bool up)
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