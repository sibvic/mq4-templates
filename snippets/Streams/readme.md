# Streams

## IStream

Interface for streams.

## IBarStream

Interface for bar streams.

## HABarStream

Bar stream of Heikin Ashi

## AStream

Abstract base for streams.

## PriceStream

Price stream.

## CustomStream

Stream from the buffer filled externally.

## CustomTimeframeBarStream

Custom timeframe bar stream.

## BarStream

Bar stream.

## D1CustomHourBarStream

D1 bar source with a custom start hour.

## ACustomBarStream

Abstract class for a custom bar sources.

## W1CustomHourAndDayBarStream

W1 bar source with a custom start hour and week day.

## HighestHighStream

Gives highest values during loopback period.

## LowersLowStream

Gives lowest values during loopback period.

## ColoredStream

Color streams (draws a line using several colors).

Usage:

    ColoredStream _streams;
    int init()
    {
        int id = 0;
        id = _streams.RegisterStream(id, up_color, "Up");
        id = _streams.RegisterStream(id, down_color, "Down");
        id = _streams.RegisterStream(id, neutral_color, "Neutral");
        id = _streams.RegisterInternal(id);
    }

    int start()
    {
        for (int i = limit; i >= 0; i--)
        {
            if (IsUp(i))
                _streams.Set(value[i], i, 0);
            else if (IsDown(i)) 
                _streams.Set(value[i], i, 1);
            else
                _streams.Set(value[i], i, 2);
        }
    }
