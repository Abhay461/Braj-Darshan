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
import { ConfirmDialog } from '../../components/common/ConfirmDialog';
import { FacilityModal } from '../../components/modals/FacilityModal';
import { useFacilities, useFacilityMutations } from '../../hooks/useFacilities';
import { Facility } from '../../types';

export const FacilityList: React.FC = () => {
  const [search, setSearch] = useState('');
  const [selectedFacility, setSelectedFacility] = useState<Facility | null>(null);
  const [modalOpen, setModalOpen] = useState(false);
  const [deleteId, setDeleteId] = useState<string | null>(null);

  const { data: facilitiesRes, isLoading } = useFacilities({ search: search || undefined });
  const { createFacility, updateFacility, deleteFacility, isCreating, isUpdating } = useFacilityMutations();

  const facilities = facilitiesRes?.data || [];

  const handleOpenCreate = () => {
    setSelectedFacility(null);
    setModalOpen(true);
  };

  const handleOpenEdit = (facility: Facility) => {
    setSelectedFacility(facility);
    setModalOpen(true);
  };

  const handleSave = async (data: Partial<Facility>) => {
    if (selectedFacility) {
      await updateFacility({ id: selectedFacility._id, data });
    } else {
      await createFacility(data);
    }
  };

  const handleConfirmDelete = async () => {
    if (deleteId) {
      await deleteFacility(deleteId);
      setDeleteId(null);
    }
  };

  const columns: GridColDef[] = [
    { field: 'name', headerName: 'Facility Name', flex: 1, minWidth: 180 },
    { field: 'icon', headerName: 'Material Icon Code', flex: 1, minWidth: 160 },
    {
      field: 'actions',
      headerName: 'Actions',
      width: 120,
      align: 'right',
      sortable: false,
      renderCell: (params) => (
        <Box sx={{ display: 'flex', gap: 0.5 }}>
          <Tooltip title="Edit Facility">
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
        title="Facilities & Amenities Management"
        subtitle="Manage visitor services like Parking, Wheelchair Access, Prasad counters, etc."
        breadcrumbs={[{ label: 'Dashboard', path: '/' }, { label: 'Facilities' }]}
        actions={
          <Button variant="contained" startIcon={<AddIcon />} onClick={handleOpenCreate}>
            Add Facility
          </Button>
        }
      />

      <Card sx={{ mb: 3, p: 1 }}>
        <CardContent sx={{ p: 2, '&:last-child': { pb: 2 } }}>
          <TextField
            placeholder="Search facilities..."
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
        <Box sx={{ height: 480, width: '100%' }}>
          <DataGrid
            rows={facilities}
            columns={columns}
            getRowId={(row) => row._id}
            loading={isLoading}
            disableRowSelectionOnClick
            sx={{ border: 'none' }}
          />
        </Box>
      </Card>

      <FacilityModal
        open={modalOpen}
        facility={selectedFacility}
        loading={isCreating || isUpdating}
        onClose={() => setModalOpen(false)}
        onSubmit={handleSave}
      />

      <ConfirmDialog
        open={Boolean(deleteId)}
        title="Soft Delete Facility"
        message="Are you sure you want to delete this facility?"
        onConfirm={handleConfirmDelete}
        onClose={() => setDeleteId(null)}
      />
    </Box>
  );
};
