# Stage 1: Build
FROM mcr.microsoft.com/dotnet/sdk:8.0 AS build
WORKDIR /src

# Copiar el archivo de proyecto y restaurar dependencias (Optimization: Layer Caching)
COPY *.csproj ./
RUN dotnet restore

# Copiar el resto del código y compilar
COPY . .
RUN dotnet publish -c Release -o /app/publish /p:UseAppHost=false

# Stage 2: Runtime
FROM mcr.microsoft.com/dotnet/aspnet:8.0 AS final
WORKDIR /app

# Exponer el puerto por defecto de .NET 8 (8080)
EXPOSE 8080

# Copiar los binarios desde el stage de build
COPY --from=build /app/publish .

# Comando de inicio
ENTRYPOINT ["dotnet", "MyApp.dll"]
