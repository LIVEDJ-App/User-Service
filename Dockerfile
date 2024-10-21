FROM mcr.microsoft.com/dotnet/aspnet:8.0 AS base
WORKDIR /app
EXPOSE 5030

FROM mcr.microsoft.com/dotnet/sdk:8.0 AS build
ARG BUILD_CONFIGURATION=Development
WORKDIR /src

COPY ["User.Api/User.Api.csproj", "User.Api/"]
COPY ["User.Application/User.Application.csproj", "User.Application/"]
COPY ["User.Domain/User.Domain.csproj", "User.Domain/"]
COPY ["User.Persistence/User.Persistence.csproj", "User.Persistence/"]

RUN dotnet restore "User.Api/User.Api.csproj"

COPY . .
WORKDIR "/src/User.Api"
RUN dotnet build "User.Api.csproj" -c $BUILD_CONFIGURATION -o /app/build

FROM build AS publish
ARG BUILD_CONFIGURATION=Development
RUN dotnet publish "User.Api.csproj" -c $BUILD_CONFIGURATION -o /app/publish

FROM base AS final
WORKDIR /app
COPY --from=publish /app/publish .
ENTRYPOINT ["dotnet", "User.Api.dll"]
