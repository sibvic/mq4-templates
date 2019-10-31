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

## CreateTrailingAction

Creates trailing action for the order.