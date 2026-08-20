const EmergencyContact = require('../models/EmergencyContact');
const ApiResponse = require('../utils/ApiResponse');
const ApiError = require('../utils/ApiError');
const asyncHandler = require('../middleware/asyncHandler');

const getEmergencyContacts = asyncHandler(async (req, res) => {
  const {
    page = 1,
    limit = 50,
    category,
    area = 'Braj',
    isActive = 'true',
    sort = 'sortOrder',
  } = req.query;

  const query = { isDeleted: { $ne: true } };

  if (category) query.category = category;
  if (area) query.area = area;
  if (isActive !== 'all') query.isActive = isActive === 'true';

  const sortObj = {};
  if (sort.startsWith('-')) {
    sortObj[sort.substring(1)] = -1;
  } else {
    sortObj[sort] = 1;
  }

  const skip = (parseInt(page) - 1) * parseInt(limit);

  const [contacts, total] = await Promise.all([
    EmergencyContact.find(query).sort(sortObj).skip(skip).limit(parseInt(limit)),
    EmergencyContact.countDocuments(query),
  ]);

  res.json(
    ApiResponse.success({
      data: contacts,
      meta: {
        currentPage: parseInt(page),
        totalPages: Math.ceil(total / parseInt(limit)),
        totalCount: total,
        limit: parseInt(limit),
      },
    })
  );
});

const getEmergencyContactsByCategory = asyncHandler(async (req, res) => {
  const { category } = req.params;
  const { area = 'Braj' } = req.query;

  const contacts = await EmergencyContact.find({
    isDeleted: { $ne: true },
    category,
    area,
    isActive: true,
  }).sort({ sortOrder: 1 });

  res.json(ApiResponse.success({ data: contacts }));
});

const getEmergencyContact = asyncHandler(async (req, res) => {
  const contact = await EmergencyContact.findOne({
    _id: req.params.id,
    isDeleted: { $ne: true },
  });

  if (!contact) {
    throw new ApiError(404, 'Emergency contact not found');
  }

  res.json(ApiResponse.success({ data: contact }));
});

const createEmergencyContact = asyncHandler(async (req, res) => {
  const contact = await EmergencyContact.create(req.body);
  res.status(201).json(ApiResponse.success({ data: contact }, 'Emergency contact created successfully'));
});

const updateEmergencyContact = asyncHandler(async (req, res) => {
  const contact = await EmergencyContact.findOneAndUpdate(
    { _id: req.params.id, isDeleted: { $ne: true } },
    req.body,
    { new: true, runValidators: true }
  );

  if (!contact) {
    throw new ApiError(404, 'Emergency contact not found');
  }

  res.json(ApiResponse.success({ data: contact }, 'Emergency contact updated successfully'));
});

const deleteEmergencyContact = asyncHandler(async (req, res) => {
  const contact = await EmergencyContact.findOneAndUpdate(
    { _id: req.params.id, isDeleted: { $ne: true } },
    { isDeleted: true, deletedAt: new Date() },
    { new: true }
  );

  if (!contact) {
    throw new ApiError(404, 'Emergency contact not found');
  }

  res.json(ApiResponse.success(null, 'Emergency contact deleted successfully'));
});

const restoreEmergencyContact = asyncHandler(async (req, res) => {
  const contact = await EmergencyContact.findOneAndUpdate(
    { _id: req.params.id, isDeleted: true },
    { isDeleted: false, deletedAt: null },
    { new: true }
  );

  if (!contact) {
    throw new ApiError(404, 'Emergency contact not found or not deleted');
  }

  res.json(ApiResponse.success({ data: contact }, 'Emergency contact restored successfully'));
});

module.exports = {
  getEmergencyContacts,
  getEmergencyContactsByCategory,
  getEmergencyContact,
  createEmergencyContact,
  updateEmergencyContact,
  deleteEmergencyContact,
  restoreEmergencyContact,
};