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
import { FestivalModal } from '../../components/modals/FestivalModal';
import { useFestivals, useFestivalMutations } from '../../hooks/useFestivals';
import { useTemples } from '../../hooks/useTemples';
import { Festival } from '../../types';

export const FestivalList: React.FC = () => {
  const [search, setSearch] = useState('');
  const [selectedFestival, setSelectedFestival] = useState<Festival | null>(null);
  const [modalOpen, setModalOpen] = useState(false);
  const [deleteId, setDeleteId] = useState<string | null>(null);

  const { data: festivalsRes, isLoading } = useFestivals({ search: search || undefined });
  const { data: templesRes } = useTemples({ limit: 100 });
  const { createFestival, updateFestival, deleteFestival, isCreating, isUpdating } = useFestivalMutations();

  const festivals = festivalsRes?.data || [];
  const temples = templesRes?.data || [];

  const handleOpenCreate = () => {
    setSelectedFestival(null);
    setModalOpen(true);
  };

  const handleOpenEdit = (festival: Festival) => {
    setSelectedFestival(festival);
    setModalOpen(true);
  };

  const handleSave = async (data: Partial<Festival>) => {
    if (selectedFestival) {
      await updateFestival({ id: selectedFestival._id, data });
    } else {
      await createFestival(data);
    }
  };

  const handleConfirmDelete = async () => {
    if (deleteId) {
      await deleteFestival(deleteId);
      setDeleteId(null);
    }
  };

  const columns: GridColDef[] = [
    {
      field: 'bannerImage',
      headerName: 'Banner',
      width: 80,
      sortable: false,
      renderCell: (params) => (
        <Box
          component="img"
          src={params.row.bannerImage || 'https://res.cloudinary.com/demo/image/upload/v1/braj-darshan/banners/janmashtami.jpg'}
          alt={params.row.name}
          sx={{ width: 44, height: 32, borderRadius: '6px', objectFit: 'cover', border: '1px solid #E4E4E7', my: 1 }}
        />
      ),
    },
    { field: 'name', headerName: 'Festival Name', flex: 1, minWidth: 160 },
    { field: 'description', headerName: 'Description', flex: 1.5, minWidth: 200 },
    {
      field: 'dates',
      headerName: 'Festival Dates',
      flex: 1,
      minWidth: 160,
      valueGetter: (_, row) =>
        row.startDate
          ? `${new Date(row.startDate).toLocaleDateString()} - ${row.endDate ? new Date(row.endDate).toLocaleDateString() : ''}`
          : 'Upcoming / Annual',
    },
    {
      field: 'status',
      headerName: 'Status',
      width: 120,
      renderCell: (params) => <StatusChip status={params.row.status} isDeleted={params.row.isDeleted} />,
    },
    {
      field: 'actions',
      headerName: 'Actions',
      width: 120,
      align: 'right',
      sortable: false,
      renderCell: (params) => (
        <Box sx={{ display: 'flex', gap: 0.5 }}>
          <Tooltip title="Edit Festival">
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
        title="Festivals & Utsavs Management"
        subtitle="Manage cultural festivals, Janmashtami, Radhashtami, and annual events"
        breadcrumbs={[{ label: 'Dashboard', path: '/' }, { label: 'Festivals' }]}
        actions={
          <Button variant="contained" startIcon={<AddIcon />} onClick={handleOpenCreate}>
            Add Festival
          </Button>
        }
      />

      <Card sx={{ mb: 3, p: 1 }}>
        <CardContent sx={{ p: 2, '&:last-child': { pb: 2 } }}>
          <TextField
            placeholder="Search festivals..."
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
            rows={festivals}
            columns={columns}
            getRowId={(row) => row._id}
            loading={isLoading}
            disableRowSelectionOnClick
            sx={{ border: 'none' }}
          />
        </Box>
      </Card>

      <FestivalModal
        open={modalOpen}
        festival={selectedFestival}
        temples={temples}
        loading={isCreating || isUpdating}
        onClose={() => setModalOpen(false)}
        onSubmit={handleSave}
      />

      <ConfirmDialog
        open={Boolean(deleteId)}
        title="Soft Delete Festival"
        message="Are you sure you want to delete this festival?"
        onConfirm={handleConfirmDelete}
        onClose={() => setDeleteId(null)}
      />
    </Box>
  );
};
