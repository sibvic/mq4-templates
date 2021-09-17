#ifndef NewObjectCondition_IMP
#define NewObjectCondition_IMP

//v 1.0
class NewObjectCondition : public ACondition
{
   string _id;
public:
   NewObjectCondition(const string symbol, ENUM_TIMEFRAMES timeframe, string id)
      :ACondition(symbol, timeframe)
   {
      _id = id;
   }

   bool IsPass(const int period, const datetime date)
   {
      for (int k = ObjectsTotal(); k >= 0; k--)
      {
         string name = ObjectName(0, k);
         datetime time = (datetime)ObjectGetInteger(0, name, OBJPROP_TIME);
         if (time >= date && StringFind(name, _id) == 0)
         {
            return ObjectGetDouble(0, name, OBJPROP_PRICE) <= iLow(_symbol, _timeframe, period);
         }
      }
      return false;
   }
};
#endif