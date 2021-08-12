#!/bin/bash

echo "on-create start" >> ~/status

# run dotnet restore
dotnet restore weather/weather.csproj 

# copy grafana.db to /grafana
sudo rm -f /grafana/grafana.db
sudo cp deploy/grafanadata/grafana.db /grafana
sudo chown -R 472:472 /grafana

echo "on-create complete" >> ~/status
