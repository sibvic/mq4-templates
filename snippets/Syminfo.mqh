double SyminfoMintick(string symbol)
{
    double point = MarketInfo(symbol, MODE_POINT);
    int digits = (int)MarketInfo(symbol, MODE_DIGITS);
    int mult = digits == 3 || digits == 5 ? 10 : 1;
    return point * mult;
}