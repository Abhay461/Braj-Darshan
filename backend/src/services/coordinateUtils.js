const https = require('https');
const http = require('http');

/**
 * Extract lat/lng from any text (URL, HTML body, redirect location).
 * Uses 7 regex patterns with coordinate validation.
 */
function extractLatLngFromText(text) {
  if (!text) return null;

  try {
    let decoded = text.replace(/%2C/gi, ',');
    try { decoded = decodeURIComponent(decoded); } catch {}

    // 1. Protobuf !3d=lat !4d=lng
    const d3d4d = decoded.match(/!3d(-?\d+\.\d+)!4d(-?\d+\.\d+)/);
    if (d3d4d) {
      const lat = parseFloat(d3d4d[1]), lng = parseFloat(d3d4d[2]);
      if (isValidCoord(lat, lng)) return { latitude: lat, longitude: lng };
    }

    // 2. Protobuf !2d=lng !3d=lat
    const d2d3d = decoded.match(/!2d(-?\d+\.\d+)!3d(-?\d+\.\d+)/);
    if (d2d3d) {
      const lng = parseFloat(d2d3d[1]), lat = parseFloat(d2d3d[2]);
      if (isValidCoord(lat, lng)) return { latitude: lat, longitude: lng };
    }

    // 3. @lat,lng
    const atMatch = decoded.match(/@(-?\d+\.\d+),(-?\d+\.\d+)/);
    if (atMatch) {
      const lat = parseFloat(atMatch[1]), lng = parseFloat(atMatch[2]);
      if (isValidCoord(lat, lng)) return { latitude: lat, longitude: lng };
    }

    // 4. query/q/ll/center/destination param
    const paramMatch = decoded.match(/(?:query|q|ll|center|destination)=(-?\d+\.\d+)[,+ ]+(-?\d+\.\d+)/);
    if (paramMatch) {
      const lat = parseFloat(paramMatch[1]), lng = parseFloat(paramMatch[2]);
      if (isValidCoord(lat, lng)) return { latitude: lat, longitude: lng };
    }

    // 5. /lat,lng in path
    const dirMatch = decoded.match(/\/(-?\d{1,2}\.\d+),(-?\d{1,3}\.\d+)/);
    if (dirMatch) {
      const lat = parseFloat(dirMatch[1]), lng = parseFloat(dirMatch[2]);
      if (isValidCoord(lat, lng)) return { latitude: lat, longitude: lng };
    }

    // 6. India-range coordinate pair
    const indiaMatch = decoded.match(/(2[0-9]\.\d{3,})[,\s]+(7[0-9]\.\d{3,})/);
    if (indiaMatch) {
      const lat = parseFloat(indiaMatch[1]), lng = parseFloat(indiaMatch[2]);
      if (isValidCoord(lat, lng)) return { latitude: lat, longitude: lng };
    }

    // 7. General 4+ decimal pair
    const pairMatches = decoded.matchAll(/(-?\d{1,2}\.\d{4,})[,\s]+(-?\d{1,3}\.\d{4,})/g);
    for (const m of pairMatches) {
      const lat = parseFloat(m[1]), lng = parseFloat(m[2]);
      if (isValidCoord(lat, lng)) return { latitude: lat, longitude: lng };
    }
  } catch {}

  return null;
}

function isValidCoord(lat, lng) {
  if (lat < -90 || lat > 90 || lng < -180 || lng > 180) return false;
  if (lat === 0 && lng === 0) return false;
  if ([17, 15, 18, 1, 2, 3, 4, 5].includes(lat)) return false;
  return true;
}

/**
 * Follow redirect chain and extract lat/lng from the final URL or page body.
 */
function resolveRedirectsAndExtract(inputUrl, maxRedirects = 10) {
  return new Promise((resolve) => {
    let redirectsLeft = maxRedirects;

    function followUrl(currentUrl) {
      if (redirectsLeft <= 0) {
        resolve(null);
        return;
      }
      redirectsLeft--;

      let parsedUrl;
      try {
        parsedUrl = new URL(currentUrl);
      } catch {
        resolve(null);
        return;
      }
      const client = parsedUrl.protocol === 'https:' ? https : http;

      const options = {
        hostname: parsedUrl.hostname,
        path: parsedUrl.pathname + parsedUrl.search,
        method: 'GET',
        headers: {
          'User-Agent': 'Mozilla/5.0 (Linux; Android 10; Mobile) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/120.0.0.0 Mobile Safari/537.36',
          'Accept': 'text/html,application/xhtml+xml,application/xml;q=0.9,*/*;q=0.8',
        },
        timeout: 10000,
      };

      const request = client.request(options, (response) => {
        // Check redirect location header
        if ([301, 302, 303, 307, 308].includes(response.statusCode) && response.headers.location) {
          const redirectUrl = response.headers.location.startsWith('http')
            ? response.headers.location
            : `${parsedUrl.protocol}//${parsedUrl.hostname}${response.headers.location}`;

          // Try extracting coords from redirect URL
          const coords = extractLatLngFromText(redirectUrl);
          if (coords) {
            response.destroy();
            resolve(coords);
            return;
          }

          // Follow the redirect
          followUrl(redirectUrl);
          response.destroy();
          return;
        }

        // Not a redirect — try extracting from current URL
        const urlCoords = extractLatLngFromText(currentUrl);
        if (urlCoords) {
          response.destroy();
          resolve(urlCoords);
          return;
        }

        // Read the response body and try to extract coordinates
        let body = '';
        response.setEncoding('utf8');
        response.on('data', (chunk) => {
          body += chunk;
          // Stop reading after 50KB to avoid memory issues
          if (body.length > 50000) {
            response.destroy();
          }
        });
        response.on('end', () => {
          const bodyCoords = extractLatLngFromText(body);
          resolve(bodyCoords);
        });
        response.on('error', () => resolve(null));
      });

      request.on('error', () => resolve(null));
      request.on('timeout', () => {
        request.destroy();
        resolve(null);
      });
      request.end();
    }

    followUrl(inputUrl);
  });
}

module.exports = { extractLatLngFromText, isValidCoord, resolveRedirectsAndExtract };
