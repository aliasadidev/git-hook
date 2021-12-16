#See https://aka.ms/containerfastmode to understand how Visual Studio uses this Dockerfile to build your images for faster debugging.

FROM mcr.microsoft.com/dotnet/aspnet:5.0-buster-slim AS base
WORKDIR /app
EXPOSE 80

FROM mcr.microsoft.com/dotnet/sdk:5.0-buster-slim AS build
WORKDIR /src
#COPY packages /root/.nuget/packages for local test

COPY ["src/", "src/"]
RUN dotnet restore "src/HookApi/HookApi.csproj" --disable-parallel
#--disable-parallel
COPY . .

WORKDIR "src/HookApi"
FROM build AS publish
RUN dotnet publish "HookApi.csproj" -c Release -o /app/publish

FROM base AS final
WORKDIR /app
COPY --from=publish /app/publish .
ENTRYPOINT ["dotnet", "HookApi.dll"]
