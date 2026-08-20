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
import { EmergencyModal } from '../../components/modals/EmergencyModal';
import { useEmergencyContacts, useEmergencyContactMutations } from '../../hooks/useEmergencyContacts';
import { EmergencyContact } from '../../types';

export const EmergencyContactsList: React.FC = () => {
  const [search, setSearch] = useState('');
  const [selectedContact, setSelectedContact] = useState<EmergencyContact | null>(null);
  const [modalOpen, setModalOpen] = useState(false);
  const [deleteId, setDeleteId] = useState<string | null>(null);

  const { data: contactsRes, isLoading } = useEmergencyContacts({ search: search || undefined });
  const { createContact, updateContact, deleteContact, isCreating, isUpdating } = useEmergencyContactMutations();

  const contacts = contactsRes?.data || [];

  const handleOpenCreate = () => {
    setSelectedContact(null);
    setModalOpen(true);
  };

  const handleOpenEdit = (contact: EmergencyContact) => {
    setSelectedContact(contact);
    setModalOpen(true);
  };

  const handleSave = async (data: Partial<EmergencyContact>) => {
    if (selectedContact) {
      await updateContact({ id: selectedContact._id, data });
    } else {
      await createContact(data);
    }
  };

  const handleConfirmDelete = async () => {
    if (deleteId) {
      await deleteContact(deleteId);
      setDeleteId(null);
    }
  };

  const categoryLabels: Record<string, string> = {
    police: 'Police',
    tourist_police: 'Tourist Police',
    medical: 'Medical',
    hospital: 'Hospital',
    ambulance: 'Ambulance',
    fire: 'Fire',
    helpline: 'Helpline',
    other: 'Other',
  };

  const columns: GridColDef[] = [
    {
      field: 'name',
      headerName: 'Name',
      flex: 1.5,
      minWidth: 180,
    },
    {
      field: 'category',
      headerName: 'Category',
      width: 160,
      renderCell: (params) => (
        <span style={{ textTransform: 'capitalize' }}>{categoryLabels[params.row.category] || params.row.category}</span>
      ),
    },
    {
      field: 'phone',
      headerName: 'Phone',
      flex: 1,
      minWidth: 140,
    },
    {
      field: 'area',
      headerName: 'Area',
      width: 140,
    },
    {
      field: 'status',
      headerName: 'Status',
      width: 120,
      renderCell: (params) => <StatusChip status={params.row.isActive ? 'active' : 'inactive'} isDeleted={params.row.isDeleted} />,
    },
    {
      field: 'actions',
      headerName: 'Actions',
      width: 120,
      align: 'right',
      sortable: false,
      renderCell: (params) => (
        <Box sx={{ display: 'flex', gap: 0.5, justifyContent: 'flex-end' }}>
          <Tooltip title="Edit Contact">
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
        title="Emergency & Yatri Help Contacts"
        subtitle="Manage Tourist Police, Hospitals, Ambulance, and Helpline numbers"
        breadcrumbs={[{ label: 'Dashboard', path: '/' }, { label: 'Emergency Contacts' }]}
        actions={
          <Button variant="contained" startIcon={<AddIcon />} onClick={handleOpenCreate}>
            Add Contact
          </Button>
        }
      />

      <Card sx={{ mb: 3, p: 1 }}>
        <CardContent sx={{ p: 2, '&:last-child': { pb: 2 } }}>
          <TextField
            placeholder="Search contacts..."
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
            rows={contacts}
            columns={columns}
            getRowId={(row) => row._id}
            loading={isLoading}
            disableRowSelectionOnClick
            sx={{ border: 'none' }}
          />
        </Box>
      </Card>

      <EmergencyModal
        open={modalOpen}
        contact={selectedContact}
        loading={isCreating || isUpdating}
        onClose={() => setModalOpen(false)}
        onSubmit={handleSave}
      />

      <ConfirmDialog
        open={Boolean(deleteId)}
        title="Delete Emergency Contact"
        message="Are you sure you want to delete this emergency contact?"
        onConfirm={handleConfirmDelete}
        onClose={() => setDeleteId(null)}
      />
    </Box>
  );
};