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
  status?: 'active' | 'inactive';
  isDeleted?: boolean;
  deletedAt?: string | null;
  createdAt?: string;
  updatedAt?: string;
}

export interface Temple {
  _id: string;
  id?: string;
  name: string;
  slug: string;
  shortDescription: string;
  history?: string;
  importance?: string;
  categoryId: string | Category;
  locationId: string | Location;
  coverImage: string;
  thumbnailImage?: string;
  galleryImages?: GalleryImage[];
  address?: TempleAddress;
  latitude: number;
  longitude: number;
  darshanTiming?: string;
  phone?: string;
  website?: string;
  donationUrl?: string;
  guestHouseBookingUrl?: string;
  liveDarshanUrl?: string;
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
