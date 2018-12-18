module asr.math;

import std.math;
import std.algorithm;


public int sign(T)(T value)
{
    if (value < 0)
    {
        return -1;
    }
    else if (value > 0)
    {
        return 1;
    }
    else
    {
        return 0;
    }
}


public T clamp(T)(T value, T minValue, T maxValue)
{
    return min(max(value, minValue), maxValue);
}


public T lerp(T)(T a, T b, float t)
in
{
    assert(t >= 0 && t <= 1);
}
do
{
    if (a == b)
    {
        return a;
    }

    return a + (b - a) * t;
}