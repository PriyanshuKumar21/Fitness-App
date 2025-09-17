@echo off
echo Running Fixed Fitness App on Samsung Android device...
echo Using Android 15 compatibility with fitness_app1 flavor

:: Get list of connected devices
flutter devices > devices_list.txt

:: Run on the Samsung device if available
for /f "tokens=*" %%i in ('findstr "SM S921B" devices_list.txt') do (
  echo Found Samsung device: %%i
  flutter run -d RZCX30EN3KE --flavor fitness_app1
  goto :end
)

:: Fallback to any Android device
echo Samsung device not found, trying any Android device...
flutter run -d android --flavor fitness_app1

:end
del devices_list.txt
pause 