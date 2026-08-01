const ApiFeatures = require('../utils/ApiFeatures');

/**
 * Base Repository — generic data-access layer for all Mongoose models.
 * Subclasses inherit CRUD, pagination, filtering, sorting, and search.
 *
 * Repository pattern decouples business logic (services) from data access (Mongoose).
 */
class BaseRepository {
  /**
   * @param {import('mongoose').Model} model - Mongoose model
   */
  constructor(model) {
    this.model = model;
  }

  /**
   * Create a new document.
   * @param {object} data
   * @returns {Promise<Document>}
   */
  async create(data) {
    const doc = await this.model.create(data);
    return doc;
  }

  /**
   * Find a single document by ID.
   * @param {string} id
   * @param {string} [populateFields] - Space-separated populate paths
   * @returns {Promise<Document|null>}
   */
  async findById(id, populateFields = '') {
    let query = this.model.findById(id);
    if (populateFields) {
      populateFields.split(' ').forEach((field) => {
        query = query.populate(field);
      });
    }
    return query.exec();
  }

  /**
   * Find a single document by slug.
   */
  async findBySlug(slug, populateFields = '') {
    let query = this.model.findOne({ slug });
    if (populateFields) {
      populateFields.split(' ').forEach((field) => {
        query = query.populate(field);
      });
    }
    return query.exec();
  }

  /**
   * Find a single document by arbitrary conditions.
   */
  async findOne(conditions, populateFields = '') {
    let query = this.model.findOne(conditions);
    if (populateFields) {
      populateFields.split(' ').forEach((field) => {
        query = query.populate(field);
      });
    }
    return query.exec();
  }

  /**
   * Find all documents matching query parameters with pagination.
   * Uses ApiFeatures for filter, search, sort, select, paginate.
   *
   * @param {object} queryString - Express req.query
   * @param {string} [populateFields] - Space-separated populate paths
   * @returns {Promise<{data: Document[], meta: object}>}
   */
  async findAll(queryString = {}, populateFields = '') {
    const features = new ApiFeatures(this.model.find(), queryString)
      .filter()
      .search()
      .sort()
      .selectFields()
      .paginate();

    await features.countDocuments();

    let query = features.query;
    if (populateFields) {
      populateFields.split(' ').forEach((field) => {
        query = query.populate(field);
      });
    }

    const data = await query.lean().exec();

    return {
      data,
      meta: features.getPaginationMeta(),
    };
  }

  /**
   * Update a document by ID.
   * @param {string} id
   * @param {object} updateData
   * @returns {Promise<Document|null>}
   */
  async updateById(id, updateData) {
    const doc = await this.model.findByIdAndUpdate(id, updateData, {
      new: true,
      runValidators: true,
    });
    return doc;
  }

  /**
   * Delete a document by ID.
   * @param {string} id
   * @returns {Promise<Document|null>}
   */
  async deleteById(id) {
    return this.model.findByIdAndDelete(id);
  }

  /**
   * Count documents matching conditions.
   */
  async count(conditions = {}) {
    return this.model.countDocuments(conditions);
  }

  /**
   * Check if a document exists by conditions.
   */
  async exists(conditions) {
    const doc = await this.model.exists(conditions);
    return !!doc;
  }

  /**
   * Bulk insert documents.
   */
  async insertMany(docs) {
    return this.model.insertMany(docs);
  }

  /**
   * Delete many documents matching conditions.
   */
  async deleteMany(conditions = {}) {
    return this.model.deleteMany(conditions);
  }

  /**
   * Run an aggregation pipeline.
   */
  async aggregate(pipeline) {
    return this.model.aggregate(pipeline);
  }
}

module.exports = BaseRepository;
