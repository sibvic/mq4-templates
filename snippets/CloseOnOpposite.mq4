#include <enums/OrderSide.mq4>
#include <TradingCommands.mq4>

// Close on opposite v.1.1

interface ICloseOnOppositeStrategy
{
public:
   virtual void AddRef() = 0;
   virtual void Release() = 0;
   virtual void DoClose(const OrderSide side) = 0;
};

class DontCloseOnOppositeStrategy : public ICloseOnOppositeStrategy
{
   int _references;
public:
   DontCloseOnOppositeStrategy()
   {
      _references = 1;
   }

   virtual void AddRef()
   {
      ++_references;
   }

   virtual void Release()
   {
      --_references;
      if (_references == 0)
         delete &this;
   }

   void DoClose(const OrderSide side)
   {
      // do nothing
   }
};

class DoCloseOnOppositeStrategy : public ICloseOnOppositeStrategy
{
   int _magicNumber;
   int _slippage;
   int _references;
public:
   DoCloseOnOppositeStrategy(const int slippage, const int magicNumber)
   {
      _magicNumber = magicNumber;
      _slippage = slippage;
      _references = 1;
   }

   virtual void AddRef()
   {
      ++_references;
   }

   virtual void Release()
   {
      --_references;
      if (_references == 0)
         delete &this;
   }

   void DoClose(const OrderSide side)
   {
      OrdersIterator toClose();
      toClose.WhenSide(side).WhenMagicNumber(_magicNumber).WhenTrade();
      TradingCommands::CloseTrades(toClose, _slippage);
   }
};