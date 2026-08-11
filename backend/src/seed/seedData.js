/**
 * Seed Script — Populates the database with exact realistic Braj temples,
 * categories, locations, facilities, and festivals for immediate testing.
 *
 * Usage:
 *   npm run seed          — Insert seed data
 *   npm run seed:destroy  — Remove all seed data
 */
require('dotenv').config();

const mongoose = require('mongoose');
const connectDatabase = require('../config/database');
const Category = require('../models/Category');
const Location = require('../models/Location');
const Facility = require('../models/Facility');
const Festival = require('../models/Festival');
const Temple = require('../models/Temple');
const logger = require('../utils/logger');

// ─── Categories ────────────────────────────────────────
const categories = [
  { name: 'Krishna Temple', description: 'Temples dedicated to Lord Krishna', icon: 'temple_hindu', sortOrder: 1, status: 'active' },
  { name: 'Shiva Temple', description: 'Temples dedicated to Lord Shiva in Braj', icon: 'temple_hindu', sortOrder: 2, status: 'active' },
  { name: 'Radha Temple', description: 'Temples dedicated to Shri Radha Rani', icon: 'favorite', sortOrder: 3, status: 'active' },
  { name: 'Devi Temple', description: 'Temples dedicated to Goddess Devi', icon: 'temple_hindu', sortOrder: 4, status: 'active' },
  { name: 'Ancient Temple', description: 'Historic and ancient temples of Braj Mandal', icon: 'account_balance', sortOrder: 5, status: 'active' },
];

// ─── Locations ─────────────────────────────────────────
const locations = [
  { name: 'Vrindavan', description: 'The holy land where Lord Krishna performed divine Ras Leela', district: 'Mathura', state: 'Uttar Pradesh', country: 'India', latitude: 27.5830, longitude: 77.7000, sortOrder: 1, status: 'active' },
  { name: 'Mathura', description: 'Birthplace of Lord Krishna and historic capital of Braj', district: 'Mathura', state: 'Uttar Pradesh', country: 'India', latitude: 27.4924, longitude: 77.6737, sortOrder: 2, status: 'active' },
  { name: 'Govardhan', description: 'Sacred hill lifted by Lord Krishna on his pinky finger', district: 'Mathura', state: 'Uttar Pradesh', country: 'India', latitude: 27.4950, longitude: 77.4614, sortOrder: 3, status: 'active' },
  { name: 'Barsana', description: 'Birthplace and eternal home of Shri Radha Rani', district: 'Mathura', state: 'Uttar Pradesh', country: 'India', latitude: 27.6483, longitude: 77.3786, sortOrder: 4, status: 'active' },
  { name: 'Nandgaon', description: 'Village of Nanda Maharaj where Krishna spent his childhood', district: 'Mathura', state: 'Uttar Pradesh', country: 'India', latitude: 27.6714, longitude: 77.3667, sortOrder: 5, status: 'active' },
  { name: 'Gokul', description: 'Sacred place where infant Krishna was brought by Vasudeva', district: 'Mathura', state: 'Uttar Pradesh', country: 'India', latitude: 27.4383, longitude: 77.7167, sortOrder: 6, status: 'active' },
  { name: 'Radha Kund', description: 'The sacred lake created by Shri Radha Rani and Lord Krishna', district: 'Mathura', state: 'Uttar Pradesh', country: 'India', latitude: 27.5256, longitude: 77.4878, sortOrder: 7, status: 'active' },
  { name: 'Mahavan', description: 'Ancient Gokul where Lord Krishna spent his early childhood', district: 'Mathura', state: 'Uttar Pradesh', country: 'India', latitude: 27.4333, longitude: 77.7500, sortOrder: 8, status: 'active' },
  { name: 'Baldeo (Dauji)', description: 'Sacred town of Lord Balarama (Dauji Maharaj)', district: 'Mathura', state: 'Uttar Pradesh', country: 'India', latitude: 27.4000, longitude: 77.8167, sortOrder: 9, status: 'active' },
  { name: 'Rawal', description: 'Birthplace of Shri Radha Rani on the bank of river Yamuna', district: 'Mathura', state: 'Uttar Pradesh', country: 'India', latitude: 27.4833, longitude: 77.7333, sortOrder: 10, status: 'active' },
  { name: 'Bhandirvan', description: 'Sacred forest of divine marriage of Shri Radha Krishna', district: 'Mathura', state: 'Uttar Pradesh', country: 'India', latitude: 27.6167, longitude: 77.7500, sortOrder: 11, status: 'active' },
  { name: 'Kamyavan', description: 'One of the twelve sacred forests of Braj Mandal', district: 'Bharatpur', state: 'Rajasthan', country: 'India', latitude: 27.6560, longitude: 77.0140, sortOrder: 12, status: 'active' },
];

// ─── Facilities ────────────────────────────────────────
const facilities = [
  { name: 'Parking', icon: 'local_parking' },
  { name: 'Drinking Water', icon: 'water_drop' },
  { name: 'Toilet', icon: 'wc' },
  { name: 'Prasad', icon: 'restaurant' },
  { name: 'Wheelchair', icon: 'accessible' },
];

const seedDatabase = async () => {
  try {
    await connectDatabase();

    // Destroy mode check
    if (process.argv.includes('--destroy')) {
      await Promise.all([
        Category.deleteMany({}),
        Location.deleteMany({}),
        Facility.deleteMany({}),
        Festival.deleteMany({}),
        Temple.deleteMany({}),
      ]);
      logger.info('Database data completely destroyed');
      process.exit(0);
    }

    // Clear existing data
    await Promise.all([
      Category.deleteMany({}),
      Location.deleteMany({}),
      Facility.deleteMany({}),
      Festival.deleteMany({}),
      Temple.deleteMany({}),
    ]);
    logger.info('Existing data cleared');

    // Insert Base References
    const createdCategories = await Category.insertMany(categories);
    const createdLocations = await Location.insertMany(locations);
    const createdFacilities = await Facility.insertMany(facilities);

    const catMap = {};
    createdCategories.forEach((c) => (catMap[c.name] = c._id));

    const locMap = {};
    createdLocations.forEach((l) => (locMap[l.name] = l._id));

    const facIds = createdFacilities.map((f) => f._id);

    // ─── 8 Primary Temples Seed ────────────────────────
    const temples = [
      {
        name: 'Banke Bihari',
        shortDescription: 'One of the most revered temples in Vrindavan dedicated to Lord Krishna as Banke Bihari.',
        history: 'Established by Swami Haridas in 1864. The deity was originally worshipped at Nidhivan.',
        importance: 'Most visited temple in Vrindavan, famous for its unique curtain darshan style.',
        categoryId: catMap['Krishna Temple'],
        locationId: locMap['Vrindavan'],
        coverImage: 'https://res.cloudinary.com/demo/image/upload/v1/braj-darshan/temples/banke-bihari/cover.jpg',
        thumbnailImage: 'https://res.cloudinary.com/demo/image/upload/w_300,h_225,c_fill/v1/braj-darshan/temples/banke-bihari/cover.jpg',
        galleryImages: [
          {
            imageUrl: 'https://res.cloudinary.com/demo/image/upload/v1/braj-darshan/temples/banke-bihari/gallery/1.jpg',
            thumbnailUrl: 'https://res.cloudinary.com/demo/image/upload/w_300,h_225,c_fill/v1/braj-darshan/temples/banke-bihari/gallery/1.jpg',
            publicId: 'braj-darshan/temples/banke-bihari/gallery/1',
            caption: 'Main sanctum darshan',
            order: 1,
          },
        ],
        darshanTiming: 'Morning: 7:45 AM - 12:00 PM | Evening: 5:30 PM - 9:30 PM',
        phone: '+91-565-2442000',
        website: 'https://www.yugalsarkar.com',
        visitDuration: '1-2 hours',
        parkingAvailable: true,
        wheelchairAccessible: true,
        address: {
          street: 'Godowlia Road, Bihari Pura',
          area: 'Bihari Pura',
          city: 'Vrindavan',
          state: 'Uttar Pradesh',
          pincode: '281121',
        },
        latitude: 27.5692,
        longitude: 77.6639,
        facilities: facIds,
        tags: ['krishna', 'banke bihari', 'vrindavan', 'swami haridas'],
        keywords: ['banke bihari temple', 'vrindavan temple', 'shri krishna darshan'],
        isFeatured: true,
        isPopular: true,
        status: 'active',
        seoTitle: 'Banke Bihari Temple Vrindavan - Timings, History & Darshan',
        seoDescription: 'Complete guide to Banke Bihari Temple in Vrindavan including darshan timings, history, and location.',
      },
      {
        name: 'Prem Mandir',
        shortDescription: 'Stunning white marble temple complex maintained by Jagadguru Kripalu Parishat.',
        history: 'Shila nyas was performed in January 2001 and inauguration took place in February 2012.',
        importance: 'Renowned for intricate Italian marble carvings and captivating evening light displays.',
        categoryId: catMap['Radha Temple'],
        locationId: locMap['Vrindavan'],
        coverImage: 'https://res.cloudinary.com/demo/image/upload/v1/braj-darshan/temples/prem-mandir/cover.jpg',
        thumbnailImage: 'https://res.cloudinary.com/demo/image/upload/w_300,h_225,c_fill/v1/braj-darshan/temples/prem-mandir/cover.jpg',
        galleryImages: [
          {
            imageUrl: 'https://res.cloudinary.com/demo/image/upload/v1/braj-darshan/temples/prem-mandir/gallery/1.jpg',
            thumbnailUrl: 'https://res.cloudinary.com/demo/image/upload/w_300,h_225,c_fill/v1/braj-darshan/temples/prem-mandir/gallery/1.jpg',
            publicId: 'braj-darshan/temples/prem-mandir/gallery/1',
            caption: 'Illuminated marble structure at dusk',
            order: 1,
          },
        ],
        darshanTiming: 'Morning: 5:30 AM - 12:00 PM | Evening: 4:30 PM - 8:30 PM',
        phone: '+91-565-2530000',
        website: 'https://www.jkp.org.in',
        visitDuration: '2-3 hours',
        parkingAvailable: true,
        wheelchairAccessible: true,
        address: {
          street: 'Chhatikara Road',
          area: 'Raman Reti',
          city: 'Vrindavan',
          state: 'Uttar Pradesh',
          pincode: '281121',
        },
        latitude: 27.5724,
        longitude: 77.6738,
        facilities: facIds,
        tags: ['prem mandir', 'radha krishna', 'vrindavan', 'kripalu parishat'],
        keywords: ['prem mandir vrindavan', 'marble temple', 'light show vrindavan'],
        isFeatured: true,
        isPopular: true,
        status: 'active',
        seoTitle: 'Prem Mandir Vrindavan - Marble Temple Timings & Light Show',
        seoDescription: 'Discover Prem Mandir Vrindavan: timings, musical fountain, marble architecture, and history.',
      },
      {
        name: 'ISKCON Vrindavan',
        shortDescription: 'Also known as Sri Sri Krishna Balaram Mandir, established by Srila Prabhupada.',
        history: 'Opened in 1975 by A.C. Bhaktivedanta Swami Prabhupada.',
        importance: 'International hub for Gaudiya Vaishnavism, continuous 24-hour kirtan.',
        categoryId: catMap['Krishna Temple'],
        locationId: locMap['Vrindavan'],
        coverImage: 'https://res.cloudinary.com/demo/image/upload/v1/braj-darshan/temples/iskcon-vrindavan/cover.jpg',
        thumbnailImage: 'https://res.cloudinary.com/demo/image/upload/w_300,h_225,c_fill/v1/braj-darshan/temples/iskcon-vrindavan/cover.jpg',
        galleryImages: [],
        darshanTiming: '4:30 AM - 1:00 PM | 4:30 PM - 8:30 PM',
        phone: '+91-565-2540021',
        website: 'https://www.iskconvrindavan.com',
        visitDuration: '1-2 hours',
        parkingAvailable: true,
        wheelchairAccessible: true,
        address: {
          street: 'Bhakti Vedanta Swami Marg',
          area: 'Raman Reti',
          city: 'Vrindavan',
          state: 'Uttar Pradesh',
          pincode: '281121',
        },
        latitude: 27.5732,
        longitude: 77.6754,
        facilities: facIds,
        tags: ['iskcon', 'krishna balaram', 'prabhupada', 'vrindavan'],
        keywords: ['iskcon vrindavan', 'krishna balaram mandir', 'hare krishna vrindavan'],
        isFeatured: true,
        isPopular: true,
        status: 'active',
        seoTitle: 'ISKCON Vrindavan Krishna Balaram Mandir Guide',
        seoDescription: 'Guide to ISKCON Vrindavan temple including 24-hour kirtan, samadhi, and prashadam details.',
      },
      {
        name: 'Radha Raman',
        shortDescription: 'Ancient self-manifested deity of Shri Radha Raman Dev Ji established by Gopala Bhatta Goswami.',
        history: 'Self-manifested from a Shaligram Shila in 1542.',
        importance: 'One of the seven ancient temples of Vrindavan; sacred kitchen fire has burned continuously for over 480 years.',
        categoryId: catMap['Ancient Temple'],
        locationId: locMap['Vrindavan'],
        coverImage: 'https://res.cloudinary.com/demo/image/upload/v1/braj-darshan/temples/radha-raman/cover.jpg',
        thumbnailImage: 'https://res.cloudinary.com/demo/image/upload/w_300,h_225,c_fill/v1/braj-darshan/temples/radha-raman/cover.jpg',
        galleryImages: [],
        darshanTiming: '8:00 AM - 12:30 PM | 6:00 PM - 9:00 PM',
        visitDuration: '1 hour',
        parkingAvailable: false,
        wheelchairAccessible: false,
        address: {
          street: 'Radha Raman Gali',
          area: 'Shri Shahji Temple Area',
          city: 'Vrindavan',
          state: 'Uttar Pradesh',
          pincode: '281121',
        },
        latitude: 27.5852,
        longitude: 77.7011,
        facilities: facIds.slice(1, 4),
        tags: ['radha raman', 'gopala bhatta goswami', 'ancient temple', 'vrindavan'],
        keywords: ['radha raman temple', 'shaligram shila', 'vrindavan ancient temples'],
        isFeatured: true,
        isPopular: true,
        status: 'active',
        seoTitle: 'Radha Raman Temple Vrindavan - History & Timings',
        seoDescription: 'Learn about Radha Raman Temple established in 1542 with self-manifested Shaligram deity.',
      },
      {
        name: 'Radha Vallabh',
        shortDescription: 'Historical temple of the Radha Vallabh sampradaya established by Hith Harivansh Mahaprabhu.',
        history: 'Established in 1535 by Shri Hith Harivansh Mahaprabhu.',
        importance: 'Emphasizes devotion to Shri Radha Rani as the supreme sovereign deity.',
        categoryId: catMap['Radha Temple'],
        locationId: locMap['Vrindavan'],
        coverImage: 'https://res.cloudinary.com/demo/image/upload/v1/braj-darshan/temples/radha-vallabh/cover.jpg',
        thumbnailImage: 'https://res.cloudinary.com/demo/image/upload/w_300,h_225,c_fill/v1/braj-darshan/temples/radha-vallabh/cover.jpg',
        galleryImages: [],
        darshanTiming: '5:00 AM - 12:00 PM | 5:00 PM - 9:00 PM',
        visitDuration: '1 hour',
        parkingAvailable: false,
        wheelchairAccessible: false,
        address: {
          street: 'Gothra Gali',
          area: 'Radha Vallabh Ghera',
          city: 'Vrindavan',
          state: 'Uttar Pradesh',
          pincode: '281121',
        },
        latitude: 27.5841,
        longitude: 77.7025,
        facilities: facIds.slice(1, 4),
        tags: ['radha vallabh', 'hit harivansh', 'vrindavan'],
        keywords: ['radha vallabh temple', 'hit harivansh mahaprabhu', 'vrindavan darshan'],
        isFeatured: false,
        isPopular: true,
        status: 'active',
        seoTitle: 'Radha Vallabh Temple Vrindavan - Devotional Heritage',
        seoDescription: 'Complete guide to Shri Radha Vallabh Temple in Vrindavan.',
      },
      {
        name: 'Madan Mohan',
        shortDescription: 'One of the oldest temples in Vrindavan located on Dwaita Hill overlooking the Yamuna.',
        history: 'Established by Sanatana Goswami in the 16th century.',
        importance: 'First temple built by the Six Goswamis of Vrindavan.',
        categoryId: catMap['Ancient Temple'],
        locationId: locMap['Vrindavan'],
        coverImage: 'https://res.cloudinary.com/demo/image/upload/v1/braj-darshan/temples/madan-mohan/cover.jpg',
        thumbnailImage: 'https://res.cloudinary.com/demo/image/upload/w_300,h_225,c_fill/v1/braj-darshan/temples/madan-mohan/cover.jpg',
        galleryImages: [],
        darshanTiming: '7:00 AM - 12:00 PM | 4:00 PM - 8:00 PM',
        visitDuration: '1 hour',
        parkingAvailable: false,
        wheelchairAccessible: false,
        address: {
          street: 'Kali Ghat',
          area: 'Dwaita Hill',
          city: 'Vrindavan',
          state: 'Uttar Pradesh',
          pincode: '281121',
        },
        latitude: 27.5867,
        longitude: 77.6980,
        facilities: facIds.slice(1, 4),
        tags: ['madan mohan', 'sanatana goswami', 'ancient temple'],
        keywords: ['madan mohan temple vrindavan', 'sanatana goswami temple'],
        isFeatured: false,
        isPopular: true,
        status: 'active',
        seoTitle: 'Madan Mohan Temple Vrindavan - Oldest Goswami Temple',
        seoDescription: 'Explore the historic Madan Mohan Temple in Vrindavan.',
      },
      {
        name: 'Govind Dev',
        shortDescription: 'Historic red sandstone architectural marvel built by Raja Man Singh of Amber in 1590.',
        history: 'Built by Raja Man Singh under the guidance of Rupa Goswami.',
        importance: 'A masterpiece of medieval Indian architecture combining Hindu, Western, and Mughal styles.',
        categoryId: catMap['Ancient Temple'],
        locationId: locMap['Vrindavan'],
        coverImage: 'https://res.cloudinary.com/demo/image/upload/v1/braj-darshan/temples/govind-dev/cover.jpg',
        thumbnailImage: 'https://res.cloudinary.com/demo/image/upload/w_300,h_225,c_fill/v1/braj-darshan/temples/govind-dev/cover.jpg',
        galleryImages: [],
        darshanTiming: '8:00 AM - 12:30 PM | 4:30 PM - 8:30 PM',
        visitDuration: '1 hour',
        parkingAvailable: true,
        wheelchairAccessible: false,
        address: {
          street: 'Govind Dev Mandir Marg',
          area: 'Vrindavan',
          city: 'Vrindavan',
          state: 'Uttar Pradesh',
          pincode: '281121',
        },
        latitude: 27.5847,
        longitude: 77.7003,
        facilities: facIds.slice(0, 4),
        tags: ['govind dev', 'raja man singh', 'red sandstone temple'],
        keywords: ['govind dev temple vrindavan', 'rupa goswami temple'],
        isFeatured: true,
        isPopular: false,
        status: 'active',
        seoTitle: 'Govind Dev Temple Vrindavan - Red Sandstone Heritage',
        seoDescription: 'Learn about the majestic 16th century Govind Dev Temple in Vrindavan.',
      },
      {
        name: 'Gopinath',
        shortDescription: 'Historic temple established by Madhu Pandit Goswami housing Shri Gopinath Ji.',
        history: 'Originally established by Madhu Pandit Goswami in the 16th century.',
        importance: 'One of the primary ancient Goswami shrines in Vrindavan.',
        categoryId: catMap['Ancient Temple'],
        locationId: locMap['Vrindavan'],
        coverImage: 'https://res.cloudinary.com/demo/image/upload/v1/braj-darshan/temples/gopinath/cover.jpg',
        thumbnailImage: 'https://res.cloudinary.com/demo/image/upload/w_300,h_225,c_fill/v1/braj-darshan/temples/gopinath/cover.jpg',
        galleryImages: [],
        darshanTiming: '7:30 AM - 12:00 PM | 5:00 PM - 8:30 PM',
        visitDuration: '1 hour',
        parkingAvailable: false,
        wheelchairAccessible: false,
        address: {
          street: 'Gopinath Bazaar',
          area: 'Gopinath Gali',
          city: 'Vrindavan',
          state: 'Uttar Pradesh',
          pincode: '281121',
        },
        latitude: 27.5815,
        longitude: 77.7032,
        facilities: facIds.slice(1, 4),
        tags: ['gopinath temple', 'madhu pandit goswami', 'vrindavan ancient'],
        keywords: ['gopinath temple vrindavan', 'ancient temples of braj'],
        isFeatured: false,
        isPopular: false,
        status: 'active',
        seoTitle: 'Gopinath Temple Vrindavan - Historic Shrine',
        seoDescription: 'Guide to Gopinath Temple in Vrindavan with timings and history.',
      },
    ];

    const createdTemples = await Temple.insertMany(temples);

    // ─── Seed Festivals ────────────────────────────────
    const festivalTemples = createdTemples.slice(0, 3).map((t) => t._id);
    const festivals = [
      {
        name: 'Janmashtami',
        description: 'Grand celebration of the birth of Lord Krishna across all Braj temples.',
        bannerImage: 'https://res.cloudinary.com/demo/image/upload/v1/braj-darshan/banners/janmashtami.jpg',
        startDate: new Date('2026-08-25'),
        endDate: new Date('2026-08-26'),
        templeIds: festivalTemples,
        status: 'active',
      },
      {
        name: 'Radhashtami',
        description: 'Celebration of the appearance day of Shri Radha Rani, especially in Barsana and Vrindavan.',
        bannerImage: 'https://res.cloudinary.com/demo/image/upload/v1/braj-darshan/banners/radhashtami.jpg',
        startDate: new Date('2026-09-08'),
        endDate: new Date('2026-09-09'),
        templeIds: festivalTemples,
        status: 'active',
      },
    ];

    await Festival.insertMany(festivals);

    logger.info(`Database seeded successfully!`);
    logger.info(`Categories: ${createdCategories.length}`);
    logger.info(`Locations: ${createdLocations.length}`);
    logger.info(`Facilities: ${createdFacilities.length}`);
    logger.info(`Temples: ${createdTemples.length}`);
    logger.info(`Festivals: ${festivals.length}`);

    process.exit(0);
  } catch (error) {
    logger.error(`Failed to seed database: ${error.message}`);
    console.error(error);
    process.exit(1);
  }
};

seedDatabase();
