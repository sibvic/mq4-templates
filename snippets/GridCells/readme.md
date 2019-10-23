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