#!/usr/bin/env bash
# Script for getting current weather info
# You need to specify OPENWEATHER_KEY, OPENWEAHER_CITY_ID
# and OPENWEATHER_UNITS somewhere in your environment

weather=$(curl -sf "http://api.openweathermap.org/data/2.5/weather?appid=$OPENWEATHER_KEY&id=$OPENWEATHER_CITY_ID&units=$OPENWEATHER_UNITS")

if [ -z "$weather" ]; then
    exit
fi

city=$(echo $weather | jq -r ".name")
temperature=$(echo $weather | jq ".main.temp" | cut -d "." -f 1)
feels_like=$(echo $weather | jq ".main.feels_like" | cut -d "." -f 1)
wind_speed=$(echo $weather | jq -r ".wind.speed")
humidity=$(echo $weather | jq -r ".main.humidity")
icon_code=$(echo $weather | jq -r ".weather[].icon" | head -1)
description=$(echo $weather | jq -r ".weather[].description" | head -1 | sed -e "s/\b\(.\)/\u\1/")

case $icon_code in
    # Crear sky
    "01d")
        icon=""
        ;;
    "01n")
        icon=""
        ;;

    # Few clouds
    "02d")
        icon=""
        ;;
    "02n")
        icon=""
        ;;

    # Scattered clouds
    "03d" | "03n")
        icon=""
        ;;

    # Broken clouds
    "04d" | "04n")
        icon=""
        ;;

    # Shower rain
    "09d")
        icon=""
        ;;
    "09n")
        icon=""
        ;;

    # Rain
    "10d")
        icon=""
        ;;
    "10n")
        icon=""
        ;;

    # Thunderstorm
    "11d")
        icon=""
        ;;
    "11n")
        icon=""
        ;;

    # Snow
    "13d")
        icon=""
        ;;
    "13n")
        icon=""
        ;;

    # Mist
    "50d" | "50n")
        icon=""
        ;;
    
    *)
        icon=""
        ;;
esac

eww update weather-temperature="$temperature"
eww update weather-feels-like="$feels_like"
eww update weather-icon="$icon"
eww update weather-description="$description"
eww update weather-city="$city"
eww update weather-wind-speed="$wind_speed"
eww update weather-humidity="$humidity"
