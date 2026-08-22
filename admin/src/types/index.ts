export interface ApiResponse<T> {
  success: boolean;
  message: string;
  data: T;
  meta?: PaginationMeta;
}

export interface PaginationMeta {
  currentPage: number;
  totalPages: number;
  totalCount: number;
  limit: number;
  hasNextPage: boolean;
  hasPrevPage: boolean;
}

export interface GalleryImage {
  imageUrl: string;
  thumbnailUrl: string;
  publicId: string;
  caption?: string;
  order?: number;
}

export interface TempleAddress {
  street?: string;
  area?: string;
  city?: string;
  state?: string;
  pincode?: string;
  full?: string;
}

export interface Category {
  _id: string;
  id?: string;
  name: string;
  slug: string;
  description?: string;
  icon?: string;
  sortOrder?: number;
  status: 'active' | 'inactive';
  isDeleted?: boolean;
  deletedAt?: string | null;
  templeCount?: number;
  createdAt?: string;
  updatedAt?: string;
}

export interface Location {
  _id: string;
  id?: string;
  name: string;
  slug: string;
  description?: string;
  coverImage?: string;
  district?: string;
  state?: string;
  country?: string;
  latitude: number;
  longitude: number;
  sortOrder?: number;
  status: 'active' | 'inactive';
  isDeleted?: boolean;
  deletedAt?: string | null;
  templeCount?: number;
  createdAt?: string;
  updatedAt?: string;
}

export interface Facility {
  _id: string;
  id?: string;
  name: string;
  slug: string;
  icon?: string;
  isDeleted?: boolean;
  deletedAt?: string | null;
  createdAt?: string;
  updatedAt?: string;
}

export interface FestivalThemeConfig {
  bannerImage?: string;
  accentColor?: string;
  showPetals?: boolean;
  petalType?: 'gulal' | 'flower' | 'diya' | 'none';
}

export interface Festival {
  _id: string;
  id?: string;
  name: string;
  slug: string;
  description?: string;
  bannerImage?: string;
  startDate?: string | null;
  endDate?: string | null;
  templeIds?: (string | Temple)[];
  themeConfig?: FestivalThemeConfig;
  status?: 'active' | 'inactive';
  isDeleted?: boolean;
  deletedAt?: string | null;
  createdAt?: string;
  updatedAt?: string;
}

export interface PinIconOption {
  name: string;
  iconClass: string;
  isDefault: boolean;
}

export interface MapSettings {
  defaultZoom: number;
  minZoom: number;
  maxZoom: number;
  defaultCenterLat: number;
  defaultCenterLng: number;
  defaultPinIconStyle: string;
  defaultPinColor: string;
  defaultPinSize: number;
  mapStyle: string;
  availablePinIcons: PinIconOption[];
  updatedBy?: string;
  createdAt?: string;
  updatedAt?: string;
}

export interface Temple {
  _id: string;
  id?: string;
  name: string;
  nameHindi?: string;
  slug: string;
  shortDescription: string;
  history?: string;
  historyHindi?: string;
  importance?: string;
  categoryId: string | Category;
  locationId: string | Location;
  coverImage: string;
  thumbnailImage?: string;
  galleryImages?: GalleryImage[];
  address?: TempleAddress;
  latitude: number;
  longitude: number;
  mapZoom?: number;
  mapPinIconStyle?: string;
  mapPinColor?: string;
  mapPinSize?: number;
  darshanTiming?: string;
  phone?: string;
  website?: string;
  donationUrl?: string;
  guestHouseBookingUrl?: string;
  liveDarshanUrl?: string;
  directionsUrl?: string;
  visitDuration?: string;
  parkingAvailable?: boolean;
  wheelchairAccessible?: boolean;
  facilities?: (string | Facility)[];
  tags?: string[];
  keywords?: string[];
  isFeatured?: boolean;
  isPopular?: boolean;
  status: 'active' | 'inactive' | 'draft';
  seoTitle?: string;
  seoDescription?: string;
  isDeleted?: boolean;
  deletedAt?: string | null;
  createdAt?: string;
  updatedAt?: string;
}

export interface HealthData {
  status: string;
  database: string;
  cloudinary: string;
  version: string;
  uptime: number;
  timestamp: string;
}

export interface QueryParams {
  page?: number;
  limit?: number;
  sort?: string;
  search?: string;
  status?: string;
  categoryId?: string;
  locationId?: string;
  isFeatured?: boolean;
  isPopular?: boolean;
}

export interface EmergencyContactLocation {
  lat?: number;
  lng?: number;
  address?: string;
  name?: string;
}

export interface EmergencyContact {
  _id: string;
  id?: string;
  name: string;
  category: 'police' | 'medical' | 'fire' | 'helpline' | 'hospital' | 'ambulance' | 'tourist_police' | 'other';
  phone: string;
  description?: string;
  location?: EmergencyContactLocation;
  isActive: boolean;
  sortOrder: number;
  area: string;
  isVerified: boolean;
  isDeleted?: boolean;
  deletedAt?: string | null;
  createdAt?: string;
  updatedAt?: string;
}
