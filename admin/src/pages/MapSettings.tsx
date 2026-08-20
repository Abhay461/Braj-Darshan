import React, { useState } from 'react';
import {
  Box,
  Card,
  CardContent,
  Typography,
  TextField,
  Button,
  FormControl,
  InputLabel,
  Select,
  MenuItem,
  Grid2 as Grid,
  Divider,
  Alert,
  Slider,
  IconButton,
  Tooltip,
  Paper,
} from '@mui/material';
import SaveIcon from '@mui/icons-material/SaveOutlined';
import RefreshIcon from '@mui/icons-material/RefreshOutlined';
import LocationOnIcon from '@mui/icons-material/LocationOnOutlined';
import PaletteIcon from '@mui/icons-material/PaletteOutlined';
import ZoomInIcon from '@mui/icons-material/ZoomInOutlined';
import ZoomOutIcon from '@mui/icons-material/ZoomOutOutlined';
import MapIcon from '@mui/icons-material/MapOutlined';
import { PageHeader } from '../components/common/PageHeader';
import { useMapSettings, useMapSettingsMutations } from '../hooks/useMapSettings';
import { MapSettings, PinIconOption } from '../types';

const PIN_ICON_OPTIONS = [
  { name: 'Default Pin', iconClass: 'location_on', icon: <LocationOnIcon /> },
  { name: 'Place Pin', iconClass: 'place', icon: <LocationOnIcon /> },
  { name: 'Temple Icon', iconClass: 'temple_hindu', icon: <LocationOnIcon /> },
  { name: 'Location Pin', iconClass: 'location_pin', icon: <LocationOnIcon /> },
  { name: 'My Location', iconClass: 'my_location', icon: <LocationOnIcon /> },
  { name: 'Flag', iconClass: 'flag', icon: <LocationOnIcon /> },
  { name: 'Landscape', iconClass: 'landscape', icon: <LocationOnIcon /> },
  { name: 'Terrain', iconClass: 'terrain', icon: <LocationOnIcon /> },
];

const MAP_STYLE_OPTIONS = [
  { value: 'standard', label: 'Standard' },
  { value: 'satellite', label: 'Satellite' },
  { value: 'terrain', label: 'Terrain' },
  { value: 'hybrid', label: 'Hybrid' },
  { value: 'dark', label: 'Dark' },
];

const COLOR_PRESETS = [
  '#C5221F', '#B91C1C', '#EA4335', '#1A73E8', '#34A853',
  '#FBBC05', '#9C27B0', '#FF5722', '#00BCD4', '#795548',
  '#607D8B', '#000000',
];

const getIconComponent = (iconClass: string) => {
  return <LocationOnIcon />;
};

export const MapSettingsPage: React.FC = () => {
  const { data: settingsRes, isLoading, error, refetch } = useMapSettings();
  const { updateMapSettings, resetMapSettings, isUpdating, isResetting } = useMapSettingsMutations();

  const settings = settingsRes?.data;
  const [formData, setFormData] = useState<Partial<MapSettings>>({
    defaultZoom: settings?.defaultZoom ?? 14.0,
    minZoom: settings?.minZoom ?? 5.0,
    maxZoom: settings?.maxZoom ?? 18.0,
    defaultCenterLat: settings?.defaultCenterLat ?? 27.5830,
    defaultCenterLng: settings?.defaultCenterLng ?? 77.7000,
    defaultPinIconStyle: settings?.defaultPinIconStyle ?? 'location_on',
    defaultPinColor: settings?.defaultPinColor ?? '#C5221F',
    defaultPinSize: settings?.defaultPinSize ?? 42,
    mapStyle: settings?.mapStyle ?? 'standard',
  });

  const [availablePinIcons, setAvailablePinIcons] = useState<PinIconOption[]>(
    settings?.availablePinIcons ?? PIN_ICON_OPTIONS.map((opt) => ({
      name: opt.name,
      iconClass: opt.iconClass,
      isDefault: opt.isDefault,
    }))
  );

  const handleChange = (field: string, value: any) => {
    setFormData((prev) => ({ ...prev, [field]: value }));
  };

  const handleSave = async () => {
    await updateMapSettings({
      ...formData,
      availablePinIcons,
    });
  };

  const handleReset = async () => {
    await resetMapSettings();
    refetch();
  };

  const handlePinIconChange = (index: number, iconClass: string) => {
    setAvailablePinIcons((prev) =>
      prev.map((icon, i) => (i === index ? { ...icon, iconClass } : icon))
    );
  };

  const handlePinNameChange = (index: number, name: string) => {
    setAvailablePinIcons((prev) =>
      prev.map((icon, i) => (i === index ? { ...icon, name } : icon))
    );
  };

  const handleDefaultPinChange = (index: number) => {
    setAvailablePinIcons((prev) =>
      prev.map((icon, i) => ({ ...icon, isDefault: i === index }))
    );
  };

  const addPinIcon = () => {
    setAvailablePinIcons((prev) => [
      ...prev,
      { name: 'Custom Pin', iconClass: 'location_on', isDefault: false },
    ]);
  };

  const removePinIcon = (index: number) => {
    if (availablePinIcons.length <= 1) return;
    setAvailablePinIcons((prev) => prev.filter((_, i) => i !== index));
  };

  const pinPreviewStyle = {
    color: formData.defaultPinColor,
    fontSize: formData.defaultPinSize,
    filter: 'drop-shadow(0px 2px 4px rgba(0,0,0,0.3))',
  };

  if (isLoading) {
    return (
      <Box>
        <PageHeader title="Map Settings" subtitle="Configure global map appearance and behavior" />
        <Box sx={{ display: 'flex', justifyContent: 'center', py: 6 }}>
          <Typography>Loading map settings...</Typography>
        </Box>
      </Box>
    );
  }

  if (error) {
    return (
      <Box>
        <PageHeader title="Map Settings" subtitle="Configure global map appearance and behavior" />
        <Alert severity="error" sx={{ mx: 2, mb: 2 }}>
          Failed to load map settings: {String(error)}
          <Button onClick={() => refetch()} startIcon={<RefreshIcon />} size="small" sx={{ ml: 2 }}>
            Retry
          </Button>
        </Alert>
      </Box>
    );
  }

  return (
    <Box>
      <PageHeader
        title="Map Settings"
        subtitle="Configure global map appearance, zoom levels, pin styles, and default center"
        actions={
          <Box sx={{ display: 'flex', gap: 1.5 }}>
            <Button
              variant="outlined"
              startIcon={<RefreshIcon />}
              onClick={handleReset}
              disabled={isResetting}
            >
              Reset to Defaults
            </Button>
            <Button
              variant="contained"
              startIcon={<SaveIcon />}
              onClick={handleSave}
              disabled={isUpdating || isResetting}
            >
              {isUpdating ? 'Saving...' : 'Save Settings'}
            </Button>
          </Box>
        }
      />

      <Grid container spacing={3}>
        <Grid size={{ xs: 12, md: 6 }}>
          <Card sx={{ p: 1 }}>
            <CardContent>
              <Box sx={{ display: 'flex', alignItems: 'center', gap: 1, mb: 2 }}>
                <ZoomInIcon color="primary" />
                <Typography variant="h4" sx={{ fontWeight: 700 }}>
                  Zoom Levels
                </Typography>
              </Box>

              <Grid container spacing={2}>
                <Grid size={{ xs: 12, sm: 6 }}>
                  <TextField
                    label="Default Zoom"
                    type="number"
                    value={formData.defaultZoom}
                    onChange={(e) => handleChange('defaultZoom', parseFloat(e.target.value) || 0)}
                    inputProps={{ step: 0.1, min: 1, max: 20 }}
                    fullWidth
                    helperText="Initial zoom when map loads"
                  />
                </Grid>
                <Grid size={{ xs: 12, sm: 6 }}>
                  <TextField
                    label="Minimum Zoom"
                    type="number"
                    value={formData.minZoom}
                    onChange={(e) => handleChange('minZoom', parseFloat(e.target.value) || 0)}
                    inputProps={{ step: 0.1, min: 1, max: 20 }}
                    fullWidth
                    helperText="Minimum zoom level (zoomed out)"
                  />
                </Grid>
                <Grid size={{ xs: 12, sm: 6 }}>
                  <TextField
                    label="Maximum Zoom"
                    type="number"
                    value={formData.maxZoom}
                    onChange={(e) => handleChange('maxZoom', parseFloat(e.target.value) || 0)}
                    inputProps={{ step: 0.1, min: 1, max: 20 }}
                    fullWidth
                    helperText="Maximum zoom level (zoomed in)"
                  />
                </Grid>
              </Grid>

              <Box sx={{ mt: 3 }}>
                <Typography variant="subtitle2" sx={{ mb: 1, fontWeight: 600 }}>
                  Default Zoom Slider Preview
                </Typography>
                <Slider
                  value={formData.defaultZoom}
                  onChange={(_, value) => handleChange('defaultZoom', value)}
                  min={1}
                  max={20}
                  step={0.1}
                  valueLabelDisplay="auto"
                  marks={[
                    { value: 1, label: '1' },
                    { value: 5, label: '5' },
                    { value: 10, label: '10' },
                    { value: 15, label: '15' },
                    { value: 20, label: '20' },
                  ]}
                />
              </Box>
            </CardContent>
          </Card>
        </Grid>

        <Grid size={{ xs: 12, md: 6 }}>
          <Card sx={{ p: 1 }}>
            <CardContent>
              <Box sx={{ display: 'flex', alignItems: 'center', gap: 1, mb: 2 }}>
                <MapIcon color="primary" />
                <Typography variant="h4" sx={{ fontWeight: 700 }}>
                  Default Map Center
                </Typography>
              </Box>

              <Grid container spacing={2}>
                <Grid size={{ xs: 12, sm: 6 }}>
                  <TextField
                    label="Default Center Latitude"
                    type="number"
                    value={formData.defaultCenterLat}
                    onChange={(e) => handleChange('defaultCenterLat', parseFloat(e.target.value) || 0)}
                    inputProps={{ step: 'any', min: -90, max: 90 }}
                    fullWidth
                    helperText="Vrindavan default: 27.5830"
                  />
                </Grid>
                <Grid size={{ xs: 12, sm: 6 }}>
                  <TextField
                    label="Default Center Longitude"
                    type="number"
                    value={formData.defaultCenterLng}
                    onChange={(e) => handleChange('defaultCenterLng', parseFloat(e.target.value) || 0)}
                    inputProps={{ step: 'any', min: -180, max: 180 }}
                    fullWidth
                    helperText="Vrindavan default: 77.7000"
                  />
                </Grid>
              </Grid>
            </CardContent>
          </Card>
        </Grid>

        <Grid size={{ xs: 12, md: 6 }}>
          <Card sx={{ p: 1 }}>
            <CardContent>
              <Box sx={{ display: 'flex', alignItems: 'center', gap: 1, mb: 2 }}>
                <LocationOnIcon color="primary" />
                <Typography variant="h4" sx={{ fontWeight: 700 }}>
                  Default Pin Style
                </Typography>
              </Box>

              <Grid container spacing={2}>
                <Grid size={{ xs: 12, sm: 6 }}>
                  <FormControl fullWidth>
                    <InputLabel>Pin Icon Style</InputLabel>
                    <Select
                      value={formData.defaultPinIconStyle}
                      label="Pin Icon Style"
                      onChange={(e) => handleChange('defaultPinIconStyle', e.target.value)}
                    >
                      {PIN_ICON_OPTIONS.map((opt) => (
                        <MenuItem key={opt.iconClass} value={opt.iconClass}>
                          <Box sx={{ display: 'flex', alignItems: 'center', gap: 1 }}>
                            {getIconComponent(opt.iconClass)}
                            <Typography>{opt.name}</Typography>
                          </Box>
                        </MenuItem>
                      ))}
                    </Select>
                  </FormControl>
                </Grid>

                <Grid size={{ xs: 12, sm: 6 }}>
                  <FormControl fullWidth>
                    <InputLabel>Map Style</InputLabel>
                    <Select
                      value={formData.mapStyle}
                      label="Map Style"
                      onChange={(e) => handleChange('mapStyle', e.target.value)}
                    >
                      {MAP_STYLE_OPTIONS.map((opt) => (
                        <MenuItem key={opt.value} value={opt.value}>
                          {opt.label}
                        </MenuItem>
                      ))}
                    </Select>
                  </FormControl>
                </Grid>

                <Grid size={{ xs: 12, sm: 6 }}>
                  <TextField
                    label="Pin Color (Hex)"
                    value={formData.defaultPinColor}
                    onChange={(e) => handleChange('defaultPinColor', e.target.value)}
                    fullWidth
                    helperText="Enter hex color code (e.g., #C5221F)"
                    inputProps={{ pattern: '^#[0-9A-Fa-f]{3,6}$' }}
                  />
                </Grid>

                <Grid size={{ xs: 12, sm: 6 }}>
                  <TextField
                    label="Pin Size"
                    type="number"
                    value={formData.defaultPinSize}
                    onChange={(e) => handleChange('defaultPinSize', parseInt(e.target.value, 10) || 0)}
                    inputProps={{ min: 20, max: 80 }}
                    fullWidth
                    helperText="Pin icon size in pixels"
                  />
                </Grid>
              </Grid>

              <Box sx={{ mt: 2 }}>
                <Typography variant="subtitle2" sx={{ mb: 1, fontWeight: 600 }}>
                  Quick Color Presets
                </Typography>
                <Box sx={{ display: 'flex', flexWrap: 'wrap', gap: 1 }}>
                  {COLOR_PRESETS.map((color) => (
                    <Tooltip key={color} title={color}>
                      <Button
                        variant={formData.defaultPinColor === color ? 'contained' : 'outlined'}
                        size="small"
                        onClick={() => handleChange('defaultPinColor', color)}
                        sx={{
                          backgroundColor: formData.defaultPinColor === color ? color : undefined,
                          borderColor: formData.defaultPinColor === color ? color : undefined,
                          color: formData.defaultPinColor === color ? '#fff' : undefined,
                          minWidth: 36,
                          height: 36,
                          padding: 0,
                        }}
                      >
                        <Box
                          sx={{
                            width: 16,
                            height: 16,
                            borderRadius: 1,
                            backgroundColor: color,
                            border: '1px solid rgba(0,0,0,0.1)',
                          }}
                        />
                      </Button>
                    </Tooltip>
                  ))}
                </Box>
              </Box>

              <Box sx={{ mt: 3, p: 2, backgroundColor: '#f5f5f5', borderRadius: 2, textAlign: 'center' }}>
                <Typography variant="subtitle2" sx={{ mb: 1, fontWeight: 600 }}>
                  Pin Preview
                </Typography>
                <Box sx={{ display: 'flex', alignItems: 'center', justifyContent: 'center', gap: 1, py: 2 }}>
                  <LocationOnIcon style={pinPreviewStyle} />
                  <Typography variant="body1" sx={{ fontFamily: 'monospace' }}>
                    Size: {formData.defaultPinSize}px | Color: {formData.defaultPinColor}
                  </Typography>
                </Box>
              </Box>
            </CardContent>
          </Card>
        </Grid>

        <Grid size={{ xs: 12, md: 6 }}>
          <Card sx={{ p: 1 }}>
            <CardContent>
              <Box sx={{ display: 'flex', alignItems: 'center', justifyContent: 'space-between', mb: 2 }}>
                <Box sx={{ display: 'flex', alignItems: 'center', gap: 1 }}>
                  <PaletteIcon color="primary" />
                  <Typography variant="h4" sx={{ fontWeight: 700 }}>
                    Available Pin Icons (Admin Dropdown)
                  </Typography>
                </Box>
                <Button size="small" startIcon={<LocationOnIcon />} onClick={addPinIcon}>
                  Add Icon
                </Button>
              </Box>

              <Typography variant="body2" sx={{ mb: 2, color: 'text.secondary' }}>
                These icons appear in the temple-specific map settings dropdown. Mark one as default.
              </Typography>

              {availablePinIcons.map((icon, index) => (
                <Paper key={index} elevation={1} sx={{ p: 2, mb: 1.5, display: 'flex', alignItems: 'center', gap: 2, flexWrap: 'wrap' }}>
                  <Box sx={{ display: 'flex', alignItems: 'center', gap: 1, minWidth: 120 }}>
                    <Tooltip title={icon.iconClass}>
                      <IconButton
                        size="small"
                        color="primary"
                        variant="outlined"
                        disabled
                        sx={{ minWidth: 40 }}
                      >
                        {getIconComponent(icon.iconClass)}
                      </IconButton>
                      <FormControl sx={{ minWidth: 180 }} size="small">
                        <Select
                          value={icon.iconClass}
                          label="Icon"
                          onChange={(e) => handlePinIconChange(index, e.target.value)}
                        >
                          {PIN_ICON_OPTIONS.map((opt) => (
                            <MenuItem key={opt.iconClass} value={opt.iconClass}>
                              <Box sx={{ display: 'flex', alignItems: 'center', gap: 1 }}>
                                {getIconComponent(opt.iconClass)}
                                <Typography variant="body2">{opt.name}</Typography>
                              </Box>
                            </MenuItem>
                          ))}
                        </Select>
                      </FormControl>
                    </Tooltip>
                  </Box>

                  <Box sx={{ flexGrow: 1, minWidth: 200 }}>
                    <TextField
                      size="small"
                      label="Display Name"
                      value={icon.name}
                      onChange={(e) => handlePinNameChange(index, e.target.value)}
                      fullWidth
                    />
                  </Box>

                  <FormControl size="small">
                    <Select
                      value={icon.isDefault.toString()}
                      label="Default"
                      onChange={(e) => handleDefaultPinChange(index)}
                    >
                      <MenuItem value="true">Default</MenuItem>
                      <MenuItem value="false">Not Default</MenuItem>
                    </Select>
                  </FormControl>

                  {availablePinIcons.length > 1 && (
                    <IconButton
                      size="small"
                      color="error"
                      onClick={() => removePinIcon(index)}
                      aria-label="Remove pin icon"
                    >
                      <LocationOnIcon fontSize="small" />
                    </IconButton>
                  )}
                </Paper>
              ))}

              {availablePinIcons.filter((i) => i.isDefault).length !== 1 && (
                <Alert severity="warning" sx={{ mt: 2 }}>
                  Exactly one pin icon must be marked as default.
                </Alert>
              )}
            </CardContent>
          </Card>
        </Grid>

        <Grid size={{ xs: 12 }}>
          <Card sx={{ p: 2, backgroundColor: '#FFF8E1', border: '1px solid #FFE082' }}>
            <CardContent>
              <Typography variant="h5" sx={{ mb: 1, color: '#F57F17' }}>
                How Map Settings Work
              </Typography>
              <Typography variant="body1" paragraph>
                <strong>Global Settings:</strong> Applied to all temples by default. Control default zoom, center, pin style, and map appearance.
              </Typography>
              <Typography variant="body1" paragraph>
                <strong>Temple-Specific Overrides:</strong> In the Temple Form, you can optionally override zoom, pin icon, pin color, and pin size for individual temples. If left empty, global settings are used.
              </Typography>
              <Typography variant="body1" paragraph>
                <strong>Coordinate System:</strong> Temple latitude/longitude coordinates are NEVER modified by map settings. The pin visual tip always stays exactly on the temple GPS coordinate. Only zoom, pin appearance, and initial camera position are affected.
              </Typography>
              <Typography variant="body1" paragraph>
                <strong>Mobile App Sync:</strong> Changes take effect immediately when the mobile app refreshes its map data (pull-to-refresh or app restart). No Flutter code changes needed for future admin setting updates.
              </Typography>
            </CardContent>
          </Card>
        </Grid>
      </Grid>
    </Box>
  );
};
