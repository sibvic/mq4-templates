// Or condition v2.0

#include <ACondition.mq4>

#ifndef OrCondition_IMP
#define OrCondition_IMP

class OrCondition : public ACondition
{
   ICondition *_conditions[];
public:
   ~OrCondition()
   {
      int size = ArraySize(_conditions);
      for (int i = 0; i < size; ++i)
      {
         _conditions[i].Release();
      }
   }

   void Add(ICondition *condition, bool addRef)
   {
      int size = ArraySize(_conditions);
      ArrayResize(_conditions, size + 1);
      _conditions[size] = condition;
      if (addRef)
         condition.AddRef();
   }

   virtual bool IsPass(const int period)
   {
      int size = ArraySize(_conditions);
      for (int i = 0; i < size; ++i)
      {
         if (_conditions[i].IsPass(period))
            return true;
      }
      return false;
   }
};
#endif