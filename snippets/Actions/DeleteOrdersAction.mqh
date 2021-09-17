// 1.0

#ifndef DeleteOrdersAction_IMP
#define DeleteOrdersAction_IMP
class DeleteOrdersAction : public AAction
{
   int _magicNumber;
   bool _buySide;
public:
   DeleteOrdersAction(int magicNumber, bool buySide)
   {
      _magicNumber = magicNumber;
      _buySide = buySide;
   }

   virtual bool DoAction(const int period, const datetime date)
   {
      OrdersIterator toDelete();
      toDelete.WhenMagicNumber(_magicNumber)
         .WhenSide(_buySide ? BuySide : SellSide);
      TradingCommands::DeleteOrders(toDelete);
      return false;
   }
};
#endif