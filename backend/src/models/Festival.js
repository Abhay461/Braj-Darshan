const mongoose = require('mongoose');
const slugify = require('slugify');

const festivalSchema = new mongoose.Schema(
  {
    name: {
      type: String,
      required: [true, 'Festival name is required'],
      trim: true,
      maxlength: [200, 'Festival name cannot exceed 200 characters'],
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
    bannerImage: {
      type: String,
      trim: true,
      default: '',
    },
    startDate: {
      type: Date,
      default: null,
    },
    endDate: {
      type: Date,
      default: null,
    },
    templeIds: [
      {
        type: mongoose.Schema.Types.ObjectId,
        ref: 'Temple',
      },
    ],
    themeConfig: {
      bannerImage: { type: String, trim: true, default: '' },
      accentColor: { type: String, trim: true, match: [/^#([A-Fa-f0-9]{6}|[A-Fa-f0-9]{3})$/, 'Invalid hex color format'], default: '' },
      showPetals: { type: Boolean, default: false },
      petalType: { type: String, enum: ['gulal', 'flower', 'diya', 'none'], default: 'none' },
    },
    status: {
      type: String,
      enum: ['active', 'inactive'],
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

festivalSchema.index({ isDeleted: 1, status: 1, startDate: 1 });
festivalSchema.index({ name: 'text', description: 'text' });

festivalSchema.pre('save', function (next) {
  if (this.isModified('name') || this.isNew) {
    this.slug = slugify(this.name, { lower: true, strict: true });
  }
  next();
});

festivalSchema.virtual('id').get(function () {
  return this._id.toHexString();
});

const Festival = mongoose.model('Festival', festivalSchema);

module.exports = Festival;
