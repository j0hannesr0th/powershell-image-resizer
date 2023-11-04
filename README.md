# Image Resizer PowerShell Script

This PowerShell script is designed to resize images in the directory where the script is located. It offers the flexibility to resize images either by specifying the maximum width or by a percentage of the original size. Additionally, users can set the image quality for the output files.

## Requirements

- Windows Operating System with PowerShell.
- .NET Framework (already included in Windows).

## Usage

1. Place the `resize.ps1` script in the folder containing the `.jpg` images you want to resize.

2. Open PowerShell and navigate to the directory containing your images and the script.

3. If you haven't previously set your execution policy to allow scripts to run, you will need to do so by running PowerShell as Administrator and executing the following command: `Set-ExecutionPolicy RemoteSigned` and choose 'Yes' to allow the change.

4. Execute the script by typing: `.\resize.ps1`

5. Follow the on-screen prompts:
- Enter `"width"` to specify maximum width or `"percent"` to resize by percentage. If you press Enter without typing a value, it will default to percentage resizing (50% reduction).
- If you chose `"width"`, enter the maximum width for the images. Otherwise, enter the resize percentage.
- Enter the desired image quality (1-100). The default is 80 if no value is entered.
- Enter the new base filename (without extension). The script will append a number to each file it creates.

The script will process all `.jpg` images in the same folder, resize them according to the specified parameters, and save the new images with the designated quality and filenames.

## Script Output

- Resized images will be saved in the same directory as the script.
- Each new image will have a filename in the format: `<newBaseFileName>-<number>.jpg`.

## Note

The script currently supports only `.jpg` files. Ensure that you have a backup of your images before running the script, as the resizing process is not reversible.
