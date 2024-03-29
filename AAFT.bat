<# : chooser.bat
::################################################################################
::# Assisted or Automatic Tomogram Flattening
::#
::# Batch script for running IMOD/Etomo executables for the tomogram flattening
::#
::# (c) 2019 Kiewisz
::# This code is licensed under GPL V3.0 license (see LICENSE.txt for details)
::#
::# Author: Robert Kiewisz
::# Created: 2020-11-07
::################################################################################

<# : chooser.bat
::# https://stackoverflow.com/a/15885133/1683264
::# https://bio3d.colorado.edu/imod/
Title AATF
setlocal
cls
@echo off

:MENU
ECHO #############################################
ECHO # Assisted or Automatic Tomogram Flattening #
ECHO #############################################
ECHO (c) 2019 Kiewisz
ECHO This code is licensed under GPL V3.0 license (see LICENSE.txt for details)
ECHO.
ECHO.
ECHO This script running IMOD executables and allows for the assisted automated 
ECHO flattening.
ECHO.
ECHO The Automatic flattening with the 'standard settings' is sufficient for the
ECHO majority of the samples with good quality.
ECHO.
ECHO The assisted flattening allows for automatic generation of the surface model
ECHO and quick/easy fixing it before running flattening with 'warpvol'
ECHO.
ECHO ..........................................................................
ECHO PRESS 1, 2 to select your task or 3 to EXIT.
ECHO ..........................................................................
ECHO.
ECHO.
ECHO 1 - Run fully-automated tomography flattening
ECHO 2 - Run manual tomography flattening
ECHO 3 - Exit
ECHO.

SET /P M=Select number then press ENTER:

IF %M%==1 GOTO AUTO
IF %M%==2 GOTO SETTING
IF %M%==3 GOTO EOF
cls

::## Set up a parameaters for 'findsection'
:SETTING

::## Set up a size of the scaler for 'findsection'
ECHO #############################################
ECHO # Assisted or Automatic Tomogram Flattening #
ECHO #############################################
ECHO (c) 2019 Kiewisz
ECHO This code is licensed under GPL V3.0 license (see LICENSE.txt for details)
ECHO.
ECHO.
ECHO ..........................................................................
ECHO Select box sizes
ECHO.
ECHO This option can be used to specify how many default binnings to analyze, 
ECHO instead of entering each one with the -binning option. These binnings are 
ECHO isotropic (the same in each dimension).  The default binnings available are 
ECHO 1, 2, 3, 4, 6, 8, 12, 16, 24, 32, 48, and 64. The default is to do a single
ECHo scale at binning 12.
ECHO.
ECHO.
ECHO Select size of boxes in XYZ
ECHO 1  - Unbin scaler
ECHO 2  - Use when you want to generate even more bins
ECHO 4  - Use when you want to generate more bins
ECHO 12 - 'Standard setting' - Works well for majority of flattening jobs
ECHO ..........................................................................
ECHO.
ECHO.
set /p SCALE=Enter size:
cls

::## Set up a size of the box for 'findsection'
ECHO #############################################
ECHO # Assisted or Automatic Tomogram Flattening #
ECHO #############################################
ECHO (c) 2019 Kiewisz
ECHO This code is licensed under GPL V3.0 license (see LICENSE.txt for details)
ECHO.
ECHO.
ECHO ..........................................................................
ECHO Select patch sizes
ECHO.
ECHO Size in X, Y, and Z of boxes in which to measure mean and SD, in binned 
ECHO pixels.  This option can be entered multiple times, up to once per each 
ECHO scaling, but one entry seems to be sufficient. For scalings past the last 
ECHO one for which a size was entered, the size in each dimension will be set to 
ECHO span about the same extent in unbinned pixels as for the last binning for 
ECHO which size was entered. The entry is required. (Successive entries accumulate)
ECHO.
ECHO.
ECHO Select size of boxes in XYZ
ECHO 16,16,1 - Suggested for a dataset with high contrast and very good quality
ECHO 32,32,1 - 'Standard setting'
ECHO 64,64,1 - Suggested for data with low contrast. (Higher value can be use)
ECHO 64,64,10 - Allows to bin stack in Z for higher accuracy with low contrast data
ECHO ..........................................................................
ECHO.
ECHO.
set /p SIZE=Enter patch size:
cls

::## Set up a tomogram  sampling for 'findsection'
ECHO #############################################
ECHO # Assisted or Automatic Tomogram Flattening #
ECHO #############################################
ECHO (c) 2019 Kiewisz
ECHO This code is licensed under GPL V3.0 license (see LICENSE.txt for details)
ECHO.
ECHO.
ECHO ..........................................................................
ECHO Select a sampling size:
ECHO.
ECHO Number of positions to sample in a single tomogram to obtain lines for 
ECHO Tomopitch.  The position and spacing between these samples is determined by 
ECHO their number, the sample extent, and the total number of blocks of analyzed 
ECHO boxes in Y.
ECHO ..........................................................................
ECHO.
ECHO.
ECHO Select of sampling positions
ECHO 5 - 'Standard setting'
ECHO.
set /p SAMPLE=Enter sampling:
cls

::## Set up a tomogram  block size for 'findsection'
ECHO #############################################
ECHO # Assisted or Automatic Tomogram Flattening #
ECHO #############################################
ECHO (c) 2019 Kiewisz
ECHO This code is licensed under GPL V3.0 license (see LICENSE.txt for details)
ECHO.
ECHO.
ECHO ..........................................................................
ECHO Select a block size:
ECHO.
ECHO Size of block in which to consolidate the boxes for further analysis, 
ECHO in unbinned pixels.  If this option is not entered, the program will start 
ECHO with a size of 100 pixels, or 200 if making a surface model, and then 
ECHO increase the size to get an equivalent area if there are too few boxes in 
ECHO one direction (specifically, when using multiple tomogram samples, the size 
ECHO generally gets increased to ~300). If the option is entered, the number
ECHO is used as is, without such an adjustment.
ECHO ..........................................................................
ECHO.
ECHO.
ECHO Select of sampling positions
ECHO 48 - 'Standard setting'
ECHO.
set /p BLOCK=Enter block size:
cls

::## Set up a tomogram  axis for 'findsection'
ECHO #############################################
ECHO # Assisted or Automatic Tomogram Flattening #
ECHO #############################################
ECHO (c) 2019 Kiewisz
ECHO This code is licensed under GPL V3.0 license (see LICENSE.txt for details)
ECHO.
ECHO.
ECHO ..........................................................................
ECHO Select a tomogram axis:
ECHO.
ECHO Rotation angle from Y axis to tilt axis in the raw tilt series,
ECHO counterclockwise positive.  With this entry, the program will
ECHO avoid analyzing regions outside the area that can be well-recon-
ECHO structed from the original images.  However, the correct region
ECHO is identified only if the aligned stack and reconstruction were
ECHO centered on the original tilt series.
ECHO ..........................................................................
ECHO.
ECHO.
set /p AXIS=Enter axis:
cls

::## Set up a smoothing factor for 'flattenwarp'
ECHO #############################################
ECHO # Assisted or Automatic Tomogram Flattening #
ECHO #############################################
ECHO (c) 2019 Kiewisz
ECHO This code is licensed under GPL V3.0 license (see LICENSE.txt for details)
ECHO.
ECHO.
ECHO ..........................................................................
ECHO Select the lambda (smoothing) factor:
ECHO.
ECHO One or more values to control the amount of smoothing in the
ECHO thin plate spline (TPS).  The values are the log of the lambda
ECHO parameter.  If one value is entered, the program will go on to
ECHO compute warping transforms.  If multiple values are entered in
ECHO order to assess their effect, an output model must be specified
ECHO with -middle, but no transforms will be computed and no output
ECHO file is needed for them.  Values varying in steps of 0.5 will
ECHO produce useful changes in smoothing.  Negative values are just
ECHO as meaningful as positive ones.
ECHO.
ECHO.
ECHO Select smoothing factor:
ECHO 1 - No smoothing
ECHO 2 - 'Standard setting'
ECHO 3 - Introduce more smoothing for highly warped tomogram
ECHO     but also introduce more smoothing artifacts.
ECHO 4 >= - Higher smoothing value used only for highly deform tomograms
ECHO ..........................................................................
ECHO.
ECHO.
set /p LAMBDA=Enter size:
cls

IF %M%==2 GOTO ASSIST

::## Full-automatic tomogram flattening
:AUTO

::## Set up a tomogram  axis for 'findsection'
ECHO #############################################
ECHO # Assisted or Automatic Tomogram Flattening #
ECHO #############################################
ECHO (c) 2019 Kiewisz
ECHO This code is licensed under GPL V3.0 license (see LICENSE.txt for details)
ECHO.
ECHO.
ECHO ..........................................................................
ECHO Select a tomogram axis:
ECHO.
ECHO Rotation angle from Y axis to tilt axis in the raw tilt series,
ECHO counterclockwise positive.  With this entry, the program will
ECHO avoid analyzing regions outside the area that can be well-recon-
ECHO structed from the original images.  However, the correct region
ECHO is identified only if the aligned stack and reconstruction were
ECHO centered on the original tilt series.
ECHO ..........................................................................
ECHO.
ECHO.
set /p AXIS=Enter axis:
cls

for /f "delims=" %%I in ('powershell -noprofile "iex (${%~f0} | out-string)"') do (
    Title AATF %%~I

    findsection -scal 12 -size 32,32,1 -axis %AXIS% -surf %%~I_flat.mod %%~I
    flattenwarp -lambda %LAMBDA% %%~I_flat.mod %%~I_flat.xf
    warpvol -InputFile %%~I -OutputFile %%~I_flat.rec -TransformFile %%~I_flat.xf -SameSizeAsInput
	
    del /f %%~I_flat.xf
    cls
)
goto :EOF

::## Assist tomogram flattening
:ASSIST

for /f "delims=" %%I in ('powershell -noprofile "iex (${%~f0} | out-string)"') do (
    Title AATF %%~I

    findsection -scal %SCALE% -size %SIZE% -axis %AXIS% -samples %SAMPLE% -block %BLOCK% -surf %%~I_flat.mod %%~I
    START /WAIT 3dmod -Y %%I %%~I_flat.mod
    flattenwarp -lambda %LAMBDA% %%~I_flat.mod %%~I_flat.xf
    warpvol -InputFile %%~I -OutputFile %%~I_flat.rec -TransformFile %%~I_flat.xf -SameSizeAsInput
	
    del /f %%~I_flat.xf
    cls
)
goto :EOF

: end Batch portion / begin PowerShell hybrid chimera #>
Add-Type -AssemblyName System.Windows.Forms
$f = new-object Windows.Forms.OpenFileDialog
$f.InitialDirectory = pwd
$f.Filter = "Tomo Files (*.rec)|*.rec|All Files (*.*)|*.*"
$f.ShowHelp = $true
$f.Multiselect = $true
[void]$f.ShowDialog()
if ($f.Multiselect) { $f.FileNames } else { $f.FileName }
