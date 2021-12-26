# using assembly OpenCvSharp.dll
# using assembly OpenCvSharp.Extensions.dll
# using assembly System.Drawing.Common.dll

###
### Prepare these DLLs:
### (Maybe you sholud adapt to your version of Powershell.)
###
### 1. Create an empty project targeting .NET Framework 4.6.1
### 2. Install "OpenCvSharp4" and "OpenCvSharp4.runtime.win" from NuGet.
### 3. Find DLLs from "package" folder of the project directory. (Usually stored in the each "lib" folder.)
###
### - opencv_videoio_ffmpeg453_64.dll
### - OpenCvSharp.dll
### - OpenCvSharp.Extensions.dll
### - OpenCvSharpExtern.dll
### - System.Drawing.Common.dll
###

class TinyCapture {

    # Object only holds device index, therefore creates a OpenCvSharp.VideoCapture instance each time it is needed.
    # This strategy is not as fast, but it will prevent the device from being locked.
    [int] hidden $_Index

    [int] $Width
    [int] $Height

    TinyCapture([int] $Index) {$this._TinyCapture($Index, 1920, 1080)}
    TinyCapture([int] $Index, [int] $Width, [int] $Height) {$this._TinyCapture($Index, $Width, $Height)}
    [void] hidden _TinyCapture([int] $Index, [int] $Width, [int] $Height) {
        $this._Index = $Index
        $this.Width = $Width
        $this.Height = $Height

        [OpenCvSharp.VideoCapture] $capture = [OpenCvSharp.VideoCapture]::new($this._Index, [OpenCvSharp.VideoCaptureAPIs]::DSHOW)
        if(!$capture.IsOpened()) {
            $capture.Release()
            throw [System.Exception]::new("The specified device index is invalid.")
        }
        $capture.Release()
    }

    [string] GetImage() {return $this.GetImage("$((Get-Date).ToString('yyyyMMddHHmmss')).png")}
    [string] GetImage([string] $Filename) {

        Write-Debug "TinyCapture.GetImage()"

        [OpenCvSharp.VideoCapture] $capture = [OpenCvSharp.VideoCapture]::new($this._Index, [OpenCvSharp.VideoCaptureAPIs]::DSHOW)
        if(!$capture.IsOpened()) {
            $capture.Release()
            throw [System.Exception]::new("The specified device index is invalid.")
        }

        [OpenCvSharp.Mat] $frame = [OpenCvSharp.Mat]::new()
        $capture.FrameWidth = $this.Width
        $capture.FrameHeight = $this.Height

        if(!$capture.Read($frame)) {
            $capture.Release()
            throw [System.Exception]::new("Could not read from capture device.")
        }

        [OpenCvSharp.Extensions.BitmapConverter]::ToBitmap($frame).Save($Filename)
        trap {
            $capture.Release()
            throw [System.Exception]::new("Failed to save image.")
        }

        $capture.Release()
        return $Filename
    }
}