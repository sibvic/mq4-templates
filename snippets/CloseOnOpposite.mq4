// Close on opposite v.1.1
#include <enums/OrderSide.mq4>
interface ICloseOnOppositeStrategy
{
public:
   virtual void DoClose(const OrderSide side) = 0;
};

class DontCloseOnOppositeStrategy : public ICloseOnOppositeStrategy
{
public:
   void DoClose(const OrderSide side)
   {
      // do nothing
   }
};

class DoCloseOnOppositeStrategy : public ICloseOnOppositeStrategy
{
   int _magicNumber;
   int _slippage;
public:
   DoCloseOnOppositeStrategy(const int slippage, const int magicNumber)
   {
      _magicNumber = magicNumber;
      _slippage = slippage;
   }

   void DoClose(const OrderSide side)
   {
      OrdersIterator toClose();
      toClose.WhenSide(side).WhenMagicNumber(_magicNumber).WhenTrade();
      TradingCommands::CloseTrades(toClose, _slippage);
   }
};