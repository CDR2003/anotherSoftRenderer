module asr.rect;

import std.math;
import asr.vector;

public struct RectT(T)
{
    public T x;

    public T y;

    public T width;

    public T height;

    public this(T x, T y, T width, T height)
    {
        this.x = x;
        this.y = y;
        this.width = width;
        this.height = height;
    }

    public this(VectorT!(T, 2) position, VectorT!(T, 2) size)
    {
        this.x = position.x;
        this.y = position.y;
        this.width = size.x;
        this.height = size.y;
    }

    @property
    public T xMin() const
    {
        return this.x;
    }

    @property
    public T xMax() const
    {
        return this.x + this.width;
    }

    @property
    public T yMin() const
    {
        return this.y;
    }

    @property
    public T yMax() const
    {
        return this.y + this.height;
    }

    public bool contains(VectorT!(T, 2) point) const
    {
        return this.contains(point.x, point.y);
    }

    public bool contains(T x, T y) const
    {
        return (this.xMin <= x && x < this.xMax) && (this.yMin <= y && y < this.yMax);
    }
}


alias Rect = RectT!(int);
alias RectF = RectT!(float);
