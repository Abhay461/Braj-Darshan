const mongoose = require('mongoose');
const slugify = require('slugify');

const categorySchema = new mongoose.Schema(
  {
    name: {
      type: String,
      required: [true, 'Category name is required'],
      trim: true,
      unique: true,
      maxlength: [100, 'Category name cannot exceed 100 characters'],
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
    icon: {
      type: String,
      trim: true,
      default: 'temple_hindu',
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
categorySchema.index({ isDeleted: 1, status: 1, sortOrder: 1 });
categorySchema.index({ name: 'text', description: 'text' });

// Auto-generate slug
categorySchema.pre('save', function (next) {
  if (this.isModified('name') || this.isNew) {
    this.slug = slugify(this.name, { lower: true, strict: true });
  }
  next();
});

// Virtual: templeCount
categorySchema.virtual('templeCount', {
  ref: 'Temple',
  localField: '_id',
  foreignField: 'categoryId',
  count: true,
  match: { isDeleted: false, status: 'active' },
});

categorySchema.virtual('id').get(function () {
  return this._id.toHexString();
});

const Category = mongoose.model('Category', categorySchema);

module.exports = Category;
