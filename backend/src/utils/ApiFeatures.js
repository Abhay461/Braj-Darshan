/**
 * ApiFeatures — Chainable query builder for Mongoose.
 *
 * Supports:
 *  • Filtering (field=value, field[gte]=value, etc.)
 *  • Full-text search (?search=keyword)
 *  • Sorting (?sort=-createdAt,name)
 *  • Field selection (?fields=name,slug,coverImage)
 *  • Pagination (?page=2&limit=20)
 *
 * Designed for 100k+ document collections with indexed queries.
 */
class ApiFeatures {
  /**
   * @param {import('mongoose').Query} query - Mongoose query object
   * @param {object} queryString - Express req.query
   */
  constructor(query, queryString) {
    this.query = query;
    this.queryString = queryString;
    this.totalCount = 0;
  }

  /**
   * Filter by query parameters.
   * Supports MongoDB comparison operators: gte, gt, lte, lt, ne, in
   * Usage: ?status=active&viewCount[gte]=100
   */
  filter() {
    const queryObj = { ...this.queryString };
    const excludedFields = ['page', 'sort', 'limit', 'fields', 'search', 'populate'];
    excludedFields.forEach((field) => delete queryObj[field]);

    // Handle 'in' operator for arrays: ?categoryId[in]=id1,id2
    Object.keys(queryObj).forEach((key) => {
      if (typeof queryObj[key] === 'object') {
        Object.keys(queryObj[key]).forEach((op) => {
          if (op === 'in' && typeof queryObj[key][op] === 'string') {
            queryObj[key][op] = queryObj[key][op].split(',');
          }
        });
      }
    });

    // Convert to MongoDB operators: { gte: 100 } → { $gte: 100 }
    let queryStr = JSON.stringify(queryObj);
    queryStr = queryStr.replace(
      /\b(gte|gt|lte|lt|ne|in|nin|regex)\b/g,
      (match) => `$${match}`
    );

    this.query = this.query.find(JSON.parse(queryStr));
    return this;
  }

  /**
   * Full-text search using MongoDB text index.
   * Usage: ?search=banke bihari
   */
  search() {
    if (this.queryString.search) {
      const searchTerm = this.queryString.search.trim();

      this.query = this.query.find({
        $or: [
          { $text: { $search: searchTerm } },
          { name: { $regex: searchTerm, $options: 'i' } },
          { tags: { $regex: searchTerm, $options: 'i' } },
          { keywords: { $regex: searchTerm, $options: 'i' } },
          { 'address.area': { $regex: searchTerm, $options: 'i' } },
        ],
      });
    }
    return this;
  }

  /**
   * Sort results.
   * Usage: ?sort=-createdAt,name (prefix with - for descending)
   * Default: -createdAt
   */
  sort() {
    if (this.queryString.sort) {
      const sortBy = this.queryString.sort.split(',').join(' ');
      this.query = this.query.sort(sortBy);
    } else {
      this.query = this.query.sort('-createdAt');
    }
    return this;
  }

  /**
   * Select specific fields.
   * Usage: ?fields=name,slug,coverImage
   * Always excludes __v
   */
  selectFields() {
    if (this.queryString.fields) {
      const fields = this.queryString.fields.split(',').join(' ');
      this.query = this.query.select(fields);
    } else {
      this.query = this.query.select('-__v');
    }
    return this;
  }

  /**
   * Paginate results.
   * Usage: ?page=2&limit=20
   * Default: page=1, limit=10, max=100
   */
  paginate() {
    const page = Math.max(1, parseInt(this.queryString.page, 10) || 1);
    const limit = Math.min(100, Math.max(1, parseInt(this.queryString.limit, 10) || 10));
    const skip = (page - 1) * limit;

    this.page = page;
    this.limit = limit;
    this.query = this.query.skip(skip).limit(limit);

    return this;
  }

  /**
   * Count total documents matching the filter (before pagination).
   * Must be called after filter() and search() but before exec().
   */
  async countDocuments() {
    const countQuery = this.query.model.find(this.query.getFilter());
    this.totalCount = await countQuery.countDocuments();
    return this;
  }

  /**
   * Generate pagination metadata.
   */
  getPaginationMeta() {
    const totalPages = Math.ceil(this.totalCount / this.limit);
    return {
      currentPage: this.page,
      totalPages,
      totalCount: this.totalCount,
      limit: this.limit,
      hasNextPage: this.page < totalPages,
      hasPrevPage: this.page > 1,
    };
  }
}

module.exports = ApiFeatures;
