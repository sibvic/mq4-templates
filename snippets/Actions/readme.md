# Actions

## IAction

Action interface.

## AAction

Base implementation of reference counting.

## MoveToBreakevenAction

Moves stop loss to breakeven.

## MoveNetStopLossAction

Moves stop loss for all positions to the same level.

## MoveNetTakeProfitAction

Moves take profit for all positions to the same level.

## AOrderAction

Used to execute action on orders.

## MoveStopLossOnProfitOrderAction

Creates MoveNetStopLossAction for orders.

## CloseOrderAction

Closes order.

## TrailingPipsAction

Keeps stop loss distance to the orders to the defined amount of pips.

## TrailingStreamAction

Keeps stop loss sync with stream value.

## CreateTrailingAction

Creates trailing action for the order. Start could be specified in pips or % of stop loss.

## CreateTrailingStreamAction

Creates trailing action for the order. Start could be specified in pips or % of stop loss. Keeps stop loss sync with a stream value.

## CreateATRTrailingAction

Creates trailing action for the order. The trailng starts after ATR distance has been reached in the profit.

## CloseAllAction

Closes all trades.

## SetStopLossAndTakeProfitAction

Sets stop loss and/or take profit.

## PartialCloseOrderAction

Partially closes the trade.

## MoveTakeProfitAction

Move take profit action.

## LossTradesCounterAction

Used with TradingMonitor. Counts trades with a loss in a raw.

## DeletePendingOrderAction

Deletes pending order.

## DeletePendingOrdersAction

Deletes all pending orders with a specified magic number.

## EntryAction

Executes entry action.

## OpenMarketOrderAction

Open market order action.

## CreateMartingaleAction

Creates additional position on loss.

## DeleteOrdersAction

Deletes order with a specified magic number and side.