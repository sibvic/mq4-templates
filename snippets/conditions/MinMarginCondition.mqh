// v1.0

#ifndef MinMarginCondition_IMP
#define MinMarginCondition_IMP
class MinMarginCondition : public AConditionBase
{
   datetime _minMargin;
public:
   MinMarginCondition(double minMargin)
      :AConditionBase("Min margin")
   {
      _minMargin = minMargin;
   }

   virtual bool IsPass(const int period, const datetime date)
   {
      return (100 * AccountFreeMargin() / AccountEquity()) >= _minMargin;
   }
};
#endif