const mongoose = require('mongoose');
const slugify = require('slugify');

const galleryImageSchema = new mongoose.Schema(
  {
    imageUrl: { type: String, required: true, trim: true },
    thumbnailUrl: { type: String, trim: true, default: '' },
    publicId: { type: String, trim: true, default: '' },
    caption: { type: String, trim: true, default: '' },
    order: { type: Number, default: 0 },
  },
  { _id: false }
);

const templeSchema = new mongoose.Schema(
  {
    name: {
      type: String,
      required: [true, 'Temple name is required'],
      trim: true,
      maxlength: [200, 'Temple name cannot exceed 200 characters'],
      index: true,
    },
    slug: {
      type: String,
      unique: true,
      lowercase: true,
      trim: true,
      index: true,
    },
    shortDescription: {
      type: String,
      required: [true, 'Short description is required'],
      trim: true,
      maxlength: [2000, 'Short description cannot exceed 2000 characters'],
    },
    history: {
      type: String,
      trim: true,
      default: '',
    },
    importance: {
      type: String,
      trim: true,
      default: '',
    },

    // ─── References ────────────────────────────────────
    categoryId: {
      type: mongoose.Schema.Types.ObjectId,
      ref: 'Category',
      required: [true, 'Category is required'],
      index: true,
    },
    locationId: {
      type: mongoose.Schema.Types.ObjectId,
      ref: 'Location',
      required: [true, 'Location is required'],
      index: true,
    },

    // ─── Images (Cloudinary) ───────────────────────────
    coverImage: {
      type: String,
      required: [true, 'Cover image URL is required'],
      trim: true,
    },
    thumbnailImage: {
      type: String,
      trim: true,
      default: '',
    },
    galleryImages: [galleryImageSchema],

    // ─── Address & Geolocation ─────────────────────────
    address: {
      street: { type: String, trim: true, default: '' },
      area: { type: String, trim: true, default: '' },
      city: { type: String, trim: true, default: '' },
      state: { type: String, trim: true, default: 'Uttar Pradesh' },
      pincode: { type: String, trim: true, default: '' },
      full: { type: String, trim: true, default: '' },
    },
    latitude: {
      type: Number,
      required: [true, 'Latitude is required'],
      min: [-90, 'Latitude must be between -90 and 90'],
      max: [90, 'Latitude must be between -90 and 90'],
    },
    longitude: {
      type: Number,
      required: [true, 'Longitude is required'],
      min: [-180, 'Longitude must be between -180 and 180'],
      max: [180, 'Longitude must be between -180 and 180'],
    },

    // ─── Visit Information ─────────────────────────────
    darshanTiming: {
      type: String,
      trim: true,
      default: '',
    },
    phone: {
      type: String,
      trim: true,
      default: '',
    },
    website: {
      type: String,
      trim: true,
      default: '',
    },
    donationUrl: {
      type: String,
      trim: true,
      default: '',
    },
    guestHouseBookingUrl: {
      type: String,
      trim: true,
      default: '',
    },
    liveDarshanUrl: {
      type: String,
      trim: true,
      default: '',
    },
    directionsUrl: {
      type: String,
      trim: true,
      default: '',
    },
    visitDuration: {
      type: String,
      trim: true,
      default: '1-2 hours',
    },
    parkingAvailable: {
      type: Boolean,
      default: false,
    },
    wheelchairAccessible: {
      type: Boolean,
      default: false,
    },

    // ─── Facilities ────────────────────────────────────
    facilities: [
      {
        type: mongoose.Schema.Types.ObjectId,
        ref: 'Facility',
      },
    ],

    // ─── Search & Tagging ──────────────────────────────
    tags: [
      {
        type: String,
        trim: true,
        lowercase: true,
      },
    ],
    keywords: [
      {
        type: String,
        trim: true,
        lowercase: true,
      },
    ],

    // ─── Listing & Status Flags ────────────────────────
    isFeatured: {
      type: Boolean,
      default: false,
      index: true,
    },
    isPopular: {
      type: Boolean,
      default: false,
      index: true,
    },
    status: {
      type: String,
      enum: {
        values: ['active', 'inactive', 'draft'],
        message: 'Status must be active, inactive, or draft',
      },
      default: 'active',
      index: true,
    },

    // ─── SEO Metadata ──────────────────────────────────
    seoTitle: {
      type: String,
      trim: true,
      default: '',
    },
    seoDescription: {
      type: String,
      trim: true,
      default: '',
    },

    // ─── Soft Delete ───────────────────────────────────
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

// ─── Compound Indexes for High Concurrency (100k+ scale) ─
templeSchema.index({ isDeleted: 1, status: 1, createdAt: -1 });
templeSchema.index({ isDeleted: 1, status: 1, isFeatured: 1, createdAt: -1 });
templeSchema.index({ isDeleted: 1, status: 1, isPopular: 1, createdAt: -1 });
templeSchema.index({ isDeleted: 1, status: 1, categoryId: 1, createdAt: -1 });
templeSchema.index({ isDeleted: 1, status: 1, locationId: 1, createdAt: -1 });
templeSchema.index({ isDeleted: 1, latitude: 1, longitude: 1 });

// ─── Text Index for Full-Text Search ────────────────────
templeSchema.index(
  {
    name: 'text',
    shortDescription: 'text',
    history: 'text',
    importance: 'text',
    'address.area': 'text',
    'address.city': 'text',
    tags: 'text',
    keywords: 'text',
  },
  {
    weights: {
      name: 10,
      tags: 5,
      keywords: 5,
      shortDescription: 3,
      history: 2,
      importance: 2,
      'address.city': 2,
      'address.area': 2,
    },
    name: 'temple_text_search',
  }
);

// ─── Pre-save Hooks ─────────────────────────────────────
templeSchema.pre('save', async function (next) {
  if (this.isModified('name') || this.isNew) {
    let baseSlug = slugify(this.name, { lower: true, strict: true, locale: 'en' });
    let slug = baseSlug;
    let counter = 1;
    const Temple = this.constructor;
    while (await Temple.findOne({ slug, _id: { $ne: this._id } })) {
      slug = `${baseSlug}-${counter}`;
      counter++;
    }
    this.slug = slug;
  }

  // Auto-generate full address if components exist
  if (this.isModified('address')) {
    const parts = [
      this.address.street,
      this.address.area,
      this.address.city,
      this.address.state,
      this.address.pincode,
    ].filter(Boolean);
    if (parts.length > 0) {
      this.address.full = parts.join(', ');
    }
  }
  next();
});

// ─── Virtuals ──────────────────────────────────────────
templeSchema.virtual('id').get(function () {
  return this._id.toHexString();
});

const Temple = mongoose.model('Temple', templeSchema);

module.exports = Temple;
