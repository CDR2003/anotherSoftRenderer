module asr.game;

import derelict.sdl2.sdl;
import std.algorithm;
import std.stdio;
import std.math;
import std.string;
import asr.vector;
import asr.graphics_device;
import asr.color;
import asr.buffer;
import asr.rect;
import asr.math;

public class Game
{
    public immutable string DEFAULT_WINDOW_TITLE = "ASR Demo";

    public immutable int DEFAULT_WINDOW_WIDTH = 640;

    public immutable int DEFAULT_WINDOW_HEIGHT = 480;

    private string _windowTitle;

    private int _windowWidth;

    private int _windowHeight;

    private GraphicsDevice _graphicsDevice;

    private int _zoomRatio;

    private Point2 _zoomTopLeft;

    private bool _paused;

    public this()
    {
        _windowTitle = DEFAULT_WINDOW_TITLE;
        _windowWidth = DEFAULT_WINDOW_WIDTH;
        _windowHeight = DEFAULT_WINDOW_HEIGHT;
        _graphicsDevice = null;
        _zoomRatio = 1;
        _zoomTopLeft = Point2.zero;
        _paused = false;
    }

    @property
    public int windowWidth() const
    {
        return _windowWidth;
    }

    @property
    public int windowHeight() const
    {
        return _windowHeight;
    }

    @property
    public Point2 windowSize() const
    {
        return Point2(_windowWidth, _windowHeight);
    }

    @property
    public GraphicsDevice graphicsDevice()
    {
        return _graphicsDevice;
    }

    public final void run()
    {
        DerelictSDL2.load();

        if (SDL_Init(SDL_INIT_VIDEO | SDL_INIT_TIMER) < 0)
        {
            writefln("SDL couldn't initialize! SDL_Error: %s", SDL_GetError());
            return;
        }
        scope(exit) SDL_Quit();

        auto window = SDL_CreateWindow(toStringz(_windowTitle), SDL_WINDOWPOS_CENTERED, SDL_WINDOWPOS_CENTERED, _windowWidth, _windowHeight, SDL_WindowFlags.SDL_WINDOW_SHOWN);
        if (window == null)
        {
            writefln("Create window failed! SDL_Error: %s", SDL_GetError());
            return;
        }
        scope(exit) SDL_DestroyWindow(window);

        auto screen = SDL_GetWindowSurface(window);

        auto renderer = SDL_CreateRenderer(window, -1, SDL_RENDERER_ACCELERATED | SDL_RENDERER_PRESENTVSYNC);
        if (renderer == null)
        {
            writefln("Create renderer failed! SDL_Error: %s", SDL_GetError());
            return;
        }
        scope(exit) SDL_DestroyRenderer(renderer);

        auto backBufferTexture = SDL_CreateTexture(renderer, SDL_PIXELFORMAT_RGBA8888, SDL_TextureAccess.SDL_TEXTUREACCESS_STREAMING, _windowWidth, _windowHeight);
        scope(exit) SDL_DestroyTexture(backBufferTexture);

        _graphicsDevice = new GraphicsDevice(_windowWidth, _windowHeight);

        auto oldTicks = SDL_GetTicks();
        auto running = true;
        while (running)
        {
            SDL_Event e;
            while (SDL_PollEvent(&e))
            {
                if (e.type == SDL_QUIT)
                {
                    running = false;
                }
                this.handleEvent(e);
            }

            auto immutable newTicks = SDL_GetTicks();
            auto immutable deltaTicks = newTicks - oldTicks;
            auto deltaTime = cast(float)deltaTicks / 1000.0f;
            oldTicks = newTicks;

            if (_paused == false)
            {
                this.update(deltaTime);
            }

            this.draw();

            this.bitBlit(renderer, backBufferTexture);

            SDL_RenderPresent(renderer);
        }
    }

    public final void zoom(Point2 zoomCenter, int ratioOffset)
    {
        if (ratioOffset == 0)
        {
            return;
        }

        auto oldZoomRatio = _zoomRatio;
        _zoomRatio = max(_zoomRatio + ratioOffset, 1);
        if (_zoomRatio == 1)
        {
            _zoomTopLeft = Point2.zero;
            return;
        }
        
        auto sourceZoomCenter = _zoomTopLeft + zoomCenter / oldZoomRatio;
        _zoomTopLeft = sourceZoomCenter - zoomCenter / _zoomRatio;
    }

    public final void togglePause()
    {
        _paused = !_paused;
    }

    public void update(float deltaTime)
    {
    }

    public void draw()
    {
    }

    private void handleEvent(const ref SDL_Event e)
    {
        if (e.type == SDL_MOUSEWHEEL)
        {
            // Handle Zoom
            Point2 mousePos = Point2.zero;
            SDL_GetMouseState(&mousePos.x, &mousePos.y);
            this.zoom(mousePos, e.wheel.y);
        }
        else if (e.type == SDL_KEYDOWN && e.key.keysym.sym == SDL_Keysym.sym.SDLK_SPACE)
        {
            // Handle Pause/Unpause
            this.togglePause();
        }
    }

    private void bitBlit(SDL_Renderer* renderer, SDL_Texture* backBufferTexture)
    {
        SDL_SetRenderTarget(renderer, backBufferTexture);
        SDL_SetRenderDrawColor(renderer, 0, 0, 0, 255);
        SDL_RenderFillRect(renderer, null);

        uint* pixels = null;
        int pitch = 0;
        SDL_LockTexture(backBufferTexture, null, cast(void**)&pixels, &pitch);

        auto backBuffer = _graphicsDevice.backBuffer;
        for (int y = 0; y < backBuffer.height; y++)
        {
            for (int x = 0; x < backBuffer.width; x++)
            {
                this.copyZoomedPixel(x, y, pitch, pixels, backBuffer);
            }
        }

        SDL_UnlockTexture(backBufferTexture);
        SDL_SetRenderTarget(renderer, null);
        SDL_RenderCopy(renderer, backBufferTexture, null, null);
    }

    private void copyZoomedPixel(int x, int y, int pitch, uint* pixels, Color32Buffer buffer)
    {
        auto sourceRect = Rect(_zoomTopLeft, this.windowSize / _zoomRatio + Point2.one);
        if (sourceRect.contains(x, y) == false)
        {
            return;
        }

        for (int offsetY = 0; offsetY < _zoomRatio; offsetY++)
        {
            for (int offsetX = 0; offsetX < _zoomRatio; offsetX++)
            {
                auto targetX = (x - _zoomTopLeft.x) * _zoomRatio + offsetX;
                auto targetY = (y - _zoomTopLeft.y) * _zoomRatio + offsetY;
                if (targetX < 0 || targetX >= buffer.width || targetY < 0 || targetY >= buffer.height)
                {
                    continue;
                }
                
                auto pos = targetY * (pitch / uint.sizeof) + targetX;
                pixels[pos] = buffer.getPixel(x, y).toUInt;
            }
        }
    }
}