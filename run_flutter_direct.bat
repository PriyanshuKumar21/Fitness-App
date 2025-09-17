@echo off
echo Running Flutter app on Windows with verbose output...
cd /d %~dp0
flutter run -d windows --verbose > flutter_log.txt 2>&1
echo Done. Check flutter_log.txt for details.
pause 