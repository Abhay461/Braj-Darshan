const mongoose = require('mongoose');
const slugify = require('slugify');

const categorySchema = new mongoose.Schema(
  {
    name: {
      type: String,
      required: [true, 'Category name is required'],
      trim: true,
      maxlength: [100, 'Category name cannot exceed 100 characters'],
    },
    slug: {
      type: String,
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

// Auto-generate unique slug
categorySchema.pre('save', async function (next) {
  if (this.isModified('name') || this.isNew) {
    let baseSlug = slugify(this.name, { lower: true, strict: true }) || 'category';
    let slug = baseSlug;
    let counter = 1;
    const Category = this.constructor;
    while (await Category.findOne({ slug, _id: { $ne: this._id } })) {
      slug = `${baseSlug}-${counter}`;
      counter++;
    }
    this.slug = slug;
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
