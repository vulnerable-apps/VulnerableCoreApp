# Use the latest supported .NET 6 SDK
FROM mcr.microsoft.com/dotnet/sdk:8.0 AS build-env
WORKDIR /src

# Copy and restore dependencies
COPY *.csproj ./
RUN dotnet restore

# Copy the remaining application files and build the project
COPY . ./
RUN dotnet publish -c Release -o /publish

# Use the ASP.NET runtime image for production (lighter than SDK)
FROM mcr.microsoft.com/dotnet/aspnet:8.0 AS runtime
WORKDIR /app
COPY --from=build-env /publish ./
EXPOSE 80
ENTRYPOINT ["dotnet", "VulnerableCoreApp.dll"]
