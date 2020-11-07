################################################################################
# Assisted or Automatic Tomogram Flattening
#
# Batch script for running IMOD/Etomo executables for the tomogram flattening
#
# (c) 2019 Kiewisz
# This code is licensed under GPL V3.0 license (see LICENSE.txt for details)
#
# Author: Robert Kiewisz
# Created: 2020-11-07
################################################################################

<# : chooser.bat
Title AATF
setlocal
cls

@echo off
:MENU
ECHO.
ECHO Assisted or Automatic Tomogram Flattening
ECHO.
ECHO This script running IMOD executables and allows for the assisted automated 
ECHO flattening.
ECHO.
ECHO ..........................................................................
ECHO PRESS 1, 2 to select your task or 3 to EXIT.
ECHO ..........................................................................
ECHO.
ECHO.
ECHO 1 - Run fully-automated tomography flattening
ECHO 2 - Run assisted tomography flattening
ECHO 3 - EXIT
ECHO.

SET /P M=Select number then press ENTER:

IF %M%==3 GOTO EOF
cls

ECHO.
ECHO Assisted or Automatic Tomogram Flattening
ECHO.
ECHO ..........................................................................
ECHO Do you want to modify the standard parameters used for 'findsection'?
ECHO ..........................................................................
ECHO.
ECHO.
ECHO 1 - Yes
ECHO 2 - No
ECHO.

SET /P S=Select number then press ENTER:

cls
IF %S%==1 GOTO SETTING
IF %S%==2 IF %M%==1 GOTO AUTO
IF %S%==2 IF %M%==2 GOTO ASSIST

## Set up a parameaters for 'findsection'
:SETTING

## Set up a size of the box for 'findsection'
ECHO.
ECHO Assisted or Automatic Tomogram Flattening
ECHO.
ECHO ..........................................................................
ECHO Select box sizes
ECHO.
ECHO Size in X, Y, and Z of boxes in which to measure mean and SD, in
ECHO binned pixels.  This option can be entered multiple times, up to
ECHO once per each scaling, but one entry seems to be sufficient.
ECHO For scalings past the last one for which a size was entered, the
ECHO size in each dimension will be set to span about the same extent
ECHO in unbinned pixels as for the last binning for which size was
ECHO entered. The entry is required.  (Successive entries accumulate)
ECHO.
ECHO.
ECHO Select size of boxes in XYZ
ECHO 16,16,1 - suggested for a dataset with high contrast
ECHO 32,32,1 - standard setting
ECHO 64,64,1 - or higher is suggested for data with low contrast
ECHO 64,64,10 - allows to bin stack in Z for higher accuracy
ECHO ..........................................................................
ECHO.
ECHO.
set /p SIZE=Enter size:
ECHO.
cls

## Set up a tomogram  axis for 'findsection'
ECHO.
ECHO Assisted or Automatic Tomogram Flattening
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
ECHO.
cls

## Set up a smoothing factor for 'flattenwarp'
ECHO.
ECHO Assisted or Automatic Tomogram Flattening
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
ECHO 1    - No smoothing
ECHO 2    - Standard setting
ECHO 3 >= - Introduce more smoothing for highly warped tomogram, 
ECHO         but also introduce more smoothing artifacts.
ECHO ..........................................................................
ECHO.
ECHO.
set /p LAMBDA=Enter size:
ECHO.
cls

IF %M%==1 GOTO AUTO
IF %M%==2 GOTO ASSIST

## Full-automatic tomogram flattening
GOTO MENU
:AUTO

for /f "delims=" %%I in ('powershell -noprofile "iex (${%~f0} | out-string)"') do (
    Title AATF %%~I
	
    findsection -scal 12 -size %SIZE% -axis %AXIS% -surf %%~I_flat.mod %%~I
    flattenwarp -lambda %LAMBDA% %%~I_flat.mod %%~I_flat.xf
    warpvol -InputFile %%~I -OutputFile %%~I_flat.rec -TransformFile %%~I_flat.xf -SameSizeAsInput
	
    del /f %%~I_flat.xf
    cls
)
goto :EOF

## Assist tomogram flattening
GOTO MENU
:ASSIST

for /f "delims=" %%I in ('powershell -noprofile "iex (${%~f0} | out-string)"') do (
    Title AATF %%~I
	
    findsection -scal 12 -size %SIZE% -axis %AXIS% -surf %%~I_flat.mod %%~I
    START /WAIT 3dmod -Y %%I %%~I_flat.mod
    flattenwarp -lambda %LAMBDA% %%~I_flat.mod %%~I_flat.xf
    warpvol -InputFile %%~I -OutputFile %%~I_flat.rec -TransformFile %%~I_flat.xf -SameSizeAsInput
	
    del /f %%~I_flat.xf
    cls
)
goto :EOF

GOTO MENU
:EOF

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
