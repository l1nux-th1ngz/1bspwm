#!/bin/bash

# Fetch the full mirror list page
echo "Fetching Debian mirror list..."
mirror_list=$(curl -s https://www.debian.org/mirror/list-full)

# Extract the first 5 mirrors in the US
mirror_urls=($(echo "$mirror_list" | grep -Eo 'https?://[^"]+' | grep -i 'us' | head -n 5))

# Check if we found any mirrors
if [ ${#mirror_urls[@]} -eq 0 ]; then
    echo "No US mirrors found."
    exit 1
fi

# Show the found mirrors
echo "Found the following US mirrors:"
for url in "${mirror_urls[@]}"; do
    echo "$url"
done

# Get geolocation info for the first mirror
echo "Fetching mirror location..."
mirror_ip=$(echo "$mirror_urls" | head -n 1 | awk -F/ '{print $3}')
location_info=$(curl -s ipinfo.io/$mirror_ip)
city=$(echo "$location_info" | grep -oP '(?<="city":")[^"]+')
country=$(echo "$location_info" | grep -oP '(?<="country":")[^"]+')
echo "Mirror location: $city, $country"

# Measure speed by downloading a small file from the first mirror
echo "Measuring download speed from mirror..."
test_file="${mirror_urls[0]}/dists/stable/main/binary-amd64/Packages.gz"
start=$(date +%s.%N)
curl -s --connect-timeout 10 --max-time 20 "$test_file" -o /dev/null
end=$(date +%s.%N)
duration=$(echo "$end - $start" | bc)

if (( $(echo "$duration > 0" | bc -l) )); then
    speed_kb=$(echo "1024 / $duration" | bc)
    echo "Estimated download speed: ${speed_kb} KB/s"
else
    echo "Could not measure speed."
fi
