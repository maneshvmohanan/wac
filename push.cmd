@echo off
echo.
echo.
echo.

@echo off
set /p msg=Enter changes message: 
echo %msg%

git add .
git commit -m "%msg%"
git push

echo.
echo.
echo Script execution completed...
echo.
pause
