// Lots provider interface v2.0

#ifndef ILotsProvider_IMP
#define ILotsProvider_IMP
class ILotsProvider
{
public:
   virtual double GetValue(int period, double entryPrice) = 0;
   virtual void AddRef() = 0;
   virtual void Release() = 0;
};
#endif

