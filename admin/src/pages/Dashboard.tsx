import React from 'react';
import {
  Box,
  Typography,
  Grid2 as Grid,
  Card,
  CardContent,
  Button,
  Chip,
  Table,
  TableHead,
  TableRow,
  TableCell,
  TableBody,
} from '@mui/material';
import TempleIcon from '@mui/icons-material/AccountBalanceOutlined';
import CategoryIcon from '@mui/icons-material/CategoryOutlined';
import LocationIcon from '@mui/icons-material/LocationOnOutlined';
import FacilityIcon from '@mui/icons-material/CheckCircleOutlined';
import FestivalIcon from '@mui/icons-material/EventOutlined';
import StarIcon from '@mui/icons-material/StarBorderOutlined';
import TrendingUpIcon from '@mui/icons-material/TrendingUpOutlined';
import CloudIcon from '@mui/icons-material/CloudOutlined';
import AddIcon from '@mui/icons-material/Add';
import { Link as RouterLink } from 'react-router-dom';
import { ResponsiveContainer, BarChart, Bar, XAxis, YAxis, Tooltip, PieChart, Pie, Cell } from 'recharts';

import { PageHeader } from '../components/common/PageHeader';
import { StatCard } from '../components/common/StatCard';
import { LoadingSkeleton, CardSkeleton } from '../components/common/LoadingSkeleton';
import { StatusChip } from '../components/common/StatusChip';
import { useTemples, useFeaturedTemples, usePopularTemples, useRecentTemples } from '../hooks/useTemples';
import { useCategories } from '../hooks/useCategories';
import { useLocations } from '../hooks/useLocations';
import { useFacilities } from '../hooks/useFacilities';
import { useFestivals } from '../hooks/useFestivals';
import { useHealth } from '../hooks/useHealth';

const MONOCHROME_COLORS = ['#18181B', '#3F3F46', '#71717A', '#A1A1AA', '#D4D4D8', '#E4E4E7'];

export const Dashboard: React.FC = () => {
  const { data: templesRes, isLoading: loadingTemples } = useTemples({ limit: 100 });
  const { data: featuredRes } = useFeaturedTemples(10);
  const { data: popularRes } = usePopularTemples(10);
  const { data: recentRes } = useRecentTemples(5);
  const { data: categoriesRes } = useCategories();
  const { data: locationsRes } = useLocations();
  const { data: facilitiesRes } = useFacilities();
  const { data: festivalsRes } = useFestivals();
  const { data: healthRes } = useHealth();

  if (loadingTemples) {
    return (
      <Box>
        <PageHeader title="Dashboard" subtitle="Overview of Braj Darshan Platform" />
        <CardSkeleton />
        <Box sx={{ mt: 3 }}>
          <LoadingSkeleton rows={4} />
        </Box>
      </Box>
    );
  }

  const temples = templesRes?.data || [];
  const totalTemples = templesRes?.meta?.totalCount || temples.length;
  const categories = categoriesRes?.data || [];
  const locations = locationsRes?.data || [];
  const facilities = facilitiesRes?.data || [];
  const festivals = festivalsRes?.data || [];
  const featuredCount = featuredRes?.data?.length || 0;
  const popularCount = popularRes?.data?.length || 0;

  // Group temples by Category for Chart
  const categoryData = categories.map((cat) => {
    const count = temples.filter((t) => {
      const catId = typeof t.categoryId === 'object' ? t.categoryId._id : t.categoryId;
      return catId === cat._id;
    }).length;
    return { name: cat.name, count };
  });

  // Group temples by Location for Chart
  const locationData = locations.map((loc) => {
    const count = temples.filter((t) => {
      const locId = typeof t.locationId === 'object' ? t.locationId._id : t.locationId;
      return locId === loc._id;
    }).length;
    return { name: loc.name, count };
  });

  return (
    <Box>
      <PageHeader
        title="Dashboard Overview"
        subtitle="Real-time status and statistics for Braj Darshan platform"
        actions={
          <Button
            component={RouterLink}
            to="/temples/new"
            variant="contained"
            startIcon={<AddIcon />}
            sx={{ borderRadius: '12px' }}
          >
            Add New Temple
          </Button>
        }
      />

      {/* Metric Cards Grid */}
      <Grid container spacing={2.5} sx={{ mb: 4 }}>
        <Grid size={{ xs: 12, sm: 6, md: 3 }}>
          <StatCard title="Total Temples" value={totalTemples} subtitle="Active on platform" icon={<TempleIcon />} />
        </Grid>
        <Grid size={{ xs: 12, sm: 6, md: 3 }}>
          <StatCard title="Featured" value={featuredCount} subtitle="Highlighted shrines" icon={<StarIcon />} />
        </Grid>
        <Grid size={{ xs: 12, sm: 6, md: 3 }}>
          <StatCard title="Popular Shrines" value={popularCount} subtitle="High visitor interest" icon={<TrendingUpIcon />} />
        </Grid>
        <Grid size={{ xs: 12, sm: 6, md: 3 }}>
          <StatCard title="Categories" value={categories.length} subtitle="Temple types" icon={<CategoryIcon />} />
        </Grid>

        <Grid size={{ xs: 12, sm: 6, md: 3 }}>
          <StatCard title="Locations" value={locations.length} subtitle="Sacred Braj towns" icon={<LocationIcon />} />
        </Grid>
        <Grid size={{ xs: 12, sm: 6, md: 3 }}>
          <StatCard title="Facilities" value={facilities.length} subtitle="Visitor amenities" icon={<FacilityIcon />} />
        </Grid>
        <Grid size={{ xs: 12, sm: 6, md: 3 }}>
          <StatCard title="Festivals" value={festivals.length} subtitle="Upcoming events" icon={<FestivalIcon />} />
        </Grid>
        <Grid size={{ xs: 12, sm: 6, md: 3 }}>
          <StatCard
            title="Cloudinary CDN"
            value={healthRes?.data?.cloudinary || 'configured'}
            subtitle="Auto WebP/AVIF active"
            icon={<CloudIcon />}
          />
        </Grid>
      </Grid>

      {/* Analytics Charts */}
      <Grid container spacing={3} sx={{ mb: 4 }}>
        <Grid size={{ xs: 12, md: 7 }}>
          <Card sx={{ p: 2 }}>
            <CardContent>
              <Typography variant="h4" sx={{ mb: 2, fontWeight: 700 }}>
                Temples by Location
              </Typography>
              <Box sx={{ width: '100%', height: 260 }}>
                <ResponsiveContainer width="100%" height="100%">
                  <BarChart data={locationData}>
                    <XAxis dataKey="name" stroke="#71717A" fontSize={12} tickLine={false} />
                    <YAxis stroke="#71717A" fontSize={12} tickLine={false} />
                    <Tooltip cursor={{ fill: '#F4F4F5' }} />
                    <Bar dataKey="count" fill="#18181B" radius={[8, 8, 0, 0]} />
                  </BarChart>
                </ResponsiveContainer>
              </Box>
            </CardContent>
          </Card>
        </Grid>

        <Grid size={{ xs: 12, md: 5 }}>
          <Card sx={{ p: 2 }}>
            <CardContent>
              <Typography variant="h4" sx={{ mb: 2, fontWeight: 700 }}>
                Temples by Category
              </Typography>
              <Box sx={{ width: '100%', height: 260, display: 'flex', alignItems: 'center', justifyContent: 'center' }}>
                <ResponsiveContainer width="100%" height="100%">
                  <PieChart>
                    <Pie
                      data={categoryData}
                      dataKey="count"
                      nameKey="name"
                      cx="50%"
                      cy="50%"
                      innerRadius={50}
                      outerRadius={80}
                      paddingAngle={4}
                    >
                      {categoryData.map((_, index) => (
                        <Cell key={`cell-${index}`} fill={MONOCHROME_COLORS[index % MONOCHROME_COLORS.length]} />
                      ))}
                    </Pie>
                    <Tooltip />
                  </PieChart>
                </ResponsiveContainer>
              </Box>
            </CardContent>
          </Card>
        </Grid>
      </Grid>

      {/* Recent Temples Table */}
      <Card sx={{ p: 1 }}>
        <CardContent>
          <Box sx={{ display: 'flex', justifyContent: 'space-between', alignItems: 'center', mb: 2 }}>
            <Typography variant="h4" sx={{ fontWeight: 700 }}>
              Recently Added Temples
            </Typography>
            <Button component={RouterLink} to="/temples" size="small">
              View All Temples
            </Button>
          </Box>

          <Table size="small">
            <TableHead>
              <TableRow>
                <TableCell>Temple</TableCell>
                <TableCell>Category</TableCell>
                <TableCell>Location</TableCell>
                <TableCell>Status</TableCell>
                <TableCell align="right">Action</TableCell>
              </TableRow>
            </TableHead>
            <TableBody>
              {(recentRes?.data || temples.slice(0, 5)).map((temple) => {
                const catName = typeof temple.categoryId === 'object' ? temple.categoryId.name : 'Category';
                const locName = typeof temple.locationId === 'object' ? temple.locationId.name : 'Location';
                return (
                  <TableRow key={temple._id} hover>
                    <TableCell sx={{ fontWeight: 600 }}>{temple.name}</TableCell>
                    <TableCell>{catName}</TableCell>
                    <TableCell>{locName}</TableCell>
                    <TableCell>
                      <StatusChip status={temple.status} isDeleted={temple.isDeleted} />
                    </TableCell>
                    <TableCell align="right">
                      <Button component={RouterLink} to={`/temples/${temple._id}/edit`} size="small">
                        Edit
                      </Button>
                    </TableCell>
                  </TableRow>
                );
              })}
            </TableBody>
          </Table>
        </CardContent>
      </Card>
    </Box>
  );
};
