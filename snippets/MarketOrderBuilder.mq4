// Market order builder v 1.7
// More templates and snippets on https://github.com/sibvic/mq4-templates
#include <enums/OrderSide.mq4>
class MarketOrderBuilder
{
   OrderSide _orderSide;
   string _instrument;
   double _amount;
   double _rate;
   int _slippage;
   double _stop;
   double _limit;
   int _magicNumber;
   string _comment;
   bool _ecnBroker;
public:
   MarketOrderBuilder()
   {
      _ecnBroker = false;
   }

   MarketOrderBuilder *SetSide(const OrderSide orderSide)
   {
      _orderSide = orderSide;
      return &this;
   }
   
   // Sets ECN broker flag
   MarketOrderBuilder* SetECNBroker(bool isEcn)
   {
      _ecnBroker = isEcn;
      return &this;
   }

   MarketOrderBuilder *SetInstrument(const string instrument)
   {
      _instrument = instrument;
      return &this;
   }
   
   MarketOrderBuilder *SetAmount(const double amount)
   {
      _amount = amount;
      return &this;
   }
   
   MarketOrderBuilder *SetSlippage(const int slippage)
   {
      _slippage = slippage;
      return &this;
   }
   
   MarketOrderBuilder *SetStopLoss(const double stop)
   {
      _stop = NormalizeDouble(stop, Digits);
      return &this;
   }
   
   MarketOrderBuilder *SetTakeProfit(const double limit)
   {
      _limit = NormalizeDouble(limit, Digits);
      return &this;
   }
   
   MarketOrderBuilder *SetMagicNumber(const int magicNumber)
   {
      _magicNumber = magicNumber;
      return &this;
   }

   MarketOrderBuilder *SetComment(const string comment)
   {
      _comment = comment;
      return &this;
   }
   
   int Execute(string &errorMessage)
   {
      int orderType = _orderSide == BuySide ? OP_BUY : OP_SELL;
      double minstoplevel = MarketInfo(_instrument, MODE_STOPLEVEL); 
      
      double rate = _orderSide == BuySide ? MarketInfo(_instrument, MODE_ASK) : MarketInfo(_instrument, MODE_BID);
      int order;
      if (_ecnBroker)
         order = OrderSend(_instrument, orderType, _amount, rate, _slippage, 0, 0, _comment, _magicNumber);
      else
         order = OrderSend(_instrument, orderType, _amount, rate, _slippage, _stop, _limit, _comment, _magicNumber);
      if (order == -1)
      {
         int error = GetLastError();
         switch (error)
         {
            case ERR_INVALID_TRADE_VOLUME:
               {
                  double minVolume = SymbolInfoDouble(_instrument, SYMBOL_VOLUME_MIN);
                  if (_amount < minVolume)
                  {
                     errorMessage = "Volume of the lot is too low: " + DoubleToStr(_amount) + " Min lot is: " + DoubleToStr(minVolume);
                     return -1;
                  }
                  double maxVolume = SymbolInfoDouble(_instrument, SYMBOL_VOLUME_MAX);
                  if (_amount > maxVolume)
                  {
                     errorMessage = "Volume of the lot is too high: " + DoubleToStr(_amount) + " Max lot is: " + DoubleToStr(maxVolume);
                     return -1;
                  }
                  errorMessage = "Invalid volume: " + DoubleToStr(_amount);
               }
               return -1;
            case ERR_OFF_QUOTES:
               errorMessage = "No quotes";
               return -1;
            case ERR_TRADE_NOT_ALLOWED:
               errorMessage = "Trading is not allowed";
               return -1;
            case ERR_TRADE_HEDGE_PROHIBITED:
               errorMessage = "Trade hedge prohibited";
               return -1;
            case ERR_INVALID_STOPS:
               {
                  double point = SymbolInfoDouble(_instrument, SYMBOL_POINT);
                  int minStopDistancePoints = (int)SymbolInfoInteger(_instrument, SYMBOL_TRADE_STOPS_LEVEL);
                  if (_stop != 0.0)
                  {
                     if (MathRound(MathAbs(rate - _stop) / point) < minStopDistancePoints)
                        errorMessage = "Your stop loss level is too close. The minimal distance allowed is " + IntegerToString(minStopDistancePoints) + " points";
                     else
                        errorMessage = "Invalid stop loss in the request. Do you have ECN broker and forget to enable ECN?";
                  }
                  else if (_limit != 0.0)
                  {
                     if (MathRound(MathAbs(rate - _limit) / point) < minStopDistancePoints)
                        errorMessage = "Your take profit level is too close. The minimal distance allowed is " + IntegerToString(minStopDistancePoints) + " points";
                     else
                        errorMessage = "Invalid take profit in the request. Do you have ECN broker and forget to enable ECN?";
                  }
                  else
                     errorMessage = "Invalid stop loss or take profit in the request. Do you have ECN broker and forget to enable ECN?";
               }
               return -1;
            case ERR_INVALID_PRICE:
               errorMessage = "Invalid price";
               return -1;
            default:
               errorMessage = "Failed to create order: " + IntegerToString(error);
               return -1;
         }
      }
      else if (_ecnBroker)
         TradingCommands::MoveSLTP(order, _stop, _limit, errorMessage);
      return order;
   }
};