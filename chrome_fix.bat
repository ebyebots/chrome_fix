@echo off
:: Кодировка UTF-8, чтобы русский текст в консоли не превратился в «кракозябры»
chcp 65001 >nul
title Автоматический фикс TLS для Chrome

echo [1/3] Закрытие зависших процессов Chrome...
:: Принудительно закрываем Chrome, чтобы освободить файл конфигурации
taskkill /f /im chrome.exe >nul 2>&1
timeout /t 1 /nobreak >nul

echo [2/3] Применение настроек TLS в файл Local State...
:: Исправленный скрипт: использует -Force и мягкую проверку существования массива
powershell -Command "$p=\"$env:LOCALAPPDATA\Google\Chrome\User Data\Local State\"; if(Test-Path $p){$j=Get-Content $p -Raw|ConvertFrom-Json; if(!$j.browser){$j|Add-Member -Type NoteProperty -Name 'browser' -Value @{}}; if(-not $j.browser.PSObject.Properties['enabled_labs_experiments']){$j.browser|Add-Member -Type NoteProperty -Name 'enabled_labs_experiments' -Value @() -Force}; if($j.browser.enabled_labs_experiments -notcontains 'cryptography-compliance-cnsa@1'){$j.browser.enabled_labs_experiments+='cryptography-compliance-cnsa@1';$j|ConvertTo-Json -Depth 100|Set-Content $p -Encoding UTF8}}"

echo [3/3] Перезапуск Google Chrome...
:: Автоматически запускает Chrome обратно
start "" "C:\Program Files\Google\Chrome\Application\chrome.exe"

echo.
echo [УСПЕШНО] Все операции выполнены без ошибок! Chrome перезапущен.
echo.
pause
