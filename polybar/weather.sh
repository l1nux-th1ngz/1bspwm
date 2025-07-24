#!/bin/bash
set -euo pipefail

# Load API key
APIKEY=$(cat "$HOME/.owm-key")
if [ -z "$APIKEY" ]; then
    echo "Error: API key not found in ~/.owm-key"
    exit 1
fi

# Configuration
CITY_NAME='Murray'
COUNTRY_CODE='US'
LANG='en'
UNITS='imperial'  # options: metric, imperial, kelvin

# Colors (leave empty for default polybar color)
COLOR_TEXT=""
COLOR_CLOUD="#606060"
COLOR_THUNDER="#d3b987"
COLOR_LIGHT_RAIN="#73cef4"
COLOR_HEAVY_RAIN="#b3deef"
COLOR_SNOW="#FFFFFF"
COLOR_FOG="#606060"
COLOR_TORNADO="#d3b987"
COLOR_SUN="#ffc24b"
COLOR_MOON="#FFFFFF"
COLOR_ERR="#f43753"
COLOR_WIND="#73cef4"
COLOR_COLD="#b3deef"
COLOR_HOT="#f43753"
COLOR_NORMAL_TEMP="#FFFFFF"

# Polybar font codes
WEATHER_FONT_CODE=4
TEMP_FONT_CODE=2

# Wind settings
DISPLAY_WIND="yes"
BEAUFORTICON="yes"
KNOTS="yes"
DECIMALS=0
MIN_WIND=11
DISPLAY_FORCE="yes"
DISPLAY_WIND_UNIT="yes"

# Temperature thresholds
HOT_TEMP=25
COLD_TEMP=0
DISPLAY_LABEL="yes"

# Functions for color handling
function color_begin {
  if [ -n "$COLOR_TEXT" ]; then
    echo "%{F$COLOR_TEXT}"
  else
    echo ""
  fi
}

function color_end {
  if [ -n "$COLOR_TEXT" ]; then
    echo "%{F-}"
  else
    echo ""
  fi
}

# Build API URL
function build_url {
  local city="$1"
  local country="$2"
  local units="$3"
  local lang="$4"
  local base_url="https://api.openweathermap.org/data/2.5/weather"
  local query="$(echo "$city" | sed 's/ /%20/g'),${country}"
  local url="${base_url}?appid=${APIKEY}&lang=${lang}"
  if [ "$units" != "kelvin" ]; then
    url="${url}&units=${units}"
  fi
  echo "$url"
}

# Fetch weather data
function get_weather_data {
  local url="$1"
  local response
  response=$(curl -s "$url")
  if ! echo "$response" | jq -e . > /dev/null; then
    echo "Error: Invalid JSON response"
    exit 1
  fi
  local code
  code=$(echo "$response" | jq -r .cod)
  if [ "$code" != "200" ]; then
    local message
    message=$(echo "$response" | jq -r .message)
    echo "API Error: $message"
    exit 1
  fi
  echo "$response"
}

# Set weather icon based on weather ID
function set_icons {
  local wid=$1
  local date=$2
  local sunrise=$3
  local sunset=$4

  if [ "$wid" -le 232 ]; then
    ICON_COLOR=$COLOR_THUNDER
    ICON=$( [ "$date" -ge "$sunrise" ] && [ "$date" -le "$sunset" ] && echo "" || echo "" )
  elif [ "$wid" -le 311 ]; then
    ICON_COLOR=$COLOR_LIGHT_RAIN
    ICON=$( [ "$date" -ge "$sunrise" ] && [ "$date" -le "$sunset" ] && echo "" || echo "" )
  elif [ "$wid" -le 321 ]; then
    ICON_COLOR=$COLOR_HEAVY_RAIN
    ICON=$( [ "$date" -ge "$sunrise" ] && [ "$date" -le "$sunset" ] && echo "" || echo "" )
  elif [ "$wid" -le 531 ]; then
    ICON_COLOR=$COLOR_HEAVY_RAIN
    ICON=$( [ "$date" -ge "$sunrise" ] && [ "$date" -le "$sunset" ] && echo "" || echo "" )
  elif [ "$wid" -le 622 ]; then
    ICON_COLOR=$COLOR_SNOW
    ICON=""
  elif [ "$wid" -le 771 ]; then
    ICON_COLOR=$COLOR_FOG
    ICON=""
  elif [ "$wid" -eq 781 ]; then
    ICON_COLOR=$COLOR_TORNADO
    ICON=""
  elif [ "$wid" -eq 800 ]; then
    if [ "$date" -ge "$sunrise" ] && [ "$date" -le "$sunset" ]; then
      ICON_COLOR=$COLOR_SUN
      ICON=""
    else
      ICON_COLOR=$COLOR_MOON
      ICON=""
    fi
  elif [ "$wid" -eq 801 ]; then
    if [ "$date" -ge "$sunrise" ] && [ "$date" -le "$sunset" ]; then
      ICON_COLOR=$COLOR_SUN
      ICON=""
    else
      ICON_COLOR=$COLOR_MOON
      ICON=""
    fi
  elif [ "$wid" -le 804 ]; then
    ICON_COLOR=$COLOR_CLOUD
    ICON=""
  else
    ICON_COLOR=$COLOR_ERR
    ICON=""
  fi

  # Wind icon and force
  local wind_speed
  wind_speed=$(echo "$RESPONSE" | jq .wind.speed)
  local wind_icon=""
  local wind_force
  wind_force=$(echo "$wind_speed" | awk '{printf "%.0f", $1}')

  if [ "$BEAUFORTICON" = "yes" ]; then
    local wind_kph
    wind_kph=$(echo "$wind_force * 3.6" | bc)
    case $(printf "%.0f" "$wind_kph") in
      0|1) wind_icon="" ;;
      2|3|4|5) wind_icon="" ;;
      6|7|8|9|10|11) wind_icon="" ;;
      12|13|14|15|16|17|18|19) wind_icon="" ;;
      20|21|22|23|24|25|26|27) wind_icon="" ;;
      28|29|30|31|32|33|34|35) wind_icon="" ;;
      36|37|38|39|40|41|42|43) wind_icon="" ;;
      44|45|46|47|48|49|50|51) wind_icon="" ;;
      52|53|54|55|56|57|58|59) wind_icon="" ;;
      60|61|62|63|64|65|66|67) wind_icon="" ;;
      68|69|70|71|72|73|74) wind_icon="" ;;
      75|76|77|78|79|80|81|82) wind_icon="" ;;
      *) wind_icon="" ;;
    esac
    # Convert wind speed to desired units
    if [ "$KNOTS" = "yes" ]; then
      case "$UNITS" in
        imperial) wind_force=$(echo "scale=$DECIMALS; $wind_speed * 0.8689762419" | bc) ;;
        metric) wind_force=$(echo "scale=$DECIMALS; $wind_speed * 3.6" | bc) ;;
        kelvin) wind_force=$wind_speed ;;  # no conversion
      esac
    else
      if [ "$UNITS" != "imperial" ]; then
        wind_force=$(echo "scale=$DECIMALS; $wind_speed * 3.6" | bc)
      fi
    fi
  fi

  # Build wind display
  if [ "$DISPLAY_WIND" = "yes" ] && [ "$(echo "$wind_force >= $MIN_WIND" | bc)" -eq 1 ]; then
    local wind_str
    wind_str="%{T$WEATHER_FONT_CODE}%{F$COLOR_WIND}$wind_icon%{F-}%{T-}"
    if [ "$DISPLAY_FORCE" = "yes" ]; then
      wind_str="$wind_str $color_begin$wind_force$color_end"
      if [ "$DISPLAY_WIND_UNIT" = "yes" ]; then
        case "$UNITS" in
          "imperial") wind_str="$wind_str ${color_begin}mph${color_end}" ;;
          "metric") wind_str="$wind_str ${color_begin}km/h${color_end}" ;;
          "kelvin") wind_str="$wind_str ${color_begin}K${color_end}" ;;
        esac
      fi
    fi
    wind_str="$wind_str |"
  else
    wind_str=""
  fi

  # Temperature icon
  local temp_icon
  case "$UNITS" in
    "metric") temp_icon="󰔄" ;;
    "imperial") temp_icon="󰔅" ;;
    "kelvin") temp_icon="󰔆" ;;
  esac

  # Format temperature
  local temp_value="$2"
  temp_value=$(echo "$temp_value" | cut -d "." -f 1)
  local temp_str
  if [ "$temp_value" -le "$COLD_TEMP" ]; then
    temp_str="%{F$COLOR_COLD}%{T$TEMP_FONT_CODE}%{T-}%{F-} ${color_begin}$temp_value${color_end}${color_begin}$temp_icon${color_end}"
  elif [ "$(echo "$temp_value >= $HOT_TEMP" | bc)" -eq 1 ]; then
    temp_str="%{F$COLOR_HOT}%{T$TEMP_FONT_CODE}%{T-}%{F-} ${color_begin}$temp_value${color_end}${color_begin}$temp_icon${color_end}"
  else
    temp_str="%{F$COLOR_NORMAL_TEMP}%{T$TEMP_FONT_CODE}%{T-}%{F-} ${color_begin}$temp_value${color_end}${color_begin}$temp_icon${color_end}"
  fi

  # Final output assembly
  local output="$wind_str %{T$WEATHER_FONT_CODE}%{F$ICON_COLOR}$ICON%{F-}%{T-} $ERR_MSG$color_begin$DESCRIPTION$color_end| $temp_str"
  echo "$output"
}

# Main execution
main() {
  local url
  url=$(build_url "$CITY_NAME" "$COUNTRY_CODE" "$UNITS" "$LANG")
  RESPONSE=$(get_weather_data "$url")

  # Parse data
  local main_desc
  main_desc=$(echo "$RESPONSE" | jq -r .weather[0].main)
  local wid
  wid=$(echo "$RESPONSE" | jq -r .weather[0].id)
  local description
  description=$(echo "$RESPONSE" | jq -r .weather[0].description | sed 's/"//g')
  local sunrise
  sunrise=$(echo "$RESPONSE" | jq -r .sys.sunrise)
  local sunset
  sunset=$(echo "$RESPONSE" | jq -r .sys.sunset)
  local date
  date=$(date +%s)
  local temperature
  temperature=$(echo "$RESPONSE" | jq -r .main.temp)

  # Set icons
  set_icons "$wid" "$date" "$sunrise" "$sunset"

  # Output
  output=$(set_icons "$wid" "$date" "$sunrise" "$sunset")
  # Display the final output
  echo "$output"
}

main
