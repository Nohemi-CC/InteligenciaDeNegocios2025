## Comando para ejecutar en linux
```docker
docker run -e "ACCEPT_EULA=Y" -e "MSSQL_SA_PASSWORD=Mipassw0rd123!" \
-p 1422:1433 --name sqlserverBI \
-v sqlserver-volume:/var/opt/mssql \
-d mcr.microsoft.com/mssql/server:2025-latest

```

## Comando para ejecutar en windows
```docker
docker run -e "ACCEPT_EULA=Y" -e "MSSQL_SA_PASSWORD=Mipassw0rd123!" `
-p 1422:1433 --name sqlserverBI2 `
-v sqlserver-volume:/var/opt/mssql `
-d sha256:b1395aa51b4ec39981883560f1379ea9eba2a1c0719bf8e6477902769316bb79
```
