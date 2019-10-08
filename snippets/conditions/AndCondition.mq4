// And condition v2.0
#include <ACondition.mq4>
#ifndef AndCondition_IMP
#define AndCondition_IMP
class AndCondition : public ACondition
{
   ICondition *_conditions[];
public:
   ~AndCondition()
   {
      int size = ArraySize(_conditions);
      for (int i = 0; i < size; ++i)
      {
         _conditions[i].Release();
      }
   }

   void Add(ICondition* condition, bool addRef)
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
         if (!_conditions[i].IsPass(period))
            return false;
      }
      return true;
   }
};
#endif