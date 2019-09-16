// Position cap v.1.1
#include <enums/OrderSide.mq4>
interface IPositionCapStrategy
{
public:
   virtual bool IsLimitHit() = 0;
};

class PositionCapStrategy : public IPositionCapStrategy
{
   int _magicNumber;
   int _maxSidePositions;
   int _totalPositions;
   string _symbol;
   OrderSide _side;
public:
   PositionCapStrategy(const OrderSide side, const int magicNumber, const int maxSidePositions, const int totalPositions,
      const string symbol = "")
   {
      _symbol = symbol;
      _side = side;
      _magicNumber = magicNumber;
      _maxSidePositions = maxSidePositions;
      _totalPositions = totalPositions;
   }

   bool IsLimitHit()
   {
      OrdersIterator sideSpecificIterator();
      sideSpecificIterator.WhenMagicNumber(_magicNumber).WhenTrade().WhenSide(_side);
      if (_symbol != "")
         sideSpecificIterator.WhenSymbol(_symbol);
      int side_positions = sideSpecificIterator.Count();
      if (side_positions >= _maxSidePositions)
         return true;

      OrdersIterator it();
      it.WhenMagicNumber(_magicNumber).WhenTrade();
      if (_symbol != "")
         it.WhenSymbol(_symbol);
      int positions = it.Count();
      return positions >= _totalPositions;
   }
};

class NoPositionCapStrategy : public IPositionCapStrategy
{
public:
   bool IsLimitHit()
   {
      return false;
   }
};