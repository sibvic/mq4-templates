// Closed orders iterator v1.0

#ifndef ClosedOrdersIterator
#define ClosedOrdersIterator

#include <enums/OrderSide.mq4>

class ClosedOrdersIterator
{
   bool _useMagicNumber;
   int _magicNumber;
   bool _useOrderType;
   int _orderType;
   bool _useSide;
   bool _isBuySide;
   int _lastIndex;
   bool _useSymbol;
   string _symbol;
   bool _useProfit;
   double _profit;
   bool _useComment;
   string _comment;
   CompareType _profitCompare;
public:
   ClosedOrdersIterator()
   {
      _useOrderType = false;
      _useMagicNumber = false;
      _useSide = false;
      _lastIndex = INT_MIN;
      _useSymbol = false;
      _useProfit = false;
      _useComment = false;
   }

   ClosedOrdersIterator *WhenSymbol(const string symbol)
   {
      _useSymbol = true;
      _symbol = symbol;
      return &this;
   }

   ClosedOrdersIterator *WhenProfit(const double profit, const CompareType compare)
   {
      _useProfit = true;
      _profit = profit;
      _profitCompare = compare;
      return &this;
   }

   ClosedOrdersIterator *WhenSide(const OrderSide side)
   {
      _useSide = true;
      _isBuySide = side == BuySide;
      return &this;
   }

   ClosedOrdersIterator *WhenOrderType(const int orderType)
   {
      _useOrderType = true;
      _orderType = orderType;
      return &this;
   }

   ClosedOrdersIterator *WhenMagicNumber(const int magicNumber)
   {
      _useMagicNumber = true;
      _magicNumber = magicNumber;
      return &this;
   }

   ClosedOrdersIterator *WhenComment(const string comment)
   {
      _useComment = true;
      _comment = comment;
      return &this;
   }

   int GetOrderType() { return OrderType(); }
   double GetProfit() { return OrderProfit(); }
   double IsBuy() { return OrderType() == OP_BUY; }
   double IsSell() { return OrderType() == OP_SELL; }
   int GetTicket() { return OrderTicket(); }
   datetime GetOpenTime() { return OrderOpenTime(); }
   double GetOpenPrice() { return OrderOpenPrice(); }

   int Count()
   {
      int count = 0;
      for (int i = OrdersHistoryTotal() - 1; i >= 0; i--)
      {
         if (OrderSelect(i, SELECT_BY_POS, MODE_HISTORY) && PassFilter())
            count++;
      }
      return count;
   }

   bool Next()
   {
      if (_lastIndex == INT_MIN)
         _lastIndex = OrdersHistoryTotal() - 1;
      else
         _lastIndex = _lastIndex - 1;
      while (_lastIndex >= 0)
      {
         if (OrderSelect(_lastIndex, SELECT_BY_POS, MODE_HISTORY) && PassFilter())
            return true;
         _lastIndex = _lastIndex - 1;
      }
      return false;
   }

   bool Any()
   {
      for (int i = OrdersHistoryTotal() - 1; i >= 0; i--)
      {
         if (OrderSelect(i, SELECT_BY_POS, MODE_HISTORY) && PassFilter())
            return true;
      }
      return false;
   }

   int First()
   {
      for (int i = OrdersHistoryTotal() - 1; i >= 0; i--)
      {
         if (OrderSelect(i, SELECT_BY_POS, MODE_HISTORY) && PassFilter())
            return OrderTicket();
      }
      return -1;
   }

   void Reset()
   {
      _lastIndex = INT_MIN;
   }

private:
   bool PassFilter()
   {
      if (_useMagicNumber && OrderMagicNumber() != _magicNumber)
         return false;
      if (_useOrderType && OrderType() != _orderType)
         return false;
      if (_useSymbol && OrderSymbol() != _symbol)
         return false;
      if (_useProfit)
      {
         switch (_profitCompare)
         {
            case CompareLessThan:
               if (OrderProfit() >= _profit)
                  return false;
               break;
         }
      }
      if (_useSide)
      {
         if (_isBuySide && !IsBuy())
            return false;
         if (!_isBuySide && !IsSell())
            return false;
      }
      if (_useComment && OrderComment() != _comment)
         return false;
      return true;
   }
};

#endif