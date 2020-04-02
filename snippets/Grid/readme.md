## TrendValueCell

Shows trend.

## ICell

Interface for a cell

## ICellFactory

Interface for a cell factory

## GridBuilder

Grid builder

## TrendValueCellFactory

Creates TrendValueCell

## TextValueCell

Shows text.

## TextValueCellFactory

Creates TextValueCell

## EmptyCell

Empty cell

## LabelCell

Label cell

## Row

Row of cells

## Grid

Grid 

# Grid cells

## GridCells

The grid itself.

Example:

    grid = new GridCells(IndicatorObjPrefix, 1.3);
    grid.Clear();
    int rowIndex = 1;
    grid.Add("Ticket", Label, 1, rowIndex);
    grid.Add("Symbol", Label, 2, rowIndex);
    grid.Add("S/B", Label, 3, rowIndex);
    grid.Add("R/R", Label, 4, rowIndex);
    grid.Add("Pips", Label, 5, rowIndex);
    grid.Add("Gross P/L", Label, 6, rowIndex);
    ++rowIndex;
    ...
    grid.Draw(x, y);

## GridTextCell

## GridRow

## IValueFormatter

Interface for a value formatter.

## AValueFormatter

Abstract value formatter. Implements reference counting. Should be used as a parent most of the times.

## FixedTextFormatter

Returns fixed strign and color.
