
#include <ICellFactory.mq4>

// Text value cell factory v1.0

#ifndef TextValueCellFactory_IMP
#define TextValueCellFactory_IMP

class TextValueCellFactory : public ICellFactory
{
public:

   virtual string GetHeader()
   {
      return "Value";
   }
   
   virtual ICell* Create(const string id, const int x, const int y, const string symbol, const ENUM_TIMEFRAMES timeframe)
   {
      return new TextValueCell(id, x, y, symbol, timeframe);
   }
};
#endif