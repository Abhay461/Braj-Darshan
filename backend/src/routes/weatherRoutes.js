const express = require('express');
const router = express.Router();
const axios = require('axios');

const WEATHER_API_KEY = process.env.WEATHER_API_KEY || process.env.OPENWEATHER_API_KEY;
const WEATHER_API_URL = process.env.WEATHER_API_URL || 'https://api.openweathermap.org/data/2.5/weather';

const weatherCache = new Map();
const CACHE_TTL = 10 * 60 * 1000; // 10 minutes

function getCacheKey(lat, lng) {
  return `${lat.toFixed(4)},${lng.toFixed(4)}`;
}

function getCachedWeather(key) {
  const cached = weatherCache.get(key);
  if (cached && Date.now() - cached.timestamp < CACHE_TTL) {
    return cached.data;
  }
  return null;
}

function setCachedWeather(key, data) {
  weatherCache.set(key, { data, timestamp: Date.now() });
}

async function fetchWeatherFromAPI(lat, lng) {
  if (!WEATHER_API_KEY) {
    throw new Error('Weather API key not configured');
  }

  const params = {
    lat,
    lon: lng,
    appid: WEATHER_API_KEY,
    units: 'metric',
    lang: 'en',
  };

  const response = await axios.get(WEATHER_API_URL, { params, timeout: 5000 });
  return response.data;
}

function parseWeatherData(data) {
  const weather = data.weather?.[0];
  const main = data.main || {};
  const wind = data.wind || {};

  const temp = Math.round(main.temp);
  const condition = weather?.main || 'Clear';
  const description = weather?.description || '';
  const humidity = main.humidity || 0;
  const windSpeed = Math.round(wind.speed || 0);
  const icon = weather?.icon || '01d';

  // Determine Yatra suggestion based on weather
  let yatraSuggestion = 'Suitable for darshan and yatra';
  let suggestionType = 'pleasant';

  const conditionLower = condition.toLowerCase();
  if (conditionLower.includes('rain') || conditionLower.includes('drizzle') || conditionLower.includes('thunderstorm')) {
    yatraSuggestion = 'Carry an umbrella and wear waterproof footwear';
    suggestionType = 'rain';
  } else if (temp > 35) {
    yatraSuggestion = 'Extreme heat - prefer morning or evening darshan';
    suggestionType = 'heat';
  } else if (temp > 30) {
    yatraSuggestion = 'Warm weather - stay hydrated, prefer early hours';
    suggestionType = 'warm';
  } else if (conditionLower.includes('fog') || conditionLower.includes('mist') || conditionLower.includes('haze') || conditionLower.includes('smoke')) {
    yatraSuggestion = 'Fog/poor visibility - travel carefully, use headlights';
    suggestionType = 'fog';
  } else if (temp < 10) {
    yatraSuggestion = 'Cool weather - carry light woolens for evening';
    suggestionType = 'cool';
  }

  return {
    temperature: temp,
    condition,
    description: description.charAt(0).toUpperCase() + description.slice(1),
    humidity,
    windSpeed,
    icon,
    yatraSuggestion,
    suggestionType,
    locationName: data.name || 'Vrindavan',
    country: data.sys?.country || 'IN',
    timestamp: Date.now(),
  };
}

router.get('/', async (req, res) => {
  try {
    const lat = parseFloat(req.query.lat) || 27.5830;
    const lng = parseFloat(req.query.lng) || 77.7000;

    // Validate coordinates
    if (isNaN(lat) || isNaN(lng) || lat < -90 || lat > 90 || lng < -180 || lng > 180) {
      return res.status(400).json({
        success: false,
        message: 'Invalid coordinates',
      });
    }

    const cacheKey = getCacheKey(lat, lng);
    let weatherData = getCachedWeather(cacheKey);

    if (!weatherData) {
      try {
        const rawData = await fetchWeatherFromAPI(lat, lng);
        weatherData = parseWeatherData(rawData);
        setCachedWeather(cacheKey, weatherData);
      } catch (apiError) {
        console.error('Weather API error:', apiError.message);

        // Try to return cached data even if expired
        const expiredCache = weatherCache.get(cacheKey);
        if (expiredCache) {
          weatherData = { ...expiredCache.data, fromCache: true, cacheExpired: true };
        } else {
          return res.status(503).json({
            success: false,
            message: 'Weather service temporarily unavailable',
            error: apiError.message,
          });
        }
      }
    }

    res.json({
      success: true,
      data: weatherData,
    });
  } catch (error) {
    console.error('Weather endpoint error:', error.message);
    res.status(500).json({
      success: false,
      message: 'Failed to fetch weather data',
    });
  }
});

module.exports = router;