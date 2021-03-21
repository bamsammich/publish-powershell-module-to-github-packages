
FROM microsoft/powershell

RUN apt-get update \
    && apt-get install apt-transport-https wget --yes \
    && wget https://packages.microsoft.com/config/ubuntu/18.04/packages-microsoft-prod.deb -O packages-microsoft-prod.deb \
    && dpkg -i packages-microsoft-prod.deb \
    && apt-get update \
    && apt-get install --yes dotnet-sdk-3.1

ADD "entrypoint.ps1" "/data/"
RUN chmod +x /data/entrypoint.ps1

ENTRYPOINT ["pwsh", "/data/entrypoint.ps1"]