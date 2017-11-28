# cx-crt

*cx-crt* is a module for CerberusX that makes it possible to render graphics into a configurable virtual crt monitor.

<p align="center">
  <img src="https://i.imgur.com/7q1E9mD.jpg" alt="image: crt module">
</p>

## Installation

1. copy the folder `crt` into your CerberusX `modules_ext` folder (`YOUR-CERBERUS-X-PATH/modules_ext/`)

2. rebuild your documentation:

        Menu bar > Help > Rebuild Help

## Code Example

The following example code creates a virtual crt screen and renders a circle at its center:

```monkey
Import mojo2
Import crt

#GLFW_WINDOW_TITLE="crt example"
#GLFW_WINDOW_WIDTH=640
#GLFW_WINDOW_HEIGHT=480

Class MyApp Extends App
    Field canvas:Canvas
    Field crt:GraphicsCRT
    
    Method OnCreate()
        canvas = New Canvas
        
        ' initialize crt screen:
        crt = New GraphicsCRT(160, 120)
    End
    
    Method OnRender()
        ' clear screen and render circle:
        crt.Canvas.Clear()
        crt.Canvas.SetColor(1, 1, 1)
        crt.Canvas.DrawCircle(crt.ResolutionX/2, crt.ResolutionY/2, 50)
        
        ' draw crt screen on main canvas:
        crt.DrawScreen(canvas, 0, 0, DeviceWidth(), DeviceHeight())
        
        canvas.Flush()
    End
End

Function Main()
    New MyApp
End
```

The result should look like this:

<p align="center">
  <img src="https://i.imgur.com/77Z3e55.jpg" alt="image: example application">
</p>
