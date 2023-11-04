Add-Type -AssemblyName System.Drawing

# Set default values
$defaultQuality = 80
$defaultResizeMethod = 'percent'
$defaultResizePercent = 50  # Default resize to 50% if percentage method is chosen

# Prompt the user for resizing option with default as percentage
$resizingOption = Read-Host -Prompt 'Enter "width" to specify maximum width or "percent" to resize by percentage (default: percent)'
if ($resizingOption -eq '') {
    $resizingOption = $defaultResizeMethod
}

# Based on the user input or default, either ask for maximum width or percentage
if ($resizingOption -eq "width") {
    $maxWidth = Read-Host -Prompt 'Enter the maximum width for the images'
    if ($maxWidth -eq '') {
        Write-Host "No width entered. Exiting script."
        exit
    }
    $maxWidth = [int]$maxWidth
}
else {
    $resizePercent = Read-Host -Prompt "Enter the resize percentage (default: $defaultResizePercent%)"
    if ($resizePercent -eq '') {
        $resizePercent = $defaultResizePercent
    }
    $resizePercent = [int]$resizePercent / 100.0
}

# Prompt the user for the desired image quality with default
$imageQuality = Read-Host -Prompt "Enter the desired image quality (1-100, default: $defaultQuality)"
if ($imageQuality -eq '') {
    $imageQuality = $defaultQuality
}
$imageQuality = [math]::Max(1, [math]::Min([int]$imageQuality, 100))

# Prompt for a new base filename
$newBaseFileName = Read-Host -Prompt 'Enter the new base filename (without extension)'

# Get the path to the current directory where the PowerShell script is located
$scriptPath = Split-Path -Path $MyInvocation.MyCommand.Definition -Parent

# Get all image files in the script directory
$imageFiles = Get-ChildItem -Path $scriptPath -Filter *.jpg

$i = 1
foreach ($file in $imageFiles) {
    # Load the image
    $image = [System.Drawing.Image]::FromFile($file.FullName)

    # Calculate the new dimensions
    if ($resizingOption -eq "width") {
        $ratio = $image.Width / $image.Height
        $newWidth = [math]::Min($maxWidth, $image.Width)
        $newHeight = $newWidth / $ratio
    }
    else {
        # default to percentage
        $newWidth = [int]($image.Width * $resizePercent)
        $newHeight = [int]($image.Height * $resizePercent)
    }

    # Create the resized image
    $newImage = New-Object System.Drawing.Bitmap $newWidth, $newHeight
    $graphic = [System.Drawing.Graphics]::FromImage($newImage)
    $graphic.DrawImage($image, 0, 0, $newWidth, $newHeight)

    # Encoder parameter for image quality
    $encoderInfo = [System.Drawing.Imaging.ImageCodecInfo]::GetImageEncoders() | Where-Object { $_.MimeType -eq 'image/jpeg' }
    $encoderParams = New-Object System.Drawing.Imaging.EncoderParameters(1)
    $encoderParams.Param[0] = New-Object System.Drawing.Imaging.EncoderParameter([System.Drawing.Imaging.Encoder]::Quality, $imageQuality)

    # Save the new image with the specified quality and filename
    $newFileName = "{0}-{1}.jpg" -f $newBaseFileName, $i
    $newImagePath = [System.IO.Path]::Combine($scriptPath, $newFileName)
    $newImage.Save($newImagePath, $encoderInfo, $encoderParams)

    # Dispose of the objects to free up resources
    $graphic.Dispose()
    $newImage.Dispose()
    $image.Dispose()

    # Increment the image number
    $i++
}

Write-Host "Resizing and quality adjustment completed with new filenames."
