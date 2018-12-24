module asr.game;

import derelict.sdl2.sdl;
import std.stdio;
import std.math;
import std.string;
import asr.vector;
import asr.graphics_device;
import asr.color;

public class Game
{
    public immutable string DEFAULT_WINDOW_TITLE = "ASR Demo";

    public immutable int DEFAULT_WINDOW_WIDTH = 640;

    public immutable int DEFAULT_WINDOW_HEIGHT = 480;

    private string _windowTitle;

    private int _windowWidth;

    private int _windowHeight;

    private GraphicsDevice _graphicsDevice;

    public this()
    {
        _windowTitle = DEFAULT_WINDOW_TITLE;
        _windowWidth = DEFAULT_WINDOW_WIDTH;
        _windowHeight = DEFAULT_WINDOW_HEIGHT;
        _graphicsDevice = null;
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

        auto immutable oldTicks = SDL_GetTicks();
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
            }

            auto immutable newTicks = SDL_GetTicks();
            auto immutable deltaTicks = newTicks - oldTicks;
            auto deltaTime = cast(float)deltaTicks / 1000.0f;
            this.update(deltaTime);
            this.draw();

            this.bitBlit(renderer, backBufferTexture);

            SDL_RenderPresent(renderer);
        }
    }

    public void update(float deltaTime)
    {
    }

    public void draw()
    {
    }

    private void bitBlit(SDL_Renderer* renderer, SDL_Texture* backBufferTexture)
    {
        uint* pixels = null;
        int pitch = 0;
        SDL_LockTexture(backBufferTexture, null, cast(void**)&pixels, &pitch);

        auto backBuffer = _graphicsDevice.backBuffer;
        for (int y = 0; y < backBuffer.height; y++)
        {
            for (int x = 0; x < backBuffer.width; x++)
            {
                auto pos = y * (pitch / uint.sizeof) + x;
                pixels[pos] = backBuffer.getPixel(x, y).toUInt;
            }
        }

        SDL_UnlockTexture(backBufferTexture);

        SDL_RenderCopy(renderer, backBufferTexture, null, null);
    }
}