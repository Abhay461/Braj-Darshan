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
import { CategoryModal } from '../../components/modals/CategoryModal';
import { useCategories, useCategoryMutations } from '../../hooks/useCategories';
import { Category } from '../../types';

export const CategoryList: React.FC = () => {
  const [search, setSearch] = useState('');
  const [selectedCategory, setSelectedCategory] = useState<Category | null>(null);
  const [modalOpen, setModalOpen] = useState(false);
  const [deleteId, setDeleteId] = useState<string | null>(null);

  const { data: categoriesRes, isLoading } = useCategories({ search: search || undefined });
  const { createCategory, updateCategory, deleteCategory, isCreating, isUpdating } = useCategoryMutations();

  const categories = categoriesRes?.data || [];

  const handleOpenCreate = () => {
    setSelectedCategory(null);
    setModalOpen(true);
  };

  const handleOpenEdit = (category: Category) => {
    setSelectedCategory(category);
    setModalOpen(true);
  };

  const handleSave = async (data: Partial<Category>) => {
    if (selectedCategory) {
      await updateCategory({ id: selectedCategory._id, data });
    } else {
      await createCategory(data);
    }
  };

  const handleConfirmDelete = async () => {
    if (deleteId) {
      await deleteCategory(deleteId);
      setDeleteId(null);
    }
  };

  const columns: GridColDef[] = [
    { field: 'name', headerName: 'Category Name', flex: 1, minWidth: 160 },
    { field: 'slug', headerName: 'Slug', flex: 1, minWidth: 140 },
    { field: 'description', headerName: 'Description', flex: 1.5, minWidth: 200 },
    { field: 'icon', headerName: 'Icon Identifier', width: 140 },
    { field: 'sortOrder', headerName: 'Sort Order', width: 110, align: 'center' },
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
          <Tooltip title="Edit Category">
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
        title="Categories Management"
        subtitle="Organize shrines into structured religious categories"
        breadcrumbs={[{ label: 'Dashboard', path: '/' }, { label: 'Categories' }]}
        actions={
          <Button variant="contained" startIcon={<AddIcon />} onClick={handleOpenCreate}>
            Add Category
          </Button>
        }
      />

      <Card sx={{ mb: 3, p: 1 }}>
        <CardContent sx={{ p: 2, '&:last-child': { pb: 2 } }}>
          <TextField
            placeholder="Search categories..."
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
            rows={categories}
            columns={columns}
            getRowId={(row) => row._id}
            loading={isLoading}
            disableRowSelectionOnClick
            sx={{ border: 'none' }}
          />
        </Box>
      </Card>

      <CategoryModal
        open={modalOpen}
        category={selectedCategory}
        loading={isCreating || isUpdating}
        onClose={() => setModalOpen(false)}
        onSubmit={handleSave}
      />

      <ConfirmDialog
        open={Boolean(deleteId)}
        title="Soft Delete Category"
        message="Are you sure you want to delete this category?"
        onConfirm={handleConfirmDelete}
        onClose={() => setDeleteId(null)}
      />
    </Box>
  );
};
