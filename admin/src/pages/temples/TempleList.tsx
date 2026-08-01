import React, { useState } from 'react';
import {
  Box,
  Card,
  CardContent,
  TextField,
  Button,
  IconButton,
  Typography,
  Switch,
  FormControl,
  InputLabel,
  Select,
  MenuItem,
  InputAdornment,
  Tooltip,
} from '@mui/material';
import SearchIcon from '@mui/icons-material/Search';
import AddIcon from '@mui/icons-material/Add';
import EditIcon from '@mui/icons-material/EditOutlined';
import DeleteIcon from '@mui/icons-material/DeleteOutlined';
import RestoreIcon from '@mui/icons-material/RestoreOutlined';
import VisibilityIcon from '@mui/icons-material/VisibilityOutlined';
import FileUploadIcon from '@mui/icons-material/FileUploadOutlined';
import { DataGrid, GridColDef } from '@mui/x-data-grid';
import { Link as RouterLink } from 'react-router-dom';

import { PageHeader } from '../../components/common/PageHeader';
import { StatusChip } from '../../components/common/StatusChip';
import { ConfirmDialog } from '../../components/common/ConfirmDialog';
import { TemplePreviewModal } from '../../components/modals/TemplePreviewModal';
import { ImportModal } from '../../components/modals/ImportModal';
import { useTemples, useTempleMutations } from '../../hooks/useTemples';
import { useCategories } from '../../hooks/useCategories';
import { useLocations } from '../../hooks/useLocations';
import { Temple } from '../../types';

export const TempleList: React.FC = () => {
  const [page, setPage] = useState(1);
  const [limit, setLimit] = useState(10);
  const [search, setSearch] = useState('');
  const [selectedCategory, setSelectedCategory] = useState('');
  const [selectedLocation, setSelectedLocation] = useState('');
  const [selectedStatus, setSelectedStatus] = useState('');

  const [previewTemple, setPreviewTemple] = useState<Temple | null>(null);
  const [deleteId, setDeleteId] = useState<string | null>(null);
  const [restoreId, setRestoreId] = useState<string | null>(null);
  const [importOpen, setImportOpen] = useState(false);

  const { data: categoriesRes } = useCategories();
  const { data: locationsRes } = useLocations();

  const queryParams = {
    page,
    limit,
    search: search || undefined,
    categoryId: selectedCategory || undefined,
    locationId: selectedLocation || undefined,
    status: selectedStatus || undefined,
  };

  const { data: templesRes, isLoading } = useTemples(queryParams);
  const { updateTemple, deleteTemple, restoreTemple, isDeleting, isRestoring, createTemple } = useTempleMutations();

  const temples = templesRes?.data || [];
  const totalCount = templesRes?.meta?.totalCount || 0;

  const handleToggleFeatured = async (temple: Temple) => {
    await updateTemple({ id: temple._id, data: { isFeatured: !temple.isFeatured } });
  };

  const handleTogglePopular = async (temple: Temple) => {
    await updateTemple({ id: temple._id, data: { isPopular: !temple.isPopular } });
  };

  const handleToggleStatus = async (temple: Temple) => {
    const nextStatus = temple.status === 'active' ? 'inactive' : 'active';
    await updateTemple({ id: temple._id, data: { status: nextStatus } });
  };

  const handleConfirmDelete = async () => {
    if (deleteId) {
      await deleteTemple(deleteId);
      setDeleteId(null);
    }
  };

  const handleConfirmRestore = async () => {
    if (restoreId) {
      await restoreTemple(restoreId);
      setRestoreId(null);
    }
  };

  const handleBulkImport = async (importData: Partial<Temple>[]) => {
    for (const item of importData) {
      if (categoriesRes?.data?.[0]?._id && locationsRes?.data?.[0]?._id) {
        item.categoryId = item.categoryId || categoriesRes.data[0]._id;
        item.locationId = item.locationId || locationsRes.data[0]._id;
      }
      await createTemple(item);
    }
  };

  const columns: GridColDef[] = [
    {
      field: 'coverImage',
      headerName: 'Cover',
      width: 80,
      sortable: false,
      renderCell: (params) => (
        <Box
          component="img"
          src={params.row.thumbnailImage || params.row.coverImage}
          alt={params.row.name}
          sx={{ width: 44, height: 44, borderRadius: '10px', objectFit: 'cover', border: '1px solid #E4E4E7', my: 1 }}
        />
      ),
    },
    {
      field: 'name',
      headerName: 'Temple Name',
      flex: 1.2,
      minWidth: 180,
      renderCell: (params) => (
        <Box sx={{ py: 1 }}>
          <Typography variant="body2" sx={{ fontWeight: 600 }}>
            {params.row.name}
          </Typography>
          <Typography variant="caption" color="text.secondary">
            {params.row.slug}
          </Typography>
        </Box>
      ),
    },
    {
      field: 'category',
      headerName: 'Category',
      flex: 1,
      minWidth: 140,
      valueGetter: (_, row) => (typeof row.categoryId === 'object' ? row.categoryId?.name : 'Category'),
    },
    {
      field: 'location',
      headerName: 'Location',
      flex: 1,
      minWidth: 140,
      valueGetter: (_, row) => (typeof row.locationId === 'object' ? row.locationId?.name : 'Location'),
    },
    {
      field: 'isFeatured',
      headerName: 'Featured',
      width: 100,
      renderCell: (params) => (
        <Switch
          size="small"
          checked={!!params.row.isFeatured}
          onChange={() => handleToggleFeatured(params.row)}
        />
      ),
    },
    {
      field: 'isPopular',
      headerName: 'Popular',
      width: 100,
      renderCell: (params) => (
        <Switch
          size="small"
          checked={!!params.row.isPopular}
          onChange={() => handleTogglePopular(params.row)}
        />
      ),
    },
    {
      field: 'status',
      headerName: 'Status',
      width: 120,
      renderCell: (params) => (
        <Box sx={{ display: 'flex', alignItems: 'center', gap: 1 }}>
          <StatusChip status={params.row.status} isDeleted={params.row.isDeleted} />
          {!params.row.isDeleted && (
            <Switch
              size="small"
              checked={params.row.status === 'active'}
              onChange={() => handleToggleStatus(params.row)}
            />
          )}
        </Box>
      ),
    },
    {
      field: 'actions',
      headerName: 'Actions',
      width: 160,
      sortable: false,
      align: 'right',
      renderCell: (params) => (
        <Box sx={{ display: 'flex', gap: 0.5 }}>
          <Tooltip title="Preview Shrine">
            <IconButton size="small" onClick={() => setPreviewTemple(params.row)}>
              <VisibilityIcon fontSize="small" />
            </IconButton>
          </Tooltip>

          <Tooltip title="Edit">
            <IconButton size="small" component={RouterLink} to={`/temples/${params.row._id}/edit`}>
              <EditIcon fontSize="small" />
            </IconButton>
          </Tooltip>

          {params.row.isDeleted ? (
            <Tooltip title="Restore Temple">
              <IconButton size="small" color="primary" onClick={() => setRestoreId(params.row._id)}>
                <RestoreIcon fontSize="small" />
              </IconButton>
            </Tooltip>
          ) : (
            <Tooltip title="Soft Delete">
              <IconButton size="small" color="error" onClick={() => setDeleteId(params.row._id)}>
                <DeleteIcon fontSize="small" />
              </IconButton>
            </Tooltip>
          )}
        </Box>
      ),
    },
  ];

  return (
    <Box>
      <PageHeader
        title="Temples Management"
        subtitle="Manage and discover temples across Braj Mandal"
        breadcrumbs={[{ label: 'Dashboard', path: '/' }, { label: 'Temples' }]}
        actions={
          <Box sx={{ display: 'flex', gap: 1.5 }}>
            <Button
              variant="outlined"
              startIcon={<FileUploadIcon />}
              onClick={() => setImportOpen(true)}
            >
              Bulk Import
            </Button>
            <Button
              component={RouterLink}
              to="/temples/new"
              variant="contained"
              startIcon={<AddIcon />}
            >
              Add Temple
            </Button>
          </Box>
        }
      />

      {/* Search & Filter Toolbar */}
      <Card sx={{ mb: 3, p: 1 }}>
        <CardContent sx={{ p: 2, '&:last-child': { pb: 2 } }}>
          <Box sx={{ display: 'flex', gap: 2, flexWrap: 'wrap', alignItems: 'center' }}>
            <TextField
              placeholder="Search temple name, tags..."
              value={search}
              onChange={(e) => {
                setSearch(e.target.value);
                setPage(1);
              }}
              size="small"
              sx={{ flexGrow: 1, minWidth: 220 }}
              SlotProps={{
                input: {
                  startAdornment: (
                    <InputAdornment position="start">
                      <SearchIcon fontSize="small" />
                    </InputAdornment>
                  ),
                },
              }}
            />

            <FormControl size="small" sx={{ minWidth: 160 }}>
              <InputLabel>Category</InputLabel>
              <Select
                value={selectedCategory}
                label="Category"
                onChange={(e) => {
                  setSelectedCategory(e.target.value);
                  setPage(1);
                }}
              >
                <MenuItem value="">All Categories</MenuItem>
                {(categoriesRes?.data || []).map((cat) => (
                  <MenuItem key={cat._id} value={cat._id}>
                    {cat.name}
                  </MenuItem>
                ))}
              </Select>
            </FormControl>

            <FormControl size="small" sx={{ minWidth: 160 }}>
              <InputLabel>Location</InputLabel>
              <Select
                value={selectedLocation}
                label="Location"
                onChange={(e) => {
                  setSelectedLocation(e.target.value);
                  setPage(1);
                }}
              >
                <MenuItem value="">All Locations</MenuItem>
                {(locationsRes?.data || []).map((loc) => (
                  <MenuItem key={loc._id} value={loc._id}>
                    {loc.name}
                  </MenuItem>
                ))}
              </Select>
            </FormControl>

            <FormControl size="small" sx={{ minWidth: 140 }}>
              <InputLabel>Status</InputLabel>
              <Select
                value={selectedStatus}
                label="Status"
                onChange={(e) => {
                  setSelectedStatus(e.target.value);
                  setPage(1);
                }}
              >
                <MenuItem value="">All Status</MenuItem>
                <MenuItem value="active">Active</MenuItem>
                <MenuItem value="inactive">Inactive</MenuItem>
                <MenuItem value="draft">Draft</MenuItem>
              </Select>
            </FormControl>
          </Box>
        </CardContent>
      </Card>

      {/* Data Grid Table */}
      <Card sx={{ p: 1 }}>
        <Box sx={{ height: 600, width: '100%' }}>
          <DataGrid
            rows={temples}
            columns={columns}
            getRowId={(row) => row._id}
            loading={isLoading}
            rowCount={totalCount}
            pageSizeOptions={[10, 25, 50]}
            paginationMode="server"
            paginationModel={{ page: page - 1, pageSize: limit }}
            onPaginationModelChange={(model) => {
              setPage(model.page + 1);
              setLimit(model.pageSize);
            }}
            disableRowSelectionOnClick
            sx={{
              border: 'none',
              '& .MuiDataGrid-cell': {
                borderBottom: '1px solid #F4F4F5',
              },
            }}
          />
        </Box>
      </Card>

      {/* Modals & Dialogs */}
      <TemplePreviewModal
        open={Boolean(previewTemple)}
        temple={previewTemple}
        onClose={() => setPreviewTemple(null)}
      />

      <ConfirmDialog
        open={Boolean(deleteId)}
        title="Soft Delete Temple"
        message="Are you sure you want to soft-delete this temple? It will be hidden from mobile apps but can be restored anytime."
        confirmText="Soft Delete"
        loading={isDeleting}
        onConfirm={handleConfirmDelete}
        onClose={() => setDeleteId(null)}
      />

      <ConfirmDialog
        open={Boolean(restoreId)}
        title="Restore Temple"
        message="Are you sure you want to restore this soft-deleted temple?"
        confirmText="Restore"
        loading={isRestoring}
        onConfirm={handleConfirmRestore}
        onClose={() => setRestoreId(null)}
      />

      <ImportModal
        open={importOpen}
        onClose={() => setImportOpen(false)}
        onImport={handleBulkImport}
      />
    </Box>
  );
};
