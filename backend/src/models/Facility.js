const mongoose = require('mongoose');
const slugify = require('slugify');

const facilitySchema = new mongoose.Schema(
  {
    name: {
      type: String,
      required: [true, 'Facility name is required'],
      trim: true,
      unique: true,
      maxlength: [100, 'Facility name cannot exceed 100 characters'],
    },
    slug: {
      type: String,
      unique: true,
      lowercase: true,
      index: true,
    },
    icon: {
      type: String,
      trim: true,
      default: 'check_circle',
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

facilitySchema.index({ isDeleted: 1, name: 1 });

facilitySchema.pre('save', function (next) {
  if (this.isModified('name') || this.isNew) {
    this.slug = slugify(this.name, { lower: true, strict: true });
  }
  next();
});

facilitySchema.virtual('id').get(function () {
  return this._id.toHexString();
});

const Facility = mongoose.model('Facility', facilitySchema);

module.exports = Facility;
