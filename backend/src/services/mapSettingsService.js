const MapSettings = require('../models/MapSettings');
const ApiError = require('../utils/ApiError');

class MapSettingsService {
  async getSettings() {
    let settings = await MapSettings.findOne({});
    if (!settings) {
      settings = await MapSettings.create({});
    }
    return settings;
  }

  async updateSettings(updateData, adminId = null) {
    let settings = await MapSettings.findOne({});

    if (!settings) {
      settings = await MapSettings.create({ ...updateData, updatedBy: adminId });
    } else {
      Object.assign(settings, updateData);
      if (adminId) settings.updatedBy = adminId;
      await settings.save();
    }

    return settings;
  }

  async resetToDefaults(adminId = null) {
    let settings = await MapSettings.findOne({});

    if (!settings) {
      settings = await MapSettings.create({ updatedBy: adminId });
    } else {
      const defaults = new MapSettings({});
      Object.keys(settings.toObject()).forEach((key) => {
        if (!['_id', 'createdAt', '__v'].includes(key)) {
          settings[key] = defaults[key];
        }
      });
      if (adminId) settings.updatedBy = adminId;
      await settings.save();
    }

    return settings;
  }
}

module.exports = new MapSettingsService();
