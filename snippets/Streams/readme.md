# Streams

## IStream

Interface for streams.

## AOnStream

Abstract class for streams based on another stream.

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

## StDevStream

Standard deviation stream

## CandleStreams and ColoredStream

Builds bar stream and multi-color stream.

## ConditionCandleStreams

CandeStreams with condition. Sets the values when condition returns true.

## IStreamFactory

Stream factory.

## StreamFactory

Stream factory dummy.

## StdAveragesStream

Returns iMA value.

## BoilingerBandStream

Boilinger Band stream.

## RangeStream

Range stream.

## RangeStreamOnStream

Range stream based on IBarStream as a source.

## BoilingerBandStandardStream

Boilinger bands using standard MT4 function.

## MoveStream

Calculates total move (open-close) on timeframe bar during another timeframe bar.

## MoveStreamOnStream

Move stream based on IBarStream as a source.

## AStreamBase

Abstract implemention of stream with reference counting.

## ValueWhenStream

Sets value to a stream when condition is passed.

## IchimokuStream

Ichimoku streams. Returns nothing. Used for separate ichimoku streams.

## IchimokuTenkanSenStream, IchimokuKijunSenStream, IchimokuSpanAStream, IchimokuSpanBStream

Separate Ichimoku streams.

## RenkoStream

Renko bar stream.

## IndicatorOutputStream

Stream with an indicator output.

## PointAndFigure

Point and Figure bar stream.

## ChangeStream

Return difference between the current value and n periods before.

## MaxOnStream

Max value on stream.

## MinOnStream

Min value on stream.

## TrueRangeStream

True range stream.

## ATRStream

Average true range stream

## FixnanStream

Stream equivalent to Pine Script fixnan

## PivotHighStream

Stream equivalent to Pine Script pivothigh

## PivotLowStream

Stream equivalent to Pine Script pivotlow