// constant lots value provider v1.0

#include <MoneyManagement/ILotsProvider.mqh>
#ifndef ConstLotsValueProvider_IMPL
#define ConstLotsValueProvider_IMPL
class ConstLotsValueProvider : public ILotsProvider
{
   double lots;
   int refs;
public:
   ConstLotsValueProvider(double lots)
   {
      refs = 1;
      this.lots = lots;
   }
   double GetValue(int period, double entryPrice)
   {
      return lots;
   }
   
   void AddRef()
   {
      ++refs;
   }

   void Release()
   {
      --refs;
      if (refs == 0)
         delete &this;
   }
};
#endif