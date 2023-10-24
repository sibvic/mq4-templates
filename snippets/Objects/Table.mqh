// Table v1.0
#include <Grid/Grid.mqh>
#include <Grid/LabelCell.mqh>

enum TablePosition
{
   TablePositionTopLeft,
   TablePositionTopCenter,
   TablePositionTopRight,
   TablePositionMiddleLeft,
   TablePositionMiddleCenter,
   TablePositionMiddleRight,
   TablePositionBottomLeft,
   TablePositionBottomCenter,
   TablePositionBottomRight
};

class Table
{
   string _prefix;
   TablePosition _position;
   int _columns;
   int _rows;
   int _borderWidth;
   Grid* _grid;
public:
   Table(string prefix, TablePosition position, int columns, int rows)
   {
      _prefix = prefix;
      _position = position;
      _columns = columns;
      _rows = rows;
      _borderWidth = 0;
      _grid = new Grid();
      for (int i = 0; i < rows; ++i)
      {
         Row* row = _grid.AddRow();
         for (int j = 0; j < columns; ++j)
         {
            string id = _prefix + "_cell_" + IntegerToString(i) + "_" + IntegerToString(j);
            row.Add(new LabelCell(id, "", CORNER_LEFT_UPPER, 10, Red, 0));
         }
      }
      Redraw();
   }
   ~Table()
   {
      delete _grid;
   }
   
   void SetBorderWidth(int borderWidth)
   {
      _borderWidth = borderWidth;
   }
   void CellText(int column, int row, string text)
   {
      Row* gridRow = _grid.GetRow(row);
      LabelCell* cell = (LabelCell*)gridRow.GetCell(column);
      if (cell.SetText(text))
      {
         Redraw();
      }
   }
   void CellTextColor(int column, int row, color clr)
   {
      Row* gridRow = _grid.GetRow(row);
      LabelCell* cell = (LabelCell*)gridRow.GetCell(column);
      if (cell.SetColor(clr))
      {
         Redraw();
      }
   }
   
   void Redraw()
   {
      int x = 0;
      int y = 0;
      switch (_position)
      {
         case TablePositionTopLeft:
            break;
         case TablePositionTopCenter:
            x = (GetScreenWidth() - GetGridWidth()) / 2;
            break;
         case TablePositionTopRight:
            x = GetScreenWidth() - GetGridWidth();
            break;
         case TablePositionMiddleLeft:
            y = (GetScreenHeight() - GetGridHeight()) / 2;
            break;
         case TablePositionMiddleCenter:
            y = (GetScreenHeight() - GetGridHeight()) / 2;
            x = (GetScreenWidth() - GetGridWidth()) / 2;
            break;
         case TablePositionMiddleRight:
            y = (GetScreenHeight() - GetGridHeight()) / 2;
            x = GetScreenWidth() - GetGridWidth();
            break;
         case TablePositionBottomLeft:
            y = GetScreenHeight() - GetGridHeight();
            break;
         case TablePositionBottomCenter:
            y = GetScreenHeight() - GetGridHeight();
            x = (GetScreenWidth() - GetGridWidth()) / 2;
            break;
         case TablePositionBottomRight:
            y = GetScreenHeight() - GetGridHeight();
            x = GetScreenWidth() - GetGridWidth();
            break;
      }
      _grid.Draw(x, y);
   }
private:
   int GetScreenWidth()
   {
      return ChartGetInteger(0, CHART_WIDTH_IN_PIXELS, 0);
   }
   int GetGridWidth()
   {
      int width = 0;
      for (int i = 0; i < _rows; ++i)
      {
         RowSize* rowSizes = new RowSize();
         _grid.GetRow(i).Measure(rowSizes);
         int rowWidth = 0;
         for (int ii = 0; ii < _columns; ++ii)
         {
            rowWidth += rowSizes.GetWidth(ii);
         }
         delete rowSizes;
         width = MathMax(width, rowWidth);
      }
      return width;
   }
   int GetScreenHeight()
   {
      return ChartGetInteger(0, CHART_HEIGHT_IN_PIXELS, 0);
   }
   int GetGridHeight()
   {
      int height = 0;
      for (int i = 0; i < _rows; ++i)
      {
         RowSize* rowSizes = new RowSize();
         _grid.GetRow(i).Measure(rowSizes);
         height = MathMax(height, rowSizes.GetMaxHeight());
         delete rowSizes;
      }
      return height;
   }
};