# Build stage
FROM mcr.microsoft.com/dotnet/sdk:10.0 AS build
WORKDIR /src

# Eerst enkel de csproj-bestanden, zodat 'restore' gecachet blijft
COPY src/Rise.Server/Rise.Server.csproj src/Rise.Server/
COPY src/Rise.Client/Rise.Client.csproj src/Rise.Client/
COPY src/Rise.Persistence/Rise.Persistence.csproj src/Rise.Persistence/
COPY src/Rise.Services/Rise.Services.csproj src/Rise.Services/
COPY src/Rise.Shared/Rise.Shared.csproj src/Rise.Shared/
COPY src/Rise.Domain/Rise.Domain.csproj src/Rise.Domain/
RUN dotnet restore src/Rise.Server/Rise.Server.csproj

COPY . .
RUN dotnet publish src/Rise.Server/Rise.Server.csproj -c Release -o /app --no-restore

# Runtime stage
FROM mcr.microsoft.com/dotnet/aspnet:10.0 AS runtime
WORKDIR /app
COPY --from=build /app .

EXPOSE 8080
ENV ASPNETCORE_URLS=http://+:8080
ENTRYPOINT ["dotnet", "Rise.Server.dll"]