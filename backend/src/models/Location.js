const mongoose = require('mongoose');
const slugify = require('slugify');

const locationSchema = new mongoose.Schema(
  {
    name: {
      type: String,
      required: [true, 'Location name is required'],
      trim: true,
      unique: true,
      maxlength: [100, 'Location name cannot exceed 100 characters'],
    },
    slug: {
      type: String,
      unique: true,
      lowercase: true,
      index: true,
    },
    description: {
      type: String,
      trim: true,
      default: '',
    },
    coverImage: {
      type: String,
      trim: true,
      default: '',
    },
    district: {
      type: String,
      trim: true,
      default: 'Mathura',
    },
    state: {
      type: String,
      trim: true,
      default: 'Uttar Pradesh',
    },
    country: {
      type: String,
      trim: true,
      default: 'India',
    },
    latitude: {
      type: Number,
      required: [true, 'Latitude is required'],
    },
    longitude: {
      type: Number,
      required: [true, 'Longitude is required'],
    },
    sortOrder: {
      type: Number,
      default: 0,
    },
    status: {
      type: String,
      enum: {
        values: ['active', 'inactive'],
        message: 'Status must be active or inactive',
      },
      default: 'active',
      index: true,
    },
    isDeleted: {
      type: Boolean,
      default: false,
      index: true,
    },
    deletedAt: {
      type: Date,
      default: null,
    },
  },
  {
    timestamps: true,
    toJSON: { virtuals: true },
    toObject: { virtuals: true },
  }
);

// Indexes
locationSchema.index({ isDeleted: 1, status: 1, sortOrder: 1 });
locationSchema.index({ name: 'text', description: 'text', district: 'text' });

locationSchema.pre('save', function (next) {
  if (this.isModified('name') || this.isNew) {
    this.slug = slugify(this.name, { lower: true, strict: true });
  }
  next();
});

// Virtual: templeCount
locationSchema.virtual('templeCount', {
  ref: 'Temple',
  localField: '_id',
  foreignField: 'locationId',
  count: true,
  match: { isDeleted: false, status: 'active' },
});

locationSchema.virtual('id').get(function () {
  return this._id.toHexString();
});

const Location = mongoose.model('Location', locationSchema);

module.exports = Location;
