На некоторых серверах на базе Windows Server 2012 R2 с ролью сервера печати была замечена проблема со службой "Print Spooler",
возникающая плавающим образом. На этапе загрузки сервера от системы мониторинга SCOM приходила масса оповещений однотипного характера "Alert: Shared Printer Availability Alert".


Изучение Event-логов этих серверов показало, что система мониторинга реагирует на ошибки с Event ID 315:

```
Log Name:      Microsoft-Windows-PrintService/Admin
Source:        Microsoft-Windows-PrintService
Event ID:      315
Task Category: Sharing a printer
Level:         Error
Keywords:      Classic Spooler Event,Printer
User:          SYSTEM
Computer:      SRV-PRN01.holding.com
Description:   The print spooler failed to share printer PR050 with shared resource name PR050. Error 2114. The printer cannot be used by others on the network.
```
Замечено было, что подобная ошибка генерировалась для каждого сетевого принтера, подключённого к серверу печати и опубликованного пользователям сети.

Описание этой ошибки можно найти в статье Event 315 with error 2114 on startup, где обозначено, 
что проблема может возникать по той причине, что служба "Print Spooler" (Spooler) пытается "расшарить" сетевые принтеры раньше, 
чем инициализировалась служба "Server" (LanmanServer). Здесь даются рекомендации проверять зависимости службы "Server" на предмет присутствия нестандартных служб, 
которые могут увеличивать время запуска этой службы. Но в нашем случае ничего подозрительного в конфигурации службы "Server" обнаружено не было.

Дальнейший анализ Event-лога "System" подтвердил то, что ошибки возникают только в том случае, 
если при запуске сервера служба "Print Spooler" запустилась по времени на несколько секунд раньше службы "Server".

Одним из вариантов разрешения такой ситуации может стать настройка явной зависимости службы "Print Spooler" от службы "Server". 
То есть, нам нужно сделать так, чтобы служба "Print Spooler" запускалась только после запуска службы "Server". 
При этом следует понимать и то, что создание такой зависимости между службами приведёт также к тому, что при остановке службы "Server" будет останавливаться служба "Print Spooler".

Настроить зависимость между службами можно разными способами. Мы рассмотрим 2 примера – помощью утилиты sc и с помощью PowerShell.

При использовании утилиту sc запросить информацию о текущем состоянии зависимостей службы можно следующей командой:

```
sc qc spooler
```


Как видим, у службы уже есть зависимость от двух служб ("RPCSS" и "http"). Добавить дополнительную зависимость можно следующим образом:

```
sc config spooler depend= RPCSS/http/LanmanServer
```


Теперь можем заглянуть в оснастку управления службами services.msc и убедиться в том, 
что там для службы "Print Spooler" теперь отображается информация о зависимости от службы "Server"


Аналогичную настройку зависимостей службы можно выполнить с помощью PowerShell.

Чтобы запросить информацию о текущих зависимостях службы, выполним:

```
Get-Service "Print Spooler" -RequiredServices
```
Изменить перечень служб, от которых зависит данная служба с помощью PowerShell можно, например, через правку параметров системного реестра:

```
Set-ItemProperty -Path "HKLM:\SYSTEM\CurrentControlSet\Services\Spooler" -Name DependOnService -Value @("RPCSS","http","LanmanServer")
```


После изменения настройки зависимостей службы "Print Spooler" перезагрузим сервер и снова проанализируем Event-лог "System". 
Убедимся в том, что служба "Print Spooler" действительно запускается только после запуска службы "Server",
а в логе службы печати отсутствуют ошибки "The print spooler failed to share printer…".
