# Start-from-browser-exe
 Start exe from google chrome

Once I needed to run the exe application from the Google Chrome browser. The browser did not want to start exe, he just downloaded it from the local disk. I went into research and found a way to start exe from Google Chrome browser

Step by step:

First you need to download and install the distribution https://www.autohotkey.com/ on computer where you need start exe app from browser.

Secondly, you need run the "appurl.reg" file in the registry where the exe app startup script from the browser is located.

Thirdly, put two files "appurl.exe" and "appurl.ahk" along the path "C:\Program Files\AutoHotKey\"
appurl.ahk - this is the source from which appurl.exe

In the fourth, in the browser, create a new bookmark and in the name use any name and in the address url write:

if you run from rdp session from disk E:\
appurl:////tsclient//E//myapp.exe    

or

if you run from local folder:  
 appurl://C:/usr/myapp.cmd    

myapp.cmd - as example is present
