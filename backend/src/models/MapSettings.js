const mongoose = require('mongoose');

const pinIconStyleSchema = new mongoose.Schema(
  {
    name: { type: String, required: true, trim: true },
    iconClass: { type: String, required: true, trim: true },
    isDefault: { type: Boolean, default: false },
  },
  { _id: false }
);

const mapSettingsSchema = new mongoose.Schema(
  {
    defaultZoom: {
      type: Number,
      default: 14.0,
      min: [1, 'Minimum zoom must be at least 1'],
      max: [20, 'Maximum zoom cannot exceed 20'],
    },
    minZoom: {
      type: Number,
      default: 5.0,
      min: [1, 'Minimum zoom must be at least 1'],
      max: [20, 'Maximum zoom cannot exceed 20'],
    },
    maxZoom: {
      type: Number,
      default: 18.0,
      min: [1, 'Minimum zoom must be at least 1'],
      max: [20, 'Maximum zoom cannot exceed 20'],
    },
    defaultCenterLat: {
      type: Number,
      default: 27.5830,
      min: [-90, 'Latitude must be between -90 and 90'],
      max: [90, 'Latitude must be between -90 and 90'],
    },
    defaultCenterLng: {
      type: Number,
      default: 77.7000,
      min: [-180, 'Longitude must be between -180 and 180'],
      max: [180, 'Longitude must be between -180 and 180'],
    },
    defaultPinIconStyle: {
      type: String,
      default: 'location_on',
      trim: true,
      enum: {
        values: [
          'location_on',
          'place',
          'temple_hindu',
          'location_pin',
          'my_location',
          'flag',
          'landscape',
          'terrain',
        ],
        message: 'Invalid pin icon style',
      },
    },
    defaultPinColor: {
      type: String,
      default: '#C5221F',
      trim: true,
      match: [/^#([A-Fa-f0-9]{6}|[A-Fa-f0-9]{3})$/, 'Invalid hex color format'],
    },
    defaultPinSize: {
      type: Number,
      default: 42,
      min: [20, 'Pin size must be at least 20'],
      max: [80, 'Pin size cannot exceed 80'],
    },
    mapStyle: {
      type: String,
      default: 'standard',
      trim: true,
      enum: {
        values: ['standard', 'satellite', 'terrain', 'hybrid', 'dark'],
        message: 'Invalid map style',
      },
    },
    availablePinIcons: {
      type: [pinIconStyleSchema],
      default: [
        { name: 'Default Pin', iconClass: 'location_on', isDefault: true },
        { name: 'Place Pin', iconClass: 'place', isDefault: false },
        { name: 'Temple Icon', iconClass: 'temple_hindu', isDefault: false },
        { name: 'Location Pin', iconClass: 'location_pin', isDefault: false },
        { name: 'My Location', iconClass: 'my_location', isDefault: false },
        { name: 'Flag', iconClass: 'flag', isDefault: false },
        { name: 'Landscape', iconClass: 'landscape', isDefault: false },
        { name: 'Terrain', iconClass: 'terrain', isDefault: false },
      ],
    },
    updatedBy: {
      type: mongoose.Schema.Types.ObjectId,
      ref: 'Admin',
    },
  },
  {
    timestamps: true,
  }
);

mapSettingsSchema.index({}, { unique: true });

mapSettingsSchema.pre('validate', function (next) {
  if (this.minZoom > this.defaultZoom) {
    this.defaultZoom = this.minZoom;
  }
  if (this.maxZoom < this.defaultZoom) {
    this.defaultZoom = this.maxZoom;
  }
  if (this.minZoom > this.maxZoom) {
    this.maxZoom = this.minZoom;
  }
  next();
});

mapSettingsSchema.virtual('id').get(function () {
  return this._id.toHexString();
});

const MapSettings = mongoose.model('MapSettings', mapSettingsSchema);

module.exports = MapSettings;
