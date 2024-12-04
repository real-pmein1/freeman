#ifdef _WIN32
#include <Windows.h>
#elif unix
#include <X11/Xlib.h>
#include <cstring>
#endif

#include <iostream>
#include <time.h>
#include <thread>
#include <filesystem>

#ifdef unix
Display *display;

Window window_from_name_search(Window current, char const *needle) {
    Window retval, root, parent, *children;
    unsigned children_count;
    char *name = NULL;

    /* Check if this window has the name we seek */
    if(XFetchName(display, current, &name) > 0) {
        int r = strcmp(needle, name);
        XFree(name);
        if(r == 0) {
            return current;
        }
    }

    retval = 0;

    /* If it does not: check all subwindows recursively. */
    if(0 != XQueryTree(display, current, &root, &parent, &children, &children_count)) {
        unsigned i;
        for(i = 0; i < children_count; ++i) {
            Window win = window_from_name_search(children[i], needle);

            if(win != 0) {
                retval = win;
                break;
            }
        }

        XFree(children);
    }

    return retval;
}

// frontend function: open display connection, start searching from the root window.
Window window_from_name(char const *name) {
    Window w = window_from_name_search(XDefaultRootWindow(display), name);
    return w;
}
#endif

int main(int argc, char * argv[]){
    time_t start = time(0);
#ifdef _WIN32
    HWND gameWindow = nullptr;
    HWND menuWindow = FindWindowA("Engine", "Game Menu");
    HWND launcherWindow = FindWindowA("Engine", "Half-Life: Alyx NoVR Launcher");
#elif unix
    display = XOpenDisplay(NULL);
    Window gameWindow = 0;
    Window menuWindow = window_from_name("Game Menu");
    Window launcherWindow = window_from_name("Half-Life: Alyx NoVR Launcher");
#endif
    if (argc > 1) {
#ifdef _WIN32
        gameWindow = FindWindowA("SDL_app", "Half-Life: Alyx");
#elif unix
        gameWindow = window_from_name("Half-Life: Alyx");
#endif
        std::string arg1 = argv[1];
        if (arg1 == "exec") {
#ifdef _WIN32
            SendMessage(gameWindow, WM_KEYDOWN, VK_PAUSE, 0);
            SendMessage(gameWindow, WM_KEYUP, VK_PAUSE, 0);
#elif unix
            // TODO: send xlib pause key input
#endif
        } else if (arg1 == "focusgame") {
#ifdef _WIN32
            SetForegroundWindow(gameWindow);
#elif unix
            XRaiseWindow(display, gameWindow);
#endif
        } else if (arg1 == "focuslauncher") {
#ifdef _WIN32
            SetForegroundWindow(launcherWindow);
#elif unix
            XRaiseWindow(display, launcherWindow);
#endif
        } else if (arg1 == "update") {
            int error = -1;
            while (error != 0) {
#ifdef _WIN32
                error = remove("HLA-NoVR-Launcher.exe");
#elif unix
                error = remove("HLA-NoVR-Launcher-Linux");
#endif
            }
#ifdef _WIN32
            std::filesystem::rename("HLA-NoVR-Launcher.exe.update", "HLA-NoVR-Launcher.exe");

            STARTUPINFO si;
            PROCESS_INFORMATION pi;
            ZeroMemory(&si, sizeof(si));
            si.cb = sizeof(si);
            ZeroMemory(&pi, sizeof(pi));
            CreateProcess(NULL, const_cast<LPSTR>("HLA-NoVR-Launcher.exe"), NULL, NULL, FALSE, 0, NULL, NULL, &si, &pi);
#elif unix
            std::filesystem::rename("HLA-NoVR-Launcher-Linux.update", "HLA-NoVR-Launcher-Linux");

            std::system("./HLA-NoVR-Launcher-Linux");
#endif
        }
    } else {
        /*
        while (true) {
            std::cout << window_from_name("Half-Life: Alyx") << std::endl;
            std::this_thread::sleep_for(std::chrono::milliseconds(33));
        }
        */
#ifdef _WIN32
        RECT rect;
        while (gameWindow == nullptr) {
#elif unix
        while (gameWindow == 0) {
#endif
            if (difftime(time(0), start) > 120) {
                std::cout << "exit" << std::endl;
                return 0;
            } else {
#ifdef _WIN32
                gameWindow = FindWindowA("SDL_app", "Half-Life: Alyx");
#elif unix
                gameWindow = window_from_name("Half-Life: Alyx");
#endif
            }
        }
#ifdef _WIN32
        SetWindowLongPtr(menuWindow, GWLP_HWNDPARENT, (LONG_PTR)gameWindow);
        SetForegroundWindow(gameWindow);
        while (GetClientRect(gameWindow, &rect)) {
            ClientToScreen(gameWindow, reinterpret_cast<POINT*>(&rect.left));
            ClientToScreen(gameWindow, reinterpret_cast<POINT*>(&rect.right));
            std::cout << "geometry:" << rect.left << ":" << rect.top << ":" << (rect.right - rect.left) << ":" << (rect.bottom - rect.top) << std::endl;
            std::cout << "escape:" << GetKeyState(VK_ESCAPE) << std::endl;
#elif unix
        XSetTransientForHint(display, menuWindow, gameWindow);
        while (window_from_name("Half-Life: Alyx")) {
            int windowTopLeft[2];
            XTranslateCoordinates(display, gameWindow, XDefaultRootWindow(display), 0, 0, &windowTopLeft[0], &windowTopLeft[1], &menuWindow);
            XWindowAttributes windowAttributes;
            XGetWindowAttributes(display, gameWindow, &windowAttributes);
            std::cout << "geometry:" << windowTopLeft[0] << ":" << windowTopLeft[1] << ":" << windowAttributes.width << ":" << windowAttributes.height << std::endl;
#endif
            std::this_thread::sleep_for(std::chrono::milliseconds(10));
        }
        std::cout << "exit" << std::endl;
    }
    return 0;
}
