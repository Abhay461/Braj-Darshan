import React, { useEffect, useRef, useState } from 'react';
import { Box, Typography, Button, Paper, CircularProgress } from '@mui/material';
import CenterFocusWeakIcon from '@mui/icons-material/CenterFocusWeak';

interface LocationMapPickerProps {
  latitude: number;
  longitude: number;
  onChange: (coords: { latitude: number; longitude: number }) => void;
}

export const LocationMapPicker: React.FC<LocationMapPickerProps> = ({
  latitude,
  longitude,
  onChange,
}) => {
  const mapContainerRef = useRef<HTMLDivElement | null>(null);
  const mapInstanceRef = useRef<any>(null);
  const markerInstanceRef = useRef<any>(null);
  const onChangeRef = useRef(onChange);
  const [isLoaded, setIsLoaded] = useState(false);

  useEffect(() => {
    onChangeRef.current = onChange;
  }, [onChange]);

  const isValid =
    typeof latitude === 'number' &&
    typeof longitude === 'number' &&
    !isNaN(latitude) &&
    !isNaN(longitude) &&
    latitude >= -90 &&
    latitude <= 90 &&
    longitude >= -180 &&
    longitude <= 180 &&
    (latitude !== 0 || longitude !== 0);

  const safeLat = isValid ? latitude : 27.5830;
  const safeLng = isValid ? longitude : 77.7000;

  // Dynamically load Leaflet JS & CSS from unpkg CDN
  useEffect(() => {
    if ((window as any).L) {
      setIsLoaded(true);
      return;
    }

    // CSS
    if (!document.getElementById('leaflet-css')) {
      const link = document.createElement('link');
      link.id = 'leaflet-css';
      link.rel = 'stylesheet';
      link.href = 'https://unpkg.com/leaflet@1.9.4/dist/leaflet.css';
      document.head.appendChild(link);
    }

    // JS
    if (!document.getElementById('leaflet-js')) {
      const script = document.createElement('script');
      script.id = 'leaflet-js';
      script.src = 'https://unpkg.com/leaflet@1.9.4/dist/leaflet.js';
      script.onload = () => {
        setIsLoaded(true);
      };
      document.body.appendChild(script);
    } else {
      const checkInterval = setInterval(() => {
        if ((window as any).L) {
          setIsLoaded(true);
          clearInterval(checkInterval);
        }
      }, 100);
      return () => clearInterval(checkInterval);
    }
  }, []);

  // Initialize Map once Leaflet is loaded
  useEffect(() => {
    if (!isLoaded || !mapContainerRef.current) return;
    const L = (window as any).L;
    if (!L) return;

    if (!mapInstanceRef.current) {
      const map = L.map(mapContainerRef.current, {
        center: [safeLat, safeLng],
        zoom: 16,
        zoomControl: true,
      });

      // Google Maps Tile Layer
      L.tileLayer('https://mt1.google.com/vt/lyrs=m&x={x}&y={y}&z={z}', {
        maxZoom: 20,
        attribution: '&copy; Google Maps',
      }).addTo(map);

      // Custom Red Location Pin
      const redPinIcon = L.divIcon({
        className: 'custom-admin-map-pin',
        html: `
          <div style="position: relative; width: 36px; height: 36px; display: flex; justify-content: center; align-items: flex-end;">
            <svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 24 24" fill="#C5221F" width="36" height="36" style="filter: drop-shadow(0px 2px 5px rgba(0,0,0,0.4));">
              <path d="M12 2C8.13 2 5 5.13 5 9c0 5.25 7 13 7 13s7-7.75 7-13c0-3.87-3.13-7-7-7zm0 9.5c-1.38 0-2.5-1.12-2.5-2.5s1.12-2.5 2.5-2.5 2.5 1.12 2.5 2.5-1.12 2.5-2.5 2.5z"/>
            </svg>
          </div>
        `,
        iconSize: [36, 36],
        iconAnchor: [18, 3],
      });

      const marker = L.marker([safeLat, safeLng], {
        icon: redPinIcon,
        draggable: true,
        title: 'Drag marker to update temple location',
      }).addTo(map);

      marker.on('dragend', () => {
        const position = marker.getLatLng();
        const newLat = Number(position.lat.toFixed(7));
        const newLng = Number(position.lng.toFixed(7));
        onChangeRef.current({ latitude: newLat, longitude: newLng });
      });

      map.on('click', (e: any) => {
        const newLat = Number(e.latlng.lat.toFixed(7));
        const newLng = Number(e.latlng.lng.toFixed(7));
        marker.setLatLng([newLat, newLng]);
        onChangeRef.current({ latitude: newLat, longitude: newLng });
      });

      mapInstanceRef.current = map;
      markerInstanceRef.current = marker;
    }

    return () => {
      if (mapInstanceRef.current) {
        mapInstanceRef.current.remove();
        mapInstanceRef.current = null;
        markerInstanceRef.current = null;
      }
    };
  }, [isLoaded]);

  // Sync Map & Marker when parent latitude/longitude changes
  useEffect(() => {
    if (mapInstanceRef.current && markerInstanceRef.current && isValid) {
      const currentMarkerPos = markerInstanceRef.current.getLatLng();
      const latDiff = Math.abs(currentMarkerPos.lat - safeLat);
      const lngDiff = Math.abs(currentMarkerPos.lng - safeLng);

      if (latDiff > 0.00001 || lngDiff > 0.00001) {
        markerInstanceRef.current.setLatLng([safeLat, safeLng]);
        mapInstanceRef.current.panTo([safeLat, safeLng], { animate: true });
      }
    }
  }, [safeLat, safeLng, isValid]);

  const handleRecenter = () => {
    if (mapInstanceRef.current && isValid) {
      mapInstanceRef.current.setView([safeLat, safeLng], 17, { animate: true });
    }
  };

  return (
    <Paper
      elevation={0}
      sx={{
        borderRadius: 2,
        overflow: 'hidden',
        border: '1px solid #E0E0E0',
        mb: 2.5,
        backgroundColor: '#FAFAFA',
      }}
    >
      <Box
        sx={{
          px: 2,
          py: 1.2,
          display: 'flex',
          justify: 'space-between',
          alignItems: 'center',
          backgroundColor: '#F5F5F5',
          borderBottom: '1px solid #E0E0E0',
        }}
      >
        <Typography variant="body2" sx={{ fontWeight: 600, color: 'text.secondary', display: 'flex', alignItems: 'center', gap: 0.8 }}>
          📍 Drag the Red Pin or Click on the map to set exact Temple Location
        </Typography>
        <Button
          size="small"
          variant="outlined"
          startIcon={<CenterFocusWeakIcon />}
          onClick={handleRecenter}
          sx={{ textTransform: 'none', py: 0.2, px: 1 }}
        >
          Center Pin
        </Button>
      </Box>

      {/* Map Container */}
      <Box
        ref={mapContainerRef}
        sx={{
          width: '100%',
          height: 320,
          zIndex: 1,
          position: 'relative',
          display: 'flex',
          justify: 'center',
          alignItems: 'center',
          backgroundColor: '#EFEFEF',
          '& .leaflet-container': {
            width: '100%',
            height: '100%',
            fontFamily: 'inherit',
          },
          '& .custom-admin-map-pin': {
            background: 'transparent !important',
            border: 'none !important',
            boxShadow: 'none !important',
          },
        }}
      >
        {!isLoaded && (
          <Box sx={{ display: 'flex', alignItems: 'center', gap: 1, color: 'text.secondary' }}>
            <CircularProgress size={24} />
            <Typography variant="body2">Loading Interactive Map...</Typography>
          </Box>
        )}
      </Box>

      <Box
        sx={{
          px: 2,
          py: 1,
          backgroundColor: '#FFF',
          display: 'flex',
          justify: 'space-between',
          alignItems: 'center',
          borderTop: '1px solid #EEEEEE',
        }}
      >
        <Typography variant="caption" sx={{ color: 'text.secondary', fontWeight: 500 }}>
          Pin Coordinates: <strong>{safeLat.toFixed(6)}</strong>, <strong>{safeLng.toFixed(6)}</strong>
        </Typography>
        <Typography variant="caption" sx={{ color: '#2E7D32', fontWeight: 600 }}>
          ✅ Coordinates sync live with form fields below
        </Typography>
      </Box>
    </Paper>
  );
};
