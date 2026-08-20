const mongoose = require('mongoose');

const emergencyContactSchema = new mongoose.Schema(
  {
    name: {
      type: String,
      required: [true, 'Name is required'],
      trim: true,
      maxlength: [100, 'Name cannot exceed 100 characters'],
    },
    category: {
      type: String,
      required: [true, 'Category is required'],
      enum: {
        values: ['police', 'medical', 'fire', 'helpline', 'hospital', 'ambulance', 'tourist_police', 'other'],
        message: 'Invalid category',
      },
      index: true,
    },
    phone: {
      type: String,
      required: [true, 'Phone number is required'],
      trim: true,
      match: [/^[\+]?[(]?[0-9]{3}[)]?[-\s\.]?[0-9]{3}[-\s\.]?[0-9]{4,6}$/, 'Invalid phone number format'],
    },
    description: {
      type: String,
      trim: true,
      default: '',
    },
    location: {
      lat: { type: Number, min: -90, max: 90 },
      lng: { type: Number, min: -180, max: 180 },
      address: { type: String, trim: true, default: '' },
      name: { type: String, trim: true, default: '' },
    },
    isActive: {
      type: Boolean,
      default: true,
      index: true,
    },
    sortOrder: {
      type: Number,
      default: 0,
    },
    area: {
      type: String,
      trim: true,
      default: 'Braj',
    },
    isVerified: {
      type: Boolean,
      default: false,
    },
  },
  {
    timestamps: true,
    toJSON: { virtuals: true },
    toObject: { virtuals: true },
  }
);

emergencyContactSchema.index({ isActive: 1, category: 1, sortOrder: 1 });
emergencyContactSchema.index({ area: 1, isActive: 1 });

emergencyContactSchema.virtual('id').get(function () {
  return this._id.toHexString();
});

const EmergencyContact = mongoose.model('EmergencyContact', emergencyContactSchema);

module.exports = EmergencyContact;