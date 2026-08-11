import React, { useState } from 'react';
import {
  Box,
  Card,
  CardContent,
  Button,
  IconButton,
  TextField,
  InputAdornment,
  Tooltip,
} from '@mui/material';
import SearchIcon from '@mui/icons-material/Search';
import AddIcon from '@mui/icons-material/Add';
import EditIcon from '@mui/icons-material/EditOutlined';
import DeleteIcon from '@mui/icons-material/DeleteOutlined';
import { DataGrid, GridColDef } from '@mui/x-data-grid';

import { PageHeader } from '../../components/common/PageHeader';
import { StatusChip } from '../../components/common/StatusChip';
import { ConfirmDialog } from '../../components/common/ConfirmDialog';
import { LocationModal } from '../../components/modals/LocationModal';
import { useLocations, useLocationMutations } from '../../hooks/useLocations';
import { Location } from '../../types';

export const LocationList: React.FC = () => {
  const [search, setSearch] = useState('');
  const [selectedLocation, setSelectedLocation] = useState<Location | null>(null);
  const [modalOpen, setModalOpen] = useState(false);
  const [deleteId, setDeleteId] = useState<string | null>(null);

  const { data: locationsRes, isLoading } = useLocations({ search: search || undefined, limit: 100 });
  const { createLocation, updateLocation, deleteLocation, isCreating, isUpdating } = useLocationMutations();

  const locations = locationsRes?.data || [];

  const handleOpenCreate = () => {
    setSelectedLocation(null);
    setModalOpen(true);
  };

  const handleOpenEdit = (location: Location) => {
    setSelectedLocation(location);
    setModalOpen(true);
  };

  const handleSave = async (data: Partial<Location>) => {
    if (selectedLocation) {
      await updateLocation({ id: selectedLocation._id, data });
    } else {
      await createLocation(data);
    }
  };

  const handleConfirmDelete = async () => {
    if (deleteId) {
      await deleteLocation(deleteId);
      setDeleteId(null);
    }
  };

  const columns: GridColDef[] = [
    { field: 'name', headerName: 'Location Name', flex: 1, minWidth: 200 },
    {
      field: 'actions',
      headerName: 'Actions',
      width: 120,
      align: 'right',
      sortable: false,
      renderCell: (params) => (
        <Box sx={{ display: 'flex', gap: 0.5 }}>
          <Tooltip title="Edit Location">
            <IconButton size="small" onClick={() => handleOpenEdit(params.row)}>
              <EditIcon fontSize="small" />
            </IconButton>
          </Tooltip>
          <Tooltip title="Delete">
            <IconButton size="small" color="error" onClick={() => setDeleteId(params.row._id)}>
              <DeleteIcon fontSize="small" />
            </IconButton>
          </Tooltip>
        </Box>
      ),
    },
  ];

  return (
    <Box>
      <PageHeader
        title="Locations Management"
        subtitle="Manage towns, villages, and sacred geographical zones of Braj"
        breadcrumbs={[{ label: 'Dashboard', path: '/' }, { label: 'Locations' }]}
        actions={
          <Button variant="contained" startIcon={<AddIcon />} onClick={handleOpenCreate}>
            Add Location
          </Button>
        }
      />

      <Card sx={{ mb: 3, p: 1 }}>
        <CardContent sx={{ p: 2, '&:last-child': { pb: 2 } }}>
          <TextField
            placeholder="Search locations..."
            value={search}
            onChange={(e) => setSearch(e.target.value)}
            size="small"
            sx={{ maxWidth: 360 }}
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
        </CardContent>
      </Card>

      <Card sx={{ p: 1 }}>
        <Box sx={{ height: 500, width: '100%' }}>
          <DataGrid
            rows={locations}
            columns={columns}
            getRowId={(row) => row._id}
            loading={isLoading}
            disableRowSelectionOnClick
            sx={{ border: 'none' }}
          />
        </Box>
      </Card>

      <LocationModal
        open={modalOpen}
        location={selectedLocation}
        loading={isCreating || isUpdating}
        onClose={() => setModalOpen(false)}
        onSubmit={handleSave}
      />

      <ConfirmDialog
        open={Boolean(deleteId)}
        title="Soft Delete Location"
        message="Are you sure you want to delete this location?"
        onConfirm={handleConfirmDelete}
        onClose={() => setDeleteId(null)}
      />
    </Box>
  );
};
