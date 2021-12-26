using assembly OpenCvSharp.dll
using assembly OpenCvSharp.Extensions.dll
using assembly System.Drawing.Common.dll
using module TinyCapture\

function Test-TinyCapture {

    # Successfully create the object.
    [TinyCapture] $capture = [TinyCapture]::new(0)

    # Initialize with $Width and $Height.
    [TinyCapture] $capture = [TinyCapture]::new(0, 1600, 1200)

    # Failed to create the object.
    try {
        [TinyCapture] $capture = [TinyCapture]::new(666)
    }
    catch {
        # Write-Output "OK"
    }
    
    # Take a picture.
    [TinyCapture] $capture = [TinyCapture]::new(0, 1600, 1200)
    [string] $filename = $capture.GetImage()

    # Take a picture with a filename.
    $filename = $capture.GetImage("test.png")

    # Failed to save a picture with an invalid filename.
    try {
        $capture.GetImage("\/:*?`"<>|.png")
    }
    catch {
        # Write-Output "OK"
    }
}

Test-TinyCapture